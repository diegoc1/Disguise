/* Will Harvey */

#import "ReceiptLocationAnnotation.h"

@interface ReceiptLocationAnnotation()


@end


@implementation ReceiptLocationAnnotation

-(id) initWithTitle: (NSString *) title image: (UIImage *) image total: (float) total andCoordinate: (CLLocationCoordinate2D) coordinate {
    self = [super init];
    if (self) {
        self.image = image;
        self.title = title;
        self.coordinate = coordinate;
        self.total = total;
    }
    
    return self;
}

@end
