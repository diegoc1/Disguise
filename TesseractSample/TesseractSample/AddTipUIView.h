//
//  AddTipUIView.h
//  SelectItems
//
//  Created by Diego Canales on 11/27/13.
//  Copyright (c) 2013 Diego Canales. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddTipUIView : UIView <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic) double tipAmount;

- (id)initWithFrameAndSelector:(CGRect)frame withOnFinishedSelector:(SEL) selector;


@end
