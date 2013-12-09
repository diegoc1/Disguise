/* Will Harvey */

#import "ProgressPopupView.h"

@interface ProgressPopupView()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, strong) UIView *backgroundView;

@end

@implementation ProgressPopupView


-(void) startAnimating {
    
}

-(void) setText: (NSString *) text {
    self.label.text = text;
}

-(id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame: frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.backgroundView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        self.backgroundView.backgroundColor = [UIColor whiteColor];
        self.backgroundView.layer.cornerRadius = 30;
        [self addSubview: self.backgroundView];
        
        self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
        [self.activityView startAnimating];
        [self.activityView setCenter: CGPointMake(self.frame.size.width/2, self.frame.size.height/2 + 28)];
        [self addSubview: self.activityView];
        
        self.label = [[UILabel alloc] init];
        [self addSubview: self.label];
        self.label.textColor = [UIColor darkGrayColor];
        self.label.text = @"Processing...";
        self.label.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 23];
        self.label.backgroundColor = [UIColor clearColor];
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.frame = CGRectMake(0, 27, self.frame.size.width,  40);
        
        [self fastPopIn: self.frame];
        
    }
    return self;
}


-(void) fastPopIn: (CGRect) frame {
    float width = frame.size.width;
    float height = frame.size.height;
    
    float extraSpace = 15;
    self.backgroundView.frame = CGRectMake(-1 * extraSpace, -1 * extraSpace, width + 2 * extraSpace, height + 2 * extraSpace);
    
    [UIView beginAnimations: @"popin" context: nil];
    [UIView setAnimationDuration: 0.2];
    self.backgroundView.frame = CGRectMake(0, 0, width, height);
    [UIView commitAnimations];
}


@end
