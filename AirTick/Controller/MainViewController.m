//
//  MainViewController.m
//  AirTick
//
//  Created by Grigory Stolyarov on 14.05.2021.
//

#import "MainViewController.h"
#import "TestViewController.h"
#import "DataManager.h"
#import "PlaceViewController.h"

@interface MainViewController ()

@property (nonatomic, strong) UIButton *departureButton;
@property (nonatomic, strong) UIButton *arrivalButton;
@property (nonatomic) SearchRequest searchRequest;

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
    
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    self.navigationItem.backButtonTitle = @"";
    self.title = @"Ticket Search";
    
    CGFloat topHeight = self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].windows.lastObject.windowScene.statusBarManager.statusBarFrame.size.height;
    
    _departureButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_departureButton setTitle:@"Select Departure Point..." forState: UIControlStateNormal];
    _departureButton.tintColor = [UIColor whiteColor];
    _departureButton.frame = CGRectMake(spacingX, topHeight + spacingY, [UIScreen mainScreen].bounds.size.width - spacingX * 2, 50.0);
    _departureButton.backgroundColor = [UIColor systemBlueColor];
    _departureButton.layer.cornerRadius = _departureButton.frame.size.height / 2;
    [_departureButton.layer masksToBounds];
    [_departureButton addTarget:self action:@selector(placeButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_departureButton];
    
    _arrivalButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_arrivalButton setTitle:@"Select Destination Point..." forState: UIControlStateNormal];
    _arrivalButton.tintColor = [UIColor whiteColor];
    _arrivalButton.frame = CGRectMake(spacingX, CGRectGetMaxY(_departureButton.frame) + spacingY, [UIScreen mainScreen].bounds.size.width - spacingX * 2, 50.0);
    _arrivalButton.backgroundColor = [UIColor systemBlueColor];
    _arrivalButton.layer.cornerRadius = _arrivalButton.frame.size.height / 2;
    [_arrivalButton.layer masksToBounds];
    [_arrivalButton addTarget:self action:@selector(placeButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_arrivalButton];
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

- (void)dealloc {
    // Unsubscribe from notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDataManagerLoadDataDidComplete object:nil];
}

- (void)loadDataComplete {
    NSLog(@"%@", NSStringFromSelector(_cmd));
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
        _searchRequest.destionation = iata;
        prefixText = [NSMutableString stringWithString:@"To: "];
    }
    
    [button setTitle: [prefixText stringByAppendingString:title] forState: UIControlStateNormal];
}

@end
