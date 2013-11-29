//
//  LineClassifier.h
//  TesseractSample
//
//  Created by Diego Canales on 11/23/13.
//
//

#import <Foundation/Foundation.h>

@interface LineClassifier : NSObject

- (id) initWithTrainingStrings:(NSMutableArray *)trainingData andActualAssignments:(NSMutableArray *)actualAssignments;
+ (NSMutableArray *) extractFeaturesFromLine:(NSString *)line;
- (int) classifyLine:(NSMutableArray *)features;
- (int) classifyUsingDecisionTree:(NSMutableArray *)features;


@end
