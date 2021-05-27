//
//  TicketTableViewCell.h
//  AirTick
//
//  Created by Grigory Stolyarov on 27.05.2021.
//

#import <UIKit/UIKit.h>
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"

@interface TicketTableViewCell : UITableViewCell

@property (nonatomic, strong) Ticket *ticket;

@end
