//
//  CropperView.m
//  TesseractSample
//
//  Created by Diego Canales on 12/8/13.
//
//

#import "CropperView.h"

typedef void (^CompletionBlock)(UIImage *);


@interface CropperView()
@property (nonatomic) CGPoint startLoc;
@property (strong, nonatomic) UIView *cropper;
@property (strong, nonatomic) UIImageView *imview;
@property (strong, nonatomic) UIImage *img;
@property (nonatomic) double xloc;
@property (nonatomic) double yloc;
@property (nonatomic) double width;
@property (nonatomic) double height;
@property (nonatomic) int direction;
@property (nonatomic) BOOL allowDrag;
@property (nonatomic) int xSectionInView;
@property (nonatomic) int ySectionInView;
@property (nonatomic, strong) CompletionBlock handler;
@property (strong, nonatomic) UIButton *cropButton;
@end

#define CROP_BUT_WIDTH 80
#define CROP_BUT_HEIGHT 40
//This macro function came from :http://stackoverflow.com/questions/19405228/how-to-i-properly-set-uicolor-from-int
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation CropperView

- (id)initWithFrame:(CGRect)frame andImage:(UIImage *)image andCompletionHandler: (void
                                                                                   (^)(UIImage *)) handler {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.handler = handler;
        
        //CGRect mainScreenRectangle = [[UIScreen mainScreen] bounds];
        CGFloat height = self.frame.size.height;
        CGFloat width = self.frame.size.width;
      //  self.completionSelector = selector;
        if (image) self.img = image;
        self.img = [UIImage imageWithCGImage:[self.img CGImage] scale:1.0  orientation: 0];
        
        self.imview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height - 40)];
        [self addSubview:self.imview];
        [self.imview setImage:self.img];
        
        self.cropper = [[UIView alloc] initWithFrame:CGRectMake(self.imview.frame.origin.x + 10, self.imview.frame.origin.y + 10, self.imview.frame.size.width - 20, self.imview.frame.size.height - 80)];
        [self addSubview:self.cropper];
        self.cropper.userInteractionEnabled = YES;
        
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
        [panRecognizer setMinimumNumberOfTouches:1];
        [panRecognizer setMaximumNumberOfTouches:1];
        UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinch:)];
       
        [self.cropper addGestureRecognizer:panRecognizer];
        [self.cropper addGestureRecognizer:pinchRecognizer];
        self.allowDrag = TRUE;
        
        self.cropButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width / 2 - CROP_BUT_WIDTH / 2, self.frame.size.height - 40 - CROP_BUT_HEIGHT - 15 , CROP_BUT_WIDTH, CROP_BUT_HEIGHT)];
        [self.cropButton setTitle:@"Crop" forState:UIControlStateNormal];
        [self.cropButton setBackgroundColor:[UIColor grayColor]];
        [self.cropButton addTarget:self action:@selector(cropButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self.cropButton addTarget:self action:@selector(buttonDown:) forControlEvents:UIControlEventTouchDown];
        [self.cropButton addTarget:self action:@selector(buttonUp:) forControlEvents:UIControlEventTouchUpOutside];
        [self.cropButton addTarget:self action:@selector(buttonUp:) forControlEvents:UIControlEventTouchUpInside];
        self.cropButton.layer.cornerRadius = 10;
        [self addSubview:self.cropButton];
        
        self.cropper.layer.borderColor = [UIColor blackColor].CGColor;
        self.cropper.layer.borderWidth = 5.0f;

    }
    return self;
}

-(void)buttonDown: (UIButton *) sender {
    [sender setBackgroundColor:UIColorFromRGB(0x333333)];
}

-(void)buttonUp: (UIButton *) sender {
    [sender setBackgroundColor:[UIColor grayColor]];
}

-(void) pinch:(UIPinchGestureRecognizer *)recognizer {
    double scale = recognizer.scale;
    if (recognizer.scale > 1) {
        scale = 1 + ((recognizer.scale - 1) / 50);
    } else {
        scale = 1 - ((1 - recognizer.scale) / 50);
    }

    double oldWidth = self.cropper.frame.size.width;
    double oldHeight = self.cropper.frame.size.height;
    double newWidth = oldWidth * scale;
    double newHeight = oldHeight * scale;
    if (self.cropper.frame.origin.x + newWidth < self.imview.frame.origin.x + self.imview.frame.size.width && self.cropper.frame.origin.y + newHeight < self.imview.frame.origin.y + self.imview.frame.size.height && newWidth > 5 && newHeight > 5) {
    
    [self.cropper setFrame:CGRectMake(self.cropper.frame.origin.x, self.cropper.frame.origin.y, newWidth, newHeight)];
    }
}


-(void) cropButtonPressed {
  //  self.img =[UIImage imageWithCGImage:[self.img CGImage] scale:self.img.scale orientation:self.img.imageOrientation];
    NSLog(@"image width %f", self.img.size.width);
     NSLog(@"image height %f", self.img.size.height);
    
    
    double x_ratio = self.img.size.width / self.imview.frame.size.width;
    double y_ratio = self.img.size.height / self.imview.frame.size.height;
   // NSLog(@"Width of image: %f height %f", self.img.size.width, self.img.size.height);
    NSLog(@"x_ration :%f", x_ratio);
    NSLog(@"y _ratio: %f", y_ratio);
    
    
    double x_origin_diff = abs(self.imview.frame.origin.x - self.cropper.frame.origin.x);
    double y_origin_diff = abs(self.imview.frame.origin.y - self.cropper.frame.origin.y);
    CGRect r = CGRectMake(x_origin_diff * x_ratio, y_origin_diff* y_ratio, self.cropper.frame.size.width * x_ratio, self.cropper.frame.size.height * y_ratio);
 //   CGRect r = CGRectMake(y_origin_diff* y_ratio, x_origin_diff * x_ratio, y_origin_diff* y_ratio, self.cropper.frame.size.width * x_ratio, self.cropper.frame.size.height * y_ratio);
    NSLog(@"r1 is %f", x_origin_diff * x_ratio);
    NSLog(@"r2 is %f", y_origin_diff* y_ratio);
    NSLog(@"r3 is %f", self.cropper.frame.size.width * x_ratio);
    NSLog(@"r4 is %f", self.cropper.frame.size.height * y_ratio);

   // CGRect r = CGRectMake(300, 300, 1000 , 1000);
    CGImageRef imageRef = CGImageCreateWithImageInRect([self.img CGImage], r);
   //
    
    self.img =[UIImage imageWithCGImage:imageRef scale:self.img.scale orientation:self.img.imageOrientation];
    
    [self.imview setImage:self.img];
    
    
    self.handler(self.img);
    [self removeFromSuperview];
}

- (int) getXSectionOfView: (CGPoint) point {
    if (point.x < self.cropper.frame.origin.x + (self.cropper.frame.size.width / 2)) return 0;
    return 1;
}

- (int) getYSectionOfView: (CGPoint) point {
    if (point.y < self.cropper.frame.origin.y + (self.cropper.frame.size.height / 2)) return 0;
    return 1;
}

- (int) getDirection: (CGPoint) velocity {
    if(velocity.x > 0 && abs(velocity.x) >= abs(velocity.y)) {
        return 0;
    } else if(velocity.x < 0 && abs(velocity.x) >= abs(velocity.y)) {
        return 1;
    } else if(velocity.y < 0 && abs(velocity.y) >= abs(velocity.x)) {
        return 2;
    } else {
        return 3;
    }
}


-(void)move:(UIPanGestureRecognizer *)recognizer {
    CGFloat distance;
    CGPoint velocity = [recognizer velocityInView:self.cropper];
    int currDirection = [self getDirection:velocity];
    if (recognizer.state == UIGestureRecognizerStateBegan || self.direction != currDirection) {
        self.startLoc = [recognizer locationInView:self];
        self.xloc = self.cropper.frame.origin.x;
        self.yloc = self.cropper.frame.origin.y;
        self.width = self.cropper.frame.size.width;
        self.height = self.cropper.frame.size.height;
        CGPoint locInView = [recognizer locationInView:self];
        if (recognizer.state == UIGestureRecognizerStateBegan) {
            self.xSectionInView = [self getXSectionOfView:locInView];
            self.ySectionInView = [self getYSectionOfView:locInView];
        }
        self.direction = [self getDirection:velocity];
    }
    else {
        CGPoint stopLocation = [recognizer locationInView:self];
        CGFloat dx = stopLocation.x - self.startLoc.x;
        CGFloat dy = stopLocation.y - self.startLoc.y;
        distance = sqrt(dx*dx + dy*dy );
        CGRect newFrame;
        
        if(self.direction == 0) {
            if (self.xSectionInView == 0) newFrame = CGRectMake(self.xloc + distance, self.yloc, self.width - distance, self.height);
            else newFrame = CGRectMake(self.xloc, self.yloc, self.width + distance, self.height);
        }
        else if(self.direction == 1) {
            if (self.xSectionInView == 1) newFrame = CGRectMake(self.xloc, self.yloc, self.width - distance, self.height);
            else newFrame = CGRectMake(self.xloc - distance, self.yloc, self.width + distance, self.height);
        }
        else if(self.direction == 2) {
            if (self.ySectionInView == 1) newFrame = CGRectMake(self.xloc, self.yloc, self.width, self.height - distance);
            else newFrame = CGRectMake(self.xloc, self.yloc - distance, self.width, self.height + distance);
        }
        else {
            if (self.ySectionInView == 0) newFrame = CGRectMake(self.xloc, self.yloc + distance, self.width, self.height - distance);
            else newFrame = CGRectMake(self.xloc, self.yloc, self.width, self.height + distance);
        }
        if (newFrame.origin.x >= self.imview.frame.origin.x && newFrame.origin.y >= self.imview.frame.origin.y && newFrame.size.width <= self.imview.frame.size.width && newFrame.size.height < self.imview.frame.size.height && newFrame.size.width > 10 && newFrame.size.height > 10) {
            [self.cropper setFrame:newFrame];
        }
    }
    
    
    
}

- (UIImage *) getCroppedImage {
    return self.img;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
