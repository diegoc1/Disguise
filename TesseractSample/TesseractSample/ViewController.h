//
//  ViewController.h
//  TesseractSample
//
//  Created by Ângelo Suzuki on 11/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MBProgressHUD;

namespace tesseract {
    class TessBaseAPI;
};

@interface ViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    MBProgressHUD *progressHud;
    UIImagePickerController *imagePickerController;
    tesseract::TessBaseAPI *tesseract;
    uint32_t *pixels;    
    
    IBOutlet UIImageView *iv;
}

@property (nonatomic, strong) MBProgressHUD *progressHud;
@property (nonatomic, retain) IBOutlet UIImageView *iv;

- (void)setTesseractImage:(UIImage *)image;
-(IBAction)takePhoto:(id)sender;


@end
