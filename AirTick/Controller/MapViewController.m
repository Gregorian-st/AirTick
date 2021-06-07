//
//  MapViewController.m
//  AirTick
//
//  Created by Grigory Stolyarov on 28.05.2021.
//

#import "MapViewController.h"

@interface MapViewController () <MKMapViewDelegate>

@property (strong, nonatomic) MKMapView *mapView;
@property (nonatomic, strong) LocationService *locationService;
@property (nonatomic, strong) City *origin;
@property (nonatomic, strong) NSArray *prices;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViewController];
    
    [[DataManager sharedInstance] loadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadDataComplete) name:kDataManagerLoadDataDidComplete object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCurrentLocation:) name:kLocationServiceDidUpdateCurrentLocation object:nil];
    
}

- (void)setupViewController {
    _mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    _mapView.showsUserLocation = YES;
    _mapView.delegate = self;
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    [self.navigationController.navigationBar setLargeTitleTextAttributes: @{NSForegroundColorAttributeName:[UIColor systemBlueColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:35.0]}];
    self.title = @"Price Map";
    [self.view addSubview:_mapView];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadDataComplete {
    _locationService = [[LocationService alloc] init];
}

- (void)updateCurrentLocation:(NSNotification *)notification {
    CLLocation *currentLocation = notification.object;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(currentLocation.coordinate, 1000000, 1000000);
    [_mapView setRegion: region animated: YES];
    if (currentLocation) {
        _origin = [[DataManager sharedInstance] cityForLocation:currentLocation];
        if (_origin) {
            [[APIManager sharedInstance] mapPricesFor:_origin withCompletion:^(NSArray *prices) {
                self.prices = prices;
            }];
        }
    }
}

- (void)setPrices:(NSArray *)prices {
    _prices = prices;
    [_mapView removeAnnotations: _mapView.annotations];
    for (MapPrice *price in prices) {
        dispatch_async(dispatch_get_main_queue(), ^{
            MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
            annotation.title = [NSString stringWithFormat:@"%@ (%@)", price.destination.name, price.destination.code];
            annotation.subtitle = [NSString stringWithFormat:@"%ld ₽", (long)price.value];
            annotation.coordinate = price.destination.coordinate;
            [self->_mapView addAnnotation: annotation];
        });
    }
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    MKPointAnnotation *selectedAnnotation;
    selectedAnnotation = (MKPointAnnotation *)view.annotation;
    for (MapPrice *price in self.prices) {
        
        if (selectedAnnotation.coordinate.latitude == price.destination.coordinate.latitude && selectedAnnotation.coordinate.longitude == price.destination.coordinate.longitude) {
            
            Ticket *ticket = [Ticket new];
            ticket.departure = price.departure;
            ticket.airline = price.airline;
            ticket.from = price.origin.code;
            ticket.to = price.destinationCode;
            ticket.price = [NSNumber numberWithLong:price.value];
            
            BOOL isInFavorites = [[CoreDataService sharedInstance] isFavorite:ticket fromMap:YES];
            if (isInFavorites) {
                return;
            }
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Ticket" message:@"Please select action:" preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *favoriteAction;
            favoriteAction = [UIAlertAction actionWithTitle:@"Add to Favorites" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[CoreDataService sharedInstance] addToFavorite:ticket fromMap:YES];
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:favoriteAction];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        
    }
}

@end
