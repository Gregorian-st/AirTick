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
        self.title = @"Tickets";
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
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Ticket" message:@"Please select action:" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *favoriteAction;
    favoriteAction = [UIAlertAction actionWithTitle:@"Add to Favorites" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[CoreDataService sharedInstance] addToFavorite:ticket fromMap:NO];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:favoriteAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
