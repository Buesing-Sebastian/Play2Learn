//
//  P2LQTIAssessmentItemImporter.m
//  Play2Learn
//
//  Created by Sebastian Büsing on 02.06.13.
//  Copyright (c) 2013 Sebastian Büsing. All rights reserved.
//

#import "P2LQTIAssessmentItemImporter.h"
#import "Question+DBAPI.h"
#import "Answer+DBAPI.h"
#import "Catalog+DBAPI.h"
#import "XMLReader.h"

@implementation P2LQTIAssessmentItemImporter

+ (void)importAssessmentItemRefUsingDictionary:(NSDictionary *)dictionary intoLesson:(Lesson *)lesson
{
    if (dictionary == nil || lesson == nil)
    {
        NSLog(@"Error: cannot import Item without dictionary or lesson.");
    }
    else
    {
        NSString *href = [dictionary objectForKey:@"href"];
        NSString *identifier = [dictionary objectForKey:@"identifier"];
        
        if (identifier && href)
        {
            identifier = [identifier stringByReplacingOccurrencesOfString:@"question" withString:@""];
            
            Question *question = (Question *)[Question findModelWithPrimaryKey:[identifier intValue]];
            
            if (!question)
            {
                question = [[Question alloc] initEntity];
            }
            else
            {
                NSSet *answers = question.answers;
                
                for (Answer *answer in answers)
                {
                    [answer deleteModel];
                }
                
                question.answers = nil;
                question.correctAnswers = nil;
                [question save];
            }
            
            question.lesson = lesson;
            [lesson addQuestionsObject:question];
            
            NSData *data;
            
            if ([lesson.catalog.href isEqualToString:@""])
            {
                NSString *filePath = [[NSBundle mainBundle] pathForResource:identifier ofType:@"xml"];
                data = [NSData dataWithContentsOfFile:filePath];
            }
            else
            {
                NSString *string = [NSString stringWithContentsOfURL:[NSURL URLWithString:[lesson.catalog.href stringByAppendingFormat:@"%@.xml", identifier]]
                                                            encoding:NSUTF8StringEncoding
                                                               error:nil];
                data = [string dataUsingEncoding:NSUTF8StringEncoding];
            }
            
            
            
            NSError *error = nil;
            NSDictionary *assessmentItem = [XMLReader dictionaryForXMLData:data error:&error];
            
            if (assessmentItem)
            {
                [self importAssessmentItemDictionary:(NSDictionary *)[assessmentItem objectForKey:@"assessmentItem"] forQuestion:question];
            }
            else
            {
                NSLog(@"could not grab assessmentItem from href: %@", href);
            }
        }
        else
        {
            NSLog(@"Error: cannot import AssessmentItemRef without identifier or href");
        }
    }
}

+ (void)importAssessmentItemDictionary:(NSDictionary *)dictionary forQuestion:(Question *)question
{
    if (dictionary == nil || question == nil)
    {
        NSLog(@"Error: cannot import Item without dictionary or question.");
    }
    else
    {
        NSDictionary *responseDeclaration = [dictionary objectForKey:@"responseDeclaration"];
        NSDictionary *outcomeDeclaration = [dictionary objectForKey:@"outcomeDeclaration"];
        NSDictionary *itemBody = [dictionary objectForKey:@"itemBody"];
        
        if (responseDeclaration && outcomeDeclaration && itemBody)
        {
            NSDictionary *correctResponses = [responseDeclaration objectForKey:@"correctResponse"];
            NSDictionary *defaultValue = [outcomeDeclaration objectForKey:@"defaultValue"];
            NSDictionary *choiceInteraction = [itemBody objectForKey:@"choiceInteraction"];
            
            if (correctResponses && defaultValue && choiceInteraction)
            {
                NSDictionary *prompt = [choiceInteraction objectForKey:@"prompt"];
                
                if (prompt)
                {
                    question.prompt = [prompt objectForKey:@"text"];
                    question.difficulty = (int16_t)[[[defaultValue objectForKey:@"value"] objectForKey:@"text"] intValue];
                    
                    NSArray *choices = [choiceInteraction objectForKey:@"simpleChoice"];
                    NSArray *correctChoices = [correctResponses isKindOfClass:[NSMutableDictionary class]] ? [correctResponses objectForKey:@"value"] : correctResponses;
                    
                    if (choices && correctChoices)
                    {
                        if ([correctChoices isKindOfClass:[NSDictionary class]])
                        {
                            correctChoices = [NSArray arrayWithObject:correctChoices];
                        }
                        else
                        {
                            NSMutableArray *temp = [NSMutableArray new];
                            
                            for (NSDictionary *cDict in correctChoices)
                            {
                                [temp addObject:[cDict objectForKey:@"value"]];
                            }
                            correctChoices = temp;
                        }
                        
                        for (NSDictionary *answer in choices)
                        {
                            Answer *importedAnswer = [self importAnswer:answer intoQuestion:question];
                            
                            if (importedAnswer == nil)
                            {
                                continue;
                            }
                            
                            [question addAnswersObject:importedAnswer];
                            
                            NSString *identifier = [answer objectForKey:@"identifier"];
                            
                            if (identifier)
                            {
                                for (NSDictionary *correctChoice in correctChoices)
                                {
                                    if ([[correctChoice objectForKey:@"text"] isEqualToString:identifier])
                                    {
                                        [question addCorrectAnswersObject:importedAnswer];
                                    }
                                }
                            }
                            else
                            {
                                NSLog(@"Error: Answer has no identifier");
                            }
                            
                        
                        }
                        [question save];
                    }
                    else
                    {
                        NSLog(@"Error: could not find answers");
                    }
                }
                else
                {
                    NSLog(@"Error: could not find prompt for question!");
                }
            }
            else
            {
                NSLog(@"Error: cannot import AssessmentItem without correctResponse, defaultValue or choiceInteraction");
            }
        }
        else
        {
            NSLog(@"Error: cannot import AssessmentItem without responseDeclaration, outcomeDeclaration or itemBody");
        }
    }
}

+ (Answer *)importAnswer:(NSDictionary *)answerDictionary intoQuestion:(Question *)question
{
    NSString *answerId = [answerDictionary objectForKey:@"identifier"];
    
    if (answerId)
    {
        Answer *answer = [[Answer alloc] initEntity];
        
        answer.text = [answerDictionary objectForKey:@"text"];
        answer.question = question;
        
        [answer save];
        
        return answer;
    }
    else
    {
        NSLog(@"Error: answer has no id!");
    }
    
    return nil;
}

@end
