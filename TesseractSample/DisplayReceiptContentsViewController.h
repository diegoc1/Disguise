//
//  DisplayReceiptContentsViewController.h
//  TesseractSample
//
//  Created by Diego Canales on 11/30/13.
//
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>


@interface DisplayReceiptContentsViewController : UIViewController <MFMailComposeViewControllerDelegate>

-(id) initWithContents: (NSString *) title loc:(NSString *)location total:(double)total image:(UIImage *)image;

@end