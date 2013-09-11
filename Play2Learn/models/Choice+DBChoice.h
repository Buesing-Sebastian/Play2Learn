//
//  Choice+DBChoice.h
//  Play2Learn
//
//  Created by Sebastian Büsing on 07.06.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import "Choice.h"

@interface Choice (DBChoice)

- (id)initWithInquiry:(Inquiry *)inquiry question:(Question *)question andAnswers:(Answer *)answer;

- (void)save;

@end
