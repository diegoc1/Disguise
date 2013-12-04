//
//  SVMClassifier.m
//  TesseractSample
//
//  Created by Diego Canales on 11/28/13.
//
//

#import "SVMClassifier.h"
#include <OpenCV/opencv2/core/core.hpp>
#include <OpenCV/opencv2/highgui/highgui.hpp>
#include <OpenCV/opencv2/ml/ml.hpp>
#import "LineClassifier.h"

@interface SVMClassifier ()
@property (nonatomic) int numFeatures;

@end

@implementation SVMClassifier

using namespace cv;

- (id) initWithPoints:(NSArray *)points actualClassifications:(NSArray *)classifications featureLength:(int)length {
    self = [super init];
    if (self) {
        // Set up training data
        self.numFeatures = [points[0] count];
        int numPoints = [points count];
        float** ary = new float*[numPoints];
        for(int i = 0; i < numPoints; ++i) {
            ary[i] = new float[length];
            for (int j = 0; j < length; j++) {
                ary[i][j] = [[(NSArray *)[points objectAtIndex:i] objectAtIndex:j] floatValue];
            }
        }
        float *clas = new float[numPoints];
        for (int i = 0; i < numPoints; i++) {
            
            if ([[classifications objectAtIndex:i] isEqualToString:@"I"]) {
                clas[i] = -1;
            } else {
                clas[i] = 1;
            }
        }
        Mat labelsMat(numPoints, 1, CV_32FC1, clas);
        Mat trainingDataMat(numPoints, self.numFeatures, CV_32FC1, ary);
        std::cout << "M = "<< std::endl << " "  << trainingDataMat << std::endl << std::endl;
        CvSVMParams params;
        params.svm_type    = CvSVM::C_SVC;
        params.kernel_type = CvSVM::POLY;
        params.gamma = 1;
        params.degree = 4;
        params.term_crit   = cvTermCriteria(CV_TERMCRIT_ITER, 100, 1e-6);
        //        params.term_crit = cvTermCriteria( CV_TERMCRIT_ITER+CV_TERMCRIT_EPS, 1000, FLT_EPSILON );
        SVM.train(trainingDataMat, labelsMat, Mat(), Mat(), params);
    }
    
    return self;
}

- (float) classifyFeaturesForLine:(NSArray *)features {
    float *cf = new float[[features count]];
    for (int i = 0; i < [features count]; i++) {
        cf[i] = [[features objectAtIndex:i] intValue];
    }
    Mat sMat(self.numFeatures , 1, CV_32FC1, cf);
    float response = SVM.predict(sMat);
    return response;
}


@end
