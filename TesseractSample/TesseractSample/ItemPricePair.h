//
//  ItemPricePair.h
//  SelectItems
//
//  Created by Diego Canales on 11/27/13.
//  Copyright (c) 2013 Diego Canales. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ItemPricePair : NSObject

@property (strong, nonatomic) NSString *item_title;
@property (nonatomic) double price;

- (id) initWithTitleAndPrice: (NSString * )title withPrice:(double)price;

@end
