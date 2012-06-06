//
//  Subscription.h
//  ENSSample
//
//  Created by Thijs Damen on 03-06-12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ENSSubscription : NSObject

@property (nonatomic, strong) NSString *channelId;
@property (nonatomic, strong) NSDate *dateEnd;
@property (nonatomic, strong) NSDate *dateStart;
@property (nonatomic, strong) NSDate *timeEnd;
@property (nonatomic, strong) NSDate *timeStart;
@property (nonatomic, strong) NSString *dayOfWeekEnd;
@property (nonatomic, strong) NSString *dayOfWeekStart;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
