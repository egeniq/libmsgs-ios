//
//  ENSNotificationManager.m
//  
//
//  Created by Thijs Damen on 01-06-12.
//  Copyright (c) 2012 Egeniq. All rights reserved.
//

#import "ENSNotificationManager.h"
#import "EFRequest.h"
#import "JSONKit.h"
#import "ENSSubscription.h"

static ENSNotificationManager *sharedInstance = nil;

@interface ENSNotificationManager ()

@property (nonatomic, strong) NSString *notificationToken;
@property (nonatomic, strong) NSString *deviceToken;
@property (nonatomic, strong, readonly) NSString *tokenExchangeURL;
@property (nonatomic, strong, readonly) NSString *appId;

- (NSString *)hexStringFromDeviceToken:(NSData *)deviceToken;
- (NSString *)URLEncodeString:(NSString *)value encoding:(NSStringEncoding)encoding;

- (void)setNotificationToken:(NSString *)notificationToken;
- (NSString *)notificationToken;

- (void)setDeviceToken:(NSString *)deviceToken;
- (NSString *)deviceToken;

- (NSString *)tokenExchangeURL;

- (void)postToLocation:(NSString *)location params:(NSDictionary *)params onComplete:(void(^)(NSDictionary *object))onComplete onError:(void(^)(NSString *errorCode, NSString *errorMessage))onError;
- (void)loadArrayForLocation:(NSString *)location params:(NSDictionary *)params onComplete:(void(^)(NSArray *list))onComplete onError:(void(^)(NSString *errorCode, NSString *errorMessage))onError;

@end

@implementation ENSNotificationManager

@synthesize notificationToken = notificationToken_;
@synthesize deviceToken = deviceToken_;
@synthesize tokenExchangeURL = tokenExchangeURL_;
@synthesize appId = appId_;

#pragma mark -
#pragma mark Register Methods
- (void)registerDevice:(NSData *)deviceToken {
    [self registerDevice:deviceToken onComplete:nil onError:nil];
}

- (void)registerDevice:(NSData *)deviceToken onComplete:(void (^)(NSString *notificationToken))onComplete onError:(void (^)(NSString *errorCode, NSString *errorMessage))onError {
    NSString *escapedDeviceToken = [self hexStringFromDeviceToken:deviceToken];
	NSString *escapedNotificationToken = [self.notificationToken stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
    if ([[self deviceToken] isEqualToString:escapedDeviceToken] && [[self notificationToken] isEqualToString:escapedNotificationToken]) {
        // The notification token we are about to send is the same as for the last successful attempt,
        // stopping to reduce server load
        return;
    } else if ([[self deviceToken] isEqualToString:escapedDeviceToken]) {
        // Same device token, but different notification token, tell server
    } else {
        // Different device token (perhaps user synced preferences to another/new device),
        // store new device token and
        // delete notification token as it must be invalid.
        [self setDeviceToken:escapedDeviceToken];
        [self setNotificationToken:nil];
    }
    
    NSString *location = @"subscribers";
	if (escapedNotificationToken != nil) {
        location = [NSString stringWithFormat:@"%@/%@", location, @";update"];
	}  
    
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:[self.appId dataUsingEncoding:NSUTF8StringEncoding], @"appId", 
                            [@"ios" dataUsingEncoding:NSUTF8StringEncoding], @"deviceFamily",
                            [self.deviceToken dataUsingEncoding:NSUTF8StringEncoding], @"deviceToken", nil];  
    
    [self postToLocation:location params:params onComplete:^(NSDictionary *object) {
        self.notificationToken = [object valueForKey:@"notificationToken"];
        if (onComplete != nil) {
            onComplete(self.notificationToken);
        }
    } onError:^(NSString *errorMessage, NSString *errorCode) {
        if (onError != nil) {
            onError(errorMessage, errorCode);            
        }
    }];
}

- (void)registerDeviceAndSubscribeToChannel:(NSString *)channelIdentifier onComplete:(void (^)(NSString *deviceToken, NSString *subscriptionIdentifier))onComplete onError:(void (^)(NSString *errorCode, NSString *errorMessage))onError {
#warning Method not implemented
    NSAssert(NO, @"Method not implemented: %s", __PRETTY_FUNCTION__);
}

#pragma mark -
#pragma mark Unregister method
- (void)unregisterDevice {
#warning Method not implemented
    NSAssert(NO, @"Method not implemented: %s", __PRETTY_FUNCTION__);
}

#pragma mark -
#pragma mark Subscribe Methods
- (void)subscribeToChannel:(NSString *)channelIdentifier onComplete:(void (^)(BOOL complete))onComplete onError:(void (^)(NSString *errorCode, NSString *errorMessage))onError {
    [self subscribeToChannel:channelIdentifier startDate:nil endDate:nil startTime:nil endTime:nil startDayOfWeek:nil endDayOfWeek:nil onComplete:onComplete onError:onError];
}

- (void)subscribeToChannel:(NSString *)channelIdentifier startDate:(NSDate *)startDate endDate:(NSDate *)endDate onComplete:(void (^)(BOOL complete))onComplete onError:(void (^)(NSString *errorCode, NSString *errorMessage))onError {
    [self subscribeToChannel:channelIdentifier startDate:startDate endDate:endDate startTime:nil endTime:nil startDayOfWeek:nil endDayOfWeek:nil onComplete:onComplete onError:onError];    
}

- (void)subscribeToChannel:(NSString *)channelIdentifier startTime:(NSDate *)startTime endTime:(NSDate *)endTime onComplete:(void (^)(BOOL complete))onComplete onError:(void (^)(NSString *errorCode, NSString *errorMessage))onError {
    [self subscribeToChannel:channelIdentifier startDate:nil endDate:nil startTime:startTime endTime:endTime startDayOfWeek:nil endDayOfWeek:nil onComplete:onComplete onError:onError];
}

- (void)subscribeToChannel:(NSString *)channelIdentifier startDayOfWeek:(NSNumber *)startDayOfWeek endDayOfWeek:(NSNumber *)endDayOfWeek onComplete:(void (^)(BOOL complete))onComplete onError:(void (^)(NSString *errorCode, NSString *errorMessage))onError {
    [self subscribeToChannel:channelIdentifier startDate:nil endDate:nil startTime:nil endTime:nil startDayOfWeek:startDayOfWeek endDayOfWeek:endDayOfWeek onComplete:onComplete onError:onError];
}

- (void)subscribeToChannel:(NSString *)channelIdentifier startDate:(NSDate *)startDate endDate:(NSDate *)endDate startTime:(NSDate *)startTime endTime:(NSDate *)endTime startDayOfWeek:(NSNumber *)startDayOfWeek endDayOfWeek:(NSNumber *)endDayOfWeek onComplete:(void (^)(BOOL complete))onComplete onError:(void (^)(NSString *errorCode, NSString *errorMessage))onError {
    NSDateFormatter *dateDateFormatter = [[NSDateFormatter alloc] init];
    [dateDateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDateFormatter *timeDateFormatter = [[NSDateFormatter alloc] init];
    [timeDateFormatter setDateFormat:@"HH:mm"];
    
    NSString *location = @"subscriptions";
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:10];
    [params setValue:[self.appId dataUsingEncoding:NSUTF8StringEncoding] forKey:@"appId"];
    [params setValue:[self.notificationToken dataUsingEncoding:NSUTF8StringEncoding] forKey:@"notificationToken"];
    [params setValue:[channelIdentifier dataUsingEncoding:NSUTF8StringEncoding] forKey:@"channelId"];
    if (startDate != nil) {
        [params setValue:[[dateDateFormatter stringFromDate:startDate] dataUsingEncoding:NSUTF8StringEncoding] forKey:@"dateStart"];
    }
    if (endDate != nil) {
        [params setValue:[[dateDateFormatter stringFromDate:endDate] dataUsingEncoding:NSUTF8StringEncoding] forKey:@"dateEnd"];
    }
    if (startTime != nil) {
        [params setValue:[[timeDateFormatter stringFromDate:startTime] dataUsingEncoding:NSUTF8StringEncoding] forKey:@"timeStart"];
    }
    if (endTime != nil) {
        [params setValue:[[timeDateFormatter stringFromDate:endTime] dataUsingEncoding:NSUTF8StringEncoding] forKey:@"timeEnd"];
    }
    if (startDayOfWeek != nil) {
        [params setValue:[[startDayOfWeek stringValue] dataUsingEncoding:NSUTF8StringEncoding] forKey:@"dowStart"];
    }
    if (endDayOfWeek != nil) {
        [params setValue:[[endDayOfWeek stringValue] dataUsingEncoding:NSUTF8StringEncoding] forKey:@"dowEnd"];
    }
    
    [self postToLocation:location params:params onComplete:^(NSDictionary *object) {
        onComplete(YES);
    } onError:^(NSString *errorCode, NSString *errorMessage) {
        onError(errorCode, errorMessage);
    }];
}

#pragma mark -
#pragma mark Subscription List Methods
- (void)subscriptionsWithOnComplete:(void (^)(NSArray *))onComplete onError:(void (^)(NSString *errorCode, NSString *errorMessage))onError {
    NSString *location = [NSString stringWithFormat:@"subscriptions/%@/%@", self.appId, self.notificationToken];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:self.appId, @"appId", self.notificationToken, @"notificationToken", nil];
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
#warning Method not implemented
    NSAssert(NO, @"Method not implemented: %s", __PRETTY_FUNCTION__);
}

#pragma mark -
#pragma mark Unsubscribe Methods
- (void)unsubscribe:(NSString *)subscriptionIdentifier {
#warning Method not implemented
    NSAssert(NO, @"Method not implemented: %s", __PRETTY_FUNCTION__);
}

- (void)unsubscribeFromChannel:(NSString *)channelIdentifier {
#warning Method not implemented
    NSAssert(NO, @"Method not implemented: %s", __PRETTY_FUNCTION__);
}

- (void)unsubscribeAll {
#warning Method not implemented
    NSAssert(NO, @"Method not implemented: %s", __PRETTY_FUNCTION__);
}

#pragma mark -
#pragma mark Connection Methods
- (void)postToLocation:(NSString *)location params:(NSDictionary *)params onComplete:(void(^)(NSDictionary *object))onComplete onError:(void(^)(NSString *errorCode, NSString *errorMessage))onError {
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", self.tokenExchangeURL, location]];
    EFRequest *request = [EFRequest requestWithURL:URL preProcessHandler:^id(NSURLResponse *response, NSData *data, NSError *__autoreleasing *error) {
        NSArray *result = [[JSONDecoder decoder] objectWithData:data];
        if (((NSHTTPURLResponse *)response).statusCode >= 400) {
            NSDictionary *userInfo = nil;
            if ([result valueForKey:@"code"] && [result valueForKey:@"message"]) {
                userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:[result valueForKey:@"code"], @"code", [result valueForKey:@"message"], @"message", nil];
            } else {
                userInfo =  [[NSDictionary alloc] initWithObjectsAndKeys:@"unkown_error", @"code", [NSString stringWithFormat:@"An unknown error occured: Error code %d", ((NSHTTPURLResponse *)response).statusCode], @"message", nil];
            }
            *error = [NSError errorWithDomain:EFErrorDomain code:EFUnknownError userInfo:userInfo];
        }
        return result;
    } resultHandler:^(NSURLResponse *response, id result, NSError *error) {
        if (error) { 
            if ([[error userInfo] isKindOfClass:[NSDictionary class]]) { 
                onError([[error userInfo] valueForKey:@"code"], [[error userInfo] valueForKey:@"message"]);
            } else {
                onError(@"unkown_error", [NSString stringWithFormat:@"An unkown error occured: %@", [error localizedDescription]]);
            }
        } else { 
            onComplete(result);
        }
    }];
    
    [request setAllHTTPPostFields:params];
    [request setHTTPMethod:@"POST"];
    [request start];
}

- (void)loadArrayForLocation:(NSString *)location params:(NSDictionary *)params onComplete:(void(^)(NSArray *list))onComplete onError:(void(^)(NSString *errorCode, NSString *errorMessage))onError {
    NSString *queryString = @"";
    for (NSString *field in [params keyEnumerator]) {
        NSString *value = [[params valueForKey:field] description];
        if ([queryString length] > 0) { 
            queryString = [NSString stringWithFormat:@"%@&%@=%@", queryString, field, [self URLEncodeString:value encoding:NSUTF8StringEncoding]];
        } else {
            queryString = [NSString stringWithFormat:@"%@?%@=%@", queryString, field, [self URLEncodeString:value encoding:NSUTF8StringEncoding]];
        }
    }
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", self.tokenExchangeURL, location]];
    EFRequest *request = [EFRequest requestWithURL:URL preProcessHandler:^id(NSURLResponse *response, NSData *data, NSError *__autoreleasing *error) {
        NSArray *result = [[JSONDecoder decoder] objectWithData:data];
        if (((NSHTTPURLResponse *)response).statusCode >= 400) {          
            NSDictionary *userInfo = nil;
            if ([result valueForKey:@"code"] && [result valueForKey:@"message"]) {
                userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:[result valueForKey:@"code"], @"code", [result valueForKey:@"message"], @"message", nil];
            } else {
                userInfo =  [[NSDictionary alloc] initWithObjectsAndKeys:@"unkown_error", @"code", [NSString stringWithFormat:@"An unknown error occured: Error code %d", ((NSHTTPURLResponse *)response).statusCode], @"message", nil];
            }
            *error = [NSError errorWithDomain:EFErrorDomain code:EFUnknownError userInfo:userInfo];
        }
        return result;
    } resultHandler:^(NSURLResponse *response, id result, NSError *error) {
        if (error) {
            if ([[error userInfo] isKindOfClass:[NSDictionary class]]) { 
                onError([[error userInfo] valueForKey:@"code"], [[error userInfo] valueForKey:@"message"]);
            } else {
                onError(@"unkown_error", [NSString stringWithFormat:@"An unkown error occured: %@", [error localizedDescription]]);
            }
        } else {
            onComplete(result);
        }
    }];
    
    [request setHTTPMethod:@"GET"];
    [request start];    
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

- (NSString *)tokenExchangeURL {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"ENSDeviceTokenExchangeURL"];
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
#pragma mark Singleton Methods
+ (ENSNotificationManager *)sharedInstance {
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [[ENSNotificationManager alloc] init];
        }
    }
    return sharedInstance;
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
