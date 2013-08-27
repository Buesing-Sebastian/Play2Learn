//
//  P2LLessonSelectionDelegate.h
//  Play2Learn
//
//  Created by Sebastian Büsing on 23.06.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Lesson.h"

@protocol P2LLessonSelectionDelegate <NSObject>

@required

- (void)didSelectLesson:(Lesson *)lesson;

@end
