//
//  ItemPricePair.m
//  SelectItems
//
//  Created by Diego Canales on 11/27/13.
//  Copyright (c) 2013 Diego Canales. All rights reserved.
//

#import "ItemPricePair.h"

@implementation ItemPricePair

- (id) initWithTitleAndPrice: (NSString * )title withPrice:(double) price {
    self = [super init];
    if (self) {
        self.item_title = title;
        self.price = price;
        
    }
    return self;
}

@end
