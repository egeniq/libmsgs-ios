//
//  MSGSRequestHelper.h
//  ENSSample
//
//  Created by Peter Verhage on 22-01-14.
//
//

#import <Foundation/Foundation.h>
#import "MSGSSubscription.h"

@class MSGSClient;

typedef enum {
    MSGSSubscriptionSortCreatedAtAsc,
    MSGSSubscriptionSortCreatedAtDesc,
    MSGSSubscriptionSortChannelCreatedAtAsc,
    MSGSSubscriptionSortChannelCreatedAtDesc,
    MSGSSubscriptionSortChannelUpdatedAtAsc,
    MSGSSubscriptionSortChannelUpdatedAtDesc
} MSGSSubscriptionSort;

@interface MSGSRequestHelper : NSObject

- (id)initWithClient:(MSGSClient *)client basePath:(NSString *)basePath;

- (NSOperation *)fetchSubscriptionWithChannelCode:(NSString *)channelCode
                                          success:(void (^)(MSGSSubscription *subscription))success
                                          failure:(void (^)(NSError *error))failure;

- (NSOperation *)fetchSubscriptionsWithLimit:(NSNumber *)limit
                                      offset:(NSNumber *)offset
                                        sort:(NSArray *)sort
                                     success:(void (^)(NSArray *subscriptions, BOOL hasMore))success
                                     failure:(void (^)(NSError *error))failure;

- (NSOperation *)fetchSubscriptionsWithChannelCodes:(NSSet *)channelCodes
                                              limit:(NSNumber *)limit
                                             offset:(NSNumber *)offset
                                               sort:(NSArray *)sort
                                            success:(void (^)(NSArray *subscriptions, BOOL hasMore))success
                                            failure:(void (^)(NSError *error))failure;

- (NSOperation *)fetchSubscriptionsWithTags:(NSSet *)tags
                                      limit:(NSNumber *)limit
                                     offset:(NSNumber *)offset
                                       sort:(NSArray *)sort
                                    success:(void (^)(NSArray *subscriptions, BOOL hasMore))success
                                    failure:(void (^)(NSError *error))failure;

- (NSOperation *)countSubscriptionsWithTags:(NSSet *)tags
                                    success:(void (^)(NSInteger count))success
                                    failure:(void (^)(NSError *error))failure;

- (NSOperation *)subscribeWithChannelCode:(NSString *)channelCode
                                  success:(void (^)(MSGSSubscription *subscription))success
                                  failure:(void (^)(NSError *error))failure;

- (NSOperation *)unsubscribeWithChannelCode:(NSString *)channelCode
                                    success:(void (^)())success
                                    failure:(void (^)(NSError *error))failure;

@end
