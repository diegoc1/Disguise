

#import <Foundation/Foundation.h>

@interface KMeansLineClustering : NSObject

@property (strong, nonatomic) NSMutableArray *assignments;
@property (strong, nonatomic) NSMutableArray *centroids;

- (id) initWithPoints:(NSArray *)points desiredNumberOfCentroids:(int)numCentroids;
@end
