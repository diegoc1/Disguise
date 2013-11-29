//
//  SVMClassifier.h
//  TesseractSample
//
//  Created by Diego Canales on 11/28/13.
//
//

#import <Foundation/Foundation.h>

@interface SVMClassifier : NSObject
- (id) initWithPoints:(NSArray *)points actualClassifications:(NSArray *)classifications featureLength:(int)length;

- (int) classifyFeaturesForLine:(NSArray *)features;
@property (nonatomic, assign) CvSVM SVM;

@end
