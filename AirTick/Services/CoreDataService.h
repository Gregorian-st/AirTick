//
//  CoreDataService.h
//  AirTick
//
//  Created by Grigory Stolyarov on 06.06.2021.
//

#import <CoreData/CoreData.h>
#import "APIManager.h"
#import "FavoriteTicket+CoreDataClass.h"

@interface CoreDataService : NSObject

+ (instancetype)sharedInstance;

- (FavoriteTicket *)favoriteFromTicket:(Ticket *)ticket fromMap:(BOOL)fromMap;
- (BOOL)isFavorite:(Ticket *)ticket fromMap:(BOOL)fromMap;
- (void)addToFavorite:(Ticket *)ticket fromMap:(BOOL)flag;
- (void)removeFromFavorite:(Ticket *)ticket fromMap:(BOOL)fromMap;
- (NSArray *)favoritesFromMap:(BOOL)fromMap sortedByDate:(BOOL)sortedByDate sortedAsc:(BOOL)sortedAsc;

@end
