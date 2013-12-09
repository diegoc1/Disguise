/* Will Harvey */

#import "ReceiptMapViewController.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "ReceiptLocationAnnotation.h"
#import "PinAnnotationButton.h"
#import "DisplayReceiptContentsViewController.h"


@interface ReceiptMapViewController ()
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (strong, nonatomic) NSArray *items;
@property (strong, nonatomic) ReceiptLocationAnnotation *lastAnnotation;

@end

@implementation ReceiptMapViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.mapView = [[MKMapView alloc] initWithFrame: self.view.frame];
    [self.mapView setDelegate: self];
    [self.mapView setShowsUserLocation: TRUE];
    [self.view addSubview: self.mapView];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    [self.locationManager startUpdatingLocation];
    
    [self populateReceipts];
}


-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    NSLog(@"didUpdateLocations");
    CLLocation *location = [locations lastObject];
    if (location) {
        MKCoordinateRegion coordRegion;
        coordRegion.center.latitude = location.coordinate.latitude;
        coordRegion.center.longitude = location.coordinate.longitude;
        coordRegion.span = MKCoordinateSpanMake(1.0, 1.0);
        coordRegion = [self.mapView regionThatFits: coordRegion];
        [self.mapView setRegion: coordRegion animated: TRUE];
        [self.locationManager stopUpdatingLocation];
    }
}

-(void) populateReceipts {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    NSError *error;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Receipt" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    self.items = fetchedObjects;
    for (NSManagedObject *info in fetchedObjects) {
        NSLog(@"Title: %@", [info valueForKey:@"title"]);
        NSLog(@"Latitude: %@", [info valueForKey:@"latitude"]);
        NSLog(@"Longitude: %@", [info valueForKey:@"longitude"]);
        NSLog(@"Total is: %@", [info valueForKey:@"individual_total"]);
        
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([[ info valueForKey:@"latitude"] floatValue], [[info valueForKey:@"longitude"] floatValue]);
        
        ReceiptLocationAnnotation *annotation = [[ReceiptLocationAnnotation alloc] initWithTitle: [info valueForKey:@"title"] image: [UIImage imageWithData:[info valueForKey:@"receipt_image"]] total: [[info valueForKey:@"individual_total"] doubleValue]  andCoordinate: coordinate];
        [self.mapView addAnnotation:annotation];
        
    }
    
    
}

-(void) mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    NSLog(@"here");
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id )annotation {
    
    MKAnnotationView *annotationView = nil;
    
    if ([annotation isKindOfClass: [ReceiptLocationAnnotation class]]) {
        ReceiptLocationAnnotation *receiptAnnotation = (ReceiptLocationAnnotation *) annotation;
        NSString* identifier = @"ReceiptPin";
        MKPinAnnotationView *annotationPinView = (MKPinAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier: identifier];
        
        
        if(!annotationPinView) {
            annotationPinView = [[MKPinAnnotationView alloc] initWithAnnotation: receiptAnnotation reuseIdentifier:identifier];
            
            UIButton *moreButton = [UIButton buttonWithType: UIButtonTypeInfoDark];
            moreButton.frame = CGRectMake(0, 0, 25, 25);
            annotationPinView.rightCalloutAccessoryView = moreButton;
            
            [annotationPinView setPinColor: MKPinAnnotationColorGreen];
            
        }
        
        annotationView = annotationPinView;
        
        
        
        
        [annotationView setEnabled:YES];
        [annotationView setCanShowCallout:YES];
    }
    
    return annotationView;
}

-(void) mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    ReceiptLocationAnnotation *annotation = (ReceiptLocationAnnotation *)view.annotation;
    DisplayReceiptContentsViewController *displayVC = [[DisplayReceiptContentsViewController alloc] initWithContents: annotation.title loc: @"..." total: annotation.total image: annotation.image];
    [self.navigationController pushViewController: displayVC animated: TRUE];
}


//-(void) moreButtonClicked: (PinAnnotationButton *) sender {
//    ReceiptLocationAnnotation *annotation = sender.annotation;
//    
//    DisplayReceiptContentsViewController *displayVC = [[DisplayReceiptContentsViewController alloc] initWithContents: annotation.title loc: @"..." total: annotation.total image: annotation.image];
//    [self.navigationController pushViewController: displayVC animated: TRUE];
//}


//- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
//    
//    if ([annotation isKindOfClass: [ReceiptLocationAnnotation class]]) {
//        MKAnnotationView *annotationView = (MKAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier: @"rec_location"];
//        
//        if (annotationView == nil) {
//            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier: @"rec_location"];
////            annotationView.enabled = YES;
////            annotationView.canShowCallout = YES;
////            
////            annotationView.image = [UIImage imageNamed:@"Default-568h.png"];
//            
//        } else {
//            annotationView.annotation = annotation; //upadte annotation
//        }
//        
//        return annotationView;
//    }
//    
//    return nil;
//}


@end
