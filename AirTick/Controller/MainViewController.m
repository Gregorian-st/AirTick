//
//  MainViewController.m
//  AirTick
//
//  Created by Grigory Stolyarov on 14.05.2021.
//

#import "MainViewController.h"
#import "TestViewController.h"
#import "PlaceViewController.h"
#import "TicketsViewController.h"

@interface MainViewController () <PlaceViewControllerDelegate>

@property (nonatomic, strong) UIView *placeContainerView;
@property (nonatomic, strong) UIButton *departureButton;
@property (nonatomic, strong) UIButton *arrivalButton;
@property (nonatomic) SearchRequest searchRequest;
@property (nonatomic, strong) UIButton *searchButton;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViewController];
    
    // Subscribe to notifications
    [[DataManager sharedInstance] loadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadDataComplete) name:kDataManagerLoadDataDidComplete object:nil];
}

- (void)setupViewController {
    CGFloat spacingY = 20.0;
    CGFloat spacingX = 20.0;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat nextY;
    
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    [self.navigationController.navigationBar setLargeTitleTextAttributes: @{NSForegroundColorAttributeName:[UIColor systemBlueColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:35.0]}];
    self.navigationItem.backButtonTitle = @"";
    self.title = @"Ticket Search";
    
    CGFloat topHeight = self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].windows.lastObject.windowScene.statusBarManager.statusBarFrame.size.height;
    
    _placeContainerView = [[UIView alloc] initWithFrame:CGRectMake(spacingX - 10, topHeight + spacingY / 2, screenWidth - (spacingX - 10) * 2, 160)];
    _placeContainerView.backgroundColor = [UIColor systemBackgroundColor];
    _placeContainerView.layer.shadowColor = [[[UIColor blackColor] colorWithAlphaComponent:0.2] CGColor];
    _placeContainerView.layer.shadowOffset = CGSizeZero;
    _placeContainerView.layer.shadowRadius = 10.0;
    _placeContainerView.layer.shadowOpacity = 0.8;
    _placeContainerView.layer.cornerRadius = 6.0;
    _placeContainerView.layer.borderWidth = 1;
    _placeContainerView.layer.borderColor = [[UIColor systemGray4Color] CGColor];
    nextY = topHeight + spacingY / 2 + _placeContainerView.frame.size.height;
    
    _departureButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_departureButton setTitle:@"Select Departure Point..." forState: UIControlStateNormal];
    _departureButton.tintColor = [UIColor blackColor];
    _departureButton.frame = CGRectMake(spacingX - 10, spacingY, screenWidth - spacingX * 2, 50.0);
    _departureButton.backgroundColor = [UIColor systemBlueColor];
    _departureButton.layer.cornerRadius = _departureButton.frame.size.height / 2;
    [_departureButton.layer masksToBounds];
    [_departureButton addTarget:self action:@selector(placeButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.placeContainerView addSubview:_departureButton];
    
    _arrivalButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_arrivalButton setTitle:@"Select Destination Point..." forState: UIControlStateNormal];
    _arrivalButton.tintColor = [UIColor blackColor];
    _arrivalButton.frame = CGRectMake(spacingX - 10, CGRectGetMaxY(_departureButton.frame) + spacingY, screenWidth - spacingX * 2, 50.0);
    _arrivalButton.backgroundColor = [UIColor systemBlueColor];
    _arrivalButton.layer.cornerRadius = _arrivalButton.frame.size.height / 2;
    [_arrivalButton.layer masksToBounds];
    [_arrivalButton addTarget:self action:@selector(placeButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.placeContainerView addSubview:_arrivalButton];
    [self.view addSubview:_placeContainerView];
    
    _searchButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_searchButton setTitle:@"SEARCH" forState: UIControlStateNormal];
    _searchButton.tintColor = [UIColor whiteColor];
    _searchButton.frame = CGRectMake(spacingX, CGRectGetMaxY(_placeContainerView.frame) + spacingY + 10, screenWidth - spacingX * 2, 50.0);
    _searchButton.backgroundColor = [UIColor systemGreenColor];
    _searchButton.layer.cornerRadius = _searchButton.frame.size.height / 2;
    [_searchButton.layer masksToBounds];
    [_searchButton addTarget:self action:@selector(searchButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_searchButton];
    
}

- (void)setupForTestViewController {
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    self.title = @"Main";
    
    // Create UIButton
    CGRect buttonTestVCFrame = CGRectMake(20, self.view.bounds.size.height - 80, self.view.bounds.size.width - 40, 40);
    UIButton *buttonTestVC = [UIButton buttonWithType:UIButtonTypeSystem];
    [buttonTestVC setTitle:@"Test ViewController" forState:UIControlStateNormal];
    buttonTestVC.frame = buttonTestVCFrame;
    buttonTestVC.backgroundColor = [UIColor systemBlueColor];
    buttonTestVC.tintColor = [UIColor whiteColor];
    buttonTestVC.layer.cornerRadius = buttonTestVCFrame.size.height / 2;
    [buttonTestVC.layer masksToBounds];
    [buttonTestVC addTarget:self action:@selector(buttonTestVCDidTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonTestVC];
}

- (void) buttonTestVCDidTapped:(UIButton *)sender {
    // Create test ViewController
    TestViewController *testViewController = [TestViewController new];
    [self.navigationController pushViewController:testViewController animated:YES];
}

- (void)placeButtonDidTap:(UIButton *)sender {
    PlaceViewController *placeViewController;
    if ([sender isEqual:_departureButton]) {
        placeViewController = [[PlaceViewController alloc] initWithType: PlaceTypeDeparture];
    } else {
        placeViewController = [[PlaceViewController alloc] initWithType: PlaceTypeArrival];
    }
    placeViewController.delegate = self;
    [self.navigationController pushViewController: placeViewController animated:YES];
}

- (void)searchButtonDidTap:(UIButton *)sender {
    [[APIManager sharedInstance] ticketsWithRequest:_searchRequest withCompletion:^(NSArray *tickets) {
        if (tickets.count > 0) {
            TicketsViewController *ticketsViewController = [[TicketsViewController alloc] initWithTickets:tickets];
            [self.navigationController showViewController:ticketsViewController sender:self];
        } else {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Sorry!" message:@"There are no results for this search" preferredStyle: UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Close" style:(UIAlertActionStyleDefault) handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];
}

- (void)dealloc {
    // Unsubscribe from notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDataManagerLoadDataDidComplete object:nil];
}

- (void)loadDataComplete {
    [[APIManager sharedInstance] cityForCurrentIP:^(City *city) {
        [self setPlace:city withDataType:DataSourceTypeCity andPlaceType:PlaceTypeDeparture forButton:self->_departureButton];
    }];
}

// MARK: - PlaceViewControllerDelegate
- (void)selectPlace:(id)place withType:(PlaceType)placeType andDataType:(DataSourceType)dataType {
    [self setPlace:place withDataType:dataType andPlaceType:placeType forButton: (placeType == PlaceTypeDeparture) ? _departureButton : _arrivalButton ];
}

- (void)setPlace:(id)place withDataType:(DataSourceType)dataType andPlaceType:(PlaceType)placeType forButton:(UIButton *)button {
    
    NSString *title;
    NSString *iata;
    
    if (dataType == DataSourceTypeCity) {
        City *city = (City *)place;
        title = city.name;
        iata = city.code;
    } else if (dataType == DataSourceTypeAirport) {
        Airport *airport = (Airport *)place;
        title = airport.name;
        iata = airport.cityCode;
    }
    
    NSMutableString *prefixText;
    if (placeType == PlaceTypeDeparture) {
        _searchRequest.origin = iata;
        prefixText = [NSMutableString stringWithString:@"From: "];
    } else {
        _searchRequest.destination = iata;
        prefixText = [NSMutableString stringWithString:@"To: "];
    }
    
    [button setTitle: [prefixText stringByAppendingString:title] forState: UIControlStateNormal];
    button.tintColor = [UIColor whiteColor];
}

@end
