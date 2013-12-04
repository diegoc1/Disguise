//
//  TesseractController.m
//  TesseractSample
//
//  Created by Will Harvey on 11/22/13.
//
//


/* WRAPPER FOR TESSERACT */

#import "TesseractController.h"
#include "baseapi.h"

#include "environ.h"
#import "pix.h"



@implementation TesseractController


-(id) init {
    self = [super init];
    if (self) {
        // Set up the tessdata path. This is included in the application bundle
        // but is copied to the Documents directory on the first run.
        NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentPath = ([documentPaths count] > 0) ? [documentPaths objectAtIndex:0] : nil;
        
        NSString *dataPath = [documentPath stringByAppendingPathComponent:@"tessdata"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        // If the expected store doesn't exist, copy the default store.
        if (![fileManager fileExistsAtPath:dataPath]) {
            // get the path to the app bundle (with the tessdata dir)
            NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
            NSString *tessdataPath = [bundlePath stringByAppendingPathComponent:@"tessdata"];
            if (tessdataPath) {
                [fileManager copyItemAtPath:tessdataPath toPath:dataPath error:NULL];
            }
        }
        
        setenv("TESSDATA_PREFIX", [[documentPath stringByAppendingString:@"/"] UTF8String], 1);
        
        // init the tesseract engine.
        tesseract = new tesseract::TessBaseAPI();
        tesseract->Init([dataPath cStringUsingEncoding:NSUTF8StringEncoding], "eng");
    }
    return self;
}

- (void)dealloc {
    delete tesseract;
    tesseract = nil;
}

- (NSString *)processOcrAt:(UIImage *)image
{
    [self setTesseractImage:image];
    tesseract->Recognize(NULL);
    char* utf8Text = tesseract->GetUTF8Text();
    return [NSString stringWithUTF8String: utf8Text];
    
    //    [self performSelectorOnMainThread:@selector(ocrProcessingFinished:)
    //                           withObject:[NSString stringWithUTF8String:utf8Text]
    //                        waitUntilDone:NO];
}



- (void)ocrProcessingFinished:(NSString *)result
{
    [[[UIAlertView alloc] initWithTitle:@"Tesseract Sample"
                                message:[NSString stringWithFormat:@"%@", result]
                               delegate:nil
                      cancelButtonTitle:nil
                      otherButtonTitles:@"OK", nil] show];
}

- (void)setTesseractImage:(UIImage *)image
{
    free(pixels);
    
    CGSize size = [image size];
    int width = size.width;
    int height = size.height;
	
	if (width <= 0 || height <= 0)
		return;
	
    // the pixels will be painted to this array
    pixels = (uint32_t *) malloc(width * height * sizeof(uint32_t));
    // clear the pixels so any transparency is preserved
    memset(pixels, 0, width * height * sizeof(uint32_t));
	
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	
    // create a context with RGBA pixels
    CGContextRef context = CGBitmapContextCreate(pixels, width, height, 8, width * sizeof(uint32_t), colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
	
    // paint the bitmap to our context which will fill in the pixels array
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), [image CGImage]);
	
	// we're done with the context and color space
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    //    tesseract->SetVariable("tessedit_char_whitelist", "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz$./-:#1234567890");
    //    tesseract->SetVariable("language_model_penalty_non_freq_dict_word", "0");
    //    tesseract->SetVariable("language_model_penalty_non_dict_word ", "0");
    //    //tesseract->SetVariable("classify_bln_numeric_mode", "1");
    //    //tesseract->SetVariable("tessedit_resegment_from_boxes", "T");
    //    //tesseract->SetVariable("tessedit_train_from_boxes", "T");
    //    //tesseract->SetVariable("edges_children_fix", "F");
    
    tesseract->SetImage((const unsigned char *) pixels, width, height, sizeof(uint32_t), width * sizeof(uint32_t));
}


@end
