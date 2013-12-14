//
//  WordDictionary.m
//  SpellCheck
//
//  Created by Diego Canales on 12/3/13.
//  Copyright (c) 2013 Diego Canales. All rights reserved.
//

#import "WordDictionary.h"

@implementation WordDictionary

//Reads in from lexicon.txt and creates an NSDictionary of words from that lexicon
-(id)init {
    self = [super init];
    if (self) {
        NSString* path = [[NSBundle mainBundle] pathForResource:@"lexicon" ofType:@"txt"];
        NSString* content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
        self.dict = [NSSet setWithArray: [content componentsSeparatedByString:@"\n" ]];
        
    }
    return self;
}

//Public function that returns TRUE if the word is dictionary.  Otherwise returns FALSE
-(BOOL)wordExists:(NSString *)word {
    return [self.dict containsObject: [word lowercaseString]];
}

@end
