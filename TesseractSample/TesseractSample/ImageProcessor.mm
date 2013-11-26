//
//  ImageProcessor.m
//  TesseractSample
//
//  Created by Will Harvey on 11/22/13.
//
//

#import "ImageProcessor.h"
#import "ContourWrapper.h"
#import "KMeansLineClustering.h"

static inline double radians (double degrees) {return degrees * M_PI/180;}


@implementation ImageProcessor

+(void) performInitialImageProcessing: (cv::Mat &) mat {
    [self setGrayscale: mat];
    [self binarizeWithCannyAndGaussianThresholding: mat];
    [self performClose: mat withSize: 1];
    NSMutableArray *segments = [self extractSegments: mat];
    NSMutableArray *pointsData = [self boundingPointsFromSegments: segments];
    KMeansLineClustering *clusterController = [[KMeansLineClustering alloc] initWithPoints:pointsData desiredNumberOfCentroids: 50];
    [clusterController exaggerateFeature:2 exaggerationAmount:60];
    [clusterController runKMeans];
    [clusterController removeInvalidPoints];
    [clusterController getArrayOfClusters];
    
    /* REMOVE BELOW */
    
    [self setRGB: mat]; //REMOVE
    for (int i = 0; i < [segments count]; i++) {
        int assignement = [clusterController.assignments[i] intValue];
        cv::Scalar color;
        
        if (assignement == 0) {
            color = cv::Scalar(0, 255, 0);
        }
        else if (assignement == 1) {
             color = cv::Scalar(255, 0, 0);
        }
        else if (assignement == 2) {
            color = cv::Scalar(125, 125, 0);
        }
        else if (assignement == 3) {
            color = cv::Scalar(0, 125, 125);
        }
        else if (assignement == 4) {
            color = cv::Scalar(125, 0, 125);
        }
        else if (assignement == 5) {
            color = cv::Scalar(35, 180, 18);
        }
        else if (assignement == 6) {
            color = cv::Scalar(255, 255, 255);
        }
        else if (assignement == 7) {
            color = cv::Scalar(204, 255, 153);
        }
        else if (assignement == 8) {
            color = cv::Scalar(51, 153, 255);
        }
        else if (assignement == 9) {
            color = cv::Scalar(204, 153, 204);
        }
        else if (assignement == 10) {
            color = cv::Scalar(255, 204, 0);
        }
        else if (assignement == 11) {
            color = cv::Scalar(204, 102, 51);
        }
        else if (assignement == 12) {
            color = cv::Scalar(153, 153, 0);
        }
        else if (assignement == 13) {
            color = cv::Scalar(255, 51, 204);
        }
        else if (assignement == 14) {
            color = cv::Scalar(102, 0, 51);
        }
        else if (assignement == 15) {
            color = cv::Scalar(0, 255, 102);
        }
        else if (assignement == 16) {
            color = cv::Scalar(153, 153, 153);
        }
        else if (assignement == 17) {
            color = cv::Scalar(255, 255, 0);
        }
        else if (assignement == -1){
             color = cv::Scalar(51, 255, 255);
        } 
        
        ContourWrapper *contourWrapper = segments[i];
        cv::rectangle(mat, contourWrapper.boundingBox, color);
    }
    
    
//    cv::Scalar color = cv::Scalar(0, 255, 0); //REMOVE
//    cv::rectangle(mat, boundingRects[i], color); //REMOVE
    
    
    /* END REMOVE */
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

+(NSMutableArray *) extractSegments: (cv::Mat &) mat {
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
    
    NSMutableArray *segmentsArray = [[NSMutableArray alloc] init];
    
    for( int i = 0; i < contours.size(); i++) {
        approxPolyDP( cv::Mat(contours[i]), contours_poly[i], 3, true );
        boundingRects[i] = boundingRect(cv::Mat(contours_poly[i]));
        
        ContourWrapper *theContour = [[ContourWrapper alloc] init];
        theContour.boundingBox = boundingRects[i];
        theContour.contourPoints = contours_poly[i];
        [segmentsArray addObject: theContour];
    }
    
    return segmentsArray;
}


/* First performs Canny edge detection (with a large close) on a copy and then 
    performs Gaussian thresholding on the original and combines the resulting two */
+(void) binarizeWithCannyAndGaussianThresholding: (cv::Mat &) mat {
    cv::Mat can;// = mat.clone();
    cv::Canny(mat, can, 20, 80, 3); //should be can output mat
    
    [self performOpen: can withSize: 8];
    [self gaussianThreshold: mat];
    mat = mat & can;
}

+(void) performOpen: (cv::Mat &) mat withSize: (int) size {
    int erosion_size = 1;
    cv::Mat element = cv::getStructuringElement(cv::MORPH_ELLIPSE,
                                                cv::Size(2 * erosion_size + 1, 2 * erosion_size + 1),
                                                cv::Point(erosion_size, erosion_size) );
    
    for (int i = 0; i < size; i++) {
        cv::dilate(mat, mat, element);
    }
    for (int i = 0; i < size; i++) {
        cv::erode(mat, mat, element);
    }
}

+(void) performClose: (cv::Mat &) mat withSize: (int) size {
    int erosion_size = 1;
    cv::Mat element = cv::getStructuringElement(cv::MORPH_ELLIPSE,
                                                cv::Size(2 * erosion_size + 1, 2 * erosion_size + 1),
                                                cv::Point(erosion_size, erosion_size) );
    
    for (int i = 0; i < size; i++) {
        cv::dilate(mat, mat, element);
    }
    for (int i = 0; i < size; i++) {
        cv::erode(mat, mat, element);
    }
}

+(void) setGrayscale:(cv::Mat &) mat {
    cv::cvtColor(mat, mat, CV_BGR2GRAY);
}

+(void) gaussianThreshold:(cv::Mat &) mat {
    //Note: should be grayscale mat
    //Locally adaptive thresholding
    cv::adaptiveThreshold(mat, mat, 255, CV_THRESH_BINARY, CV_ADAPTIVE_THRESH_GAUSSIAN_C, 65, 18);
}

+(void) setRGB: (cv::Mat &) mat {
    cvtColor(mat, mat, CV_GRAY2RGB);
}

+(void) blur: (cv::Mat &) mat {
    cv::medianBlur(mat, mat, 3);
}



+(UIImage *)resizeImage:(UIImage *)image {
    
	CGImageRef imageRef = [image CGImage];
	CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef);
	CGColorSpaceRef colorSpaceInfo = CGColorSpaceCreateDeviceRGB();
    
	if (alphaInfo == kCGImageAlphaNone)
		alphaInfo = kCGImageAlphaNoneSkipLast;
    
	int width, height;
    
	width = 480;//1280;//640;//[image size].width;
	height = 640;//1280;//640;//[image size].height;
    
	CGContextRef bitmap;
    
	if (image.imageOrientation == UIImageOrientationUp | image.imageOrientation == UIImageOrientationDown) {
		bitmap = CGBitmapContextCreate(NULL, width, height, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, alphaInfo);
        
	} else {
		bitmap = CGBitmapContextCreate(NULL, height, width, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, alphaInfo);
        
	}
    
	if (image.imageOrientation == UIImageOrientationLeft) {
		CGContextRotateCTM (bitmap, radians(90));
		CGContextTranslateCTM (bitmap, 0, -height);
        
	} else if (image.imageOrientation == UIImageOrientationRight) {
		CGContextRotateCTM (bitmap, radians(-90));
		CGContextTranslateCTM (bitmap, -width, 0);
        
	} else if (image.imageOrientation == UIImageOrientationUp) {
        
	} else if (image.imageOrientation == UIImageOrientationDown) {
		CGContextTranslateCTM (bitmap, width,height);
		CGContextRotateCTM (bitmap, radians(-180.));
        
	}
    
	CGContextDrawImage(bitmap, CGRectMake(0, 0, width, height), imageRef);
	CGImageRef ref = CGBitmapContextCreateImage(bitmap);
	UIImage *result = [UIImage imageWithCGImage:ref];
    
	CGContextRelease(bitmap);
	CGImageRelease(ref);
    
	return result;
}




@end
