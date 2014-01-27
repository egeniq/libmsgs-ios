//
//  MSGSSubscription.m
//  ENSSample
//
//  Created by Peter Verhage on 22-01-14.
//
//

#import "MSGSSubscription.h"

@implementation MSGSSubscription

- (instancetype)init {
    self = [super init];
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)keyedValues {
    self = [super init];
    if (self != nil) {
        if (keyedValues[@"channel"] != nil) {
            self.channel = [[MSGSChannel alloc] initWithDictionary:keyedValues[@"channel"]];
        }
    }
    
    return self;
}

@end
