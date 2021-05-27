//
//  APIManager.h
//  AirTick
//
//  Created by Grigory Stolyarov on 27.05.2021.
//

#import <Foundation/Foundation.h>
#import "DataManager.h"
#import "Ticket.h"

@interface APIManager : NSObject

+ (instancetype)sharedInstance;
- (void)cityForCurrentIP:(void (^)(City *city))completion;
- (void)ticketsWithRequest:(SearchRequest)request withCompletion:(void (^)(NSArray *tickets))completion;

@end
