//
//  MSGSEndpoint.m
//  ENSSample
//
//  Created by Peter Verhage on 22-01-14.
//
//

#import "MSGSEndpoint.h"

@implementation MSGSEndpoint

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self.endpointSubscriptionsActive = @(YES);
        self.userSubscriptionsActive = @(YES);
    }
    
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)keyedValues {
    self = [super init];
    if (self != nil) {
        self.token = keyedValues[@"token"] != [NSNull null] ? keyedValues[@"token"] : nil;
        self.type = keyedValues[@"type"] != [NSNull null] ? keyedValues[@"type"] : nil;
        self.address = keyedValues[@"address"] != [NSNull null] ? keyedValues[@"address"] : nil;
        self.name = keyedValues[@"name"] != [NSNull null] ? keyedValues[@"name"] : nil;
        self.endpointSubscriptionsActive = keyedValues[@"endpointSubscriptionsActive"] != [NSNull null] ? keyedValues[@"endpointSubscriptionsActive"] : nil;
        self.userSubscriptionsActive = keyedValues[@"userSubscriptionsActive"] != [NSNull null] ? keyedValues[@"userSubscriptionsActive"] : nil;
        self.data = keyedValues[@"data"] != [NSNull null] ? keyedValues[@"data"] : nil;
    }
    
    return self;
}

- (NSDictionary *)dictionary {
    NSDictionary *keyedValues = [self dictionaryWithValuesForKeys:@[@"token", @"type", @"address", @"name", @"endpointSubscriptionsActive", @"userSubscriptionsActive", @"data"]];
    return keyedValues;
}

@end
