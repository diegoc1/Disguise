//
//  SVMClassifier.h
//  TesseractSample
//
//  Created by Diego Canales on 11/28/13.
//
//

#import <Foundation/Foundation.h>

@interface SVMClassifier : NSObject {
    cv::SVM SVM;
}
- (id) initWithPoints:(NSArray *)points actualClassifications:(NSArray *)classifications featureLength:(int)length;

- (float) classifyFeaturesForLine:(NSArray *)features;

@end
