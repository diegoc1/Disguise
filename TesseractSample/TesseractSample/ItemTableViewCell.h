//
//  ItemTableViewCell.h
//  TesseractSample
//
//  Created by Diego Canales on 11/28/13.
//
//

#import <UIKit/UIKit.h>

@interface ItemTableViewCell : UITableViewCell

@property (strong, nonatomic) UILabel *title;
@property (strong, nonatomic) UILabel *price;
@property (nonatomic) BOOL deleteButtonShowing;
-(void) showDeleteButton;
-(void) hideDeleteButton;

- (id) initWithStyleAndTableView:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier tableView:(UITableView *) tableView;
- (id) initWithStyleAndListAndTableView:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier list:(NSMutableArray *) list  tableView:(UITableView *) tableView;
@end
