//
//  P2LLatexXMLConverter.m
//  Play2Learn
//
//  Created by Sebastian Büsing on 24.06.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import "P2LLatexXMLConverter.h"

@implementation P2LLatexXMLConverter

+ (void)parseFile:(NSString *)filePath
{
    NSString *searchText = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];

    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(?<=frage\\{).*?(:\\}|:\\n\\}|\\.\\}|\\?\\})"
                                                                           options:NSRegularExpressionDotMatchesLineSeparators
                                                                             error:&error];
    
    NSArray *matches = [regex matchesInString:searchText options:0 range:NSMakeRange(0, [searchText length])];
    
    NSMutableArray *questions = [NSMutableArray new];
    
    int questionCount = 1;
    
    for (NSTextCheckingResult *result in matches)
    {
        NSString *match = [searchText substringWithRange:result.range];
        
        if ([match hasSuffix:@"}"])
        {
            match = [match substringToIndex:[match length]-2];
        }
        NSMutableDictionary *questionDict = [NSMutableDictionary new];
        
        [questionDict setObject:match forKey:@"question"];
        [questionDict setObject:[NSString stringWithFormat:@"question%d", questionCount] forKey:@"Id"];
        [questionDict setObject:[NSMutableArray new] forKey:@"answers"];
        [questionDict setObject:[NSMutableArray new] forKey:@"correct"];
        [questions addObject:questionDict];
        questionCount++;
    }
    
    error = NULL;
    regex = [NSRegularExpression regularExpressionWithPattern:@"(?<=antw)(false|right).*?(\\.|\\}\\n)"
                                                      options:NSRegularExpressionDotMatchesLineSeparators
                                                        error:&error];
    matches = [regex matchesInString:searchText options:0 range:NSMakeRange(0, [searchText length])];
    
    
    int answerCount = 1;
    questionCount = 1;
    
    for (NSTextCheckingResult *result in matches)
    {
        NSString *match = [searchText substringWithRange:result.range];
        
        BOOL correctOne = NO;
        
        if ([match hasPrefix:@"right"])
        {
            correctOne = YES;
        }
        match = [match substringFromIndex:6];
        
        NSMutableDictionary *questionDict = [questions objectAtIndex:questionCount-1];
        NSMutableArray *answers = [questionDict objectForKey:@"answers"];
        NSMutableArray *correct = [questionDict objectForKey:@"correct"];
        
        [answers addObject:match];
        
        if (correctOne)
        {
            [correct addObject:[self charForNum:answerCount]];
        }
        
        answerCount = answerCount == 4 ? 1 : answerCount + 1;
        questionCount = answerCount == 1 ? questionCount + 1 : questionCount;
    }
    
    [self outputQuestions:questions];
}

+ (void)parseExportedLyxFile:(NSString *)filePath
{
    // (?<=\\begin{itemize}\n).*?(?=\\end{itemize})   ----    @"(?<=frage\\{).*?(:\\}|:\\n\\}|\\.\\}|\\?\\})" --- (?<=antw)(false|right).*?(\\.|\\}\\n)

    NSString *searchText = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    //questions
    
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(?<=(\\\\subsubsection)).*?(:)"
                                                                           options:NSRegularExpressionDotMatchesLineSeparators
                                                                             error:&error];
    
    NSArray *matches = [regex matchesInString:searchText options:0 range:NSMakeRange(0, [searchText length])];
    
    NSMutableArray *questions = [NSMutableArray new];
    
    int questionCount = 1;
    
    for (NSTextCheckingResult *result in matches)
    {
        NSString *match = [searchText substringWithRange:result.range];
        
        match = [match substringFromIndex:1];
        NSMutableDictionary *questionDict = [NSMutableDictionary new];
        
        [questionDict setObject:match forKey:@"question"];
        [questionDict setObject:[NSString stringWithFormat:@"question%d", questionCount] forKey:@"Id"];
        [questionDict setObject:[NSMutableArray new] forKey:@"answers"];
        [questionDict setObject:[NSMutableArray new] forKey:@"correct"];
        [questions addObject:questionDict];
        questionCount++;
    }
    
    // answers
    
    // The NSRegularExpression class is currently only available in the Foundation framework of iOS 4
    error = NULL;
    regex = [NSRegularExpression regularExpressionWithPattern:@"(?<=Richtige Antwort: ).*?(?=%)"
                                                      options:NSRegularExpressionDotMatchesLineSeparators error:&error];
    NSArray *correctAnswerMatches = [regex matchesInString:searchText options:0 range:NSMakeRange(0, [searchText length])];
    
    error = NULL;
    regex = [NSRegularExpression regularExpressionWithPattern:@"(?<=\\\\begin\\{itemize\\}\\n).*?(?=\\\\end\\{itemize\\})"
                                                      options:NSRegularExpressionDotMatchesLineSeparators
                                                        error:&error];
    matches = [regex matchesInString:searchText options:0 range:NSMakeRange(0, [searchText length])];
    
    questionCount = 1;
    
    for (NSTextCheckingResult *result in matches)
    {
        NSString *match = [searchText substringWithRange:result.range];
        
        // correct answer
        NSTextCheckingResult *correctAnswerResult = [correctAnswerMatches objectAtIndex:questionCount-1];
        
        NSString *correctAnswer = [searchText substringWithRange:correctAnswerResult.range];
        NSArray *correctAnswers = [correctAnswer componentsSeparatedByString:@","];
        
        NSMutableDictionary *questionDict = [questions objectAtIndex:questionCount-1];
        
        NSMutableArray *questionAnswers = [questionDict objectForKey:@"answers"];
        NSMutableArray *correct = [questionDict objectForKey:@"correct"];
        
        NSArray *answers = [match componentsSeparatedByString:@"\n"];
        
        for (int i = 0; i < 4; i++)
        {
            NSString *answer = [answers objectAtIndex:i];
            
            answer = [answer substringFromIndex:5];
            
            [questionAnswers addObject:answer];
            
            for (NSString *letter in correctAnswers)
            {
                if (i == [self numForChar:letter])
                {
                    [correct addObject:letter];
                    break;
                }
            }
        }
        
        questionCount++;
    }
    
    [self outputQuestions:questions];
}

+ (void)outputQuestions:(NSArray *)questions
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"template" ofType:@"xml"];
    NSString *template = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    for (NSMutableDictionary *dict in questions)
    {
        NSString *output = [template stringByReplacingOccurrencesOfString:@"{{prompt}}" withString:[dict objectForKey:@"question"]];
        
        NSMutableArray *answers = [dict objectForKey:@"answers"];
        NSMutableArray *correct = [dict objectForKey:@"correct"];
        
        output = [output stringByReplacingOccurrencesOfString:@"{{answerA}}" withString:[answers objectAtIndex:0]];
        output = [output stringByReplacingOccurrencesOfString:@"{{answerB}}" withString:[answers objectAtIndex:1]];
        output = [output stringByReplacingOccurrencesOfString:@"{{answerC}}" withString:[answers objectAtIndex:2]];
        output = [output stringByReplacingOccurrencesOfString:@"{{answerD}}" withString:[answers objectAtIndex:3]];
        
        NSString *correctResponse = @"";
        
        for (NSString *correctAnswer in correct)
        {
            correctResponse = [correctResponse stringByAppendingFormat:@"<correctResponse>\n<value>%@</value>\n</correctResponse>\n", correctAnswer];
        }
        
        output = [output stringByReplacingOccurrencesOfString:@"{{correctResponse}}" withString:correctResponse];
        
        printf("\n\n");
        printf("%s", [output UTF8String]);
    }
}

+ (NSString *)charForNum:(int)num
{
    switch (num) {
        case 1:
            return @"A";
            break;
            
        case 2:
            return @"B";
            break;
            
        case 3:
            return @"C";
            break;
            
        case 4:
            return @"D";
            break;
    }
    return nil;
}

+ (int)numForChar:(NSString *)string
{
    if  ([string isEqualToString:@"A"])
    {
        return 0;
    }
    else if ([string isEqualToString:@"B"])
    {
        return 1;
    }
    else if ([string isEqualToString:@"C"])
    {
        return 2;
    }
    else if ([string isEqualToString:@"D"])
    {
        return 3;
    }
    return -1;
}

@end
