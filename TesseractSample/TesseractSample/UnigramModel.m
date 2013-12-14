//
//  UnigramModel.m
//  SpellCheck
//
//  Created by Diego Canales on 12/3/13.
//  Copyright (c) 2013 Diego Canales. All rights reserved.
//

#import "UnigramModel.h"

@implementation UnigramModel

//Reads in the NewCorpus and creates a dictionary that keeps track of the unigram counts for each word in the corpus
-(id)init {
    self = [super init];
    if (self) {
        NSString* path = [[NSBundle mainBundle] pathForResource:@"NewCorpus" ofType:@"txt"];
        NSString* content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
        NSArray *chunks = [content componentsSeparatedByString: @" "];
        self.dict = [[NSMutableDictionary alloc] initWithCapacity:1000000];
        for (NSString *word in chunks) {
            if (![self.dict objectForKey:word]) [self.dict setObject:[NSNumber numberWithInt:0] forKey:word];
            int count = [[self.dict objectForKey:word] intValue];
            count += 1;
            [self.dict setObject:[NSNumber numberWithInt:count] forKey:word];
        }
    }
    return self;
}

@end
