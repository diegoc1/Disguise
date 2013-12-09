/* Will Harvey */

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface SingletonManager : NSObject {
    BOOL isTrackingLocation;
}

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic) BOOL isTrackingLocation;

+(id) sharedSingletonManager;

@end
