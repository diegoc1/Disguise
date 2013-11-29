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


@implementation SVMClassifier

using namespace cv;

- (id) initWithPoints:(NSArray *)points actualClassifications:(NSArray *)classifications featureLength:(int)length {
    self = [super init];
    if (self) {
        int width = 512, height = 512;
        Mat image = Mat::zeros(height, width, CV_8UC3);
        NSLog(@"feature length is %d", length);
        // Set up training data
        float labels[4] = {1.0, 1.0, -1.0, -1.0};
        NSLog(@"class: %@", classifications);
        int numPoints = [points count];
        float** ary = new float*[numPoints];
        for(int i = 0; i < numPoints; ++i) {
            ary[i] = new float[length];
            for (int j = 0; j < length; j++) {
                ary[i][j] = [[(NSArray *)[points objectAtIndex:i] objectAtIndex:j] floatValue];
            }
        }
   //     std::cout << ary << std::endl;
        float *clas = new float[numPoints];
        for (int i = 0; i < numPoints; i++) {
            
            if ([[classifications objectAtIndex:i] isEqualToString:@"I"]) {
                clas[i] = -1;
            } else {
                clas[i] = 1;
            }
        }
        Mat labelsMat(numPoints, 1, CV_32FC1, clas);
  //      NSMutableArray *f = LineClassifier ext
//        float test[numPoints][length];
//        test[0] = {501, 10, 1, 1, 1, 1, 1, 1};
        
    //    float trainingData[4][3] = { {501, 10, 1}, {255, 10, 2}, {501, 255, 3}, {10, 501, 4} };
        
        Mat trainingDataMat(numPoints, length, CV_32FC1, ary);
        std::cout << "M = "<< std::endl << " "  << labelsMat << std::endl << std::endl;
        // Set up SVM's parameters
        CvSVMParams params;
        params.svm_type    = CvSVM::C_SVC;
        params.kernel_type = CvSVM::SIGMOID;
        params.term_crit   = cvTermCriteria(CV_TERMCRIT_ITER, 100, 1e-6);
        
        // Train the SVM
        CvSVM SVM;
        SVM.train(trainingDataMat, labelsMat, Mat(), Mat(), params);
        
        Vec3b green(0,255,0), blue (255,0,0);
        // Show the decision regions given by the SVM
        NSArray *a = @[@"Hello there!", @"2 Eggs $5.99", @"HAMCOMBO 007875235055K 3.17 X", @"1 Calamares 3.95", @"MED DRINK 007875235055K 0.98 X"];
        for (int i = 0; i < [a count]; i++) {
            
            NSMutableArray *f = [LineClassifier extractFeaturesFromLine:[a objectAtIndex:i]];
            NSLog(@"f is %@", f);
            float *cf = new float[[f count]];
            for (int i = 0; i < [f count]; i++) {
                cf[i] = [[f objectAtIndex:i] intValue];
            }
            Mat sMat(8, 1, CV_32FC1, cf);
            float response = SVM.predict(sMat);
            NSLog(@"response for %@ was : %f", [a objectAtIndex:i], response);
        }
        
        
        for (int i = 0; i < image.rows; ++i)
            for (int j = 0; j < image.cols; ++j)
            {
                Mat sampleMat = (Mat_<float>(1,2) << i,j);
           //     float c[8] = { 0, 0, 0, 1, 18, 0, 0, 0};
              //  Mat sMat(8, 1, CV_32FC1, c);

               // std::cout << "M = "<< std::endl << " "  << sampleMat << std::endl << std::endl;
                
            //    if (response == 1)
//                    image.at<Vec3b>(j, i)  = green;
//                else if (response == -1)
//                    image.at<Vec3b>(j, i)  = blue;
            }
        
        // Show the training data
        int thickness = -1;
        int lineType = 8;
//        circle( image, Point(501,  10), 5, Scalar(  0,   0,   0), thickness, lineType);
//        circle( image, Point(255,  10), 5, Scalar(255, 255, 255), thickness, lineType);
//        circle( image, Point(501, 255), 5, Scalar(255, 255, 255), thickness, lineType);
//        circle( image, Point( 10, 501), 5, Scalar(255, 255, 255), thickness, lineType);
        
        // Show support vectors
        thickness = 2;
        lineType  = 8;
        int c     = SVM.get_support_vector_count();


        for (int i = 0; i < c; ++i)
        {
            const float* v = SVM.get_support_vector(i);
      //      circle( image,  Point( (int) v[0], (int) v[1]),   6,  Scalar(128, 128, 128), thickness, lineType);
        }
        
      //  imwrite("result.png", image);        // save the image
        
      //  imshow("SVM Simple Example", image); // show it to the user
       // waitKey(0);

    }
    return self;
}

- (int) classifyFeaturesForLine:(NSArray *)features {
    
}


@end
