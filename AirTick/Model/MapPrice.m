//
//  MapPrice.m
//  AirTick
//
//  Created by Grigory Stolyarov on 28.05.2021.
//

#import "MapPrice.h"

@implementation MapPrice

- (instancetype)initWithDictionary:(NSDictionary *)dictionary withOrigin: (City *)origin {
    self = [super init];
    if (self) {
        _destination = [[DataManager sharedInstance] cityForIATA: [dictionary valueForKey:@"destination"]];
        _origin = origin;
        _departure = [self dateFromString:[dictionary valueForKey:@"depart_date"]];
        _returnDate = [self dateFromString:[dictionary valueForKey:@"return_date"]];
        _numberOfChanges = [[dictionary valueForKey:@"number_of_changes"] integerValue];
        _value = [[dictionary valueForKey:@"value"] integerValue];
        _distance = [[dictionary valueForKey:@"distance"] integerValue];
        _actual = [[dictionary valueForKey:@"actual"] boolValue];
        _airline = [dictionary valueForKey:@"airline"];
        _destinationCode = [dictionary valueForKey:@"destination"];
    }
    return self;
}

- (NSDate * _Nullable)dateFromString:(NSString *)dateString {
    if (!dateString) {
        return nil;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    return [dateFormatter dateFromString: dateString];
}

@end
