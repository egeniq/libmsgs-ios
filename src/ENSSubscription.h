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
@property (nonatomic, strong) NSString *dateEnd;
@property (nonatomic, strong) NSString *dateStart;
@property (nonatomic, strong) NSString *timeEnd;
@property (nonatomic, strong) NSString *timeStart;
@property (nonatomic, strong) NSString *dayOfWeekEnd;
@property (nonatomic, strong) NSString *dayOfWeekStart;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
