//
//  ContourWrapper.h
//  TesseractSample
//
//  Created by Will Harvey on 11/22/13.
//
//

#import <Foundation/Foundation.h>

@interface ContourWrapper : NSObject {
    cv::Rect boundingBox;
    cv::Vector<cv::Point> contourPoints;
}

@property (nonatomic) cv::Rect boundingBox;
@property (nonatomic) cv::Vector<cv::Point> contourPoints;

@end
