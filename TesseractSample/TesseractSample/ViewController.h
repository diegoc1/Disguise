

#import <UIKit/UIKit.h>


@interface ViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    UIImagePickerController *imagePickerController;
    
    
    IBOutlet UIImageView *iv;
}
@property (nonatomic, retain) IBOutlet UIImageView *iv;

-(IBAction)takePhoto:(id)sender;


@end
