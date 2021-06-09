//
//  TicketsViewController.m
//  AirTick
//
//  Created by Grigory Stolyarov on 27.05.2021.
//

#import "TicketsViewController.h"

#define TicketCellReuseIdentifier @"TicketCellIdentifier"

@interface TicketsViewController ()

@property (nonatomic, strong) NSArray *tickets;

@end

@implementation TicketsViewController

- (instancetype)initWithTickets:(NSArray *)tickets {
    self = [super init];
    if (self) {
        _tickets = tickets;
        self.title = NSLocalizedStringWithDefaultValue(@"Tickets", @"TicketsViewController", NSBundle.mainBundle, @"Tickets", @"");
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView registerClass:[TicketTableViewCell class] forCellReuseIdentifier:TicketCellReuseIdentifier];
    }
    return self;
}

//MARK: - UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tickets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TicketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TicketCellReuseIdentifier forIndexPath:indexPath];
    cell.ticket = [_tickets objectAtIndex:indexPath.row];
    
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
    Ticket *ticket = [_tickets objectAtIndex:indexPath.row];
    BOOL isInFavorites = [[CoreDataService sharedInstance] isFavorite:ticket fromMap:NO];
    if (isInFavorites) {
        return;
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedStringWithDefaultValue(@"Ticket", @"TicketsViewController", NSBundle.mainBundle, @"Ticket", @"") message:NSLocalizedStringWithDefaultValue(@"Please select action:", @"TicketsViewController", NSBundle.mainBundle, @"Please select action:", @"") preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *favoriteAction;
    favoriteAction = [UIAlertAction actionWithTitle:NSLocalizedStringWithDefaultValue(@"Add to Favorites", @"TicketsViewController", NSBundle.mainBundle, @"Add to Favorites", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[CoreDataService sharedInstance] addToFavorite:ticket fromMap:NO];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedStringWithDefaultValue(@"Cancel", @"TicketsViewController", NSBundle.mainBundle, @"Cancel", @"") style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:favoriteAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
