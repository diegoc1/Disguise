//
//  EditTableViewCellUIView.h
//  TesseractSample
//
//  Created by Diego Canales on 12/7/13.
//
//

#import <UIKit/UIKit.h>
@class ItemPricePair;
@interface EditTableViewCellUIView : UIView
- (id)initWithFrameAndSelector:(CGRect)frame withOnFinishedSelector:(SEL)selector withItemViewPair:(ItemPricePair *)pair;

@end
