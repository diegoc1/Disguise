

#import <Foundation/Foundation.h>

@interface KMeansLineClustering : NSObject
- (id) initWithPoints:(NSArray *)points desiredNumberOfCentroids:(int)numCentroids;
@end
