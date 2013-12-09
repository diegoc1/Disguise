//
//  ItemTableViewCell.m
//  SelectItems
//
//  Created by Diego Canales on 11/27/13.
//  Copyright (c) 2013 Diego Canales. All rights reserved.
//

#import "ItemTableViewCell.h"

@interface ItemTableViewCell()
@property (strong, nonatomic) UIButton *deleteButton;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *listOfTableViewCellObjects;
@end

@implementation ItemTableViewCell

#define WIDTH_OF_TITLE 200
#define HEIGHT_OF_TITLE 20
#define WIDTH_OF_PRICE 100
#define HEIGHT_OF_PRICE 20


- (id) initWithStyleAndListAndTableView:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier list:(NSMutableArray *) list  tableView:(UITableView *) tableView {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    CGRect b = [self.contentView bounds];
    CGFloat width = b.size.width;
    self.tableView = tableView;
    self.listOfTableViewCellObjects = list;
    CGFloat height = b.size.height;
    self.deleteButtonShowing = FALSE;
    if (self) {
        // Initialization code
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(5, (height / 2) - (HEIGHT_OF_TITLE / 2), WIDTH_OF_TITLE, HEIGHT_OF_TITLE)];
        [self.contentView addSubview:self.title];
        
        self.price = [[UILabel alloc] initWithFrame:CGRectMake(width - (WIDTH_OF_PRICE / 2) - 25, (height / 2) - (HEIGHT_OF_PRICE / 2), WIDTH_OF_PRICE, HEIGHT_OF_PRICE)];
        [self.contentView addSubview:self.price];
        self.deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(b.origin.x + b.size.width, b.origin.y, b.size.height, b.size.height)];
        [self.deleteButton setTitle:@"Delete" forState:UIControlStateNormal];
        [self.deleteButton addTarget:self action:@selector(deleteButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self.deleteButton setBackgroundColor:[UIColor redColor]];
        self.deleteButton.titleLabel.font = [UIFont systemFontOfSize:11];
        [self.contentView addSubview:self.deleteButton];
        
        
    }
    return self;
}

- (void) deleteButtonPressed {
  //  self.tableView = (UITableView *)self.superview;
    NSIndexPath *indexPath = [(UITableView *)self.tableView indexPathForCell: self];
    NSArray *indeces = [[NSArray alloc] initWithObjects:indexPath, nil];
    [self.listOfTableViewCellObjects removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:indeces withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView reloadData];
}

-(void) showDeleteButton {
    CGRect b = [self.contentView bounds];

    if (!self.deleteButtonShowing) {


        CGRect b = [self.contentView bounds];
        CGRect frameForButton = CGRectMake(b.origin.x + b.size.width - b.size.height, b.origin.y, b.size.height, b.size.height);
        self.deleteButtonShowing = TRUE;
        [UIView beginAnimations:@"shrink_table" context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:.20];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [self.deleteButton setFrame:frameForButton];
        [self.price setFrame:CGRectMake(self.price.frame.origin.x - b.size.height, self.price.frame.origin.y, self.price.frame.size.width, self.price.frame.size.height)];
        [UIView commitAnimations];
    }

}

-(void) hideDeleteButton {
    self.deleteButtonShowing = FALSE;
        CGRect b = [self.contentView bounds];
        CGRect frameForButton = CGRectMake(b.origin.x + b.size.width, b.origin.y, b.size.height, b.size.height);
        
        [UIView beginAnimations:@"shrink_table" context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:.25];
        //  [UIView setAnimationDidStopSelector:@selector(addViewsBack)];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [self.deleteButton setFrame:frameForButton];
        [self.price setFrame:CGRectMake(self.price.frame.origin.x + b.size.height, self.price.frame.origin.y, self.price.frame.size.width, self.price.frame.size.height)];
        [UIView commitAnimations];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
