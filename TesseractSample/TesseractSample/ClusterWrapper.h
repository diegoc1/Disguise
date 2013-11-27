//
//  ClusterWrapper.h
//  TesseractSample
//
//  Created by Will Harvey on 11/25/13.
//
//

#import <Foundation/Foundation.h>

@interface ClusterWrapper : NSObject {
    cv::Mat clusterMat;
    NSMutableArray *contours;
}

@property (nonatomic) cv::Mat clusterMat;
@property (nonatomic, retain)  NSMutableArray *contours;

@end
