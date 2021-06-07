//
//  TicketTableViewCell.h
//  AirTick
//
//  Created by Grigory Stolyarov on 27.05.2021.
//

#import <UIKit/UIKit.h>
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"
#import "CoreDataService.h"

@interface TicketTableViewCell : UITableViewCell

@property (nonatomic, strong) Ticket *ticket;
@property (nonatomic, strong) FavoriteTicket *favoriteTicket;

@end
