/* Will Harvey */

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface ReceiptLocationAnnotation : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) UIImage *image;
@property (nonatomic, assign) float total;
@property (nonatomic, copy) NSString *title;


-(id) initWithTitle: (NSString *) title image: (UIImage *) image total: (float) total andCoordinate: (CLLocationCoordinate2D) coordinate;

@end
