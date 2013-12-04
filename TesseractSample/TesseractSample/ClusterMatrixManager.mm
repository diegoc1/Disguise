//
//  ClusterMatrixManager.m
//  TesseractSample
//
//  Created by Will Harvey on 11/25/13.
//
//

#import "ClusterMatrixManager.h"
#import "KMeansLineClustering.h"
#import "ContourWrapper.h"
#import "ClusterWrapper.h"

@implementation ClusterMatrixManager

+(NSMutableArray *) drawClusters: (cv::Mat &) mat withClusters: (KMeansLineClustering *) clusterController andSegements: (NSMutableArray *) segments andContours: (cv::vector<cv::vector<cv::Point> >) contours {
    
    NSMutableArray *clustersArray = [clusterController getArrayOfClusters];
    NSMutableArray *clusterMatricesReturnArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [clustersArray count]; i++) {
        if ([clustersArray[i] count] > 0) {
            cv::Mat clusterMat = cv::Mat::zeros(mat.size(), CV_8UC1);
            ClusterWrapper *clusterWrapper = [[ClusterWrapper alloc] init];
            clusterWrapper.minYVal = mat.size().height;
            
            for (int j = 0; j < [clustersArray[i] count]; j++) {
                int index = [clustersArray[i][j] intValue];
                
                ContourWrapper *contourWrapper = segments[index];
                cv::Rect boundRect = contourWrapper.boundingBox;
                
                cv::drawContours(clusterMat, contours, index, cv::Scalar(200), CV_FILLED);
                clusterMat(boundRect) = clusterMat(boundRect) & mat(boundRect);
                
                //Update min y val for sorting later
                clusterWrapper.minYVal = MIN(clusterWrapper.minYVal, boundRect.y);
                
            }
            clusterWrapper.contours = clustersArray[i];
            clusterWrapper.clusterMat = clusterMat.clone();
            [clusterMatricesReturnArray addObject: clusterWrapper];
        }

    }
    return clusterMatricesReturnArray;
}

+(NSMutableArray *) boundingPointsFromSegments: (NSMutableArray *) segments {
    NSMutableArray *boundingPoints = [[NSMutableArray alloc] init];
    for (int i = 0; i < [segments count]; i++) {
        ContourWrapper *contourWrapper = segments[i];
        NSNumber *width_num = [NSNumber numberWithFloat: contourWrapper.boundingBox.width];
        NSNumber *height_num = [NSNumber numberWithFloat: contourWrapper.boundingBox.height];
        //NSNumber *x_num = [NSNumber numberWithFloat: contourWrapper.boundingBox.x];
        NSNumber *y_num = [NSNumber numberWithFloat: contourWrapper.boundingBox.y];
        
        NSArray *point = @[width_num, height_num, y_num];
        [boundingPoints addObject: point];
    }
    return boundingPoints;
}

+(NSMutableArray *) extractClusterMats: (cv::Mat &) mat {
    int erosion_size = 1;
    cv::Mat element = cv::getStructuringElement(cv::MORPH_ELLIPSE,
                                                cv::Size(2 * erosion_size + 1, 2 * erosion_size + 1),
                                                cv::Point(erosion_size, erosion_size) );
    //cv::dilate(mat, mat, element);
    
    int thresh = 100;
    
    cv::Mat threshold_output;
    cv::vector<cv::vector<cv::Point> > contours;
    cv::vector<cv::Vec4i> hierarchy;
    
    /// Detect edges using Threshold
    cv::threshold(mat, threshold_output, thresh, 255, CV_THRESH_BINARY );
    
    /// Find contours
    cv::findContours( threshold_output, contours, hierarchy, CV_RETR_EXTERNAL, CV_CHAIN_APPROX_SIMPLE, cv::Point(0, 0));
    
    /// Approximate contours to polygons + get bounding rects and circles
    cv::vector<cv::vector<cv::Point> > contours_poly( contours.size() );
    cv::vector<cv::Rect> boundingRects(contours.size() );
    
    NSMutableArray *segments = [[NSMutableArray alloc] init];
    
    for( int i = 0; i < contours.size(); i++) {
        approxPolyDP( cv::Mat(contours[i]), contours_poly[i], 3, true );
        boundingRects[i] = boundingRect(cv::Mat(contours_poly[i]));
        
        ContourWrapper *theContour = [[ContourWrapper alloc] init];
        theContour.boundingBox = boundingRects[i];
        theContour.contourPoints = contours_poly[i];
        [segments addObject: theContour];
    }
    
    
    
    /* Draw cluster matrices using KMEANS */
    
    NSMutableArray *pointsData = [self boundingPointsFromSegments: segments];
    KMeansLineClustering *clusterController = [[KMeansLineClustering alloc] initWithPoints:pointsData desiredNumberOfCentroids: 30];
    [clusterController exaggerateFeature:2 exaggerationAmount:60];
    [clusterController runKMeans];
    //[clusterController removeInvalidPoints];

    return [self drawClusters: mat withClusters: clusterController andSegements: segments andContours: contours];
    
    
    /* REMOVE BELOW */
    
    //    [self setRGB: mat]; //REMOVE
    //    for (int i = 0; i < [segments count]; i++) {
    //        int assignement = [clusterController.assignments[i] intValue];
    //        cv::Scalar color;
    //
    //        if (assignement == 0) {
    //            color = cv::Scalar(0, 255, 0);
    //        }
    //        else if (assignement == 1) {
    //            color = cv::Scalar(255, 0, 0);
    //        }
    //        else if (assignement == 2) {
    //            color = cv::Scalar(125, 125, 0);
    //        }
    //        else if (assignement == 3) {
    //            color = cv::Scalar(0, 125, 125);
    //        }
    //        else if (assignement == 4) {
    //            color = cv::Scalar(125, 0, 125);
    //        }
    //        else if (assignement == 5) {
    //            color = cv::Scalar(35, 180, 18);
    //        }
    //        else if (assignement == 6) {
    //            color = cv::Scalar(255, 255, 255);
    //        }
    //        else if (assignement == 7) {
    //            color = cv::Scalar(204, 255, 153);
    //        }
    //        else if (assignement == 8) {
    //            color = cv::Scalar(51, 153, 255);
    //        }
    //        else if (assignement == 9) {
    //             color = cv::Scalar(204, 153, 204);
    //        }
    //        else if (assignement == 10) {
    //             color = cv::Scalar(255, 204, 0);
    //        }
    //        else if (assignement == 11) {
    //             color = cv::Scalar(204, 102, 51);
    //        }
    //         else if (assignement == 12) {
    //             color = cv::Scalar(153, 153, 0);
    //         }
    //         else if (assignement == 13) {
    //             color = cv::Scalar(255, 51, 204);
    //         }
    //         else if (assignement == 14) {
    //             color = cv::Scalar(102, 0, 51);
    //         }
    //         else if (assignement == 15) {
    //             color = cv::Scalar(0, 255, 102);
    //         }
    //         else if (assignement == 16) {
    //             color = cv::Scalar(153, 153, 153);
    //         }
    //         else if (assignement == 17) {
    //             color = cv::Scalar(255, 255, 0);
    //         }
    //         else {
    //             color = cv::Scalar(51, 255, 255);
    //         }
    //
    //         ContourWrapper *contourWrapper = segments[i];
    //         cv::rectangle(mat, contourWrapper.boundingBox, color);
    //    }
    
    //    cv::Scalar color = cv::Scalar(0, 255, 0); //REMOVE
    //    cv::rectangle(mat, boundingRects[i], color); //REMOVE
    
    
    /* END REMOVE */
}


@end
