//
//  P2LCatalogDetailsViewController.m
//  Play2Learn
//
//  Created by Sebastian Büsing on 22.06.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import "P2LCatalogDetailsViewController.h"
#import "P2LQTIImporter.h"

@interface P2LCatalogDetailsViewController ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *hrefLabel;
@property (nonatomic, strong) UILabel *noteLabel;
@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong) UITextField *hrefField;
@property (nonatomic, strong) UIButton *saveButton;

@end

@implementation P2LCatalogDetailsViewController

- (id)initWithFrame:(CGRect)frame andCatalog:(Catalog *)catalog
{
    self = [super initWithFrame:frame];
    if (self) {
        // Custom initialization
        self.catalog = catalog;
        
        CGRect frame = CGRectMake(10, 60, self.view.frame.size.width-20, 30);
        self.nameLabel = [[UILabel alloc] initWithFrame:frame];
        self.nameLabel.text = @"Name des Katalogs:";
        self.nameLabel.backgroundColor = [UIColor clearColor];
        
        frame = CGRectMake(10, 110, self.view.frame.size.width-20, 25);
        self.nameField = [[UITextField alloc] initWithFrame:frame];
        self.nameField.autocorrectionType = UITextAutocorrectionTypeNo;
        self.nameField.backgroundColor = [UIColor lightGrayColor];
        self.nameField.text = self.catalog.name;
        
        frame = CGRectMake(10, 160, self.view.frame.size.width-20, 30);
        self.hrefLabel = [[UILabel alloc] initWithFrame:frame];
        self.hrefLabel.text = @"URL des Katalogs:";
        self.hrefLabel.backgroundColor = [UIColor clearColor];
        
        frame = CGRectMake(10, 210, self.view.frame.size.width-20, 25);
        self.hrefField = [[UITextField alloc] initWithFrame:frame];
        self.hrefField.autocorrectionType = UITextAutocorrectionTypeNo;
        self.hrefField.backgroundColor = [UIColor lightGrayColor];
        self.hrefField.text = self.catalog.href;
        
        frame = CGRectMake(10, 260, self.view.frame.size.width-20, 30);
        self.noteLabel = [[UILabel alloc] initWithFrame:frame];
        self.noteLabel.text = @"";
        self.noteLabel.backgroundColor = [UIColor clearColor];
        
        self.saveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.saveButton.frame = CGRectMake(self.view.frame.size.width - 110, 10, 100, 44);
        [self.saveButton setTitle:@"Speichern!" forState:UIControlStateNormal];
        [self.saveButton addTarget:self action:@selector(saveButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        
        // add subviews
        [self.view addSubview:self.nameLabel];
        [self.view addSubview:self.nameField];
        [self.view addSubview:self.hrefLabel];
        [self.view addSubview:self.hrefField];
        [self.view addSubview:self.noteLabel];
        [self.view addSubview:self.saveButton];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private methods

- (void)saveButtonPressed
{
    Catalog *catalog;
    
    if (self.catalog)
    {
        catalog = self.catalog;
    }
    else
    {
        catalog = [[Catalog alloc] initEntity];
    }
    
    
    catalog.name = self.nameField.text;
    catalog.href = self.hrefField.text;
    
    self.noteLabel.text = @"importing...";
    self.saveButton.enabled = NO;
    
    [P2LQTIImporter importDataForCatalog:catalog];
    
    [self.mainViewController dismissViewController:self fromDirection:SubViewDirectionLeftToRight];
}


@end
