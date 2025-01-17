

#import "ViewController.h"
#import "UIImage+OpenCV.h"
#import "TesseractController.h"
#import "ImageProcessor.h"
#import "ClusterMatrixManager.h"
#import "ClusterWrapper.h"
#import "LineClassifier.h"
#import "KMeansLineClustering.h"
#import "SelectItemsViewController.h"
#import "SVMClassifier.h"
#import "ReceiptModel.h"
#import "ClusterDecisionTreeClassifier.h"
#import "SpellChecker.h"
#import "CropperView.h"
#import "CroppingImageCaptureViewController.h"

@interface ViewController()

@property (strong, nonatomic) UIImage *receiptImage;

//@property (strong, nonatomic) UILabel *tipLabel;
@end

@implementation ViewController

@synthesize iv;

#pragma mark - View lifecycle

-(IBAction)takePhoto:(id)sender {
  //  CroppingImageCaptureViewController *croppingVC = [[CroppingImageCaptureViewController alloc] init];
    //[self presentModalViewController: croppingVC animated:YES];
    
    
//    imagePickerController = [[UIImagePickerController alloc] init];
//    imagePickerController.delegate = self;
//    imagePickerController.sourceType =  UIImagePickerControllerSourceTypeCamera;
//    
//	[self presentModalViewController:imagePickerController animated:YES];
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker 
		didFinishPickingImage:(UIImage *)image
				  editingInfo:(NSDictionary *)editingInfo
{
    NSLog(@"inital image orienation: %d", image.imageOrientation);
    [picker dismissModalViewControllerAnimated: NO];
    
//    
////    CropperView *cropper = [[CropperView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 50) andImage:image];
//    [self.view addSubview:cropper];
//    return;
    UIImage *newImage = [ImageProcessor resizeImage: image];
    cv::Mat theMat = [newImage CVMat];

    
   // image = nil;
    

    
    //Process original image - prepare for clustering
    [ImageProcessor performInitialImageProcessing: theMat];
    
    TesseractController *tc = [[TesseractController alloc] init];
    //Create clusters and superate matrices for each
    NSMutableArray *clusterMatrices = [ClusterMatrixManager extractClusterMats: theMat];
    
    //For each cluster matrix, use Tesseract OCR to create recognized text
    for (ClusterWrapper *cluster in clusterMatrices) {
        cluster.recognizedText = [tc processOcrAt: [UIImage imageWithCVMat: cluster.clusterMat]];
        NSLog(@"%@", cluster.recognizedText);
    }
    
    SpellChecker *spellChecker = [[SpellChecker alloc] init];
    ReceiptModel *receipt = [ClusterDecisionTreeClassifier processReceiptFromClusters: clusterMatrices withSpellChecker: spellChecker];
    NSLog(@"TITLE %@", receipt.title);
    NSLog(@"TOTAL AMOUNT: %f", receipt.totalAmount);
    NSLog(@"TAX AMOUNT: %f", receipt.taxAmount);
    NSLog(@"ITEMS: %@", receipt.itemsPurchased);
    
    
    UIImage *resultingImage = [UIImage imageWithCVMat: theMat];
    //iv.image = resultingImage;
    
    
    
    SelectItemsViewController *sv = [[SelectItemsViewController alloc] initWithReceiptModel: receipt andImage: resultingImage];
    [self.navigationController pushViewController: sv animated: FALSE];
}





@end
