//
//  WordDictionary.h
//  SpellCheck
//
//  Created by Diego Canales on 12/3/13.
//  Copyright (c) 2013 Diego Canales. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WordDictionary : NSObject
@property (strong, nonatomic) NSSet *dict;

-(BOOL)wordExists:(NSString *)word;
@end
