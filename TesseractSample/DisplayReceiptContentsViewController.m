//
//  DisplayReceiptContentsViewController.m
//  TesseractSample
//
//  Created by Diego Canales on 11/30/13.
//
//

#import "DisplayReceiptContentsViewController.h"
#import <Social/Social.h>

@interface DisplayReceiptContentsViewController ()
@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) UILabel *titleTextField;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *locationTextField;
@property (strong, nonatomic) UILabel *locationLabel;
@property (strong, nonatomic) UILabel *totalLabel;
@property (strong, nonatomic) UIButton *saveButton;
@property (strong, nonatomic) UIView *saveSuccessView;
@property (nonatomic) double total;
@property (strong, nonatomic) UIView *background;
@property (strong, nonatomic) UILabel *retryLabel;
@property (strong, nonatomic) UIButton *viewReceiptButton;
@property (strong, nonatomic) UIButton *sendReceiptButton;
@property (strong, nonatomic) UIImage *receiptImage;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) UIImageView *imView;
@property (strong, nonatomic) UIView *darkenerView;
@property (strong, nonatomic) UIButton *exitButton;
@property (strong, nonatomic) UIButton *sendTextButton;
@property (strong, nonatomic) UIButton *postToFacebookButton;
@property (strong, nonatomic) UIButton *postToTwitterButton;

@end
#define TV_HEIGHT 40
#define TV_WIDTH 200


//This macro function came from :http://stackoverflow.com/questions/19405228/how-to-i-properly-set-uicolor-from-int
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
    self.backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 30, 70, 30)];
    [self.backButton setBackgroundColor:[UIColor grayColor]];
    [self.backButton setTitle:@"Back" forState:UIControlStateNormal];
    self.backButton.layer.cornerRadius = 10;
    [self.backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.backButton addTarget:self action:@selector(buttonDown:) forControlEvents:UIControlEventTouchDown];
    [self.backButton addTarget:self action:@selector(buttonUp:) forControlEvents:UIControlEventTouchUpOutside];
    [self.view addSubview:self.backButton];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.backButton.frame.origin.y + self.backButton.frame.size.height + 30, 70, 30)];
    self.titleLabel.text = @"Title: ";
    self.titleLabel.textColor = [UIColor blackColor];
    [self.view addSubview:self.titleLabel];
    
    self.titleTextField = [[UILabel alloc] initWithFrame:CGRectMake(self.titleLabel.frame.origin.x + self.titleLabel.frame.size.width + 10, self.titleLabel.frame.origin.y - 5, TV_WIDTH, TV_HEIGHT)];
    //  [self.titleTextField setBackgroundColor:[UIColor grayColor]];
    self.titleTextField.layer.borderWidth = 2;
    self.titleTextField.layer.borderColor = [UIColor grayColor].CGColor;
    self.titleTextField.layer.cornerRadius = 10;
    self.titleTextField.text = self.title;
    self.titleTextField.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.titleTextField];
    
    self.locationLabel =[[UILabel alloc] initWithFrame:CGRectMake(self.titleLabel.frame.origin.x, self.titleTextField.frame.origin.y + self.titleTextField.frame.size.height + 10 , 100, 30)];
    self.locationLabel.text = @"Location: ";
    self.locationLabel.textColor = [UIColor blackColor];
   // [self.view addSubview:self.locationLabel];
    
    self.locationTextField = [[UILabel alloc] initWithFrame:CGRectMake(self.titleLabel.frame.origin.x + self.titleLabel.frame.size.width + 10, self.locationLabel.frame.origin.y - 5, TV_WIDTH, TV_HEIGHT)];
    //   [self.locationTextField setBackgroundColor:[UIColor grayColor]];
    self.locationTextField.layer.borderWidth = 2;
    self.locationTextField.layer.borderColor = [UIColor grayColor].CGColor;
    self.locationTextField.layer.cornerRadius = 10;
    self.locationTextField.text = self.location;
    self.locationTextField.textAlignment = NSTextAlignmentCenter;
  //  [self.view addSubview:self.locationTextField];
    
    self.totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 100 /2 , self.locationTextField.frame.origin.y + self.locationTextField.frame.size.height + 20, 100, 30)];
    self.totalLabel.text = [NSString stringWithFormat:@"Total: $%.2f", self.total];
    self.totalLabel.layer.cornerRadius = 10;
    self.totalLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:self.totalLabel];
    
    
    self.viewReceiptButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 200 / 2, self.titleTextField.frame.origin.y + self.titleTextField.frame.size.height + 35, 200, 30)];
    [self.viewReceiptButton setTitle:@"View Receipt Image" forState:UIControlStateNormal];
    [self.viewReceiptButton setBackgroundColor:[UIColor grayColor]];
    self.viewReceiptButton.layer.cornerRadius = 10;
    [self.viewReceiptButton addTarget:self action:@selector(viewReceiptButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.viewReceiptButton addTarget:self action:@selector(buttonDown:) forControlEvents:UIControlEventTouchDown];
    [self.viewReceiptButton addTarget:self action:@selector(buttonUp:) forControlEvents:UIControlEventTouchUpOutside];
    [self.viewReceiptButton addTarget:self action:@selector(buttonUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.viewReceiptButton];
    
    self.sendReceiptButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 200 / 2, self.viewReceiptButton.frame.origin.y + self.viewReceiptButton.frame.size.height + 10, 200, 30)];
    [self.sendReceiptButton setTitle:@"Email Receipt" forState:UIControlStateNormal];
    [self.sendReceiptButton setBackgroundColor:[UIColor grayColor]];
    self.sendReceiptButton.layer.cornerRadius = 10;
    [self.sendReceiptButton addTarget:self action:@selector(sendReceiptButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.sendReceiptButton addTarget:self action:@selector(buttonDown:) forControlEvents:UIControlEventTouchDown];
    [self.sendReceiptButton addTarget:self action:@selector(buttonUp:) forControlEvents:UIControlEventTouchUpOutside];
    [self.sendReceiptButton addTarget:self action:@selector(buttonUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.sendReceiptButton];
    
    self.sendTextButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 200 / 2, self.sendReceiptButton.frame.origin.y + self.sendReceiptButton.frame.size.height + 10, 200, 30)];
    [self.sendTextButton setTitle:@"Text Receipt" forState:UIControlStateNormal];
    [self.sendTextButton setBackgroundColor:[UIColor grayColor]];
    self.sendTextButton.layer.cornerRadius = 10;
    [self.sendTextButton addTarget:self action:@selector(sendTextButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.sendTextButton addTarget:self action:@selector(buttonDown:) forControlEvents:UIControlEventTouchDown];
    [self.sendTextButton addTarget:self action:@selector(buttonUp:) forControlEvents:UIControlEventTouchUpOutside];
    [self.sendTextButton addTarget:self action:@selector(buttonUp:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:self.sendTextButton];
    
    self.postToFacebookButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 200 / 2, self.sendTextButton.frame.origin.y + self.sendTextButton.frame.size.height + 10, 200, 30)];
    [self.postToFacebookButton setTitle:@"Post to Facebook" forState:UIControlStateNormal];
    [self.postToFacebookButton setBackgroundColor:[UIColor grayColor]];
    self.postToFacebookButton.layer.cornerRadius = 10;
    [self.postToFacebookButton addTarget:self action:@selector(sendFacebookButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.postToFacebookButton addTarget:self action:@selector(buttonDown:) forControlEvents:UIControlEventTouchDown];
    [self.postToFacebookButton addTarget:self action:@selector(buttonUp:) forControlEvents:UIControlEventTouchUpOutside];
    [self.postToFacebookButton addTarget:self action:@selector(buttonUp:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:self.postToFacebookButton];
    
    self.postToTwitterButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 200 / 2, self.postToFacebookButton.frame.origin.y + self.postToFacebookButton.frame.size.height + 10, 200, 30)];
    [self.postToTwitterButton setTitle:@"Post to Twitter" forState:UIControlStateNormal];
    [self.postToTwitterButton setBackgroundColor:[UIColor grayColor]];
    self.postToTwitterButton.layer.cornerRadius = 10;
    [self.postToTwitterButton addTarget:self action:@selector(sendTwitterButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.postToTwitterButton addTarget:self action:@selector(buttonDown:) forControlEvents:UIControlEventTouchDown];
    [self.postToTwitterButton addTarget:self action:@selector(buttonUp:) forControlEvents:UIControlEventTouchUpOutside];
    [self.postToTwitterButton addTarget:self action:@selector(buttonUp:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:self.postToTwitterButton];
    
    
}
//This code was derived from a tutorial at :http://blog.mugunthkumar.com/coding/iphone-tutorial-how-to-send-in-app-sms/
- (void) sendTextButtonPressed {
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText])
    {
        controller.body = [NSString stringWithFormat:@"%@", self.title];
        controller.recipients = [NSArray arrayWithObjects:nil];
        controller.messageComposeDelegate = self;
        NSData *data = UIImagePNGRepresentation(self.image);
        NSString *mimeType = @"application/png";
        NSString *fileName = @"receipt.png";
        [controller addAttachmentData:data typeIdentifier:mimeType filename:fileName];
        [self presentViewController:controller animated:YES completion:Nil];
        
    }
    return;

}


/* Facebook/twitter code is Will Harvey - Everything else is Diego's */
/*********/


-(void) presentSocialViewControllerOfType: (NSString * const) sltype {
    SLComposeViewController *fbPostVC = [SLComposeViewController composeViewControllerForServiceType: sltype];
    
    [fbPostVC setInitialText: self.title];
    [fbPostVC addImage: self.image];
    
    [self presentViewController: fbPostVC animated: TRUE completion: nil];
    
    fbPostVC.completionHandler = ^(SLComposeViewControllerResult result){
        [self dismissViewControllerAnimated: TRUE completion: nil]; };
}


-(void) sendFacebookButtonPressed {
    [self presentSocialViewControllerOfType: SLServiceTypeFacebook];
}


-(void) sendTwitterButtonPressed {
    [self presentSocialViewControllerOfType: SLServiceTypeTwitter];
}


/* End of Will code */
/*********/

//This code was derived from a tutorial at: http://stackoverflow.com/questions/310946/how-can-i-send-mail-from-an-iphone-application
- (void) sendReceiptButtonPressed {
    
    [self.sendReceiptButton setBackgroundColor:[UIColor grayColor]];
    NSString *subject = [NSString stringWithFormat:@"Receipt: %@", self.title ];
    NSString *email_text = [NSString stringWithFormat:@"Here is the receipt from %@", self.location ];
    NSData *data = UIImagePNGRepresentation(self.image);
    MFMailComposeViewController *mailComposeVC = [[MFMailComposeViewController alloc] init];
    NSString *mimeType = @"application/png";
    NSString *fileName = @"receipt.png";
    mailComposeVC.mailComposeDelegate = self;
    [mailComposeVC setSubject:subject];
    [mailComposeVC setMessageBody:email_text isHTML:NO];
    [mailComposeVC addAttachmentData: data mimeType: mimeType fileName: fileName];
    
    if ([MFMailComposeViewController canSendMail])
        [self presentViewController: mailComposeVC animated:YES completion:NULL];
    else NSLog(@"cant send email");
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error;
{
    if (result == MFMailComposeResultSent) {
        NSLog(@"Mail Sent!");
    } else {
        NSLog(@"NOT SENT");
    }
    [self dismissViewControllerAnimated: TRUE completion:nil];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    [self dismissViewControllerAnimated: TRUE completion:nil];
}


-(void) viewReceiptButtonPressed {
    self.darkenerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.darkenerView setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8]];
    [self.view addSubview:self.darkenerView];
    self.imView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 30, self.view.frame.size.width  - 60, self.view.frame.size.height - 100)];
    
    self.imView.layer.cornerRadius = 10;
    self.imView.image = self.image;
    [self.imView setAlpha:0.0];
    [self.view addSubview:self.imView];
    
    self.exitButton = [[UIButton alloc] initWithFrame:CGRectMake(self.imView.frame.origin.x + self.imView.frame.size.width - 15, self.imView.frame.origin.y - 15, 30, 30)];
    self.exitButton.titleLabel.font = [UIFont systemFontOfSize:13];

    [self.exitButton setTitle:@"X" forState:UIControlStateNormal];
    [self.exitButton setBackgroundColor:[UIColor whiteColor]];
    [self.exitButton setTitleColor:[UIColor blackColor]  forState:UIControlStateNormal];
    self.exitButton.layer.cornerRadius = 15;
    [self.exitButton addTarget:self action:@selector(exitButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.exitButton addTarget:self action:@selector(buttonDown:) forControlEvents:UIControlEventTouchDown];
    [self.exitButton addTarget:self action:@selector(buttonUp:) forControlEvents:UIControlEventTouchUpOutside];
    [self.exitButton setAlpha:0.0];
    [self.view addSubview:self.exitButton];
    
    [self.viewReceiptButton setBackgroundColor:[UIColor grayColor]];
    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4];
    [self.exitButton setAlpha:1.0];
    [self.imView setAlpha:1.0];
    [UIView commitAnimations];
    
    
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


