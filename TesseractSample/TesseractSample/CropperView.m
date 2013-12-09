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
@end

@implementation CropperView

- (id)initWithFrame:(CGRect)frame andImage:(UIImage *)image andCompletionHandler: (void
                                                                                   (^)(UIImage *)) handler {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.handler = handler;
        
        //CGRect mainScreenRectangle = [[UIScreen mainScreen] bounds];
        CGFloat height = self.frame.size.height;
        CGFloat width = self.frame.size.width;
        if (image) self.img = image;
        else self.img = [UIImage imageNamed:@"receipt_img.jpg"];
      //  self.img = [UIImage imageNamed:@"receipt_img.jpg"];
        
        NSLog(@"image: %@", self.img);
        self.img = [UIImage imageWithCGImage:[self.img CGImage] scale:1.0  orientation: 0];
        NSLog(@"orientation of img %d", self.img.imageOrientation);
      //  NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
     //   self.img = [UIImage imageWithData:imageData];
     //   CGImageRef imageRef = [self.img CGImage];
        
        //self.img = [UIImage imageWithCGImage:imageRef scale:1.0 orientation:UIImageOrientationRight];
        
        self.imview = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, width - 40, height - 40)];
        [self addSubview:self.imview];
        [self.imview setImage:self.img];
      //  self.img =[UIImage imageWithCGImage:[self.img CGImage] scale:self.img.scale orientation:0];
        
        self.cropper = [[UIView alloc] initWithFrame:CGRectMake(self.imview.frame.origin.x + 10, self.imview.frame.origin.y + 10, self.imview.frame.size.width - 20, self.imview.frame.size.height - 20)];
        [self addSubview:self.cropper];
        self.cropper.userInteractionEnabled = YES;
        
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
        [panRecognizer setMinimumNumberOfTouches:1];
        [panRecognizer setMaximumNumberOfTouches:1];
        [self.cropper addGestureRecognizer:panRecognizer];
        self.allowDrag = TRUE;
        
        UIButton *cropButton = [[UIButton alloc] initWithFrame:CGRectMake(70, 50, 70, 20)];
        [cropButton setTitle:@"CROP" forState:UIControlStateNormal];
        [cropButton setBackgroundColor:[UIColor redColor]];
        [cropButton addTarget:self action:@selector(cropButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cropButton];
        
        self.cropper.layer.borderColor = [UIColor orangeColor].CGColor;
        self.cropper.layer.borderWidth = 5.0f;

    }
    return self;
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
    

    
    // or use the UIImage wherever you like
  //  self.img =[UIImage imageWithCGImage:imageRef];
 //   self.img.imageOrientation = 3;
    NSLog(@"orientation is now :%d", self.img.imageOrientation);
    [self.imview setImage:self.img];
    // self.imview.transform = CGAffineTransformMakeRotation(M_PI/2);
  //  [self.imview setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height)];
    
    
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


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
