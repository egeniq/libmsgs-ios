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

- (void)registerDevice:(NSData *)deviceToken;
- (void)registerDevice:(NSData *)deviceToken onComplete:(void(^)(NSString *deviceToken))onComplete onError:(void (^)(NSString *errorCode, NSString *errorMessage))onError;
- (void)registerDeviceAndSubscribeToChannel:(NSString *)channelIdentifier onComplete:(void(^)(NSString *deviceToken, NSString *subscriptionIdentifier))onComplete onError:(void (^)(NSString *errorCode, NSString *errorMessage))onError;

- (void)subscribeToChannel:(NSString *)channelIdentifier onComplete:(void(^)(BOOL complete))onComplete onError:(void (^)(NSString *errorCode, NSString *errorMessage))onError;
- (void)subscribeToChannel:(NSString *)channelIdentifier startDate:(NSDate *)startDate endDate:(NSDate *)endDate onComplete:(void(^)(BOOL complete))onComplete onError:(void (^)(NSString *errorCode, NSString *errorMessage))onError;
- (void)subscribeToChannel:(NSString *)channelIdentifier startTime:(NSDate *)startTime endTime:(NSDate *)endTime onComplete:(void(^)(BOOL complete))onComplete onError:(void (^)(NSString *errorCode, NSString *errorMessage))onError;
- (void)subscribeToChannel:(NSString *)channelIdentifier startDayOfWeek:(NSNumber *)startDayOfWeek endDayOfWeek:(NSNumber *)endDayOfWeek onComplete:(void(^)(BOOL complete))onComplete onError:(void (^)(NSString *errorCode, NSString *errorMessage))onError;
- (void)subscribeToChannel:(NSString *)channelIdentifier startDate:(NSDate *)startDate endDate:(NSDate *)endDate startTime:(NSDate *)startTime endTime:(NSDate *)endTime startDayOfWeek:(NSNumber *)startDayOfWeek endDayOfWeek:(NSNumber *)endDayOfWeek onComplete:(void(^)(BOOL complete))onComplete onError:(void (^)(NSString *errorCode, NSString *errorMessage))onError;

- (void)subscriptionsWithOnComplete:(void(^)(NSArray *subscriptions))onComplete onError:(void (^)(NSString *errorCode, NSString *errorMessage))onError;
- (void)subscriptionsForChannel:(NSString *)channelIdentifier onComplete:(void(^)(NSArray *subscriptions))onComplete onError:(void (^)(NSString *errorCode, NSString *errorMessage))onError;

- (void)unsubscribe:(NSString *)subscriptionIdentifier;
- (void)unsubscribeFromChannel:(NSString *)channelIdentifier;
- (void)unsubscribeAll;
- (void)unregisterDevice;

- (BOOL)deviceIsRegistered;

@end
