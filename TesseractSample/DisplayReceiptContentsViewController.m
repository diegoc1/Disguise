//
//  DisplayReceiptContentsViewController.m
//  TesseractSample
//
//  Created by Diego Canales on 11/30/13.
//
//

#import "DisplayReceiptContentsViewController.h"

@interface DisplayReceiptContentsViewController ()
@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) UITextView *titleTextField;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UITextView *locationTextField;
@property (strong, nonatomic) UILabel *locationLabel;
@property (strong, nonatomic) UILabel *totalLabel;
@property (strong, nonatomic) UIButton *saveButton;
@property (strong, nonatomic) UIView *saveSuccessView;
@property (nonatomic) double total;
@property (strong, nonatomic) UIView *background;
@property (strong, nonatomic) UILabel *retryLabel;
@property (strong, nonatomic) UIButton *viewReceiptButton;
@property (strong, nonatomic) UIImage *receiptImage;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) UIImageView *imView;
@property (strong, nonatomic) UIView *darkenerView;
@property (strong, nonatomic) UIButton *exitButton;

@end
#define TV_HEIGHT 40
#define TV_WIDTH 200

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@implementation DisplayReceiptContentsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id) initWithContents: (NSString *) title loc:(NSString *)location total:(double)total image:(UIImage *)image {
    self = [super init];
    if (self) {
        [self.view setBackgroundColor:[UIColor whiteColor]];
//        UIImageView *i = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 300, 300)];
//        i.image = image;
//        [self.view addSubview:i];
        NSLog(@"location: %@", location);
        self.location = location;
        self.image = image;
        self.title = title;
        self.total = total;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
   
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 30, 70, 40)];
    [self.backButton setBackgroundColor:[UIColor grayColor]];
    [self.backButton setTitle:@"Back" forState:UIControlStateNormal];
    self.backButton.layer.cornerRadius = 10;
    [self.backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.backButton addTarget:self action:@selector(buttonDown:) forControlEvents:UIControlEventTouchDown];
    [self.backButton addTarget:self action:@selector(buttonUp:) forControlEvents:UIControlEventTouchUpOutside];
    [self.view addSubview:self.backButton];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.backButton.frame.origin.y + self.backButton.frame.size.height + 10, 70, 30)];
    self.titleLabel.text = @"Title: ";
    self.titleLabel.textColor = [UIColor blackColor];
    [self.view addSubview:self.titleLabel];
    
    self.titleTextField = [[UITextView alloc] initWithFrame:CGRectMake(self.titleLabel.frame.origin.x + self.titleLabel.frame.size.width + 10, self.titleLabel.frame.origin.y - 5, TV_WIDTH, TV_HEIGHT)];
    [self.titleTextField setBackgroundColor:[UIColor grayColor]];
    self.titleTextField.layer.cornerRadius = 10;
    self.titleTextField.text = self.title;
    [self.view addSubview:self.titleTextField];
    
    self.locationLabel =[[UILabel alloc] initWithFrame:CGRectMake(self.titleLabel.frame.origin.x, self.titleTextField.frame.origin.y + self.titleTextField.frame.size.height + 10 , 100, 30)];
    self.locationLabel.text = @"Location: ";
    self.locationLabel.textColor = [UIColor blackColor];
    [self.view addSubview:self.locationLabel];
    
    self.locationTextField = [[UITextView alloc] initWithFrame:CGRectMake(self.titleLabel.frame.origin.x + self.titleLabel.frame.size.width + 10, self.locationLabel.frame.origin.y - 5, TV_WIDTH, TV_HEIGHT)];
    [self.locationTextField setBackgroundColor:[UIColor grayColor]];
    self.locationTextField.layer.cornerRadius = 10;
    self.locationTextField.text = self.location;
    NSLog(@"self.location: %@", self.location);
    [self.view addSubview:self.locationTextField];
    
    self.totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 100 /2 , self.locationTextField.frame.origin.y + self.locationTextField.frame.size.height + 20, 100, 30)];
    self.totalLabel.text = [NSString stringWithFormat:@"Total: $%.2f", self.total];
    self.totalLabel.layer.cornerRadius = 10;
    self.totalLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:self.totalLabel];
    
    
    self.viewReceiptButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 200 / 2, self.totalLabel.frame.origin.y + self.totalLabel.frame.size.height + 10, 200, 30)];
    [self.viewReceiptButton setTitle:@"View Receipt Image" forState:UIControlStateNormal];
    [self.viewReceiptButton setBackgroundColor:[UIColor grayColor]];
    self.viewReceiptButton.layer.cornerRadius = 10;
    [self.viewReceiptButton addTarget:self action:@selector(viewReceiptButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.viewReceiptButton addTarget:self action:@selector(buttonDown:) forControlEvents:UIControlEventTouchDown];
    [self.viewReceiptButton addTarget:self action:@selector(buttonUp:) forControlEvents:UIControlEventTouchUpOutside];
    [self.view addSubview:self.viewReceiptButton];
    
}

-(void) viewReceiptButtonPressed {
    NSLog(@"viewing receipt!");
    self.darkenerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.darkenerView setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8]];
    [self.view addSubview:self.darkenerView];

    self.imView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 30, self.view.frame.size.width  - 60, self.view.frame.size.height - 100)];
    self.imView.layer.cornerRadius = 10;
    self.imView.image = self.image;
    [self.view addSubview:self.imView];
    
    self.exitButton = [[UIButton alloc] initWithFrame:CGRectMake(self.imView.frame.origin.x + self.imView.frame.size.width - 15, self.imView.frame.origin.y - 15, 30, 30)];
    [self.exitButton setTitle:@"X" forState:UIControlStateNormal];
    [self.exitButton setBackgroundColor:[UIColor whiteColor]];
    [self.exitButton setTitleColor:[UIColor blackColor]  forState:UIControlStateNormal];
    self.exitButton.layer.cornerRadius = 15;
    [self.exitButton addTarget:self action:@selector(exitButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.exitButton addTarget:self action:@selector(buttonDown:) forControlEvents:UIControlEventTouchDown];
    [self.exitButton addTarget:self action:@selector(buttonUp:) forControlEvents:UIControlEventTouchUpOutside];
    [self.view addSubview:self.exitButton];
}

-(void) exitButtonPressed {
    [self.exitButton removeFromSuperview];
    [self.imView removeFromSuperview];
    [self.darkenerView removeFromSuperview];
}

-(void)backButtonPressed {
    [self.navigationController popViewControllerAnimated:FALSE];
}

-(void)buttonDown: (UIButton *) sender {
    [sender setBackgroundColor:UIColorFromRGB(0x333333)];
}

-(void)buttonUp: (UIButton *) sender {
    [sender setBackgroundColor:[UIColor grayColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
