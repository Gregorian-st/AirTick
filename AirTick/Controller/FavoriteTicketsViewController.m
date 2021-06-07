//
//  FavoriteTicketsViewController.m
//  AirTick
//
//  Created by Grigory Stolyarov on 06.06.2021.
//

#import "FavoriteTicketsViewController.h"

#define TicketCellReuseIdentifier @"FavoriteTicketCellIdentifier"

@interface FavoriteTicketsViewController () 

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) UIBarButtonItem *sortPriceButton;
@property (nonatomic, strong) UIBarButtonItem *sortDateButton;
@property (nonatomic, strong) NSArray *tickets;
@property (nonatomic, strong) NSArray *ticketsFavorites;
@property (nonatomic, strong) NSArray *ticketsFromMap;
@property (nonatomic) BOOL sortByDate;
@property (nonatomic) BOOL sortAsc;

@end

@implementation FavoriteTicketsViewController

- (instancetype)initFavoriteTicketsController {
    self = [super init];
    if (self) {
        self.tickets = [NSArray new];
        self.ticketsFavorites = [NSArray new];
        self.ticketsFromMap = [NSArray new];
        self.sortByDate = YES;
        self.sortAsc = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViewController];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self changeSource];
}

- (void)setupViewController {
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    [self.navigationController.navigationBar setLargeTitleTextAttributes: @{NSForegroundColorAttributeName:[UIColor systemBlueColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:35.0]}];
    self.title = @"Favorites";
    
    _sortPriceButton = [[UIBarButtonItem alloc] initWithTitle:@"Price" style:UIBarButtonItemStylePlain target:self action:@selector(sortPriceButtonTapped:)];
    _sortDateButton = [[UIBarButtonItem alloc] initWithTitle:@"   Date" style:UIBarButtonItemStylePlain target:self action:@selector(sortDateButtonTapped:)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects: _sortPriceButton, _sortDateButton, nil];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.tableView registerClass:[TicketTableViewCell class] forCellReuseIdentifier:TicketCellReuseIdentifier];
    [self.view addSubview:_tableView];
    
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Search", @"Map"]];
    [_segmentedControl addTarget:self action:@selector(changeSource) forControlEvents:UIControlEventValueChanged];
    _segmentedControl.tintColor = [UIColor systemBlueColor];
    self.navigationItem.titleView = _segmentedControl;
    _segmentedControl.selectedSegmentIndex = 0;
}

- (void) sortPriceButtonTapped:(UIBarButtonItem *)sender {
    if (!self.sortByDate) {
        self.sortAsc = !self.sortAsc;
    } else {
        self.sortByDate = NO;
    }
    [self changeSource];
}

- (void) sortDateButtonTapped:(UIBarButtonItem *)sender {
    if (self.sortByDate) {
        self.sortAsc = !self.sortAsc;
    } else {
        self.sortByDate = YES;
    }
    [self changeSource];
}

- (void)changeSource {
    _ticketsFavorites = [[CoreDataService sharedInstance] favoritesFromMap:NO sortedByDate:self.sortByDate sortedAsc:self.sortAsc];
    _ticketsFromMap = [[CoreDataService sharedInstance] favoritesFromMap:YES sortedByDate:self.sortByDate sortedAsc:self.sortAsc];
    switch (_segmentedControl.selectedSegmentIndex) {
        case 0:
            _tickets = _ticketsFavorites;
            break;
        case 1:
            _tickets = _ticketsFromMap;
            break;
        default:
            break;
    }
    [self.tableView reloadData];
}

//MARK: - UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tickets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TicketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TicketCellReuseIdentifier forIndexPath:indexPath];
    cell.favoriteTicket = [_tickets objectAtIndex:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL fromMap = _segmentedControl.selectedSegmentIndex;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Ticket" message:@"Please select action:" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *favoriteAction;
    favoriteAction = [UIAlertAction actionWithTitle:@"Delete from Favorites" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [[CoreDataService sharedInstance] removeFromFavorite:[self->_tickets objectAtIndex:indexPath.row] fromMap:fromMap];
        [self changeSource];
        [self.tableView reloadData];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:favoriteAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
