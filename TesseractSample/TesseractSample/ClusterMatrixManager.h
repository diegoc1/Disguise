//
//  ClusterMatrixManager.h
//  TesseractSample
//
//  Created by Will Harvey on 11/25/13.
//
//

#import <Foundation/Foundation.h>

@interface ClusterMatrixManager : NSObject

+(NSMutableArray *) extractClusterMats: (cv::Mat &) mat;

@end
