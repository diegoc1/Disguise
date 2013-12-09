/* Will Harvey */

/* Button for pins on MKMapView */

#import <UIKit/UIKit.h>
#import "ReceiptLocationAnnotation.h"

@interface PinAnnotationButton : UIButton

@property (nonatomic, strong) ReceiptLocationAnnotation *annotation;

@end
