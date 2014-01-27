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
        self.token = keyedValues[@"token"];
        self.type = keyedValues[@"type"];
        self.address = keyedValues[@"address"];
        self.name = keyedValues[@"name"];
        self.endpointSubscriptionsActive = keyedValues[@"endpointSubscriptionsActive"];
        self.userSubscriptionsActive = keyedValues[@"userSubscriptionsActive"];
        self.data = keyedValues[@"data"] == [NSNull null] ? nil : keyedValues[@"data"];
    }
    
    return self;
}

@end
