//
//  MSGSSimpleClient.h
//  ENSSample
//
//  Created by Peter Verhage on 27-01-14.
//
//

#import "MSGSClient.h"

@interface MSGSSimpleClient : NSObject

+ (MSGSSimpleClient *)sharedInstance;

- (void)registerEndpointWithDeviceToken:(NSData *)deviceToken
                                success:(void (^)(MSGSEndpoint *endpoint))success
                                failure:(void (^)(NSError *error))failure;

- (void)fetchSubscriptionWithChannelCode:(NSString *)channelCode
                                 success:(void (^)(MSGSSubscription *subscription))success
                                 failure:(void (^)(NSError *error))failure;

- (void)fetchSubscriptionsWithLimit:(NSNumber *)limit
                             offset:(NSNumber *)offset
                               sort:(NSArray *)sort
                            success:(void (^)(NSArray *subscriptions, BOOL hasMore))success
                            failure:(void (^)(NSError *error))failure;
- (void)fetchSubscriptionsWithTags:(NSArray *)tags
                             limit:(NSNumber *)limit
                            offset:(NSNumber *)offset
                              sort:(NSArray *)sort
                           success:(void (^)(NSArray *subscriptions, BOOL hasMore))success
                           failure:(void (^)(NSError *error))failure;
- (void)countSubscriptionsWithTags:(NSArray *)tags
                           success:(void (^)(NSInteger count))success
                           failure:(void (^)(NSError *error))failure;

- (void)subscribeWithChannelCode:(NSString *)channelCode
                         success:(void (^)(MSGSSubscription *subscription))success
                         failure:(void (^)(NSError *error))failure;

- (void)unsubscribeWithChannelCode:(NSString *)channelCode
                           success:(void (^)())success
                           failure:(void (^)(NSError *error))failure;
@end
