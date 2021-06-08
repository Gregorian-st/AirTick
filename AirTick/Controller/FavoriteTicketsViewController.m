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
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UITextField *dateTextField;

@end

@implementation FavoriteTicketsViewController {
    BOOL sortByDate;
    BOOL sortAsc;
    TicketTableViewCell *notificationCell;
}

- (instancetype)initFavoriteTicketsController {
    self = [super init];
    if (self) {
        self.tickets = [NSArray new];
        self.ticketsFavorites = [NSArray new];
        self.ticketsFromMap = [NSArray new];
        sortByDate = YES;
        sortAsc = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushReceived) name:kNotificationCenterPushReceived object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushFromMapReceived) name:kNotificationCenterPushFromMapReceived object:nil];
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
    _sortDateButton = [[UIBarButtonItem alloc] initWithTitle:@"  Date" style:UIBarButtonItemStylePlain target:self action:@selector(sortDateButtonTapped:)];
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
    
    CGRect datePickerFrame = CGRectMake(0, self.view.bounds.size.height - 100, self.view.bounds.size.width, 100);
    _datePicker = [[UIDatePicker alloc] initWithFrame:datePickerFrame];
    _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    _datePicker.minimumDate = [NSDate date];
    
    _dateTextField = [UITextField new];
    _dateTextField.hidden = YES;
    _dateTextField.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight;
    _dateTextField.inputView = _datePicker;
    
    UIToolbar *keyboardToolbar = [[UIToolbar alloc] init];
    [keyboardToolbar sizeToFit];
    UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonTapped:)];
    UIBarButtonItem *cancelBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonTapped:)];
    keyboardToolbar.items = @[flexBarButton, doneBarButton, cancelBarButton];
    
    _dateTextField.inputAccessoryView = keyboardToolbar;
    [self.view addSubview:_dateTextField];
}

- (void)pushReceived {
    self.tabBarController.selectedIndex = 2;
    _segmentedControl.selectedSegmentIndex = 0;
}

- (void)pushFromMapReceived {
    self.tabBarController.selectedIndex = 2;
    _segmentedControl.selectedSegmentIndex = 1;
}

- (void) sortPriceButtonTapped:(UIBarButtonItem *)sender {
    if (!sortByDate) {
        sortAsc = !sortAsc;
    } else {
        sortByDate = NO;
    }
    [self changeSource];
}

- (void) sortDateButtonTapped:(UIBarButtonItem *)sender {
    if (sortByDate) {
        sortAsc = !sortAsc;
    } else {
        sortByDate = YES;
    }
    [self changeSource];
}

- (void)cancelButtonTapped:(UIBarButtonItem *)sender {
    notificationCell = nil;
    [self.view endEditing:YES];
}

- (void)doneButtonTapped:(UIBarButtonItem *)sender {
    if (_datePicker.date && notificationCell) {
        NSString *message = [NSString stringWithFormat:@"%@ - %@  %lld ₽", notificationCell.favoriteTicket.from, notificationCell.favoriteTicket.to, notificationCell.favoriteTicket.price];
        NSURL *imageURL;
        if (notificationCell.airlineLogoView.image) {
            NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingString:[NSString stringWithFormat:@"/%@.png", notificationCell.ticket.airline]];
            if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
                UIImage *logo = notificationCell.airlineLogoView.image;
                NSData *pngData = UIImagePNGRepresentation(logo);
                [pngData writeToFile:path atomically:YES];
            } imageURL = [NSURL fileURLWithPath:path];
        }
        Notification notification = NotificationMake(@"Ticket reminder", message, _datePicker.date, imageURL, notificationCell.favoriteTicket);
        [[NotificationCenter sharedInstance] sendNotification:notification];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Success" message:[NSString stringWithFormat:@"Notification will be sent - %@", _datePicker.date] preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        
        _datePicker.date = [NSDate date];
        notificationCell = nil;
        [self.view endEditing:YES];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
}

- (void)changeSource {
    _ticketsFavorites = [[CoreDataService sharedInstance] favoritesFromMap:NO sortedByDate:sortByDate sortedAsc:sortAsc];
    _ticketsFromMap = [[CoreDataService sharedInstance] favoritesFromMap:YES sortedByDate:sortByDate sortedAsc:sortAsc];
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
    
    cell.transform = CGAffineTransformMakeScale(0.4, 0.4);
    cell.priceLabel.alpha = 0;
    cell.placesLabel.alpha = 0;
    cell.dateLabel.alpha = 0;
    [UIView animateWithDuration:0.5 animations:^{
        cell.transform = CGAffineTransformIdentity;
        cell.priceLabel.alpha = 1;
        cell.placesLabel.alpha = 1;
        cell.dateLabel.alpha = 1;
    }];
    
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
    
    UIAlertAction *notificationAction = [UIAlertAction actionWithTitle:@"Add a reminder" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        self->notificationCell = [tableView cellForRowAtIndexPath:indexPath];
        [self->_dateTextField becomeFirstResponder];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:favoriteAction];
    [alertController addAction:notificationAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
