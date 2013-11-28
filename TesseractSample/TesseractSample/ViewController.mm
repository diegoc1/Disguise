

#import "ViewController.h"
#import "UIImage+OpenCV.h"
#import "TesseractController.h"
#import "ImageProcessor.h"
#import "ClusterMatrixManager.h"
#import "ClusterWrapper.h"
#import "LineClassifier.h"
#import "KMeansLineClustering.h"
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

- (void) goToSelectItemsVC {
    NSLog(@"GOING");
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSMutableArray *a = [[NSMutableArray alloc] init];
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"receipt_text"
                                                     ofType:@"txt"];
    NSString* content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];
    NSMutableArray *f = [[NSMutableArray alloc] init];
    NSMutableArray *data = [[content componentsSeparatedByCharactersInSet: [NSCharacterSet newlineCharacterSet]] mutableCopy];
    NSLog(@"data: %@", data);
    
    NSMutableArray *actual_classification = [[NSMutableArray alloc] init];
    for (int i = 0; i < [data count]; i++) {
        if (i % 2 == 0) {
            [a addObject:data[i]];
        } else {
            [actual_classification addObject:data[i]];
        }
    }
    UIButton *b = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 100,30)];
    [b setBackgroundColor:[UIColor redColor]];
    [b addTarget:self action:@selector(goToSelectItemsVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:b];
    
    
    NSString *line = @"Bacon $1.50";
    NSString *l1 = @"Total: $5.00";
    NSString *l2 = @"1 Burger $4.50";
    NSString *l3 = @"2 Burgers $10.50";
    NSString *l4 = @"Check #: 0001 12/20/11";
    NSString *l5 = @"Server: Josh F 4:38 PM";
    NSString *l6 = @"Table: 7/1 Guests: 2";
    NSString *l7 = @"2 Beef Burgr (@9.95/each)";
    NSString *l8 = @"SIDE: Frieds";
    NSString *l9 = @"1 Bud Light   3.79";
    NSString *l10 = @"1 Bud 4.50";
    NSString *l11 = @"Sub-total 28.19";
    NSString *l12 = @"Sales Tax 2.50";
    NSString *l13 = @"Total 30.69";
    
    
 //   [a addObject:line];
//    [a addObject:l1];
//    [a addObject:l2];
//    [a addObject:l3];
//    [a addObject:l4];
//    [a addObject:l5];
//    [a addObject:l6];
//    [a addObject:l7];
//    [a addObject:l8];
//    [a addObject:l9];
//    [a addObject:l10];
//    [a addObject:l11];
//    [a addObject:l12];
//    [a addObject:l13];
    
    
    
    
    LineClassifier *c = [[LineClassifier alloc] initWithTrainingStrings:a andActualAssignments:actual_classification];
    
    NSMutableArray *c1;
    NSMutableArray *c2;
    NSMutableArray *c3;
    
    BOOL c1_classified = FALSE;
    BOOL c2_classified = FALSE;
    BOOL c3_classified = FALSE;
    
    
    for (int i = 0; i < [a count]; i++) {
        NSString *curr_line = [a objectAtIndex:i];
        NSMutableArray *features = [c extractFeaturesFromLine:curr_line];
        [f addObject:features];
        NSLog(@"classified: %@    %@", [self getType:[c classifyUsingDecisionTree:features]], curr_line);
        NSLog(@"and classified : %d", [c classifyLine:features]);
        NSLog(@"actual classifcation: %@", [actual_classification objectAtIndex:i]);
    }
    NSArray *n = [NSArray arrayWithArray:f];
////    KMeansLineClustering *k = [[KMeansLineClustering alloc] initWithPoints:n  desiredNumberOfCentroids:3];
////    NSMutableArray *des_cen = [[NSMutableArray alloc] init];
////    [des_cen addObject:c1];
////    [des_cen addObject:c2];
////    [des_cen addObject:c3];
////    [k assignCentroidsToArray:des_cen];
//    NSLog(@"-------------   // [k runKMeans];
//    NSLog(@"assignments %@", k.assignments);
//    for (int i = 0; i < [k.assignments count]; i++) {
//     //   if ([[k.assignments objectAtIndex:i] integerValue] == 0) {
//            NSLog(@"assignment for %@: %d", [a objectAtIndex:i], [[k.assignments objectAtIndex:i] integerValue]);
//     //   }
//    }
//------------------------------------------------------");
////    for (int i = 0; i < [k.assignments count]; i++) {
////        if ([[k.assignments objectAtIndex:i] integerValue] == 1) {
////            NSLog(@"assignment for %@: %d", [a objectAtIndex:i], [[k.assignments objectAtIndex:i] integerValue]);
////        }
////    }
//    
}

- (NSString *) getType:(int) type {
    switch (type) {
        case 0:
            return @"item";
            break;
        case 1:
            return  @"total";
        case 2:
            return  @"other";
        default:
            break;
    }
    return @"";
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
    
    TesseractController *tc = [[TesseractController alloc] init];
    NSMutableArray *clusterMatrices = [ClusterMatrixManager extractClusterMats: theMat];
    for (ClusterWrapper *cluster in clusterMatrices) {
        [tc processOcrAt: [UIImage imageWithCVMat: cluster.clusterMat]];
    }
    
    UIImage *resultingImage = [UIImage imageWithCVMat: theMat];
//    ImageWrapper *greyScale=Image::createImage(newImage, newImage.size.width, newImage.size.height);
//    ImageWrapper *edges=greyScale.image->autoLocalThreshold();
//    UIImage *postProcessingImage = edges.image->toUIImage();
    
   // [tc processOcrAt: resultingImage];
    
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
