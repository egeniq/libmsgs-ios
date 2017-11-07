//
//  MSGSSubscription.m
//  ENSSample
//
//  Created by Peter Verhage on 22-01-14.
//
//

#import "MSGSSubscription.h"
#import "MSGSUtil.h"

@implementation MSGSSubscription

- (instancetype)init {
    self = [super init];
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)keyedValues {
    self = [super init];
    if (self != nil) {
        if (keyedValues[@"channel"] != nil && keyedValues[@"channel"] != [NSNull null]) {
            self.channel = [[MSGSChannel alloc] initWithDictionary:keyedValues[@"channel"]];
            self.createdAt = [MSGSUtil dateFromString:keyedValues[@"createdAt"] != [NSNull null] ? keyedValues[@"createdAt"] : nil];
            self.updatedAt = [MSGSUtil dateFromString:keyedValues[@"updatedAt"] != [NSNull null] ? keyedValues[@"updatedAt"] : nil];
        }
    }
    
    return self;
}


- (NSDictionary *)dictionary {
    NSDictionary *keyedValues = @{ @"channel": [self.channel dictionary] };
    return keyedValues;
}

@end
