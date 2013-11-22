

#import "ViewController.h"
#import "UIImage+OpenCV.h"
#import "TesseractController.h"
#import "ImageProcessor.h"


@implementation ViewController

@synthesize iv;

#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(IBAction)takePhoto:(id)sender {
    
    imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType =  UIImagePickerControllerSourceTypeCamera;
    
	[self presentModalViewController:imagePickerController animated:YES];
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker 
		didFinishPickingImage:(UIImage *)image
				  editingInfo:(NSDictionary *)editingInfo
{
    
    [picker dismissModalViewControllerAnimated: NO];
    UIImage *newImage = [ImageProcessor resizeImage: image];
    cv::Mat theMat = [newImage CVMat];
    [ImageProcessor performInitialImageProcessing: theMat];
    
    UIImage *resultingImage = [UIImage imageWithCVMat: theMat];
//    ImageWrapper *greyScale=Image::createImage(newImage, newImage.size.width, newImage.size.height);
//    ImageWrapper *edges=greyScale.image->autoLocalThreshold();
//    UIImage *postProcessingImage = edges.image->toUIImage();
    
    TesseractController *tc = [[TesseractController alloc] init];
    [tc processOcrAt: resultingImage];
    
    iv.image = resultingImage;
    
	// Dismiss the image selection, hide the picker and
    
	//show the image view with the picked image
//    
//	[picker dismissModalViewControllerAnimated:NO];
//    [self startTesseract];
//    NSLog(@"Recognizing...");
//	UIImage *newImage = [self resizeImage:image];
//	iv.image = newImage;
//	NSString *text = [self ocrImage:newImage];
//    NSLog(@"OUTPUT: %@", text);
//	label.text = text;
}





@end
