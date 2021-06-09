//
//  LocationService.m
//  AirTick
//
//  Created by Grigory Stolyarov on 28.05.2021.
//

#import "LocationService.h"
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

@interface LocationService() <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;

@end

@implementation LocationService

- (instancetype)init {
    self = [super init];
    if (self) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        [_locationManager requestAlwaysAuthorization];
    }
    return self;
}

- (void)locationManagerDidChangeAuthorization:(CLLocationManager *)manager  {
    if (manager.authorizationStatus == kCLAuthorizationStatusAuthorizedAlways || manager.authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [_locationManager startUpdatingLocation];
    } else if (manager.authorizationStatus != kCLAuthorizationStatusNotDetermined) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedStringWithDefaultValue(@"Sorry!", @"LocationService", NSBundle.mainBundle, @"Sorry!", @"") message:NSLocalizedStringWithDefaultValue(@"The city of residence cannot be identified!", @"LocationService", NSBundle.mainBundle, @"The city of residence cannot be identified!", @"") preferredStyle: UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedStringWithDefaultValue(@"Close", @"LocationService", NSBundle.mainBundle, @"Close", @"") style:(UIAlertActionStyleDefault) handler:nil]];
        UIWindow * currentWindow = [[UIApplication sharedApplication] delegate].window;
        [currentWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    if (!_currentLocation) {
        _currentLocation = [locations firstObject];
        [_locationManager stopUpdatingLocation];
        [[NSNotificationCenter defaultCenter] postNotificationName:kLocationServiceDidUpdateCurrentLocation object:_currentLocation];
    }
}

@end
