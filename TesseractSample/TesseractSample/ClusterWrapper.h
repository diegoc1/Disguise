//
//  ClusterWrapper.h
//  TesseractSample
//
//  Created by Will Harvey on 11/25/13.
//
//

#import <Foundation/Foundation.h>

typedef enum {
    ReceiptClusterTypeTitle,
    ReceiptClusterTypeItem,
    ReceiptClusterTypeJunk,
    ReceiptClusterTypeFirst,
    ReceiptClusterTypeTotal,
    ReceiptClusterTypeTax,
} ReceiptClusterType;

@interface ClusterWrapper : NSObject {
    cv::Mat clusterMat;
    NSMutableArray *contours;
    ReceiptClusterType clusterType;
    NSString *recognizedText;
    float minYVal;
}

@property (nonatomic) cv::Mat clusterMat;
@property (nonatomic, retain)  NSMutableArray *contours;
@property (nonatomic) ReceiptClusterType clusterType;
@property (nonatomic, strong) NSString *recognizedText;
@property (nonatomic) float minYVal;

@end
