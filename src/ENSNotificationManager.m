//
//  ENSNotificationManager.m
//  
//
//  Created by Thijs Damen on 01-06-12.
//  Copyright (c) 2012 Egeniq. All rights reserved.
//

#import "ENSNotificationManager.h"
#import "ENSSubscription.h"
#import "AFNetworking.h"


static const NSTimeInterval kENSNotificationManagerTokenTimeout = 259200.0; // 3 days
static ENSNotificationManager *sharedInstance = nil;

@interface ENSNotificationManager ()

@property (nonatomic, strong) NSString *notificationToken;
@property (nonatomic, strong) NSString *deviceToken;
@property (nonatomic, strong) AFHTTPClient *client;

@end

@implementation ENSNotificationManager

#pragma mark -
#pragma mark Initialization

+ (ENSNotificationManager *)sharedInstance {
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [[ENSNotificationManager alloc] init];
        }
    }
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self.client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:self.apiURL]];
        [self.client registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [self.client setDefaultHeader:@"Accept" value:@"application/json"];
        self.client.parameterEncoding = AFFormURLParameterEncoding;
        [self.client.operationQueue setMaxConcurrentOperationCount:1];
    }
    
    return self;
}

#pragma mark -
#pragma mark Register Methods

- (void)registerDevice:(NSData *)deviceToken {
    [self registerDevice:deviceToken onComplete:nil onError:nil];
}

- (void)registerDevice:(NSData *)deviceToken onComplete:(void (^)(NSString *notificationToken))onComplete onError:(void (^)(NSString *errorCode, NSString *errorMessage))onError {
    if (!self.appId) {
        if (onError != nil) {
            onError(@"no_app_id", @"Missing app id.");
        }
        return;
    }
    
    NSString *escapedDeviceToken = [self hexStringFromDeviceToken:deviceToken];
	
    if ([self.deviceToken isEqualToString:escapedDeviceToken] && self.notificationToken != nil) {
        // Same device token as previous time and we already have a notification token,
        // stopping to reduce server load unless the notification token on file is too old
        if (self.updatedAt != nil && [[NSDate date] timeIntervalSinceDate:self.updatedAt] < kENSNotificationManagerTokenTimeout) {
            return;
        }
    } else {
        // Different device token (perhaps user synced preferences to another/new device)
        self.deviceToken = escapedDeviceToken;
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"appId"] = self.appId;
    params[@"deviceFamily"] = @"ios";
    params[@"deviceToken"] = self.deviceToken;
    
    NSString *location = @"subscribers";
	if (self.notificationToken != nil) {
        location = [NSString stringWithFormat:@"%@/%@", location, @";update"];
        params[@"notificationToken"] = self.notificationToken;
	}
    
    [self postToLocation:location params:params onComplete:^(NSDictionary *object) {
        self.updatedAt = [NSDate date];
        
        if (object != nil && [object valueForKey:@"notificationToken"] != nil) {
            self.notificationToken = [object valueForKey:@"notificationToken"];
        }
        
        if (onComplete != nil) {
            onComplete(self.notificationToken);
        }
    } onError:^(NSString *errorMessage, NSString *errorCode) {
        if (onError != nil) {
            onError(errorMessage, errorCode);            
        }
    }];
}

#pragma mark -
#pragma mark Unregister method

- (void)unregisterDeviceOnComplete:(void (^)())onComplete onError:(void (^)(NSString *errorCode, NSString *errorMessage))onError {
    if (!self.appId) {
        if (onError != nil) {
            onError(@"no_app_id", @"Missing app id.");
        }
        return;
    }
    if (!self.notificationToken) {
        if (onError != nil) {
            onError(@"no_notification_token", @"Missing notification token.");
        }
        return;
    }
    
    NSString *location = @"subscribers/;delete";
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"appId"] = self.appId;
    params[@"deviceFamily"] = @"ios";
    params[@"deviceToken"] = self.deviceToken;
    params[@"notificationToken"] = self.notificationToken;

    [self postToLocation:location params:params onComplete:^(NSDictionary *object) {
        self.deviceToken = nil;
        self.notificationToken = nil;
        onComplete();
    } onError:^(NSString *errorCode, NSString *errorMessage) {
        onError(errorCode, errorMessage);
    }];
}

#pragma mark -
#pragma mark Subscribe Methods

- (void)subscribeToChannel:(NSString *)channelIdentifier onComplete:(void (^)(NSString *subscriptionId))onComplete onError:(void (^)(NSString *errorCode, NSString *errorMessage))onError {
    [self subscribeToChannel:channelIdentifier startDate:nil endDate:nil startTime:nil endTime:nil startDayOfWeek:nil endDayOfWeek:nil onComplete:onComplete onError:onError];
}

- (void)subscribeToChannel:(NSString *)channelIdentifier startDate:(NSDate *)startDate endDate:(NSDate *)endDate onComplete:(void (^)(NSString *subscriptionId))onComplete onError:(void (^)(NSString *errorCode, NSString *errorMessage))onError {
    [self subscribeToChannel:channelIdentifier startDate:startDate endDate:endDate startTime:nil endTime:nil startDayOfWeek:nil endDayOfWeek:nil onComplete:onComplete onError:onError];    
}

- (void)subscribeToChannel:(NSString *)channelIdentifier startTime:(NSDate *)startTime endTime:(NSDate *)endTime onComplete:(void (^)(NSString *subscriptionId))onComplete onError:(void (^)(NSString *errorCode, NSString *errorMessage))onError {
    [self subscribeToChannel:channelIdentifier startDate:nil endDate:nil startTime:startTime endTime:endTime startDayOfWeek:nil endDayOfWeek:nil onComplete:onComplete onError:onError];
}

- (void)subscribeToChannel:(NSString *)channelIdentifier startDayOfWeek:(NSNumber *)startDayOfWeek endDayOfWeek:(NSNumber *)endDayOfWeek onComplete:(void (^)(NSString *subscriptionId))onComplete onError:(void (^)(NSString *errorCode, NSString *errorMessage))onError {
    [self subscribeToChannel:channelIdentifier startDate:nil endDate:nil startTime:nil endTime:nil startDayOfWeek:startDayOfWeek endDayOfWeek:endDayOfWeek onComplete:onComplete onError:onError];
}

- (void)subscribeToChannel:(NSString *)channelIdentifier startDate:(NSDate *)startDate endDate:(NSDate *)endDate startTime:(NSDate *)startTime endTime:(NSDate *)endTime startDayOfWeek:(NSNumber *)startDayOfWeek endDayOfWeek:(NSNumber *)endDayOfWeek onComplete:(void (^)(NSString *subscriptionId))onComplete onError:(void (^)(NSString *errorCode, NSString *errorMessage))onError {
    if (!self.appId) {
        if (onError != nil) {
            onError(@"no_app_id", @"Missing app id.");
        }
        return;
    }
    if (!self.notificationToken) {
        if (onError != nil) {
            onError(@"no_notification_token", @"Missing notification token.");
        }
        return;
    }
    
    NSDateFormatter *dateDateFormatter = [[NSDateFormatter alloc] init];
    [dateDateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDateFormatter *timeDateFormatter = [[NSDateFormatter alloc] init];
    [timeDateFormatter setDateFormat:@"HH:mm"];
    
    NSString *location = @"subscriptions";
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:10];
    params[@"appId"] = self.appId;
    params[@"notificationToken"] = self.notificationToken;
    params[@"channelId"] = channelIdentifier;
    if (startDate != nil) {
        params[@"dateStart"] = [dateDateFormatter stringFromDate:startDate];
    }
    if (endDate != nil) {
        params[@"dateEnd"] = [dateDateFormatter stringFromDate:endDate];
    }
    if (startTime != nil) {
        params[@"timeStart"] = [timeDateFormatter stringFromDate:startTime];
    }
    if (endTime != nil) {
        params[@"timeEnd"] = [timeDateFormatter stringFromDate:endTime];
    }
    if (startDayOfWeek != nil) {
        params[@"dowStart"] = [startDayOfWeek stringValue];
    }
    if (endDayOfWeek != nil) {
        params[@"dowEnd"] = [endDayOfWeek stringValue];
    }
    
    [self postToLocation:location params:params onComplete:^(NSDictionary *result) {
        onComplete(result[@"subscriptionId"]);
    } onError:^(NSString *errorCode, NSString *errorMessage) {
        onError(errorCode, errorMessage);
    }];
}

#pragma mark -
#pragma mark Subscription List Methods

- (void)subscriptionsWithOnComplete:(void (^)(NSArray *))onComplete onError:(void (^)(NSString *errorCode, NSString *errorMessage))onError {
    if (!self.appId) {
        if (onError != nil) {
            onError(@"no_app_id", @"Missing app id.");
        }
        return;
    }
    if (!self.notificationToken) {
        if (onError != nil) {
            onError(@"no_notification_token", @"Missing notification token.");
        }
        return;
    }
    
    NSString *location = [NSString stringWithFormat:@"subscriptions/%@/%@", [self URLEncodeString:self.appId encoding:NSUTF8StringEncoding], [self URLEncodeString:self.notificationToken encoding:NSUTF8StringEncoding]];
    NSDictionary *params = @{};
    [self loadArrayForLocation:location params:params onComplete:^(NSArray *list) {
        NSMutableArray *subscriptions = [[NSMutableArray alloc] init];
        for (NSDictionary *subscriptionDictionary in list) {
            ENSSubscription *subscription = [[ENSSubscription alloc] initWithDictionary:subscriptionDictionary];
            [subscriptions insertObject:subscription atIndex:[subscriptions count]];
        }
        onComplete(subscriptions);
    } onError:^(NSString *errorCode, NSString *errorMessage) {
        onError(errorCode, errorMessage);
    }];
}

- (void)subscriptionsForChannel:(NSString *)channelIdentifier onComplete:(void (^)(NSArray *))onComplete onError:(void (^)(NSString *errorCode, NSString *errorMessage))onError {
    if (!self.appId) {
        if (onError != nil) {
            onError(@"no_app_id", @"Missing app id.");
        }
        return;
    }
    if (!self.notificationToken) {
        if (onError != nil) {
            onError(@"no_notification_token", @"Missing notification token.");
        }
        return;
    }
    
    NSString *location = [NSString stringWithFormat:@"channels/%@", channelIdentifier];
    [self loadArrayForLocation:location params:nil onComplete:^(NSArray *list) {
        NSMutableArray *subscriptions = [[NSMutableArray alloc] init];
        for (NSDictionary *subscriptionDictionary in list) {
            ENSSubscription *subscription = [[ENSSubscription alloc] initWithDictionary:subscriptionDictionary];
            [subscriptions insertObject:subscription atIndex:[subscriptions count]];
        }
        onComplete(subscriptions);
    } onError:^(NSString *errorCode, NSString *errorMessage) {
        onError(errorCode, errorMessage);
    }];
}

#pragma mark -
#pragma mark Unsubscribe Methods

- (void)unsubscribe:(NSString *)subscriptionIdentifier onComplete:(void(^)())onComplete onError:(void (^)(NSString *errorCode, NSString *errorMessage))onError {
    if (!self.appId) {
        if (onError != nil) {
            onError(@"no_app_id", @"Missing app id.");
        }
        return;
    }
    if (!self.notificationToken) {
        if (onError != nil) {
            onError(@"no_notification_token", @"Missing notification token.");
        }
        return;
    }
    
    NSString *location = @"subscriptions/;delete";
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:3];
    params[@"appId"] = self.appId;
    params[@"notificationToken"] = self.notificationToken;
    params[@"subscriptionId"] = subscriptionIdentifier;

    [self postToLocation:location params:params onComplete:^(NSDictionary *object) {
        onComplete(YES);
    } onError:^(NSString *errorCode, NSString *errorMessage) {
        onError(errorCode, errorMessage);
    }];
}

- (void)unsubscribeFromChannel:(NSString *)channelIdentifier onComplete:(void(^)())onComplete onError:(void (^)(NSString *errorCode, NSString *errorMessage))onError {
    if (!self.appId) {
        if (onError != nil) {
            onError(@"no_app_id", @"Missing app id.");
        }
        return;
    }
    if (!self.notificationToken) {
        if (onError != nil) {
            onError(@"no_notification_token", @"Missing notification token.");
        }
        return;
    }
    
    NSString *location = @"subscriptions/;delete";
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:3];
    params[@"appId"] = self.appId;
    params[@"notificationToken"] = self.notificationToken;
    params[@"channelId"] = channelIdentifier;

    [self postToLocation:location params:params onComplete:^(NSDictionary *object) {
        onComplete(YES);
    } onError:^(NSString *errorCode, NSString *errorMessage) {
        onError(errorCode, errorMessage);
    }];
}

- (void)unsubscribeAllOnComplete:(void(^)())onComplete onError:(void (^)(NSString *errorCode, NSString *errorMessage))onError {
    if (!self.appId) {
        if (onError != nil) {
            onError(@"no_app_id", @"Missing app id.");
        }
        return;
    }
    if (!self.notificationToken) {
        if (onError != nil) {
            onError(@"no_notification_token", @"Missing notification token.");
        }
        return;
    }
    
    NSString *location = @"subscriptions/;delete";
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:2];
    params[@"appId"] = self.appId;
    params[@"notificationToken"] = self.notificationToken;

    [self postToLocation:location params:params onComplete:^(NSDictionary *object) {
        onComplete(YES);
    } onError:^(NSString *errorCode, NSString *errorMessage) {
        onError(errorCode, errorMessage);
    }];
}

#pragma mark -
#pragma mark Connection Methods

- (void)postToLocation:(NSString *)location params:(NSDictionary *)params onComplete:(void(^)(id result))onComplete onError:(void(^)(NSString *errorCode, NSString *errorMessage))onError {
    NSURLRequest *request = [self.client requestWithMethod:@"POST" path:location parameters:params];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id result) {
        onComplete(result);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id result) {
        if (result != nil) {
            onError(result[@"code"], result[@"message"]);
        } else {
            onError(@"unkown_error", [NSString stringWithFormat:@"An unkown error occured: %@", [error localizedDescription]]);
        }
    }];
    
    [self.client enqueueHTTPRequestOperation:operation];
}

- (void)loadArrayForLocation:(NSString *)location params:(NSDictionary *)params onComplete:(void(^)(NSArray *list))onComplete onError:(void(^)(NSString *errorCode, NSString *errorMessage))onError {
    NSURLRequest *request = [self.client requestWithMethod:@"GET" path:location parameters:params];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id result) {
        onComplete((NSArray *)result);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id result) {
        if (result != nil) {
            onError(result[@"code"], result[@"message"]);
        } else {
            onError(@"unkown_error", [NSString stringWithFormat:@"An unkown error occured: %@", [error localizedDescription]]);
        }
    }];
    
    [self.client enqueueHTTPRequestOperation:operation];
}

#pragma mark -
#pragma mark Getters and Setters

- (void)setNotificationToken:(NSString *)notificationToken {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setValue:notificationToken forKey:@"ENSNotificationToken"];
	[defaults synchronize];
}

- (NSString *)notificationToken {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	return [defaults stringForKey:@"ENSNotificationToken"];
}

- (void)setDeviceToken:(NSString *)deviceToken {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setValue:deviceToken forKey:@"ENSDeviceToken"];
	[defaults synchronize];
}

- (NSString *)deviceToken {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	return [defaults stringForKey:@"ENSDeviceToken"];
}

- (void)setUpdatedAt:(NSDate *)updatedAt {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:updatedAt forKey:@"ENSUpdatedAt"];
	[defaults synchronize];
}

- (NSDate *)updatedAt {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"ENSUpdatedAt"];
}

- (NSString *)apiURL {
    if ([[NSBundle mainBundle] objectForInfoDictionaryKey:@"ENSAPIURL"] != nil) {
        return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"ENSAPIURL"];
    } else {
        return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"ENSDeviceTokenExchangeURL"];
    }
}

- (NSString *)appId {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"ENSAppId"];
}

#pragma mark -
#pragma mark Convenience Methods

- (BOOL)deviceIsRegistered {
    return (self.notificationToken != nil && self.deviceToken != nil);
}

#pragma mark -
#pragma mark Conversion Methods

- (NSString *)hexStringFromDeviceToken:(NSData *)deviceToken {
    const unsigned char *bytes = (const unsigned char *)[deviceToken bytes];
    NSUInteger nbBytes =  [deviceToken length];
    
    NSUInteger strLen = 2 * nbBytes;
    
    NSMutableString *hex = [[NSMutableString alloc] initWithCapacity:strLen];
    
    for (NSUInteger i = 0; i < nbBytes; ) {
        [hex appendFormat:@"%02x", bytes[i]];
        ++i;
    }
    return hex;
}

- (NSString *)URLEncodeString:(NSString *)value encoding:(NSStringEncoding)encoding {
    return (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                        (__bridge CFStringRef)value,
                                                                        NULL,
                                                                        (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                        CFStringConvertNSStringEncodingToEncoding(encoding));
}

@end
