//
//  SelectItemsViewController.m
//  SelectItems
//
//  Created by Diego Canales on 11/27/13.
//  Copyright (c) 2013 Diego Canales. All rights reserved.
//

#import "SelectItemsViewController.h"
#import "ItemTableViewCell.h"
#import "ItemPricePair.h"
#import "AddTipUIView.h"
#import "SaveReceiptViewController.h"
#import "AppDelegate.h"
#import "ReceiptModel.h"
#import "SpellChecker.h"
#import "EditTableViewCellUIView.h"
#import "ClusterDecisionTreeClassifier.h"

@interface SelectItemsViewController ()
@property (strong, nonatomic) UITableView *availableItemsTableView;
@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) UITableView *selectedItemsTableView;
@property (strong, nonatomic) UILabel *totalPriceView;
@property (strong, nonatomic) UILabel *selectedItemsLabel;
@property (strong, nonatomic) UILabel *availableItemsLabel;
@property (strong, nonatomic) UIButton *checkoutButton;
@property (strong, nonatomic) UIButton *addTipButton;
@property (strong, nonatomic) NSMutableArray *selectedItems;
@property (strong, nonatomic) ItemTableViewCell *currSelectedCell;
@property (nonatomic) int tableViewSelection;
@property (nonatomic) double totalAmount;
@property (strong, nonatomic) AddTipUIView *tipView;
@property (nonatomic) double tipPercentage;
@property (strong, nonatomic) UIView *darkener;
@property (nonatomic) CGRect originalFrameForSelectedTableView;
@property (nonatomic) CGRect originalFrameForTotalPriceView;
@property (strong, nonatomic) UIButton *backButton;
@property (nonatomic) BOOL allowChanges;
@property (strong, nonatomic) UIButton *saveReceiptButton;
@property (strong, nonatomic) UIImage *receiptImage;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *tipLabel;
@property (nonatomic) BOOL atLeastOneDeleteButtonShowing;
@property (strong, nonatomic) EditTableViewCellUIView *editView;

//@property (strong, nonatomic) UILabel *tipLabel;
@end

@implementation SelectItemsViewController

#define TABLE_X_OFFSET 5
#define TABLE_Y_OFFSET 4

#define ITEMS_X_OFFSET 5
#define ITEMS_Y_OFFSET 20

#define TOTAL_PRICE_WIDTH 130
#define TOTAL_PRICE_HEIGHT 40

#define BUTTON_WIDTH 100
#define BUTTON_HEIGHT 40

#define CHECKOUT_BUTTON_WIDTH 80
#define CHECKOUT_BUTTON_HEIGHT 40

#define ADD_TIP_BUTTON_WIDTH 80
#define ADD_TIP_BUTTON_HEIGHT 40

#define LABEL_WIDTH 200
#define LABEL_HEIGHT 20

#define TIP_VIEW_HEIGHT 300
#define TIP_VIEW_WIDTH 200

#define TIP_LABEL_WIDTH 100
#define TIP_LABEL_HEIGHT 30

#define SPACE_BETWEEN_TOTAL_AND_ITEMS 5
//This macro function came from :http://stackoverflow.com/questions/19405228/how-to-i-properly-set-uicolor-from-int
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

- (id) initWithImage:(UIImage *)image {
    self = [super init];
    if (self) {
        self.receiptImage = image;
    }
    return self;
}


-(id) initWithReceiptModel: (ReceiptModel *) receiptModel andImage: (UIImage *) image {
    self = [super init];
    if (self) {
        self.receiptImage = image;
        self.items = [[NSMutableArray alloc] init];
        
        //Create ItemPricePairs from the receiptModel and add them to an array that the tableviewe will use to display cells
        
        for (int i = 0; i < [receiptModel.itemsPurchased count]; i++) {
            
            NSString *itemString = receiptModel.itemsPurchased[i];
            float itemValue = [ClusterDecisionTreeClassifier getAmountFromString:itemString];
            
            NSString *itemValueString = [ClusterDecisionTreeClassifier getAmountStringFromString: itemString];
            
            itemString = [itemString stringByReplacingOccurrencesOfString: itemValueString withString: @""];
            [self.items addObject:[[ItemPricePair alloc] initWithTitleAndPrice: itemString withPrice: itemValue]];
            
        }
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width / 2) - LABEL_WIDTH / 2, 10, LABEL_WIDTH, LABEL_HEIGHT)];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.text = receiptModel.title;
        self.titleLabel.textColor = [UIColor blackColor];
        [self.view addSubview: self.titleLabel];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.tipPercentage = 0.0;
    
    CGRect mainScreenBounds = [[UIScreen mainScreen] bounds];
    CGFloat width = mainScreenBounds.size.width;
    CGFloat height = mainScreenBounds.size.height;
    self.allowChanges = TRUE;
    
    
    

    
    self.addTipButton = [[UIButton alloc] initWithFrame:CGRectMake(ITEMS_X_OFFSET, height - (2* ADD_TIP_BUTTON_HEIGHT +2*SPACE_BETWEEN_TOTAL_AND_ITEMS) - 10, ADD_TIP_BUTTON_WIDTH, ADD_TIP_BUTTON_HEIGHT)];
    [self.addTipButton setBackgroundColor:[UIColor grayColor]];
    self.addTipButton.layer.cornerRadius = 10;
    [self.addTipButton setTitle:@"Set Tip" forState:UIControlStateNormal];
    self.addTipButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.addTipButton addTarget:self action:@selector(addTipButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.addTipButton addTarget:self action:@selector(buttonDown:) forControlEvents:UIControlEventTouchDown];
    [self.addTipButton addTarget:self action:@selector(buttonUp:) forControlEvents:UIControlEventTouchUpOutside];
    [self.view addSubview: self.addTipButton];
    
    self.totalPriceView = [[UILabel alloc] initWithFrame:CGRectMake(width / 2- TOTAL_PRICE_WIDTH / 2, self.addTipButton.frame.origin.y, TOTAL_PRICE_WIDTH, TOTAL_PRICE_HEIGHT)];
    //[self.totalPriceView setBackgroundColor:UIColorFromRGB(0xBBBBBB)];
    [self.totalPriceView setText:@"Total: $0"];
    [self.totalPriceView setTextColor:[UIColor blackColor]];
    [self.totalPriceView setTextAlignment:NSTextAlignmentCenter];
 //   self.totalPriceView.layer.cornerRadius = 10;
    [self.view addSubview: self.totalPriceView];
    
    self.tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - TIP_LABEL_WIDTH / 2, self.totalPriceView.frame.origin.y - (TIP_LABEL_HEIGHT + 5), TIP_LABEL_WIDTH, TIP_LABEL_HEIGHT)];
    self.tipLabel.text = [NSString stringWithFormat:@"Tip: %.0f%%", self.tipPercentage];
    self.tipLabel.textColor = [UIColor blackColor];
    self.tipLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.tipLabel];
    
    self.checkoutButton = [[UIButton alloc] initWithFrame:CGRectMake(width - CHECKOUT_BUTTON_WIDTH - 10, self.totalPriceView.frame.origin.y, CHECKOUT_BUTTON_WIDTH, CHECKOUT_BUTTON_HEIGHT)];
    [self.checkoutButton setBackgroundColor:[UIColor grayColor]];
    self.checkoutButton.layer.cornerRadius = 10;
    [self.checkoutButton setTitle:@"Checkout" forState:UIControlStateNormal];
    self.checkoutButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.checkoutButton addTarget:self action:@selector(checkoutButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: self.checkoutButton];

    
    //    self.tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(width - BUTTON_WIDTH, height - (2* BUTTON_HEIGHT +2*SPACE_BETWEEN_TOTAL_AND_ITEMS), BUTTON_WIDTH, BUTTON_HEIGHT)];
    //    [self.tipLabel setBackgroundColor:[UIColor grayColor]];
    //    self.tipLabel.layer.cornerRadius = 10;
    //    [self.tipLabel setText:[NSString stringWithFormat:@"Tip %.1f", self.tipPercentage * 100]];
    //    [self.tipLabel setTextAlignment:NSTextAlignmentCenter]
    //    [self.view addSubview:self.tipLabel];
    
    
    self.selectedItems = [[NSMutableArray alloc] init];
    
    self.availableItemsLabel = [[UILabel alloc] initWithFrame:CGRectMake((width / 2) - (LABEL_WIDTH / 2), self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + 35, LABEL_WIDTH, LABEL_HEIGHT)];
    [self.availableItemsLabel setText:@"Available Items"];
    [self.availableItemsLabel setTextColor:[UIColor grayColor]];
    [self.availableItemsLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview :self.availableItemsLabel];
    
    self.availableItemsTableView = [[UITableView alloc] initWithFrame:CGRectMake(ITEMS_X_OFFSET, self.availableItemsLabel.frame.origin.y + self.availableItemsLabel.frame.size.height + 5, (width) - (ITEMS_X_OFFSET * 2), (height / 2.5) - (ITEMS_Y_OFFSET) - TOTAL_PRICE_HEIGHT - SPACE_BETWEEN_TOTAL_AND_ITEMS)];
    
    self.availableItemsTableView.dataSource = self;
    self.availableItemsTableView.delegate = self;
    self.availableItemsTableView.allowsSelection = YES;
    self.availableItemsTableView.layer.cornerRadius = 10;
    
    UISwipeGestureRecognizer *deleteItemSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(availableTableCellSwipedLeft:)];
    deleteItemSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    UISwipeGestureRecognizer *editItemSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(availableTableCellSwipedRight:)];
    editItemSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.availableItemsTableView addGestureRecognizer:deleteItemSwipeRecognizer];
    [self.availableItemsTableView addGestureRecognizer:editItemSwipeRecognizer];
    
    
    
    [self.availableItemsTableView setBackgroundColor:UIColorFromRGB(0xFFFFCCC)];
    self.availableItemsTableView.layer.borderWidth = 2.0f;
    self.availableItemsTableView.layer.borderColor = [UIColor blackColor].CGColor;
    
    [self.view addSubview: self.availableItemsTableView];
    
    
    
    self.selectedItemsLabel = [[UILabel alloc] initWithFrame:CGRectMake(width / 2 - LABEL_WIDTH / 2, self.availableItemsTableView.frame.origin.y + self.availableItemsTableView.frame.size.height + 5, LABEL_WIDTH, LABEL_HEIGHT)];
    [self.selectedItemsLabel setText:@"Items you have selected"];
    [self.selectedItemsLabel setTextColor:[UIColor grayColor]];
    [self.selectedItemsLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview: self.selectedItemsLabel];
    
    
    
    self.selectedItemsTableView = [[UITableView alloc] initWithFrame:CGRectMake(TABLE_X_OFFSET, self.selectedItemsLabel.frame.origin.y + self.selectedItemsLabel.frame.size.height + TABLE_Y_OFFSET  , width - (TABLE_X_OFFSET * 2), self.addTipButton.frame.origin.y - ((height / 2) + TABLE_Y_OFFSET) - 2 * SPACE_BETWEEN_TOTAL_AND_ITEMS)];
    self.selectedItemsTableView.delegate = self;
    self.selectedItemsTableView.dataSource = self;
    self.selectedItemsTableView.allowsSelection = YES;
    [self.selectedItemsTableView setBackgroundColor:UIColorFromRGB(0xFFFFCCC)];
    self.selectedItemsTableView.layer.cornerRadius = 10;
    //  [self.selectedItemsTableView setBackgroundColor:[UIColor grayColor]];
    self.selectedItemsTableView.layer.borderWidth = 2.0f;
    self.selectedItemsTableView.layer.borderColor = [UIColor blackColor].CGColor;
    UISwipeGestureRecognizer *deleteItemSwipeRecognizer2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(selectedTableCellSwipedLeft:)];
    deleteItemSwipeRecognizer2.direction = UISwipeGestureRecognizerDirectionLeft;
    UISwipeGestureRecognizer *editItemSwipeRecognizer2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(selectedTableCellSwipedRight:)];
    editItemSwipeRecognizer2.direction = UISwipeGestureRecognizerDirectionRight;
    [self.selectedItemsTableView addGestureRecognizer:deleteItemSwipeRecognizer2];
    [self.selectedItemsTableView addGestureRecognizer:editItemSwipeRecognizer2];
    
    [self.view addSubview: self.selectedItemsTableView];
    
    
    
    
    
	// Do any additional setup after loading the view, typically from a nib.
}

-(void) availableTableCellSwipedLeft:(UISwipeGestureRecognizer *)gesture {
        self.atLeastOneDeleteButtonShowing = TRUE;
        CGPoint location = [gesture locationInView:self.availableItemsTableView];
        NSIndexPath *indexPathForSwipedCell = [self.availableItemsTableView indexPathForRowAtPoint:location];
        ItemTableViewCell *swipedCell  = (ItemTableViewCell *)[self.availableItemsTableView cellForRowAtIndexPath:indexPathForSwipedCell];
    
        if (!swipedCell.title || !swipedCell.price) return;
    
        [swipedCell showDeleteButton];
}

-(void) availableTableCellSwipedRight:(UISwipeGestureRecognizer *)gesture {
    CGPoint location = [gesture locationInView:self.availableItemsTableView];
    NSIndexPath *indexPathForSwipedCell = [self.availableItemsTableView indexPathForRowAtPoint:location];
    ItemTableViewCell *swipedCell  = (ItemTableViewCell *)[self.availableItemsTableView cellForRowAtIndexPath:indexPathForSwipedCell];
    
    if (!swipedCell.title || !swipedCell.price) return;
    
    if (swipedCell.deleteButtonShowing) {
        [swipedCell hideDeleteButton];
    } else {
        CGRect mainScreenBounds = [[UIScreen mainScreen] bounds];
        CGFloat height = mainScreenBounds.size.height;
        self.darkener = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [self.darkener setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8]];
        [self.view addSubview:self.darkener];
        self.editView = [[EditTableViewCellUIView alloc] initWithFrameAndSelector:CGRectMake(10, height / 2 - TIP_VIEW_HEIGHT / 2, self.view.frame.size.width - 20, TIP_VIEW_HEIGHT) withOnFinishedSelector:@selector(doneEditingAvailable) withItemViewPair:(ItemPricePair *) [self.items objectAtIndex:indexPathForSwipedCell.row]];
        [self.view addSubview:self.editView];
        [self.editView setAlpha:0.0];
        [self.darkener setAlpha:0.0];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        [self.editView setAlpha:1.0];
        [self.darkener setAlpha:1.0];
        [UIView commitAnimations];

    }
}

-(void) selectedTableCellSwipedLeft:(UISwipeGestureRecognizer *)gesture {
        CGPoint location = [gesture locationInView:self.selectedItemsTableView];
        NSIndexPath *indexPathForSwipedCell = [self.selectedItemsTableView indexPathForRowAtPoint:location];
        ItemTableViewCell *swipedCell  = (ItemTableViewCell *)[self.selectedItemsTableView cellForRowAtIndexPath:indexPathForSwipedCell];
    
        if (!swipedCell.title || !swipedCell.price) return;
    
        [swipedCell showDeleteButton];
}

-(void) selectedTableCellSwipedRight:(UISwipeGestureRecognizer *)gesture {
    CGPoint location = [gesture locationInView:self.selectedItemsTableView];
    NSIndexPath *indexPathForSwipedCell = [self.selectedItemsTableView indexPathForRowAtPoint:location];
    ItemTableViewCell *swipedCell  = (ItemTableViewCell *)[self.selectedItemsTableView cellForRowAtIndexPath:indexPathForSwipedCell];
    
    if (!swipedCell.title || !swipedCell.price) return;
    
    if (swipedCell.deleteButtonShowing) {
        [swipedCell hideDeleteButton];
    } else {
        CGRect mainScreenBounds = [[UIScreen mainScreen] bounds];
        CGFloat height = mainScreenBounds.size.height;
        self.darkener = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [self.darkener setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8]];
        [self.view addSubview:self.darkener];
        self.editView = [[EditTableViewCellUIView alloc] initWithFrameAndSelector:CGRectMake(10, height / 2 - TIP_VIEW_HEIGHT / 2, self.view.frame.size.width - 20, TIP_VIEW_HEIGHT) withOnFinishedSelector:@selector(doneEditingSelected) withItemViewPair:(ItemPricePair *) [self.selectedItems objectAtIndex:indexPathForSwipedCell.row]];
        [self.view addSubview:self.editView];
        [self.editView setAlpha:0.0];
        [self.darkener setAlpha:0.0];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.25];
        [self.editView setAlpha:1.0];
        [self.darkener setAlpha:1.0];
        [UIView commitAnimations];
    }
}

- (void) doneEditingSelected {
    [self.editView removeFromSuperview];
    [self.darkener removeFromSuperview];
    [self.selectedItemsTableView reloadData];
    [self updateTotalPrice];
}

- (void) doneEditingAvailable {
    [self.editView removeFromSuperview];
    [self.darkener removeFromSuperview];
    [self.availableItemsTableView reloadData];
}


//When the user presses back, remove necessary buttons
-(void)removeButtonsAfterFade {
    [self.backButton removeFromSuperview];
    [self.saveReceiptButton removeFromSuperview];
}


//Fades in the buttons on the main page and calls removeButtonsAfterFade to remove the save button adn back button
-(void) addViewsBack {
    [self.view addSubview:self.checkoutButton];
    [self.view addSubview:self.addTipButton];
    [self.view addSubview:self.tipLabel];
    [self.view addSubview:self.availableItemsTableView];
    [self.view addSubview:self.availableItemsLabel];
    [self.view addSubview:self.titleLabel];
    [self.checkoutButton setAlpha:0.0];
    [self.addTipButton setAlpha:0.0];
    [self.availableItemsTableView setAlpha:0.0];
    [self.availableItemsLabel setAlpha:0.0];
    [self.tipLabel setAlpha:0.0];
    [self.titleLabel setAlpha:0.0];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [self.checkoutButton setAlpha:1.0];
    [self.addTipButton setAlpha:1.0];
    [self.availableItemsTableView setAlpha:1.0];
    [self.availableItemsLabel setAlpha:1.0];
    [self.saveReceiptButton setAlpha:0.0];
    [self.tipLabel setAlpha:1.0];
    [self.titleLabel setAlpha:1.0];
    [self.backButton setAlpha:0.0];
    [UIView commitAnimations];
    [self removeButtonsAfterFade];
    
    
}

//When back button is pressed, do necessary animations and add necessary views back
-(void)backButtonPressed {
    [self.totalPriceView setFrame:self.originalFrameForTotalPriceView];
    [self.totalPriceView setAlpha:0.0];
    [UIView beginAnimations:@"shrink_table" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:.4];
    //  [UIView setAnimationDidStopSelector:@selector(addViewsBack)];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [self.selectedItemsTableView setFrame:self.originalFrameForSelectedTableView];
    
    [UIView commitAnimations];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [self.totalPriceView setAlpha:1.0];
    [UIView commitAnimations];
    [self addViewsBack];
    
    self.allowChanges = TRUE;
    
    
}

-(void) makeTotalFadeIn {
    [self.saveReceiptButton setAlpha:0.0];
    [self.backButton setAlpha:0.0];
    [self.totalPriceView setAlpha:0.0];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [self.totalPriceView setAlpha:1.0];
    [self.saveReceiptButton setAlpha:1.0];
    [self.backButton setAlpha:1.0];
    [UIView commitAnimations];
}

//Initalizes animations to display only selected items
-(void) checkoutButtonPressed {
    
    self.saveReceiptButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - (75), self.totalPriceView.frame.origin.y + self.totalPriceView.frame.size.height - 30, 150, 30)];
    [self.saveReceiptButton setBackgroundColor:[UIColor grayColor]];
    [self.saveReceiptButton addTarget:self action:@selector(saveReceiptButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.saveReceiptButton addTarget:self action:@selector(buttonDown:) forControlEvents:UIControlEventTouchDown];
    [self.saveReceiptButton addTarget:self action:@selector(buttonUp:) forControlEvents:UIControlEventTouchUpOutside];
    self.saveReceiptButton.layer.cornerRadius = 10;
    [self.saveReceiptButton setTitle:@"Save Receipt" forState:UIControlStateNormal];
    
    self.allowChanges = FALSE;
    [self.availableItemsLabel removeFromSuperview];
    [self.availableItemsTableView removeFromSuperview];
    self.originalFrameForSelectedTableView = self.selectedItemsTableView.frame;
    self.originalFrameForTotalPriceView = self.totalPriceView.frame;
    self.backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 30, 70, 30)];
    [self.backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.backButton addTarget:self action:@selector(buttonDown:) forControlEvents:UIControlEventTouchDown];
    [self.backButton addTarget:self action:@selector(buttonUp:) forControlEvents:UIControlEventTouchUpOutside];
    [self.backButton setBackgroundColor:[UIColor grayColor]];
    self.backButton.layer.cornerRadius = 10;
    [self.backButton setTitle:@"Back" forState:UIControlStateNormal];
    [self.view addSubview:self.backButton];
    
    [self.totalPriceView setFrame:CGRectMake(self.view.frame.size.width / 2 - self.totalPriceView.frame.size.width / 2, self.saveReceiptButton.frame.origin.y - self.saveReceiptButton.frame.size.height - 15, self.totalPriceView.frame.size.width, self.totalPriceView.frame.size.height)];
    
    [UIView beginAnimations:@"expand_table" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:.4];
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [self.selectedItemsTableView setFrame:CGRectMake(ITEMS_X_OFFSET, self.backButton.frame.origin.y + self.backButton.frame.size.height + 10, self.selectedItemsTableView.frame.size.width, self.totalPriceView.frame.origin.y - (self.backButton.frame.origin.y + self.backButton.frame.size.height + 20))];
    
    
    [UIView commitAnimations];
    
    
    
    [self.checkoutButton removeFromSuperview];
    [self.addTipButton removeFromSuperview];
    [self.tipLabel removeFromSuperview];
    [self.titleLabel removeFromSuperview];
    [self.view addSubview:self.saveReceiptButton];
    [self makeTotalFadeIn];
    
}

-(void) saveReceiptButtonPressed {
    [self.saveReceiptButton setBackgroundColor:[UIColor grayColor]];
    SaveReceiptViewController *vc = [[SaveReceiptViewController alloc] initWithTotal:self.totalAmount andImage:self.receiptImage andTitle:self.titleLabel.text];
    [self.navigationController pushViewController:vc animated:FALSE];
    
}

-(void) addTipButtonPressed {
    [self.addTipButton setBackgroundColor:[UIColor grayColor]];
    self.darkener = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.darkener setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8]];
    [self.view addSubview:self.darkener];
    CGRect mainScreenBounds = [[UIScreen mainScreen] bounds];
    CGFloat height = mainScreenBounds.size.height;
    self.tipView = [[AddTipUIView alloc] initWithFrameAndSelector:CGRectMake(10, height / 2 - TIP_VIEW_HEIGHT / 2, self.view.frame.size.width - 20, TIP_VIEW_HEIGHT) withOnFinishedSelector:@selector(gotTipFromView)];
//    self.darkener = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    [self.darkener setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8]];
//    [self.view addSubview:self.darkener];
    //[v setBackgroundColor:[UIColor yellowColor]];
    [self.view addSubview:self.tipView];
}


-(void) gotTipFromView {
    self.tipPercentage = self.tipView.tipAmount;
    int tipPercentageForLabel = self.tipPercentage * 100;
    self.tipLabel.text = [NSString stringWithFormat:@"Tip: %d%%", tipPercentageForLabel];
    [self.darkener removeFromSuperview];
    [self updateTotalPrice];
    [self.tipView removeFromSuperview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.availableItemsTableView) return [self.items count];
    return [self.selectedItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //Have to create a unique cell identifier for each cell.  Otherwise, cells get reused, which means that a delete button will appear multiple times in the table
    ItemPricePair *curr_object;
    if (tableView == self.selectedItemsTableView) {
        curr_object = [self.selectedItems objectAtIndex:indexPath.row];
        
        
    } else {
        curr_object = [self.items objectAtIndex:indexPath.row];
    }
    NSString *CellIdentifier = [NSString stringWithFormat:@"CELL %@ %.2f", curr_object.item_title, curr_object.price];
    
    ItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSMutableArray *listOfItemPairs = self.items;
    if (tableView == self.selectedItemsTableView) listOfItemPairs = self.selectedItems;
    if (cell == nil) {
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
      //  cell = [[ItemTableViewCell alloc] initWithStyleAndTableView:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier tableView:tableView];
        
        cell = [[ItemTableViewCell alloc] initWithStyleAndListAndTableView:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier list:listOfItemPairs tableView:tableView];
    }
    
    // Configure the cell...
    //  cell.textLabel.text = [self.items objectAtIndex:indexPath.row];

    [cell.title setText:curr_object.item_title];
    [cell.price setText:[NSString stringWithFormat:@"$%.2f", curr_object.price]];
    [cell setBackgroundColor:[UIColor clearColor]];
    
    return cell;
    
}

- (void) finishedSlideOutAnimations {
    //    NSIndexPath *indexPath0 = [NSIndexPath indexPathForRow:0 inSection:0];
    //    NSArray *k = @[indexPath0];
    //    [self.selectedItemsTableView insertRowsAtIndexPaths:k withRowAnimation:UITableViewRowAnimationLeft];
    
    [self.selectedItemsTableView reloadData];
    [self.availableItemsTableView reloadData];
    
    [self.selectedItemsTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    
    [self.availableItemsTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    
    NSIndexPath* p;
    if (self.tableViewSelection == 0) {
        p = [NSIndexPath indexPathForRow:[self.selectedItems count] - 1 inSection:0];
        [self.selectedItemsTableView scrollToRowAtIndexPath:p atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
    else {
        p = [NSIndexPath indexPathForRow:[self.items count] - 1 inSection:0];
        [self.availableItemsTableView scrollToRowAtIndexPath:p atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
    [self updateTotalPrice];
    [self performSlideInAnimation];
    [self performSelector:@selector(performHighlightCellAnimation:) withObject:[NSNumber numberWithInt:0] afterDelay:0.3];
}

//Create an animation where the cell moves from left to right
-(void)performSlideInAnimation {
    NSIndexPath* p;
    ItemTableViewCell *addedCell;
    if (self.tableViewSelection == 0) {
        p = [NSIndexPath indexPathForRow:[self.selectedItems count] - 1 inSection:0];
        addedCell = (ItemTableViewCell *)[self.selectedItemsTableView cellForRowAtIndexPath:p];
    }
    else {
        p = [NSIndexPath indexPathForRow:[self.items count] - 1 inSection:0];
        addedCell = (ItemTableViewCell *)[self.availableItemsTableView cellForRowAtIndexPath:p];
    }
    CGRect originalFrame = addedCell.frame;
    [addedCell setFrame:CGRectMake(originalFrame.origin.x - 400, originalFrame.origin.y, originalFrame.size.width, originalFrame.size.height)];
    [UIView beginAnimations:@"button_in" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:.4];
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [addedCell setFrame:originalFrame];
    
    [UIView commitAnimations];
    
    
    
}


//"Recursive" animation that highlights the cell 4 times
-(void) performHighlightCellAnimation:(NSNumber *)iteration {
    if ([iteration intValue] < 4) {
        NSNumber *next_iter = [NSNumber numberWithInt:[iteration intValue] + 1];
        NSIndexPath* p;
        ItemTableViewCell *addedCell;
        if (self.tableViewSelection == 0) {
            p = [NSIndexPath indexPathForRow:[self.selectedItems count] - 1 inSection:0];
            addedCell = (ItemTableViewCell *)[self.selectedItemsTableView cellForRowAtIndexPath:p];
        }
        else {
            p = [NSIndexPath indexPathForRow:[self.items count] - 1 inSection:0];
            addedCell = (ItemTableViewCell *)[self.availableItemsTableView cellForRowAtIndexPath:p];
        }
        if ([iteration intValue] % 2 == 0) {
            [addedCell setSelected:YES];
            [self performSelector:@selector(performHighlightCellAnimation:) withObject:next_iter afterDelay:0.2];
        }
        else {
            [addedCell setSelected:NO];
            [self performSelector:@selector(performHighlightCellAnimation:) withObject:next_iter afterDelay:0.1];
        }
        
    }
}



- (void) updateTotalPrice {
    double total = 0;
    for (int i = 0; i < [self.selectedItems count];i++) {
        ItemPricePair *pair = [self.selectedItems objectAtIndex:i];
        total += pair.price;
    }
    self.totalAmount = total;
    self.totalAmount *= (1.0 + self.tipPercentage);
    [self.totalPriceView setText:[NSString stringWithFormat:@"Total: $%.2f", self.totalAmount]];
}

-(void)buttonDown: (UIButton *) sender {
    [sender setBackgroundColor:UIColorFromRGB(0x333333)];
}

-(void)buttonUp: (UIButton *) sender {
    [sender setBackgroundColor:[UIColor grayColor]];
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.allowChanges) return;
    NSMutableArray *deleteArr;
    NSMutableArray *addArr;
    NSString *obj;
    ItemTableViewCell *cell = (ItemTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (cell.deleteButtonShowing) {
        cell.highlighted = FALSE;
        return;
    }
    self.currSelectedCell = cell;
    CGRect animFrame;
    if (tableView == self.availableItemsTableView) {
        deleteArr = self.items;
        addArr = self.selectedItems;
        obj = [self.items objectAtIndex:indexPath.row];
        animFrame = CGRectMake(cell.frame.origin.x, 0, cell.frame.size.width, cell.frame.size.height);
        self.tableViewSelection = 0;
    } else {
        deleteArr = self.selectedItems;
        addArr = self.items;
        obj = [self.selectedItems objectAtIndex:indexPath.row];
        animFrame = CGRectMake(cell.frame.origin.x, self.selectedItemsTableView.frame.origin.y + self.selectedItemsTableView.frame.size.height, cell.frame.size.width, cell.frame.size.height);
        self.tableViewSelection = 1;
    }
    animFrame =CGRectMake(cell.frame.origin.x - 400, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
    
    [deleteArr removeObject:obj];
    [addArr addObject:obj];
    [self.view bringSubviewToFront:cell];
    [UIView beginAnimations:@"button_in" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(finishedSlideOutAnimations)];
    [UIView setAnimationDuration:.4];
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [cell setFrame:animFrame];
    
    [UIView commitAnimations];
    
    
}


@end
