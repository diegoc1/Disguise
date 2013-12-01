//
//  SaveReceiptViewController.m
//  TesseractSample
//
//  Created by Diego Canales on 11/30/13.
//
//

#import "SaveReceiptViewController.h"
#import "AppDelegate.h"

@interface SaveReceiptViewController ()
@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) UITextField *titleTextField;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UITextField *locationTextField;
@property (strong, nonatomic) UILabel *locationLabel;
@property (strong, nonatomic) UITextField *totalTextField;
@property (strong, nonatomic) UILabel *totalLabel;
@property (strong, nonatomic) UIButton *saveButton;
@property (strong, nonatomic) UIView *saveSuccessView;
@property (nonatomic) double total;
@property (strong, nonatomic) UIView *background;
@property (strong, nonatomic) UILabel *retryLabel;
@property (strong, nonatomic) UIButton *OKButton;

@end

@implementation SaveReceiptViewController

#define TV_HEIGHT 40
#define TV_WIDTH 200

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}
- (id)initWithTotal:(double)total {
    self = [super init];
    if (self) {
        // Custom initialization
        self.total = total;
        NSLog(@"total: %f", self.total);
        
    }
    return self;
}


-(void)buttonDown: (UIButton *) sender {
    [sender setBackgroundColor:UIColorFromRGB(0x333333)];
}

-(void)buttonUp: (UIButton *) sender {
    [sender setBackgroundColor:[UIColor grayColor]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   // [self.view setBackgroundColor:[UIColor whiteColor]];
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
    self.titleLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:self.titleLabel];
    
    self.titleTextField = [[UITextField alloc] initWithFrame:CGRectMake(self.titleLabel.frame.origin.x + self.titleLabel.frame.size.width + 10, self.titleLabel.frame.origin.y - 5, TV_WIDTH, TV_HEIGHT)];
    [self.titleTextField setBackgroundColor:[UIColor grayColor]];
    self.titleTextField.layer.cornerRadius = 10;
    [self.view addSubview:self.titleTextField];
    
    self.locationLabel =[[UILabel alloc] initWithFrame:CGRectMake(self.titleLabel.frame.origin.x, self.titleTextField.frame.origin.y + self.titleTextField.frame.size.height + 10 , 100, 30)];
    self.locationLabel.text = @"Location: ";
    self.locationLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:self.locationLabel];
    
    self.locationTextField = [[UITextField alloc] initWithFrame:CGRectMake(self.titleLabel.frame.origin.x + self.titleLabel.frame.size.width + 10, self.locationLabel.frame.origin.y - 5, TV_WIDTH, TV_HEIGHT)];
    [self.locationTextField setBackgroundColor:[UIColor grayColor]];
    self.locationTextField.layer.cornerRadius = 10;
    [self.view addSubview:self.locationTextField];
    
    self.totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 100 /2 , self.locationTextField.frame.origin.y + self.locationTextField.frame.size.height + 20, 100, 30)];
    self.totalLabel.text = [NSString stringWithFormat:@"Total: $%.2f", self.total];
    self.totalLabel.layer.cornerRadius = 10;
    self.totalLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:self.totalLabel];
    
    
	self.saveButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 70 / 2, self.totalLabel.frame.origin.y + self.totalLabel.frame.size.height + 10, 70, 30)];
    [self.saveButton setTitle:@"Save" forState:UIControlStateNormal];
    [self.saveButton setBackgroundColor:[UIColor grayColor]];
    [self.saveButton addTarget:self action:@selector(saveButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.saveButton addTarget:self action:@selector(buttonDown:) forControlEvents:UIControlEventTouchDown];
    [self.saveButton addTarget:self action:@selector(buttonUp:) forControlEvents:UIControlEventTouchUpOutside];
    self.saveButton.layer.cornerRadius = 10;
    [self.view addSubview:self.saveButton];
}

#define SAVE_BACKGROUND_WIDTH 300
#define SAVE_BACKGROUND_HEIGHT 200

-(void) saveButtonPressed {
    NSLog(@"SAVE");
    NSLog(@"%@",self.titleTextField.text);
    NSLog(@"%@",self.locationTextField.text);
    self.background = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.background setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7]];
    [self.view addSubview:self.background];
    self.saveSuccessView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - SAVE_BACKGROUND_WIDTH / 2, self.view.frame.size.height / 2 - SAVE_BACKGROUND_HEIGHT / 2, SAVE_BACKGROUND_WIDTH, SAVE_BACKGROUND_HEIGHT)];
    self.saveSuccessView.layer.cornerRadius = 10;
    [self.saveSuccessView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.saveSuccessView];

    if (self.titleTextField.text.length != 0 && self.locationTextField.text.length != 0) {
        

        UILabel *successLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 150 / 2, self.view.frame.size.height / 2 - 75 / 2, 150, 75)];
        successLabel.text = @"Save Successful!";
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = appDelegate.managedObjectContext;
        NSManagedObject *newReceipt = [NSEntityDescription
                                           insertNewObjectForEntityForName:@"Receipt"
                                           inManagedObjectContext:context];
        [newReceipt setValue:self.titleTextField.text forKey:@"title"];
        [newReceipt setValue:self.locationTextField.text forKey:@"location"];
        [newReceipt setValue:[NSNumber numberWithDouble:self.total] forKey:@"individual_total"];
        
        NSError *error;
        if (![context save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription
                                       entityForName:@"Receipt" inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
        for (NSManagedObject *info in fetchedObjects) {
            NSLog(@"Title: %@", [info valueForKey:@"title"]);
            NSLog(@"Location: %@", [info valueForKey:@"location"]);
            NSLog(@"Total: %@", [info valueForKey:@"individual_total"]);
        }
     //   for (id basket in fetchedObjects) [context deleteObject:basket];

        [self.view addSubview:successLabel];
        [self.view endEditing:YES];
        [self performSelector:@selector(goToHome) withObject:[NSNumber numberWithInt:0] afterDelay:1.2];
        
    } else {
        [self createRetryView];
    }
    [self.saveButton setBackgroundColor:[UIColor grayColor]];
    
    
}

- (void) createRetryView {
    NSLog(@"RETRY");
    self.retryLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 200 / 2, self.view.frame.size.height / 2 - 75 / 2, 200, 75)];
    self.retryLabel.text = @"Please fill out the title and location fields!";
    self.retryLabel.numberOfLines = 2;
    self.retryLabel.textAlignment = NSTextAlignmentCenter;
    self.retryLabel.textColor = [UIColor blackColor];
    [self.view addSubview:self.retryLabel];
    self.OKButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size
                                                               .width / 2 - 75 / 2, self.retryLabel.frame.origin.y + self.retryLabel.frame.size
                                                               .height + 10, 75, 35)];
    [self.OKButton setTitle:@"OK" forState:UIControlStateNormal];
    [self.OKButton addTarget:self action:@selector(OKButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.OKButton setBackgroundColor:[UIColor grayColor]];
    [self.OKButton addTarget:self action:@selector(buttonDown:) forControlEvents:UIControlEventTouchDown];
    [self.OKButton addTarget:self action:@selector(buttonUp:) forControlEvents:UIControlEventTouchUpOutside];
    self.OKButton.layer.cornerRadius = 10;
    [self.view addSubview:self.OKButton];
    [self.view bringSubviewToFront:self.OKButton];
}

-(void) OKButtonPressed {
    [self.OKButton removeFromSuperview];
    [self.retryLabel removeFromSuperview];
    [self.background removeFromSuperview];
    [self.saveSuccessView removeFromSuperview];
}

-(void) goToHome {
    [self.navigationController popToRootViewControllerAnimated:FALSE];
}

-(void)backButtonPressed {
    [self.navigationController popViewControllerAnimated:FALSE];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
