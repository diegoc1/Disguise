//
//  DisplayReceiptContentsViewController.h
//  TesseractSample
//
//  Created by Diego Canales on 11/30/13.
//
//

#import <UIKit/UIKit.h>

@interface DisplayReceiptContentsViewController : UIViewController

-(id) initWithContents: (NSString *) title loc:(NSString *)location total:(double)total image:(UIImage *)image;

@end
