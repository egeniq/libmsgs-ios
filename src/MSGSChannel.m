//
//  MSGSChannel.m
//  ENSSample
//
//  Created by Peter Verhage on 22-01-14.
//
//

#import "MSGSChannel.h"
#import "MSGSUtil.h"

@implementation MSGSChannel

- (instancetype)init {
    self = [super init];
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)keyedValues {
    self = [super init];
    if (self != nil) {
        self.code = keyedValues[@"code"] != [NSNull null] ? keyedValues[@"code"] : nil;
        self.name = keyedValues[@"name"] != [NSNull null] ? keyedValues[@"name"] : nil;
        self.tags = keyedValues[@"tags"] != [NSNull null] ? keyedValues[@"tags"] : nil;
        self.data = keyedValues[@"data"] != [NSNull null] ? keyedValues[@"data"] : nil;
        self.createdAt = [MSGSUtil dateFromString:keyedValues[@"createdAt"] != [NSNull null] ? keyedValues[@"createdAt"] : nil];
        self.updatedAt = [MSGSUtil dateFromString:keyedValues[@"updatedAt"] != [NSNull null] ? keyedValues[@"updatedAt"] : nil];
        self.lastNotificationAt = [MSGSUtil dateFromString:keyedValues[@"lastNotificationAt"] != [NSNull null] ? keyedValues[@"lastNotificationAt"] : nil];
    }
    
    return self;
}


- (NSDictionary *)dictionary {
    NSDictionary *keyedValues = [self dictionaryWithValuesForKeys:@[@"code", @"name", @"tags", @"data"]];
    return keyedValues;
}


@end
