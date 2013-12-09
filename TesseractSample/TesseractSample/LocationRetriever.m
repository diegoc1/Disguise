/* Will Harvey */

#import "LocationRetriever.h"
#import "SingletonManager.h"

@implementation LocationRetriever

+(CGPoint) getLatitudeAndLongitude {
    SingletonManager *singleton = ((SingletonManager *)[SingletonManager sharedSingletonManager]);
    if (singleton.isTrackingLocation) {
        CLLocationManager *locationManager = singleton.locationManager;
        float latitude = locationManager.location.coordinate.latitude;
        float longitude = locationManager.location.coordinate.longitude;
        return CGPointMake(latitude, longitude);
    }
    return CGPointMake(0, 0);
}

@end
