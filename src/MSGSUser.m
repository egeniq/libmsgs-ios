//
//  MSGSUser.m
//  ENSSample
//
//  Created by Peter Verhage on 22-01-14.
//
//

#import "MSGSUser.h"

@implementation MSGSUser

- (instancetype)init {
    self = [super init];
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)keyedValues {
    self = [super init];
    if (self != nil) {
        self.token = keyedValues[@"token"] != [NSNull null] ? keyedValues[@"token"] : nil;
        self.externalUserId = keyedValues[@"externalUserId"] != [NSNull null] ? keyedValues[@"externalUserId"] : nil;
    }
    
    return self;
}

- (NSDictionary *)dictionary {
    NSDictionary *keyedValues = [self dictionaryWithValuesForKeys:@[@"token", @"externalUserId"]];
    return keyedValues;
}

@end
