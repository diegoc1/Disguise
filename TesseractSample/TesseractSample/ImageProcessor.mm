//
//  ImageProcessor.m
//  TesseractSample
//
//  Created by Will Harvey on 11/22/13.
//
//

#import "ImageProcessor.h"

static inline double radians (double degrees) {return degrees * M_PI/180;}


@implementation ImageProcessor

+(void) performInitialImageProcessing: (cv::Mat &) mat {
    [self setGrayscale: mat];
    [self gaussianThreshold: mat];
    //[self binarizeWithCannyAndGaussianThresholding: mat];
    //[self performClose: mat withSize: 1];
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
