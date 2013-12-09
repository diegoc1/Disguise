/* Will Harvey */

#import "SingletonManager.h"

@implementation SingletonManager

@synthesize isTrackingLocation;

//Single implementation adapted from example online
+(id) sharedSingletonManager {
    
    static SingletonManager *singletonManager = nil;
    static dispatch_once_t onceT;
    dispatch_once(&onceT, ^{
        singletonManager = [[self alloc] init];
    });
    return singletonManager;
    
}

-(id) init {
    self = [super init];
    
    if (self) {
        
        //Start tracking location
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.distanceFilter = kCLDistanceFilterNone;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        [self.locationManager startUpdatingLocation];
        
    }
    return self;
}

@end
