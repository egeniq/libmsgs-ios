//
//  ENSNotificationManager.h
//  
//  Helper class for registering the device for push notifications.
//
//  Created by Thijs Damen on 01-06-12.
//  Copyright (c) 2012 Egeniq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ENSNotificationManager : NSObject

+ (ENSNotificationManager *)sharedInstance;

@property (nonatomic, copy) NSString *notificationAppId;

- (void)registerDevice:(NSData *)deviceToken;
- (void)registerDevice:(NSData *)deviceToken onComplete:(void(^)(NSString *deviceToken))onComplete onError:(void (^)(NSString *errorCode, NSString *errorMessage))onError;
- (void)registerDevice:(NSData *)deviceToken channelIdentifier:(NSString *)channelIdentifier onComplete:(void (^)(NSString *notificationToken))onComplete onError:(void (^)(NSString *errorCode, NSString *errorMessage))onError;

- (void)subscribeToChannel:(NSString *)channelIdentifier onComplete:(void(^)(NSString *subscriptionId))onComplete onError:(void (^)(NSString *errorCode, NSString *errorMessage))onError;
- (void)subscribeToChannel:(NSString *)channelIdentifier startDate:(NSDate *)startDate endDate:(NSDate *)endDate onComplete:(void(^)(NSString *subscriptionId))onComplete onError:(void (^)(NSString *errorCode, NSString *errorMessage))onError;
- (void)subscribeToChannel:(NSString *)channelIdentifier startTime:(NSDate *)startTime endTime:(NSDate *)endTime onComplete:(void(^)(NSString *subscriptionId))onComplete onError:(void (^)(NSString *errorCode, NSString *errorMessage))onError;
- (void)subscribeToChannel:(NSString *)channelIdentifier startDayOfWeek:(NSNumber *)startDayOfWeek endDayOfWeek:(NSNumber *)endDayOfWeek onComplete:(void(^)(NSString *subscriptionId))onComplete onError:(void (^)(NSString *errorCode, NSString *errorMessage))onError;
- (void)subscribeToChannel:(NSString *)channelIdentifier startDate:(NSDate *)startDate endDate:(NSDate *)endDate startTime:(NSDate *)startTime endTime:(NSDate *)endTime startDayOfWeek:(NSNumber *)startDayOfWeek endDayOfWeek:(NSNumber *)endDayOfWeek onComplete:(void(^)(NSString *subscriptionId))onComplete onError:(void (^)(NSString *errorCode, NSString *errorMessage))onError;

- (void)subscriptionsWithOnComplete:(void(^)(NSArray *subscriptions))onComplete onError:(void (^)(NSString *errorCode, NSString *errorMessage))onError;
- (void)subscriptionsForChannel:(NSString *)channelIdentifier onComplete:(void(^)(NSArray *subscriptions))onComplete onError:(void (^)(NSString *errorCode, NSString *errorMessage))onError;

- (void)unsubscribe:(NSString *)subscriptionIdentifier onComplete:(void(^)())onComplete onError:(void (^)(NSString *errorCode, NSString *errorMessage))onError;
- (void)unsubscribeFromChannel:(NSString *)channelIdentifier onComplete:(void(^)())onComplete onError:(void (^)(NSString *errorCode, NSString *errorMessage))onError;
- (void)unsubscribeAllOnComplete:(void(^)())onComplete onError:(void (^)(NSString *errorCode, NSString *errorMessage))onError;
- (void)unregisterDeviceOnComplete:(void (^)())onComplete onError:(void (^)(NSString *errorCode, NSString *errorMessage))onError;

- (BOOL)deviceIsRegistered;

@end
