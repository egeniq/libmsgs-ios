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


- (void)subscribeWithChannelCode:(NSString *)channelCode
                         success:(void (^)(MSGSSubscription *subscription))success
                         failure:(void (^)(NSError *error))failure;

- (void)unsubscribeWithChannelCode:(NSString *)channelCode
                           success:(void (^)())success
                           failure:(void (^)(NSError *error))failure;

@end
