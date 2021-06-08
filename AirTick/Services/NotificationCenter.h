//
//  NotificationCenter.h
//  AirTick
//
//  Created by Grigory Stolyarov on 07.06.2021.
//

#import <UserNotifications/UserNotifications.h>
#import "FavoriteTicket+CoreDataClass.h"

#define kNotificationCenterPushReceived @"NotificationCenterPushReceived"
#define kNotificationCenterPushFromMapReceived @"NotificationCenterPushFromMapReceived"

typedef struct Notification {
    __unsafe_unretained NSString *_Nullable title;
    __unsafe_unretained NSString *_Nonnull body;
    __unsafe_unretained NSDate *_Nonnull date;
    __unsafe_unretained NSURL *_Nullable imageURL;
    __unsafe_unretained FavoriteTicket *_Nullable ticket;
} Notification;

@interface NotificationCenter : NSObject

+ (instancetype _Nonnull)sharedInstance;

- (void)registerService;
- (void)sendNotification:(Notification)notification;

Notification NotificationMake(NSString *_Nullable title, NSString *_Nonnull body, NSDate *_Nonnull date, NSURL *_Nullable imageURL, FavoriteTicket *_Nullable ticket);

@end
