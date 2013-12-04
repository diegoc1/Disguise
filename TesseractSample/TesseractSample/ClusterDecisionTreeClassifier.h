

#import <Foundation/Foundation.h>


@class ReceiptModel;
@interface ClusterDecisionTreeClassifier : NSObject

+(ReceiptModel *) processReceiptFromClusters: (NSMutableArray *) clusters;

@end
