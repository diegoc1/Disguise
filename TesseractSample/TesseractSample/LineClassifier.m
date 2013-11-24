//
//  LineClassifier.m
//  TesseractSample
//
//  Created by Diego Canales on 11/23/13.
//
//

#import "LineClassifier.h"

@implementation LineClassifier


- (id) initWithTrainingStrings:(NSMutableArray *)trainingData {
    self = [super init];
    if (self) {
        NSLog(@"CREATING with strings %@", trainingData);
      //  [self extractFeaturesFromLine:trainingData[0]];
    }
    return self;
}

- (NSMutableArray *) extractFeaturesFromLine:(NSString *)line {
    NSLog(@"extracting features for line %@", line);
    return nil;
    
}

@end
