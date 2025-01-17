//
//  LineClassifier.m
//  TesseractSample
//
//  Created by Diego Canales on 11/23/13.
//
//

#import "LineClassifier.h"

@interface LineClassifier()

@property (strong,nonatomic) NSMutableArray *weights;

@end

@implementation LineClassifier


- (id) initWithTrainingStrings:(NSMutableArray *)trainingData andActualAssignments:(NSMutableArray *)actualAssignments {
    self = [super init];
    if (self) {
        self.weights = [[NSMutableArray alloc] init];
    }
    return self;
}

//Uses the perceptron algorithm to train the classifier
- (void) trainClassifier: (NSMutableArray *) trainingData withAssignments:(NSMutableArray *) assignments{
    for (int i = 0; i < [trainingData count]; i++) {
        NSString *curr_line = [trainingData objectAtIndex:i];
        NSMutableArray *features_for_line = [LineClassifier extractFeaturesFromLine:curr_line];
        int classificaiton = [self classifyLine:features_for_line];
        int actual_classificaiton = [self getIntegerClassification:assignments[i]];
        NSLog(@"actual: %d vs predicted: %d", actual_classificaiton, classificaiton);
        if (actual_classificaiton != classificaiton) {
            
            NSLog(@"UPDATE");
            for (int j = 0; j < [self.weights count]; j++) {
                double update = [self.weights[j] doubleValue] + (actual_classificaiton * [features_for_line[j] doubleValue]);
                NSLog(@"update is %f", update);
                self.weights[j] = [NSNumber numberWithDouble:update];
            }
        }
    }
}
//Returns an integer classification from a string classification
- (int) getIntegerClassification: (NSString *) classification {
    if ([classification isEqualToString:@"I"]) return 1;
    return -1;
}


+ (int) getNumDigits: (NSString *)str {
    int count = 0;
    for (int i = 0; i < str.length; i++) {
        if (isdigit([str characterAtIndex:i])) count++;
    }
    return count;
}

- (double) dotProduct: (NSMutableArray *) features withWeightVector:(NSMutableArray *)weights {
    int length = [features count];
    double sum = 0;
    for (int i = 0; i < length; i++) {
        sum += ([[features objectAtIndex:i] doubleValue] * [[weights objectAtIndex:i] doubleValue]);
    }
    return sum;
}

//clasifies a line by using dot product
- (int) classifyLine:(NSMutableArray *)features {
    double dot_prod = [self dotProduct:features withWeightVector:self.weights];
    if (dot_prod > 0) return 1;
    return -1;
}


//- (int) classifyUsingDecisionTree:(NSMutableArray *)features {
//    double item_prob = 0;
//    double total_prob = 0;
//    double other_prob = 0;
//    
//    if ([features[0] integerValue] > 13) {
//        item_prob += 0.2;
//        total_prob -= 0.2;
//        other_prob += 0.1;
//    } else {
//        item_prob -= 0.2;
//        total_prob += 0.5;
//        other_prob += 0.1;
//    }
//    
//    if ([features[1] integerValue] == 1) {
//        item_prob += 0.7;
//        total_prob += 0.7;
//        other_prob -= 0.7;
//    } else {
//        other_prob += 0.5;
//    }
//    
//    if ([features[2] integerValue] == 1) {
//        total_prob += 1.0;
//        item_prob -= 0.2;
//        other_prob -= 0.2;
//    } else {
//        total_prob -= 1.0;
//    }
//    
//    if ([features[3] integerValue] >= 3 && [features[3] integerValue] < 5) {
//        total_prob += 0.7;
//        item_prob += 0.7;
//        other_prob -= 0.2;
//    } else {
//        item_prob -= 0.7;
//        total_prob -= 0.7;
//        other_prob += 0.4;
//    }
//    
//    if ([features[4] integerValue] == 1) {
//        total_prob += 0.4;
//        item_prob += 0.4;
//        other_prob -= 0.2;
//    } else {
//        item_prob -= 0.7;
//        total_prob -= 0.7;
//        other_prob += 0.5;
//    }
//    
//    if ([features[5] integerValue] == 1) {
//        total_prob -= 0.4;
//        item_prob -= 0.4;
//        other_prob += 0.3;
//    }
//    
//    if ([features[6] integerValue] == 1) {
//        other_prob += 0.5;
//        item_prob -= 0.2;
//        total_prob -= 0.2;
//    }
//    
//    if ([features[7] integerValue] == 1) {
//        item_prob += 1.2;
//        other_prob -= 0.2;
//        total_prob -= 0.5;
//    }
//    
//    if ([features[9] integerValue] == 1) {
//        item_prob += 5.2;
//        other_prob -= 5;
//        total_prob += 5.2;
//    } else {
//        other_prob += 0.1;
//    }
//    
//    NSLog(@"item_prob :%f   total_prob: %f    other_prob: %f", item_prob, total_prob, other_prob);
//    NSArray *items = @[[NSNumber numberWithDouble:other_prob], [NSNumber numberWithDouble:item_prob], [NSNumber numberWithDouble:total_prob]];
//    double max_item = [self findMax:items];
//  //  NSLog(@"max is %f", max_item);
//    if (max_item == item_prob) return 0;
//    else if (max_item == total_prob) return 1;
//    else return 2;
//}

//Returns a max from an array of numbers
-(double) findMax:(NSArray *)items {
    double max_val = INT_MIN;
    for (int i = 0; i < [items count];i++) {
        if ([[items objectAtIndex:i] doubleValue] > max_val) {
            max_val = [[items objectAtIndex:i] doubleValue];
        }
    }
    return max_val;
}


+ (BOOL) capitalizationExceedsThresh: (NSString *) line {
    int totalCapitalized = 0;
    for (int i = 0; i < line.length; i++) {
        if ([[NSCharacterSet uppercaseLetterCharacterSet] characterIsMember:[line characterAtIndex:i]]) {
            totalCapitalized++;
        }
    }
    return  totalCapitalized > 5;
    
}
- (void)normalizedFeatures:(NSMutableArray *) features {
    double sum = 0;
    for (int i = 0;i < [features count];i++) {
        sum += pow([features[i] doubleValue], 2);
    }
    sum = sqrt(sum);
    for (int i = 0;i < [features count];i++) {
        features[i] = [NSNumber numberWithDouble:[features[i] doubleValue] / sum];
    }
}

//Simple feature exctractor
+ (NSMutableArray *) extractFeaturesFromLine:(NSString *)line {
 //   NSLog(@"extracting features for line %@", line);
    
    NSString *lower_case_version = [line lowercaseString];
    NSMutableArray *features = [[NSMutableArray alloc] init];
    //1) Number of characters
    [features addObject:[NSNumber numberWithInteger:1]];
    
    //2) Contains '$'
    if ([lower_case_version rangeOfString:@"$"].location != NSNotFound) {
        [features addObject:[NSNumber numberWithInteger:1]];
    } else {
        [features addObject:[NSNumber numberWithInteger:0]];
    }
    
    //3) Contains total
    if ([lower_case_version rangeOfString:@"total"].location != NSNotFound) {
        [features addObject:[NSNumber numberWithInteger:1]];
    } else {
        [features addObject:[NSNumber numberWithInteger:0]];
    }
    
    //4 Number of digits
    [features addObject:[NSNumber numberWithInteger:[self getNumDigits:lower_case_version]]];
  //  [features addObject:[NSNumber numberWithInteger:1]];
    
    //5 Contains .
    if ([lower_case_version rangeOfString:@"."].location != NSNotFound) {
        [features addObject:[NSNumber numberWithInteger:1]];
    } else {
        [features addObject:[NSNumber numberWithInteger:0]];
    }
    
    //6 Contains %
    if ([lower_case_version rangeOfString:@"%"].location != NSNotFound) {
        [features addObject:[NSNumber numberWithInteger:1]];
    } else {
        [features addObject:[NSNumber numberWithInteger:0]];
    }
    
    //7 Contains :
    if ([lower_case_version rangeOfString:@":"].location != NSNotFound) {
        [features addObject:[NSNumber numberWithInteger:1]];
    } else {
        [features addObject:[NSNumber numberWithInteger:0]];
    }
    
    //8
    if (isdigit([lower_case_version characterAtIndex:0])) {
        [features addObject:[NSNumber numberWithInteger:1]];
    } else {
        [features addObject:[NSNumber numberWithInteger:0]];
    }
    
    //9
    if ([LineClassifier capitalizationExceedsThresh:line]) {
        [features addObject:[NSNumber numberWithInteger:1]];
    } else {
        [features addObject:[NSNumber numberWithInteger:0]];
    }
    
    //10
    NSString *someRegexp = @"(\\d.\\d\\d)";
    NSPredicate *myTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", someRegexp];
    
    if ([myTest evaluateWithObject: line]){
      //  NSLog(@"MATTTTCH");
    }
 //   NSError *errRegex = NULL;
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[0-9].[0-9][0-9]"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSUInteger countMatches = [regex numberOfMatchesInString:line
                                                        options:0
                                                          range:NSMakeRange(0, [line length])];
     [features addObject:[NSNumber numberWithInteger:countMatches]];
    return features;
    
}


@end
