//
//  FavoriteTicketsViewController.h
//  AirTick
//
//  Created by Grigory Stolyarov on 06.06.2021.
//

#import "TicketTableViewCell.h"
#import "CoreDataService.h"

@interface FavoriteTicketsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

- (instancetype)initFavoriteTicketsController;

@end
