//
//  TesseractController.h
//  TesseractSample
//
//  Created by Will Harvey on 11/22/13.
//
//

#import <Foundation/Foundation.h>

namespace tesseract {
    class TessBaseAPI;
};

@interface TesseractController : NSObject {
    tesseract::TessBaseAPI *tesseract;
    uint32_t *pixels;    
}
- (void)processOcrAt:(UIImage *)image;

@end
