//
//  P2LConquerViewController.m
//  Play2Learn
//
//  Created by Sebastian Büsing on 23.06.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import "P2LConquerViewController.h"
#import "P2LGraphPathGenerator.h"
#import "P2LPathView.h"
#import "Inquiry+DBAPI.h"
#import "P2LConquerChallengeViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "P2LInquiryViewController.h"
#import "P2LMoveUnitsPromptView.h"
#import "Question+DBAPI.h"
#import "P2LRatedQuestion.h"

typedef enum ConquerGameState {

    ConquerGameStateUninitialized,
    ConquerGameStateInitialized,
    ConquerGameStateUserTurnAttack,
    ConquerGameStateUserTurnMove,
    ConquerGameStateEnemyTurn,
    ConquerGameStateFinished

} ConquerGameState;

#define capitolWidth 100

@interface P2LConquerViewController ()

// Header control elements
@property (nonatomic, strong) UIButton *skipButton;
@property (nonatomic, strong) UILabel *headerNoteLabel;

@property (nonatomic, strong) P2LGraphPath *midPath;
@property (nonatomic, strong) P2LPathView *midPathView;
@property (nonatomic, strong) P2LPathView *selectedView;
@property (nonatomic, strong) P2LPathView *attackedView;
@property (nonatomic, strong) NSMutableArray *areas;
@property (nonatomic, strong) NSMutableArray *areaViews;
@property (nonatomic, strong) NSMutableArray *paths;

@property (nonatomic, strong) NSMutableDictionary *questionPool;

@property (nonatomic, strong) P2LMoveUnitsPromptView *moveUnitsView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableArray *layers;

@property (nonatomic, assign) NSInteger failCounter;
@property (nonatomic, assign) ConquerGameState currentGameState;

@property (nonatomic, strong) P2LConquerChallengeViewController *challengeViewController;
@property (nonatomic, strong) P2LInquiryViewController *inquiryController;

@end

@implementation P2LConquerViewController

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //
        _areas = [NSMutableArray new];
        _paths = [NSMutableArray new];
        _layers = [NSMutableArray new];
        
        self.failCounter = 0;
        self.skipButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.skipButton setTitle:@"Überspringen" forState:UIControlStateNormal];
        self.skipButton.frame = CGRectMake(self.view.frame.size.width - 130, 10, 120, 40);
        self.skipButton.enabled = NO;
        self.skipButton.alpha = 1.0f;
        [self.skipButton addTarget:self action:@selector(skipTurn) forControlEvents:UIControlEventTouchUpInside];
        
        self.headerNoteLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, self.view.frame.size.width - 10, 20)];
        self.headerNoteLabel.text = @"Spielfeld wird aufgebaut...";
        //
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height - 60)];
        [self.view addSubview:self.scrollView];
        [self.view addSubview:self.skipButton];
        [self.view addSubview:self.headerNoteLabel];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
}

- (void)startGame
{
    if (self.lesson == nil)
    {
        [NSException raise:NSInternalInconsistencyException format:@"Cannot start a conquer game with no lesson!"];
    }
    [self setupQuestionPool];
    // get the layour counts, which is an array with the first item equal to 1
    // and the others indicating how many areas are around the previous item
    NSArray *layerCounts = [self layerCountBasedOnLessonQuestion];
    
    // based on that information we grab the contentSize
    CGSize contentSize = [self contentSizeForLayerCounts:layerCounts];
    // and set it on the scrollView.
    self.scrollView.contentSize = contentSize;
    
    @try
    {
        // the capitol (inner area) always has the same size.
        CGRect middleRect = CGRectMake(0, 0, capitolWidth, capitolWidth);
        // create the path for it.
        self.midPath = [P2LGraphPathGenerator generatePathInsideRect:middleRect withEdgesCount:12];
        // that path now has to be centered
        [self centerMidPathInsideContentArea:contentSize andMidBounds:middleRect];
        // now it can be added as the first layer
        [self.layers addObject:[NSArray arrayWithObject:self.midPath]];
        // add path onto area collection
        [self.paths addObject:self.midPath];
        
        // now create the surrounding areas
        P2LGraphPath *innerPath = self.midPath;
        
        for (int i = 1; i < layerCounts.count; i++)
        {
            // grab the parameters
            CGFloat maxLength = [self maxLengthForLayer:i withTotalLayerCount:layerCounts.count withTotalContentArea:contentSize];
            int numPaths = [[layerCounts objectAtIndex:i] intValue];
            // and create the surrounding paths
            NSArray *surroundingPaths = [P2LGraphPathGenerator generatePathsAroundPath:innerPath withMaxLength:maxLength andNumPaths:numPaths];
            
            // add them to the layer array, since here we only create the areas
            // and add the to contentArea via UIAnimations later.
            [self.layers addObject:surroundingPaths];
            
            // create the new innerPath by join the new path
            // with the current innerPath.
            for (P2LGraphPath *somePath in surroundingPaths)
            {
                innerPath = [innerPath graphByJoiningWithAdjacentGraph:somePath];
                
                // add generatedPath to area collection
                [self.paths addObject:somePath];
            }
        }
    }
    @catch (NSException *exception)
    {
        self.layers = [NSMutableArray new];
        self.paths = [NSMutableArray new];
        
        self.failCounter++;
        NSLog(@"algorithmn failed: %d", self.failCounter);
        
        [self startGame];
        return;
    }
    
        
    [self addlayersViaAnimation];
}

- (void)challangeAccepted
{
    // remove challange ViewController
    [self dismissViewController:self.challengeViewController fromDirection:SubViewDirectionTopToBottom];
    
    // create inquiry
    Inquiry *inquiry = [[Inquiry alloc] initEntity];
    inquiry.questions = [NSSet setWithArray:[self randomQuestionsMeetingRequiredCount:3]];
    inquiry.lesson = self.lesson;
    
    self.inquiryController = [[P2LInquiryViewController alloc] initWithInquiry:inquiry andFrame:self.view.frame];
    self.inquiryController.mainViewController = nil;
    self.inquiryController.delegate = self;
    [self.inquiryController.backButton removeFromSuperview];
    
    // present inquiry
    self.inquiryController.view.frame = CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [self.view addSubview:self.inquiryController.view];
    
    [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseInOut animations:^(){
        
        self.inquiryController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        
    } completion:^(BOOL finished){
        
        [inquiry save];
        [self.inquiryController startInquiry];
        
    }];
}

- (void)challangeCanceled
{
    self.attackedView.selected = NO;
    [self.attackedView setNeedsDisplay];
    self.attackedView = nil;
    
    [self dismissViewController:self.challengeViewController fromDirection:SubViewDirectionTopToBottom];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private stuff

- (void)viewTapped:(UITapGestureRecognizer *)recognizer
{
    switch (self.currentGameState)
    {
        case ConquerGameStateUninitialized:
        case ConquerGameStateFinished:
        {
            return;
        }
            break;
        case ConquerGameStateInitialized:
        {
            // first move!
            CGPoint location = [recognizer locationInView:self.contentView];
            
            P2LPathView *pathViewClicked = [self pathViewForLocation:location];
            
            // need to hit a path ;)
            if (pathViewClicked == nil)
            {
                return;
            }
            
            // first move should be made on an outer area.
            NSArray *outerAreas = [self.layers lastObject];
            
            if ([outerAreas containsObject:pathViewClicked])
            {
                // select the view
                self.attackedView = pathViewClicked;
                pathViewClicked.selected = YES;
                [self.attackedView setNeedsDisplay];
                // and display the conquer startView
                [self attempt2ConquerAreaFromArea:nil];
            }
        }
            break;
        case ConquerGameStateUserTurnAttack:
        {
            // get clicked pathView
            CGPoint location = [recognizer locationInView:self.contentView];
            
            P2LPathView *pathViewClicked = [self pathViewForLocation:location];
            
            if (!self.selectedView)
            {
                // select our own territory to start attacking from it.
                if (!pathViewClicked.occupiedByEnemy)
                {
                    self.selectedView = pathViewClicked;
                    self.selectedView.selected = YES;
                    [self.selectedView setNeedsDisplay];
                }
            }
            else
            {
                // allow to unselect an area
                if (pathViewClicked == self.selectedView)
                {
                    self.selectedView.selected = NO;
                    [self.selectedView setNeedsDisplay];
                    self.selectedView = nil;
                }
                else
                {
                    // ready to attack!
                    if (pathViewClicked.occupiedByEnemy && [self isAreaA:pathViewClicked nextToAreaB:self.selectedView])
                    {
                        if (pathViewClicked != self.midPathView || [self allOuterPathsConquered])
                        {
                            self.attackedView = pathViewClicked;
                            [self attempt2ConquerAreaFromArea:self.selectedView];
                        }
                    }
                }
            }
            
            return;
        }
        case ConquerGameStateUserTurnMove:
        {
            // get clicked pathView
            CGPoint location = [recognizer locationInView:self.contentView];
            
            P2LPathView *pathViewClicked = [self pathViewForLocation:location];
            
            if (!self.selectedView)
            {
                // select our own territory to start attacking from it.
                if (!pathViewClicked.occupiedByEnemy)
                {
                    self.selectedView = pathViewClicked;
                    self.selectedView.selected = YES;
                    [self.selectedView setNeedsDisplay];
                }
            }
            else
            {
                // allow to unselect an area
                if (pathViewClicked == self.selectedView)
                {
                    self.selectedView.selected = NO;
                    [self.selectedView setNeedsDisplay];
                    self.selectedView = nil;
                }
                else
                {
                    // ready to move!
                    if (!pathViewClicked.occupiedByEnemy && self.selectedView.forcesCount > 1)
                    {
                        [self displayMoveModalViewWithTargetPathView:pathViewClicked];
                    }
                }
            }
            
            return;
        }
            break;
        case ConquerGameStateEnemyTurn:
        {
            return;
        }
            break;
    }
    
    if (self.currentGameState == ConquerGameStateUninitialized)
    {
        return;
    }
}

- (BOOL)allOuterPathsConquered
{
    for (P2LPathView *pathView in self.areaViews)
    {
        if (pathView != self.midPathView && pathView.occupiedByEnemy)
        {
            return NO;
        }
    }
    return YES;
}

- (P2LPathView *)pathViewForLocation:(CGPoint)location
{
    for (P2LPathView *pathView in _areas)
    {
        if ([pathView.path isInsidePoint:location])
        {
            return pathView;
        }
    }
    return nil;
}

- (void)attempt2ConquerAreaFromArea:(P2LPathView *)userArea
{
    if (!self.attackedView)
    {
        return;
    }
    P2LConquerChallengeViewController *controller = [[P2LConquerChallengeViewController alloc] initWithFrame:self.view.frame];
    
    controller.numOwnForces = userArea ? userArea.forcesCount-1 : 3;
    controller.numEnemyForces = self.attackedView.forcesCount;
    controller.mainViewController = self;
    
    [self presentViewController:controller fromDirection:SubViewDirectionBottomToTop];
}

- (void)inquiryFinishedWithCorrectness:(CGFloat)correctness
{
    if (correctness >= [self.challengeViewController correctnessRequired])
    {
        // check win condition
        if ([[self.layers objectAtIndex:0] objectAtIndex:0] == self.attackedView)
        {
            [self userWinAnimation];
            
            self.currentGameState = ConquerGameStateFinished;
            
            return;
        }
        self.attackedView.occupiedByEnemy = NO;
        [self animateNewForcesCount:(self.challengeViewController.numOwnForces + 1) onPathView:self.attackedView];
        [self animateNewForcesCount:1 onPathView:self.selectedView];
        // advance to next game state
        if (self.currentGameState == ConquerGameStateInitialized)
        {
            [self enemyTurn];
        }
        else
        {
            [self userMoveTurn];
        }
    }
    else
    {
        if (self.selectedView)
        {
            [self animateNewForcesCount:MAX(1 , (self.selectedView.forcesCount - 1)) onPathView:self.selectedView];
            // advance to next game state
            if (self.currentGameState != ConquerGameStateInitialized)
            {
                [self userMoveTurn];
            }
        }
    }
    [self deselectAreas];
}

- (void)userMoveTurn
{
    [self setHeaderNote:@"Einheiten bewegen..."];
    
    self.currentGameState = ConquerGameStateUserTurnMove;
    self.skipButton.alpha = 1.0f;
    self.skipButton.enabled = YES;
}

- (void)enemyTurn
{
    [self setHeaderNote:@"KI am Zug..."];
    
    self.currentGameState = ConquerGameStateEnemyTurn;
    
    if (self.selectedView)
    {
        self.selectedView.selected = NO;
        [self.selectedView setNeedsDisplay];
        self.selectedView = nil;
    }
    
    if (self.attackedView)
    {
        self.attackedView.selected = NO;
        [self.attackedView setNeedsDisplay];
        self.attackedView = nil;
    }
    
    // copy first layer array
    NSMutableArray *areasAroundCapitol = [[self.layers objectAtIndex:1] mutableCopy];
    
    int unitsLeft = [self.layers count] - 1;
    
    // add own unit to midPath
    [self animateNewForcesCount:self.midPathView.forcesCount+1 onPathView:self.midPathView];
    
    // iterate over all inner layers
    for (int i = 0; i < ((NSArray *)[self.layers objectAtIndex:1]).count; i++)
    {
        // grab path at random index
        int randomIndex = arc4random() % [areasAroundCapitol count];
        P2LPathView *pathView = [areasAroundCapitol objectAtIndex:randomIndex];
        
        // if occupied by enemy, add one unit and decrese counter
        if (pathView.occupiedByEnemy)
        {
            [self animateNewForcesCount:pathView.forcesCount+1 onPathView:pathView];
            unitsLeft--;
        }
        
        // remove that area from the array so we dont chose it again
        [areasAroundCapitol removeObjectAtIndex:randomIndex];
        
        // if no units are left to place abort
        if (unitsLeft == 0)
        {
            break;
        }
    }
    
    // thats it for the enemy turn - switch turn again
    self.currentGameState = ConquerGameStateUserTurnAttack;
    
    [self setHeaderNote:@"Gebiet angreifen..."];
}

- (void)skipTurn
{
    if (self.currentGameState == ConquerGameStateUserTurnMove)
    {
        self.skipButton.alpha = 0.0f;
        self.skipButton.enabled = NO;
        
        [self deselectAreas];
        [self enemyTurn];
    }
}

- (void)deselectAreas
{
    self.selectedView.selected = NO;
    self.attackedView.selected = NO;
    
    [self.selectedView setNeedsDisplay];
    [self.attackedView setNeedsDisplay];
    
    self.selectedView = nil;
    self.attackedView = nil;
}

- (BOOL)isAreaA:(P2LPathView *)areaA nextToAreaB:(P2LPathView *)areaB
{
    return [areaA.path isAdjacentToPath:areaB.path];
}

#pragma mark - question selection methods

- (void)setupQuestionPool
{
    _questionPool = [NSMutableDictionary new];
    
    for (Question *question in [self.lesson.questions allObjects])
    {
        NSString *key = [NSString stringWithFormat:@"%d", [question primaryId]];
        
        P2LRatedQuestion *ratedQuestion = [[P2LRatedQuestion alloc] initWithQuestion:question];
        [_questionPool setObject:ratedQuestion forKey:key];
    }
}

- (void)answeredQuestion:(Question *)question withCorrectness:(float)correctness
{
    // grab question from pool
    P2LRatedQuestion *ratedQuestion = [_questionPool objectForKey:[NSString stringWithFormat:@"%d", [question primaryId]]];
    
    // update values
    float numerator = ((float)ratedQuestion.numChosen * ratedQuestion.avgCorrectness + correctness);
    ratedQuestion.avgCorrectness = numerator / ((float)ratedQuestion.numChosen + 1.0f);
    ratedQuestion.numChosen++;
    ratedQuestion.rating -= 0.3; // subtraction per prompt
    ratedQuestion.rating += (1.0f - correctness) * 0.2f; // addition for mistakes in the last prompt
    ratedQuestion.rating += (1.0f - ratedQuestion.avgCorrectness) * 0.1f; // addition for mistakes in the general
    ratedQuestion.rating += (correctness < ratedQuestion.lastCorrectness) ? 0.05 : -0.025;
    ratedQuestion.lastCorrectness = correctness;
}

- (Question *)randomQuestionFromQuestionPool:(NSArray *)questionPool
{
    if (![questionPool count])
    {
        [NSException raise:NSInvalidArgumentException format:@"question Pool is empty"];
    }
    
    float barrier = 0;
    
    for (P2LRatedQuestion *ratedQuestion in questionPool)
    {
        barrier += powf(ratedQuestion.rating, 2.0f) * 1000;
    }
    
    // grab random float between 0 and barrier
    float random = ((float)arc4random() / ARC4RANDOM_MAX) * barrier;
    
    float newBarrier = 0.0f;
    
    for (P2LRatedQuestion *ratedQuestion in questionPool)
    {
        newBarrier += powf(ratedQuestion.rating, 2.0f) * 1000;
        
        if (newBarrier > random)
        {
            return ratedQuestion.question;
        }
    }
    return [[questionPool objectAtIndex:(questionPool.count - 1)] question];
}

- (NSArray *)randomQuestionsMeetingRequiredCount:(int)count
{
    // create an array to collect questions
    NSMutableArray *questions = [NSMutableArray new];
    // grab a copy of the question pool
    NSMutableDictionary *questionPool = [_questionPool mutableCopy];
    
    while (questions.count < count && [questionPool allValues].count > 0)
    {
        // get random question
        Question *randomQuestion = [self randomQuestionFromQuestionPool:[questionPool allValues]];
        
        // remove that question from the pool
        [questionPool removeObjectForKey:[NSString stringWithFormat:@"%d", [randomQuestion primaryId]]];
        
        // add question to collection
        [questions addObject:randomQuestion];
    }
    return questions;
}

#pragma mark - initial setup calculations

- (NSArray *)layerCountBasedOnLessonQuestion
{
    NSInteger count = self.lesson.questions.count;
    
    if (count <= 5)
    {
        return @[[NSNumber numberWithInt:1], [NSNumber numberWithInt:3]];
    }
    else if (count <= 10)
    {
        return @[[NSNumber numberWithInt:1], [NSNumber numberWithInt:5]];
    }
    else if (count <= 15)
    {
        return @[[NSNumber numberWithInt:1], [NSNumber numberWithInt:3], [NSNumber numberWithInt:5]];
    }
    else if (count <= 20)
    {
        return @[[NSNumber numberWithInt:1], [NSNumber numberWithInt:4], [NSNumber numberWithInt:6]];
    }
    else if (count <= 30)
    {
        return @[[NSNumber numberWithInt:1], [NSNumber numberWithInt:5], [NSNumber numberWithInt:8]];
    }
    else 
    {
        return @[[NSNumber numberWithInt:1], [NSNumber numberWithInt:3], [NSNumber numberWithInt:5], [NSNumber numberWithInt:8]];
    }
}

- (CGSize)contentSizeForLayerCounts:(NSArray *)layourCounts
{
    if (layourCounts.count <= 2)
    {
        return CGSizeMake(800, 800);
    }
    else if (layourCounts.count <= 3)
    {
        return CGSizeMake(1200, 1200);
    }
    else
    {
        return CGSizeMake(1800, 1800);
    }
}

- (void)centerMidPathInsideContentArea:(CGSize)contentArea andMidBounds:(CGRect)midBounds
{
    // get the middle of the contentArea
    CGSize offset = CGSizeMake(contentArea.width / 2.0f, contentArea.height / 2.0f);
    // subtract half the width and height of the midBounds
    offset.width -= midBounds.size.width / 2.0f;
    offset.height -= midBounds.size.height / 2.0f;
    // which gets you the upper right corner in the new coordinate space
    // so we move the midPath by that much, to get its points into that
    // coordinate space.
    [self.midPath movePointsWithXOffset:offset.width andYOffset:offset.height];
}

- (CGFloat)maxLengthForLayer:(int)layerNumber withTotalLayerCount:(int)layerCount withTotalContentArea:(CGSize)contentArea
{
    if (layerNumber > layerCount)
    {
        [NSException raise:NSInvalidArgumentException format:@"Invalid layourNumber!"];
    }
    
    CGFloat maxLength = (contentArea.width - 0) / 2.0f;
    
    float *widths = malloc(sizeof(float) * layerCount);
    
    if (layerCount <= 2)
    {
        widths[0] = 0.0f;
        widths[1] = 0.9f;
    }
    else if (layerCount <= 3)
    {
        widths[0] = 0.0f;
        widths[1] = 0.4f;
        widths[2] = 0.9f;
    }
    else if (layerCount <= 4)
    {
        
        widths[0] = 0.0f;
        widths[1] = 0.3f;
        widths[2] = 0.6f;
        widths[3] = 0.9f;
    }
    else
    {
        for (int i = 0; i < layerCount; i++)
        {
            widths[i] = i+1 * (1 / (float)layerCount) - 0.1;
        }
    }
    
    return widths[layerNumber] * maxLength;
}

#pragma mark - initial Animations

- (void)addlayersViaAnimation
{
    CGRect contentRect = CGRectMake(0, 0, self.scrollView.contentSize.width, self.scrollView.contentSize.height);
    
    // create the contentView
    self.contentView = [[UIView alloc] initWithFrame:contentRect];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    // add a tap gesture recognizer to be able to select areas
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    [self.contentView addGestureRecognizer:recognizer];
    // and it the contentView onto the scrollView
    [self.scrollView addSubview:self.contentView];
    
    // disable interaction while animating
    self.scrollView.scrollEnabled = NO;
    self.scrollView.minimumZoomScale = 1.0;
    self.scrollView.maximumZoomScale = 1.0;
    self.scrollView.delegate = self;
    self.scrollView.zoomScale = 1.0;
    
    // converting the layersArea from P2LGraphPath objects
    // to P2LPathView objects
    NSMutableArray *layersCopy = [self.layers mutableCopy];
    [self.layers removeAllObjects];
    
    for (NSArray *layer in layersCopy)
    {
        NSMutableArray *layerArray = [NSMutableArray new];
        
        for (P2LGraphPath *path in layer)
        {
            CGRect bounds = [path bounds];
            
            P2LPathView *pathView = [[P2LPathView alloc] initWithFrame:bounds andPath:path];
            
            [layerArray addObject:pathView];
        }
        [self.layers addObject:layerArray];
    }
    
    // add each area iteratively
    [self animateDisplayOfAreaWithIndex:0];
    
    // set midPathView
    self.midPathView = [((NSArray *)[self.layers objectAtIndex:0]) objectAtIndex:0];
}

- (void)animateDisplayOfAreaWithIndex:(int)areaIndex
{
    if (areaIndex >= self.paths.count)
    {
        return;
    }
    
    P2LGraphPath *nextPath = [self.paths objectAtIndex:areaIndex];
    P2LPathView *nextView = [self nextPathViewWithIndex:areaIndex];
    
    nextView.alpha = 0.0f;

    [self.areas addObject:nextView];
    [self.contentView addSubview:nextView];
    
    // TODO: scroll to rect.
    CGRect bounds = [nextPath bounds];
    CGPoint midPoint = CGPointMake(bounds.origin.x + (bounds.size.width / 2.0f), bounds.origin.y + (bounds.size.height / 2.0f));
    
    CGFloat offsetX = midPoint.x - (self.view.frame.size.width / 2.0f);
    CGFloat offsetY = midPoint.y - (self.view.frame.size.height / 2.0f);
    
    [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseInOut animations:^(){
        
        self.scrollView.contentOffset = CGPointMake(offsetX, offsetY);
        
    } completion:^(BOOL finished){
        
        [UIView animateWithDuration:0.3 delay:0.1 options:UIViewAnimationOptionCurveEaseIn animations:^(){
            
            nextView.alpha = 1.0f;
            
        } completion:^(BOOL finished){
            
            __block int index = areaIndex+1;
            
            if (index != self.paths.count)
            {
                [self animateDisplayOfAreaWithIndex:index];
            }
            else
            {
                // next up: we have to add some enemy troops
                [self addInitialTroopsViaAnimation];
            }
            
        }];
        
    }];
}

- (P2LPathView *)nextPathViewWithIndex:(int)index
{
    if (_areaViews == nil)
    {
        _areaViews = [NSMutableArray new];
        
        for (NSArray *layer in self.layers)
        {
            
            for (P2LPathView *pathView in layer)
            {
                [_areaViews addObject:pathView];
            }
        }
    }
    
    return [_areaViews objectAtIndex:index];
}


- (void)addInitialTroopsViaAnimation
{
    CGFloat delay = 0.1;
    
    for (int i = 0; i < self.layers.count; i++)
    {
        NSArray *layerAreas = [self.layers objectAtIndex:i];
        
        for (P2LPathView *pathView in layerAreas)
        {
            pathView.forcesLabel.alpha = 0.0;
            [pathView.forcesLabel setText:[NSString stringWithFormat:@"%d", self.layers.count - i]];
            pathView.forcesCount = self.layers.count - i;
            pathView.forcesLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0f];
            pathView.forcesLabel.textColor = [UIColor redColor];
            
            [UIView animateWithDuration:0.1 delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^(){
            
                pathView.forcesLabel.alpha = 1.0;
                
            
            } completion:^(BOOL finished){
            
                [UIView animateWithDuration:0.3 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^(){
                    
                    pathView.forcesLabel.font = [UIFont fontWithName:@"Helvetica" size:24.0f];
                    
                } completion:^(BOOL finished){
                
                    pathView.forcesLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0f];
                
                }];
                
            }];
        }
        delay += 0.1;
    }

    [self performSelector:@selector(enableFirstMove) withObject:self afterDelay:delay];
}

- (void)enableFirstMove
{
    self.currentGameState = ConquerGameStateInitialized;
    
    [self setHeaderNote:@"Anfangsgebiet wählen..."];
    
    // enable interaction
    self.scrollView.scrollEnabled = YES;
    self.scrollView.minimumZoomScale = 0.5;
    self.scrollView.maximumZoomScale = 2.0;
    self.scrollView.delegate = self;
    self.scrollView.zoomScale = 1.0;
    self.scrollView.bouncesZoom = NO;
}

#pragma mark - common animations

- (void)animateNewForcesCount:(int)newCount onPathView:(P2LPathView *)pathView
{
    pathView.forcesLabel.alpha = 0.0;
    pathView.forcesLabel.text = [NSString stringWithFormat:@"%d", newCount];
    pathView.forcesLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0f];
    pathView.forcesCount = newCount;
    
    if (pathView.occupiedByEnemy)
    {
        pathView.forcesLabel.textColor = [UIColor redColor];
    }
    else
    {
        pathView.forcesLabel.textColor = [UIColor blueColor];
    }
    
    [UIView animateWithDuration:0.1 delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^(){
        
        pathView.forcesLabel.alpha = 1.0;
        
        
    } completion:^(BOOL finished){
        
        [UIView animateWithDuration:0.3 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^(){
            
            pathView.forcesLabel.font = [UIFont fontWithName:@"Helvetica" size:24.0f];
            
        } completion:^(BOOL finished){
            
            pathView.forcesLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0f];
            
        }];
        
    }];
}

- (void)displayMoveModalViewWithTargetPathView:(P2LPathView *)target
{
    self.attackedView = target;
    
    self.moveUnitsView = [[P2LMoveUnitsPromptView alloc] initWithFrame:self.view.frame];
    self.moveUnitsView.unitCount = 1;
    self.moveUnitsView.maxCount = self.selectedView.forcesCount - 1;
    self.moveUnitsView.frame = CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [self.moveUnitsView.acceptButton addTarget:self action:@selector(unitMoveAccepted) forControlEvents:UIControlEventTouchUpInside];
    [self.moveUnitsView.cancelButton addTarget:self action:@selector(unitMoveCanceled) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.moveUnitsView];
    
    [UIView animateWithDuration:0.2f animations:^(){
        
        self.moveUnitsView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    } completion:nil];
}

- (void)unitMoveAccepted
{
    [UIView animateWithDuration:0.2f animations:^(){
        
        self.moveUnitsView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        
    } completion:^(BOOL finished){
        
        [self.moveUnitsView removeFromSuperview];
        [self moveUnits];
        
    }];
}

- (void)unitMoveCanceled
{
    [UIView animateWithDuration:0.2f animations:^(){
        
        self.moveUnitsView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        
    } completion:^(BOOL finished){
    
        [self.moveUnitsView removeFromSuperview];
        
    }];
}

- (void)moveUnits
{
    [self animateNewForcesCount:(self.attackedView.forcesCount + self.moveUnitsView.unitCount) onPathView:self.attackedView];
    [self animateNewForcesCount:(self.selectedView.forcesCount - self.moveUnitsView.unitCount) onPathView:self.selectedView];
    
    [self deselectAreas];
    
    self.skipButton.alpha = 0.0f;
    self.skipButton.enabled = NO;
    
    self.currentGameState = ConquerGameStateEnemyTurn;
    [self enemyTurn];
}

- (void)setHeaderNote:(NSString *)note
{
    self.headerNoteLabel.text = note;
}

- (void)userWinAnimation
{
    // display a simple victory label, mark the level as finished and the return to level
    // overview.
    UILabel *victoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.center.y-100, 200, 30)];
    
    [self.view addSubview:victoryLabel];
    
    [UIView animateWithDuration:0.2 delay:0.4 options:UIViewAnimationOptionCurveEaseInOut animations:^(){
    
        victoryLabel.center = self.view.center;
    
    } completion:^(BOOL finished){
    
        [self.mainViewController dismissViewController:self fromDirection:SubViewDirectionLeftToRight];
    
    }];
    
    // TODO: save level as done
    
    [self.view addSubview:victoryLabel];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
    
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.contentView;
}

#pragma mark - P2LMainViewSubViewControllerDelegate methods

- (void)presentViewController:(UIViewController *)viewController fromDirection:(SubViewDirection)direction
{
    self.challengeViewController = (P2LConquerChallengeViewController *)viewController;
    
    self.challengeViewController.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    
    [self.view addSubview:self.challengeViewController.view];
    
    [UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^(){
        
        self.challengeViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        
    } completion:^(BOOL finished){
        
        [self.challengeViewController beginAnimations];
        
    }];
}
- (void)dismissViewController:(UIViewController *)viewController fromDirection:(SubViewDirection)direction
{
    [UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^(){
        
        self.challengeViewController.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
        
    } completion:^(BOOL finished){
        
        [self.challengeViewController.view removeFromSuperview];
        
    }];
}

#pragma mark - P2LInquiryViewControllerDelegate methods

- (void)didFinishInquiry:(Inquiry *)inquiry withCorrectness:(CGFloat)correctness
{
    [UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^(){
        
        self.inquiryController.view.frame = CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
        
    } completion:^(BOOL finished){
        
        [self.inquiryController.view removeFromSuperview];
        self.inquiryController = nil;
        
        [self inquiryFinishedWithCorrectness:correctness];
    }];
}

@end
