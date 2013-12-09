/* Will Harvey */

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface CroppingImageCaptureViewController : UIViewController {
    
    AVCaptureStillImageOutput *stillImageOutput;
    BOOL started;
    CMTime ftp;
    CMTime nextPTS;
    
    AVCaptureSession *session;
    AVCaptureDevice *cameraDevice;

}

@end

