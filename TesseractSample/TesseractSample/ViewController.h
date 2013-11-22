//
//  ViewController.h
//  TesseractSample
//
//  Created by Ângelo Suzuki on 11/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MBProgressHUD;


@interface ViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    UIImagePickerController *imagePickerController;
    
    
    IBOutlet UIImageView *iv;
}
@property (nonatomic, retain) IBOutlet UIImageView *iv;

-(IBAction)takePhoto:(id)sender;


@end
