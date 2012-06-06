//
//  Subscription.m
//  ENSSample
//
//  Created by Thijs Damen on 03-06-12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ENSSubscription.h"

@implementation ENSSubscription

@synthesize channelId = channelId_;
@synthesize dateEnd = dateEnd_;
@synthesize dateStart = dateStart_;
@synthesize timeEnd = timeEnd_;
@synthesize timeStart = timeStart_;
@synthesize dayOfWeekEnd = dayOfWeekEnd_;
@synthesize dayOfWeekStart = dayOfWeekStart_;

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        NSDateFormatter *dateDateFormatter = [[NSDateFormatter alloc] init];
        [dateDateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDateFormatter *timeDateFormatter = [[NSDateFormatter alloc] init];
        [timeDateFormatter setDateFormat:@"HH:mm"];
        
        self.channelId = ([dictionary valueForKey:@"channelId"] != [NSNull null]) ? [dictionary valueForKey:@"channelId"] : nil;
        self.dateStart = ([dictionary valueForKey:@"dateStart"] != [NSNull null]) ? [dateDateFormatter dateFromString:[dictionary valueForKey:@"dateStart"]] : nil;
        self.dateEnd = ([dictionary valueForKey:@"dateEnd"] != [NSNull null]) ? [dateDateFormatter dateFromString:[dictionary valueForKey:@"dateEnd"]] : nil;
        self.timeStart = ([dictionary valueForKey:@"timeStart"] != [NSNull null]) ? [timeDateFormatter dateFromString:[dictionary valueForKey:@"timeStart"]] : nil;
        self.timeEnd = ([dictionary valueForKey:@"timeEnd"] != [NSNull null]) ? [timeDateFormatter dateFromString:[dictionary valueForKey:@"timeEnd"]] : nil;
        self.dayOfWeekStart = ([dictionary valueForKey:@"dowStart"] != [NSNull null]) ? [dictionary valueForKey:@"dowStart"] : nil;
        self.dayOfWeekEnd = ([dictionary valueForKey:@"dowEnd"] != [NSNull null]) ? [dictionary valueForKey:@"dowEnd"] : nil;
    }
    return self;
}

@end
