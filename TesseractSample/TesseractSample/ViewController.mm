

#import "ViewController.h"
#import "UIImage+OpenCV.h"
#import "TesseractController.h"
#import "ImageProcessor.h"
#import "LineClassifier.h"
#import "KMeansLineClustering.h"
#import "CropImageViewController.h"

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
    NSArray *d1 = @[[NSNumber numberWithDouble:96], [NSNumber numberWithDouble:4], [NSNumber numberWithDouble:7]];
    NSArray *d2 = @[[NSNumber numberWithDouble:95], [NSNumber numberWithDouble:5.2], [NSNumber numberWithDouble:5.3]];
    NSArray *d3 = @[[NSNumber numberWithDouble:97], [NSNumber numberWithDouble:5.1], [NSNumber numberWithDouble:5.2]];
    
    
    
    NSArray *d4 = @[[NSNumber numberWithDouble:80], [NSNumber numberWithDouble:3.4], [NSNumber numberWithDouble:7.1]];
    NSArray *d5 = @[[NSNumber numberWithDouble:84], [NSNumber numberWithDouble:5.6], [NSNumber numberWithDouble:5.7]];
    NSArray *d6 = @[[NSNumber numberWithDouble:82], [NSNumber numberWithDouble:4.2], [NSNumber numberWithDouble:7.7]];
    
    
    
    
    NSArray *d7 = @[[NSNumber numberWithDouble:80], [NSNumber numberWithDouble:0.4], [NSNumber numberWithDouble:.1]];
    NSArray *d8 = @[[NSNumber numberWithDouble:84], [NSNumber numberWithDouble:.1], [NSNumber numberWithDouble:0.6]];
    NSArray *d9 = @[[NSNumber numberWithDouble:82], [NSNumber numberWithDouble:0.3], [NSNumber numberWithDouble:0.7]];
    
    
    
    NSMutableArray *data = [[NSMutableArray alloc] init];
    [data addObject:d1];
    [data addObject:d2];
    [data addObject:d3];
    [data addObject:d4];
    [data addObject:d5];
    [data addObject:d6];
    [data addObject:d7];
    [data addObject:d8];
    [data addObject:d9];
    
    KMeansLineClustering *clustering = [[KMeansLineClustering alloc] initWithPoints:data desiredNumberOfCentroids:3];
    NSString *t1 =  @"Salmon $1.30";
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [arr addObject:t1];
    LineClassifier *classifier = [[LineClassifier alloc] initWithTrainingStrings:arr];
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
    NSLog(@"PHOTO HAS BEEN CHOSEN");
    
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
