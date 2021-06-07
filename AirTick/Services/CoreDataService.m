//
//  CoreDataService.m
//  AirTick
//
//  Created by Grigory Stolyarov on 06.06.2021.
//

#import "CoreDataService.h"

@interface CoreDataService ()

@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;

@end

@implementation CoreDataService

+ (instancetype)sharedInstance {
    static CoreDataService *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CoreDataService alloc] init];
        [instance setup];
    });
    return instance;
}

- (void)setup {
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"AirTickModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    NSURL *docsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *storeURL = [docsURL URLByAppendingPathComponent:@"base.sqlite"];
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_managedObjectModel];
    NSPersistentStore* store = [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:nil];
    if (!store) {
        abort();
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    _managedObjectContext.persistentStoreCoordinator = _persistentStoreCoordinator;
}

- (void)save {
    NSError *error;
    [_managedObjectContext save: &error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
}

- (FavoriteTicket *)favoriteFromTicket:(Ticket *)ticket fromMap:(BOOL)fromMap {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"FavoriteTicket"];
    if (fromMap) {
        request.predicate = [NSPredicate predicateWithFormat:@"airline == %@ AND from == %@ AND to == %@ AND departure == %@ AND fromMap == %@", ticket.airline, ticket.from, ticket.to, ticket.departure, @YES];
    } else {
        request.predicate = [NSPredicate predicateWithFormat:@"airline == %@ AND from == %@ AND to == %@ AND departure == %@ AND expires == %@ AND fromMap == %@", ticket.airline, ticket.from, ticket.to, ticket.departure, ticket.expires, @NO];
    }
    return [[_managedObjectContext executeFetchRequest:request error:nil] firstObject];
}

- (BOOL)isFavorite:(Ticket *)ticket fromMap:(BOOL)fromMap {
    return [self favoriteFromTicket:ticket fromMap:fromMap] != nil;
}

- (void)addToFavorite:(Ticket *)ticket fromMap:(BOOL)flag {
    FavoriteTicket *favorite = [NSEntityDescription insertNewObjectForEntityForName:@"FavoriteTicket" inManagedObjectContext:_managedObjectContext];
    favorite.price = ticket.price.intValue;
    favorite.airline = ticket.airline;
    favorite.departure = ticket.departure;
    favorite.expires = ticket.expires;
    favorite.flightNumber = ticket.flightNumber.intValue;
    favorite.returnDate = ticket.returnDate;
    favorite.from = ticket.from;
    favorite.to = ticket.to;
    favorite.created = [NSDate date];
    favorite.fromMap = flag;
    [self save];
}

- (void)removeFromFavorite:(Ticket *)ticket fromMap:(BOOL)fromMap {
    FavoriteTicket *favorite = [self favoriteFromTicket:ticket fromMap:fromMap];
    if (favorite) {
        [_managedObjectContext deleteObject:favorite];
        [self save];
    }
}

- (NSArray *)favoritesFromMap:(BOOL)fromMap sortedByDate:(BOOL)sortedByDate sortedAsc:(BOOL)sortedAsc {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"FavoriteTicket"];
    if (fromMap) {
        request.predicate = [NSPredicate predicateWithFormat:@"fromMap == %@", @YES];
    } else {
        request.predicate = [NSPredicate predicateWithFormat:@"fromMap == %@", @NO];
    }
    if (sortedByDate) {
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"created" ascending:sortedAsc]];
    } else {
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"price" ascending:sortedAsc]];
    }
    return [_managedObjectContext executeFetchRequest:request error:nil];
}

@end
