/* Will Harvey */

#import "CroppingImageCaptureViewController.h"
#import "ReceiptModel.h"
#import "ReceiptGenerator.h"
#import "SelectItemsViewController.h"
#import "ProgressPopupView.h"

#define BUTTON_SIZE 80
#define POPUP_WIDTH 200
#define POP_HEIGHT 130

@interface CroppingImageCaptureViewController ()

@property (nonatomic, strong) UIView *imagePreviewView;
@property (nonatomic, strong) UIButton *captureImageButton;

@end

@implementation CroppingImageCaptureViewController

-(id) init {
    self = [super init];
    
    if (self) {
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
        CGFloat screenHeight = screenRect.size.height;
        
        self.imagePreviewView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, screenWidth, screenHeight)];
        self.imagePreviewView.backgroundColor = [UIColor darkGrayColor];
        [self.view addSubview: self.imagePreviewView];
        
        
        self.captureImageButton = [[UIButton alloc] initWithFrame: CGRectMake(screenWidth/2 - BUTTON_SIZE/2, 400, BUTTON_SIZE, BUTTON_SIZE)];
        self.captureImageButton.backgroundColor = [UIColor whiteColor];
        self.captureImageButton.layer.cornerRadius = BUTTON_SIZE/2;
        [self.view addSubview: self.captureImageButton];
        
        //Black ring inside the button
        int ringDiff = 16;
        UIView *buttonRingView = [[UIView alloc] initWithFrame:CGRectMake(ringDiff/2, ringDiff/2, BUTTON_SIZE - ringDiff, BUTTON_SIZE - ringDiff)];
        buttonRingView.backgroundColor = [UIColor clearColor];
        buttonRingView.layer.cornerRadius = (BUTTON_SIZE - ringDiff)/2;
        buttonRingView.layer.borderColor = [UIColor blackColor].CGColor;
        buttonRingView.layer.borderWidth = 2.0f;
        [buttonRingView setUserInteractionEnabled:NO];
        [self.captureImageButton addSubview: buttonRingView];
        
        
        if (![self initializeCamera]) NSLog(@"Error initializing camera !");
    }
    
    return self;
}


-(BOOL) initializeCamera {
    NSError *error = nil;
    session = [AVCaptureSession new];
    [session setSessionPreset:AVCaptureSessionPresetHigh];
    cameraDevice = [AVCaptureDevice defaultDeviceWithMediaType: AVMediaTypeVideo];
    
    /* Configure camera for close distance focusing and image capture */
    [cameraDevice lockForConfiguration: nil];
    if ([cameraDevice isAutoFocusRangeRestrictionSupported]) {
        [cameraDevice setAutoFocusRangeRestriction: AVCaptureAutoFocusRangeRestrictionNear];
    }
    else {
    }
    [cameraDevice setFocusPointOfInterest: CGPointMake(0.5, 0.5)]; //Always focus on center
    [cameraDevice setFocusMode: AVCaptureFocusModeAutoFocus];
    [cameraDevice unlockForConfiguration];
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice: cameraDevice error:&error];
    if (error)
        return NO;
    if ([session canAddInput:input]) [session addInput:input];
    else return FALSE;
    
    stillImageOutput = [AVCaptureStillImageOutput new];
    if ([session canAddOutput:stillImageOutput]) [session addOutput:stillImageOutput];
    else return FALSE;
    
    //Add preview layer to our view
    AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspect];
    [previewLayer setFrame:[self.imagePreviewView bounds]];
    [[self.imagePreviewView layer] setBackgroundColor:[[UIColor blackColor] CGColor]];
    [[self.imagePreviewView layer] addSublayer:previewLayer];
    
    [session startRunning];
    
    ftp = CMTimeMakeWithSeconds(1./5., 90000);
    [self.captureImageButton addTarget: self action: @selector(captureImage) forControlEvents: UIControlEventTouchUpInside];

    return YES;
}

-(void) captureImage {
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in stillImageOutput.connections)
    {
        for (AVCaptureInputPort *port in [connection inputPorts])
        {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] )
            {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) { break; }
    }
    
    [stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection
                                                  completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error)
     {
         [session stopRunning];
         if (!imageSampleBuffer) return;
         NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation: imageSampleBuffer];
         UIImage *image = [[UIImage alloc] initWithData: imageData];
         [self didCaptureImage: image];
         
     }];
    
}

-(void) didCaptureImage: (UIImage *) image {
    
    //Notify user that processing is occurring
    ProgressPopupView *popupView = [[ProgressPopupView alloc] initWithFrame: CGRectMake(self.view.frame.size.width/2 - POPUP_WIDTH/2, 120, POPUP_WIDTH, POP_HEIGHT)];
    [self.view addSubview: popupView];
    
    //Perform computer vision on background thread, and update UI on main thread when done
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        ReceiptModel *receipt = [ReceiptGenerator getReceiptForImage: image];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            SelectItemsViewController *sv = [[SelectItemsViewController alloc] initWithReceiptModel: receipt andImage: image];
            [self.navigationController pushViewController: sv animated: FALSE];
            [session startRunning];
            
            //Remove popup when done
            [popupView removeFromSuperview];

        });
    });
    
    
    
    
   }

@end