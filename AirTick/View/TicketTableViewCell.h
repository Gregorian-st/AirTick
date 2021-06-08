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
@property (nonatomic, strong) UIImageView *airlineLogoView;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *placesLabel;
@property (nonatomic, strong) UILabel *dateLabel;

@end
