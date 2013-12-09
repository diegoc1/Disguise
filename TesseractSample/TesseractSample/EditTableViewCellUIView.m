//
//  EditTableViewCellUIView.m
//  TesseractSample
//
//  Created by Diego Canales on 12/7/13.
//
//

#import "EditTableViewCellUIView.h"
#import "ItemPricePair.h"

@interface EditTableViewCellUIView ()

@property (strong, nonatomic) UITextField *editTitleField;
@property (strong, nonatomic) UITextField *editPriceField;
@property (strong, nonatomic) ItemPricePair *pair;
@end

@implementation EditTableViewCellUIView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
#define EXIT_WIDTH 20
#define EXIT_HEIGHT 20

#define DONE_WIDTH 70
#define DONE_HEIGHT 30

#define TEXT_FIELD_WIDTH 200
#define TEXT_FIELD_HEIGHT 30

#define CLICK_LABEL_WIDTH 250
#define CLICK_LABEL_HEIGHT 30

//This macro function came from :http://stackoverflow.com/questions/19405228/how-to-i-properly-set-uicolor-from-int
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

- (id)initWithFrameAndSelector:(CGRect)frame withOnFinishedSelector:(SEL)selector withItemViewPair:(ItemPricePair *)pair
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor clearColor]];
      //  self.layer.cornerRadius = 10;
        
        //    [exit addTarget:self action:@selector(exitButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *clickToEditLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width / 2 - CLICK_LABEL_WIDTH / 2, 10, CLICK_LABEL_WIDTH, CLICK_LABEL_HEIGHT)];
        clickToEditLabel.text = @"Click on field to start editing";
        clickToEditLabel.textColor = [UIColor whiteColor];
        clickToEditLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:clickToEditLabel];
        
        self.editTitleField = [[UITextField alloc] initWithFrame:CGRectMake(self.frame.size.width / 2 - TEXT_FIELD_WIDTH / 2, clickToEditLabel.frame.origin.y +clickToEditLabel.frame.size.height + 5, TEXT_FIELD_WIDTH, TEXT_FIELD_HEIGHT)];
        self.editTitleField.text = pair.item_title;
        self.editTitleField.textColor = [UIColor blackColor];
        self.editTitleField.backgroundColor = [UIColor whiteColor];
        self.editTitleField.layer.cornerRadius = 10;
        self.editTitleField.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.editTitleField];
        
        self.editPriceField = [[UITextField alloc] initWithFrame:CGRectMake(self.frame.size.width / 2 - TEXT_FIELD_WIDTH / 2, self.editTitleField.frame.origin.y + self.editTitleField.frame.size.height + 10, TEXT_FIELD_WIDTH, TEXT_FIELD_HEIGHT)];
        self.editPriceField.text = [NSString stringWithFormat:@"%.2f", pair.price];
        self.editPriceField.backgroundColor = [UIColor whiteColor];
        self.editPriceField.textColor = [UIColor blackColor];
        self.editPriceField.textAlignment = NSTextAlignmentCenter;
        self.editPriceField.layer.cornerRadius = 10;
        self.editPriceField.keyboardType = UIKeyboardTypeDecimalPad;
        [self addSubview:self.editPriceField];
        
        UIButton *done = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width / 2 - DONE_WIDTH / 2, self.editPriceField.frame.origin.y + self.editPriceField.frame.size.height + 10, DONE_WIDTH , DONE_HEIGHT)];
        [done setTitle:@"Done" forState:UIControlStateNormal];
        [done setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateNormal];
        [done setBackgroundColor:UIColorFromRGB(0xCCCCCC)];
        [done addTarget:self action:@selector(buttonDown:) forControlEvents:UIControlEventTouchDown];
        [done addTarget:self action:@selector(buttonUp:) forControlEvents:UIControlEventTouchUpInside];
        [done addTarget:self action:@selector(buttonUp:) forControlEvents:UIControlEventTouchUpOutside];
        done.layer.cornerRadius = 10;
        
        [self addSubview:done];
        //    self.layer.cornerRadius = 10;
        //    self.layer.borderWidth = 3.0f;
        //    self.layer.borderColor = [UIColor blackColor].CGColor;
        [done addTarget:self.superview action:selector forControlEvents:UIControlEventTouchUpInside];
        
        self.pair = pair;
        
        //[self removeFromSuperview];
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}

-(void)buttonDown: (UIButton *) sender {
    self.pair.item_title = self.editTitleField.text;
    self.pair.price = [self.editPriceField.text floatValue];
    [sender setBackgroundColor:UIColorFromRGB(0x333333)];
}

-(void)buttonUp: (UIButton *) sender {
    [sender setBackgroundColor:UIColorFromRGB(0xCCCCCC)];
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
