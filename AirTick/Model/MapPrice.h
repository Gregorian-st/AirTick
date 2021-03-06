//
//  MapPrice.h
//  AirTick
//
//  Created by Grigory Stolyarov on 28.05.2021.
//

#import <Foundation/Foundation.h>
#import "DataManager.h"

@interface MapPrice : NSObject

@property (strong, nonatomic) City *destination;
@property (strong, nonatomic) City *origin;
@property (strong, nonatomic) NSDate *departure;
@property (strong, nonatomic) NSDate *returnDate;
@property (strong, nonatomic) NSString *airline;
@property (strong, nonatomic) NSString *destinationCode;
@property (nonatomic) NSInteger numberOfChanges;
@property (nonatomic) NSInteger value;
@property (nonatomic) NSInteger distance;
@property (nonatomic) BOOL actual;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary withOrigin: (City *)origin;

@end
