//
//  AddTipUIView.m
//  SelectItems
//
//  Created by Diego Canales on 11/27/13.
//  Copyright (c) 2013 Diego Canales. All rights reserved.
//

#import "AddTipUIView.h"

@interface AddTipUIView()
@property (strong, nonatomic) UIPickerView *picker;
@property (strong, nonatomic) NSMutableArray *tip_suggestions_strings;
@property (strong, nonatomic) NSMutableArray *tip_suggestions_values;
@end

@implementation AddTipUIView

#define EXIT_WIDTH 20
#define EXIT_HEIGHT 20

#define DONE_WIDTH 70
#define DONE_HEIGHT 40

//This macro function came from :http://stackoverflow.com/questions/19405228/how-to-i-properly-set-uicolor-from-int
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

- (id)initWithFrameAndSelector:(CGRect)frame withOnFinishedSelector:(SEL)selector
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor clearColor]];
        
        //    [exit addTarget:self action:@selector(exitButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *done = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width / 2 - DONE_WIDTH / 2, frame.size.height - DONE_HEIGHT - 5, DONE_WIDTH , DONE_HEIGHT)];
        [done setTitle:@"Done" forState:UIControlStateNormal];
        [done setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateNormal];
        [done setBackgroundColor:UIColorFromRGB(0xCCCCCC)];
        done.layer.cornerRadius = 10;
        
        [self addSubview:done];
        //    self.layer.cornerRadius = 10;
        //    self.layer.borderWidth = 3.0f;
        //    self.layer.borderColor = [UIColor blackColor].CGColor;
        [done addTarget:self.superview action:selector forControlEvents:UIControlEventTouchUpInside];
        [done addTarget:self action:@selector(buttonDown:) forControlEvents:UIControlEventTouchDown];
        [done addTarget:self action:@selector(buttonUp:) forControlEvents:UIControlEventTouchUpInside];
        [done addTarget:self action:@selector(buttonUp:) forControlEvents:UIControlEventTouchUpOutside];
        
        
        
        self.tipAmount = 0.0;
        //     self.picker = [[UIPickerView alloc] initWithFrame:CGRectMake(frame.size.width / 2 - frame.size.width / 4, frame.size.height / 2 - frame.size.height / 4, frame.size.width / 2, frame.size.height / 2)];
        self.picker = [[UIPickerView alloc] initWithFrame:CGRectMake(10, 0, frame.size.width - 20, frame.size.height)];
        self.picker.delegate = self;
        self.picker.dataSource = self;
        [self.picker setBackgroundColor:UIColorFromRGB(0xCCCCCC)];
    //    self.picker.layer.borderWidth = 3.0f;
     //   self.picker.layer.borderColor = [UIColor whiteColor].CGColor;
        self.picker.layer.cornerRadius = 10;
        
        [self addSubview:self.picker];
        
        self.tip_suggestions_strings = [[NSMutableArray alloc] init];
        [self.tip_suggestions_strings addObject:@"0 %"];
        [self.tip_suggestions_strings addObject:@"10 %"];
        [self.tip_suggestions_strings addObject:@"15 %"];
        [self.tip_suggestions_strings addObject:@"20 %"];
        [self.tip_suggestions_strings addObject:@"25 %"];
        self.tip_suggestions_values = [[NSMutableArray alloc] init];
        [self.tip_suggestions_values addObject:[NSNumber numberWithDouble:0.00]];
        [self.tip_suggestions_values addObject:[NSNumber numberWithDouble:0.10]];
        [self.tip_suggestions_values addObject:[NSNumber numberWithDouble:0.15]];
        [self.tip_suggestions_values addObject:[NSNumber numberWithDouble:0.20]];
        [self.tip_suggestions_values addObject:[NSNumber numberWithDouble:0.25]];
        
        
        
        
        //[self removeFromSuperview];
    }
    return self;
}


-(void)buttonDown: (UIButton *) sender {
    [sender setBackgroundColor:UIColorFromRGB(0x333333)];
}

-(void)buttonUp: (UIButton *) sender {
    [sender setBackgroundColor:UIColorFromRGB(0xCCCCCC)];
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.tip_suggestions_strings count];
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.tip_suggestions_strings objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    
    self.tipAmount = [[self.tip_suggestions_values objectAtIndex:row] doubleValue];
    NSLog(@"Suggestion %f", self.tipAmount);
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
