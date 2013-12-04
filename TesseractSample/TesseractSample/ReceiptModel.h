
#import <Foundation/Foundation.h>

@interface ReceiptModel : NSObject {
    float totalAmount;
    float tipAmount;
    float taxAmount;
    NSString *title;
    NSMutableArray *itemsPurchased;
}

@property (nonatomic) float totalAmount;
@property (nonatomic) float tipAmount;
@property (nonatomic) float taxAmount;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSMutableArray *itemsPurchased;

@end
