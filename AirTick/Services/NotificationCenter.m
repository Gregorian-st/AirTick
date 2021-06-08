//
//  NotificationCenter.m
//  AirTick
//
//  Created by Grigory Stolyarov on 07.06.2021.
//

#import "NotificationCenter.h"

@interface NotificationCenter () <UNUserNotificationCenterDelegate>

@end

@implementation NotificationCenter

+ (instancetype)sharedInstance {
    static NotificationCenter *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NotificationCenter alloc] init];
    });
    return instance;
}

- (void)registerService {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (!error) {
            NSLog(@"Authorization request succeeded!");
        }
    }];
}

- (void)sendNotification:(Notification)notification {
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = notification.title;
    content.body = notification.body;
    content.sound = [UNNotificationSound defaultSound];
    
    NSDictionary * userInfo = [NSMutableDictionary dictionary];
    [userInfo setValue:notification.ticket.airline forKey:@"airline"];
    [userInfo setValue:notification.ticket.from forKey:@"from"];
    [userInfo setValue:notification.ticket.to forKey:@"to"];
    [userInfo setValue:notification.ticket.departure forKey:@"departure"];
    [userInfo setValue:@(notification.ticket.fromMap) forKey:@"fromMap"];
    content.userInfo = userInfo;
    
    if (notification.imageURL) {
        UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:@"image" URL:notification.imageURL options:nil error:nil];
        if (attachment) {
            content.attachments = @[attachment];
        }
    }
    
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar componentsInTimeZone:[NSTimeZone systemTimeZone] fromDate:notification.date];
    NSDateComponents *newComponents = [[NSDateComponents alloc] init];
    newComponents.calendar = calendar;
    newComponents.timeZone = [NSTimeZone defaultTimeZone];
    newComponents.month = components.month;
    newComponents.day = components.day;
    newComponents.hour = components.hour;
    newComponents.minute = components.minute;
    
    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:newComponents repeats:NO];
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"Notification" content:content trigger:trigger];
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center addNotificationRequest:request withCompletionHandler:nil];
}

Notification NotificationMake(NSString *_Nullable title, NSString *_Nonnull body, NSDate *_Nonnull date, NSURL *_Nullable imageURL, FavoriteTicket *_Nullable ticket) {
    Notification notification;
    notification.title = title;
    notification.body = body;
    notification.date = date;
    notification.imageURL = imageURL;
    notification.ticket = ticket;
    return notification;
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    BOOL fromMap = [[response.notification.request.content.userInfo valueForKey:@"fromMap"] boolValue];
    
    if (fromMap) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationCenterPushFromMapReceived object:nil];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationCenterPushReceived object:nil];
    }
}

@end
