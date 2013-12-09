
#import "AppDelegate.h"

#import "CroppingImageCaptureViewController.h"
#import "SelectItemsViewController.h"
#import "HistoryViewController.h"
#import "SingletonManager.h"

#import "ReceiptMapViewController.h" //delete

@implementation AppDelegate

@synthesize window = _window;
@synthesize managedObjectContext;
@synthesize managedObjectModel;
@synthesize persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    CroppingImageCaptureViewController *imageVC = [[CroppingImageCaptureViewController alloc] init];
    
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController: imageVC];
    [navController setNavigationBarHidden:YES animated:NO];
    navController.tabBarItem.title = @"Capture";
    
    HistoryViewController *hc = [[HistoryViewController alloc] init];
    ReceiptMapViewController *mapVC = [[ReceiptMapViewController alloc] init];
    
    UINavigationController *hcNav = [[UINavigationController alloc] initWithRootViewController:hc];
    [hcNav setNavigationBarHidden:YES animated:NO];
    hcNav.tabBarItem.title = @"History";
    
    UINavigationController *mapNav = [[UINavigationController alloc] initWithRootViewController: mapVC];
    [mapNav setNavigationBarHidden:YES animated:NO];
    mapNav.tabBarItem.title = @"Map";
    
     NSArray* controllers = [NSArray arrayWithObjects:navController, hcNav, mapNav, nil];
    tabBarController.viewControllers = controllers;

    ((SingletonManager *)[SingletonManager sharedSingletonManager]).isTrackingLocation = TRUE;
    
    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}


/* Core Data work below is Diego's */

- (NSManagedObjectContext *) managedObjectContext {
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    
    return managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (managedObjectModel != nil) return managedObjectModel;
    managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    return managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
        if (persistentStoreCoordinator != nil) return persistentStoreCoordinator;
    for (int i = 0; i < 2; i++) {
        NSURL *url_for_sqlite_storage = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"<ReceiptManager>.sqlite"]];
        NSError *error = nil;
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                                 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
        persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        if(![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url_for_sqlite_storage options:options error:&error]) {
            NSLog(@"Unable to correctly add persistent store likely due to internal inconsistencies, resetting database");
            [[NSFileManager defaultManager] removeItemAtPath:url_for_sqlite_storage.path error:&error];
        } else {
            break;
        }
    }
    return persistentStoreCoordinator;
        
}

- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}



@end
