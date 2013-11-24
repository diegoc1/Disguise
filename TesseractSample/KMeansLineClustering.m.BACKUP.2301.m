//
//  KMeansLineClustering.m
//  TesseractSample
//
//  Created by Diego Canales on 11/21/13.
//
//

#import "KMeansLineClustering.h"

@interface KMeansLineClustering()

<<<<<<< HEAD
@property (strong,nonatomic) NSMutableArray *points;
@property (strong, nonatomic) NSMutableArray *centroids;
=======
@property (strong,nonatomic) NSArray *points;
>>>>>>> 95b68b2f466c24b7409843717170f918c783c371
@property (nonatomic) int num_centroids;
@property (nonatomic) int point_vec_length;

@end

@implementation KMeansLineClustering

- (id) initWithPoints:(NSArray *)points desiredNumberOfCentroids:(int)numCentroids {
    self = [super init];
    if (self) {
        if ([self vectorsSameLength:points]) {
            int vectorLength = [(NSArray *)points[0] count];
            self.point_vec_length = vectorLength;
            self.points = [NSMutableArray arrayWithArray:points];
            self.assignments = [[NSMutableArray alloc] init];
            self.centroids = [[NSMutableArray alloc] init];
            [self normalizePoints];
            [self randomlyAssignCentroids:numCentroids withLength:vectorLength];
            [self runKMeans];
        }
    }
    return self;
}

//Loops through the points and assigns that point to the closest centroid
- (void) assignPointsToCentroids {
    for (int i = 0; i < [self.points count]; i++) {
        int closestCentroidIndex = [self getClosestCentroidIndex:self.points[i]];
        self.assignments[i] = [NSNumber numberWithInt:closestCentroidIndex];
    }
}

//Gets the index of the centroid that is closest to the inputted point
- (int) getClosestCentroidIndex: (NSArray *)point {
    int closestCentroid = -1;
    double closestDistance = INT_MAX;
    for (int i = 0; i < [self.centroids count]; i++) {
        double distance_between_point_and_centroid = [self euclidianDistance:point secondVector:self.centroids[i]];
        if (distance_between_point_and_centroid < closestDistance) {
            closestCentroid = i;
            closestDistance = distance_between_point_and_centroid;
        }
    }
    return closestCentroid;
}


- (void) recalculateCentroids {
    for (int i = 0; i < [self.centroids count]; i++) {
        NSMutableArray *centroidPoints = [self getPointsForCentroid:i];
        self.centroids[i] = [self getAverageOfPoints:centroidPoints];
    }
}

//Calculates the new centroid by taking the average of the points assigned to that centroid
- (NSMutableArray *) getAverageOfPoints:(NSMutableArray *)points {
    NSMutableArray *newCentroid = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.point_vec_length; i++) {
        double average = 0;
        for (int j = 0; j < [points count]; j++) {
            average += [((NSArray *) points[j])[i] floatValue];
        }
        average /= [points count];
        [newCentroid addObject:[NSNumber numberWithDouble:average]];
    }
    return newCentroid;
}


//Gets all the points assigned to a certain centroid and puts them in an array
- (NSMutableArray *) getPointsForCentroid: (int) centroidIndex {
    NSMutableArray *pointsForCentroid = [[NSMutableArray alloc] init];
    for (int i = 0; i < [self.assignments count]; i++) {
        if ([self.assignments[i] intValue] == centroidIndex) [pointsForCentroid addObject:self.points[i]];
    }
    return pointsForCentroid;
}

- (double) meanOfPoints: (NSMutableArray *)points {
    double sum  = 0;
    for (int i = 0; i < [points count]; i++) {
        sum += [(NSNumber *)points[i] doubleValue];
    }
    sum /= [points count];
    return sum;
}

- (double) standardDeviationOfPoints: (NSArray *)points withMean:(double) meanOfPoints {
    double sum_of_diffs = 0;
    for (int i = 0; i < [points count]; i++) {
        sum_of_diffs += pow(([points[i] doubleValue] - meanOfPoints), 2);
    }
    return sqrt(sum_of_diffs / [points count]);
}

- (void) normalizePoints {
    
    /* Reset the array of points to an array of NSMutableArrays instead of NSArrays.  That way I can manipulate the arrays later in this function */
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    NSMutableArray *new_points = [[NSMutableArray alloc] init];
    for (int i = 0; i < [self.points count]; i++) {
        NSMutableArray *new_p = [[NSMutableArray alloc] initWithArray:self.points[i]];
        new_points[i] = new_p;
    }
    self.points = new_points;
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    
    for (int i = 0; i < self.point_vec_length; i++) {
        NSMutableArray *featureVec = [[NSMutableArray alloc] init];
        for (int j = 0; j < [self.points count]; j++) {
            [featureVec addObject:self.points[j][i]];
        }
        double meanOfPoints = [self meanOfPoints:featureVec];
        double standardDev = [self standardDeviationOfPoints:featureVec withMean:meanOfPoints];
        for (int j = 0; j < [self.points count]; j++) {
            
            NSNumber *or = self.points[j][i];
            NSNumber *new = [NSNumber numberWithDouble:([or doubleValue] - meanOfPoints) / standardDev];

            self.points[j][i] = new;
        }
        
        //GET RID OF THIS, THIS IS JUST AN UNNECESSARY CHECK TO SEE IF I CALCULATED MEAN AND STANDARD DEVIATION CORRECTLY
        NSMutableArray *featureVec2 = [[NSMutableArray alloc] init];
        for (int j = 0; j < [self.points count]; j++) {
            [featureVec2 addObject:self.points[j][i]];
        }
        double meanOfPoints2 = [self meanOfPoints:featureVec2];
        double standardDev2 = [self standardDeviationOfPoints:featureVec2 withMean:meanOfPoints2];
        NSLog(@"NEW MEAN IS %f", meanOfPoints2);
        NSLog(@"NEW STD IS %f", standardDev2);

    }
    NSLog(@"points is %@", self.points);
}



-(void) runKMeans {
    for (int i = 0; i < 40; i++) {
        [self assignPointsToCentroids];
        [self recalculateCentroids];
    }
    NSLog(@"final assignemtns :%@", self.assignments);
}


//Checks that all the input points are the same length
- (BOOL) vectorsSameLength:(NSArray *)points {
    if (!points || [points count] == 0) return false;
    int firstLength = [points[0] count];
    for (int i = 0; i < [points count]; i++) {
        if ([points[i] count] != firstLength) return false;
    }
    return true;
}


//Calculates euclidian distance between two vectors
- (double) euclidianDistance: (NSArray *)vec1 secondVector:(NSArray *)vec2 {
    double sum = 0;
    for (int i = 0; i < self.point_vec_length; i++) {
        sum += pow(([(NSNumber *)vec1[i] floatValue]- [(NSNumber *)vec2[i] floatValue]), 2);
    }
    return sqrt(sum);
}

//Assign centroids to random indexes in points
- (void) randomlyAssignCentroids: (int) numCentroids withLength:(int) vecLength {
    self.num_centroids = numCentroids;
    int total_num_points = [self.points count];
    for (int i = 0; i < self.num_centroids; i++) {
        NSUInteger randNum = arc4random();
        int randomIndex = randNum % total_num_points;
        NSLog(@"random index is %d", randomIndex);
        [self.centroids addObject:[self.points objectAtIndex:randomIndex]];
    }
    
    NSLog(@"centroids %@", self.centroids);
}

#pragma mark - Normalization

- (double) meanOfPoints: (NSMutableArray *)points {
    double sum  = 0;
    for (int i = 0; i < [points count]; i++) {
        sum += [(NSNumber *)points[i] doubleValue];
    }
    sum /= [points count];
    return sum;
}
- (double) standardDeviationOfPoints: (NSArray *)points withMean:(double) meanOfPoints {
    double sum_of_diffs = 0;
    for (int i = 0; i < [points count]; i++) {
        sum_of_diffs += pow(([points[i] doubleValue] - meanOfPoints), 2);
    }
    return sqrt(sum_of_diffs / [points count]);
}
- (void) normalizePoints {
    
    //Reset the array of points to an array of NSMutableArrays instead of NSArrays.  That way I can manipulate the arrays later in this function
    NSMutableArray *new_points = [[NSMutableArray alloc] init];
    for (int i = 0; i < [self.points count]; i++) {
        NSMutableArray *new_p = [[NSMutableArray alloc] initWithArray:self.points[i]];
        new_points[i] = new_p;
    }
    self.points = new_points;
    
    for (int i = 0; i < self.point_vec_length; i++) {
        NSMutableArray *featureVec = [[NSMutableArray alloc] init];
        for (int j = 0; j < [self.points count]; j++) {
            [featureVec addObject:self.points[j][i]];
        }
        double meanOfPoints = [self meanOfPoints:featureVec];
        double standardDev = [self standardDeviationOfPoints:featureVec withMean:meanOfPoints];
        for (int j = 0; j < [self.points count]; j++) {
            
            NSNumber *or = self.points[j][i];
            NSNumber *new = [NSNumber numberWithDouble:([or doubleValue] - meanOfPoints) / standardDev];
            self.points[j][i] = new;
        }
        NSMutableArray *featureVec2 = [[NSMutableArray alloc] init];
        for (int j = 0; j < [self.points count]; j++) {
            [featureVec2 addObject:self.points[j][i]];
        }
        double meanOfPoints2 = [self meanOfPoints:featureVec2];
        double standardDev2 = [self standardDeviationOfPoints:featureVec2 withMean:meanOfPoints2];
        NSLog(@"NEW MEAN IS %f", meanOfPoints2);
        NSLog(@"NEW STD IS %f", standardDev2);
    }
    NSLog(@"points is %@", self.points);
}

@end
