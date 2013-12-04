//
//  SelectItemsViewController.h
//  SelectItems
//
//  Created by Diego Canales on 11/27/13.
//  Copyright (c) 2013 Diego Canales. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ReceiptModel;

@interface SelectItemsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

-(id) initWithReceiptModel: (ReceiptModel *) receiptModel andImage: (UIImage *) image;
- (id) initWithImage:(UIImage *)image;

@end
