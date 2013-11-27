#import <Foundation/Foundation.h>
@interface KMeansLineClustering : NSObject
@property (strong, nonatomic) NSMutableArray *assignments;
@property (strong, nonatomic) NSMutableArray *centroids;
- (id) initWithPoints:(NSArray *)points desiredNumberOfCentroids:(int)numCentroids;
<<<<<<< HEAD

- (void) exaggerateFeature: (int) indexOfFeautre exaggerationAmount:(int) amount;

-(void) runKMeans;

-(NSMutableArray *) getArrayOfClusters;

- (void) removeInvalidPoints;
@end
=======
- (void) exaggerateFeature: (int) indexOfFeautre exaggerationAmount:(int) amount;
-(void) runKMeans;
- (NSMutableArray *) getArrayOfClusters;

@end
>>>>>>> 013f8c916abab82b6cea474f3956ce352f71422d
