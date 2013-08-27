//
//  P2LLatexXMLConverter.h
//  Play2Learn
//
//  Created by Sebastian Büsing on 24.06.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface P2LLatexXMLConverter : NSObject

+ (void)parseFile:(NSString *)filePath;

+ (void)parseExportedLyxFile:(NSString *)filePath;

@end
