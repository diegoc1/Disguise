/* Will Harvey */

#import <Foundation/Foundation.h>

@class ReceiptModel;

@interface ReceiptGenerator : NSObject

+(ReceiptModel *) getReceiptForImage: (UIImage *) image;

@end
