//
//  ItemTableViewCell.m
//  SelectItems
//
//  Created by Diego Canales on 11/27/13.
//  Copyright (c) 2013 Diego Canales. All rights reserved.
//

#import "ItemTableViewCell.h"

@implementation ItemTableViewCell

#define WIDTH_OF_TITLE 100
#define HEIGHT_OF_TITLE 20
#define WIDTH_OF_PRICE 100
#define HEIGHT_OF_PRICE 20


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    CGRect b = [self.contentView bounds];
    CGFloat width = b.size.width;
    CGFloat height = b.size.height;
    if (self) {
        // Initialization code
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(5, (height / 2) - (HEIGHT_OF_TITLE / 2), WIDTH_OF_TITLE, HEIGHT_OF_TITLE)];
        [self.contentView addSubview:self.title];
        
        self.price = [[UILabel alloc] initWithFrame:CGRectMake(width - (WIDTH_OF_PRICE / 2) - 25, (height / 2) - (HEIGHT_OF_PRICE / 2), WIDTH_OF_PRICE, HEIGHT_OF_PRICE)];
        [self.contentView addSubview:self.price];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
