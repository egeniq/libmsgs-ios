//
//  MSGSSimpleClient.m
//  ENSSample
//
//  Created by Peter Verhage on 27-01-14.
//
//

#import "MSGSSimpleClient.h"
#import "MSGSUtil.h"

@interface MSGSSimpleClient ()

@property (nonatomic, strong) MSGSClient *client;

@property (nonatomic, strong) MSGSEndpoint *endpoint;

@end

@implementation MSGSSimpleClient

#pragma mark -
#pragma mark Constructor

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        NSURL *baseURL = [NSURL URLWithString:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"MSGSAPIURL"]];
        NSString *apiKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"MSGSAPIKey"];
        self.client = [[MSGSClient alloc] initWithBaseURL:baseURL apiKey:apiKey];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *keyedValues = [defaults dictionaryForKey:@"MSGSEndpoint"];
        _endpoint = keyedValues != nil ? [[MSGSEndpoint alloc] initWithDictionary:keyedValues] : nil;
    }
    
    return self;
}

#pragma mark -
#pragma mark Shared instance

+ (MSGSSimpleClient *)sharedInstance {
    static MSGSSimpleClient *instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[MSGSSimpleClient alloc] init];
    });
    
    return instance;
}

#pragma mark -
#pragma mark Setters

- (void)setEndpoint:(MSGSEndpoint *)endpoint {
    _endpoint = endpoint;
    
    NSDictionary *keyedValues = [MSGSUtil dictionaryWithoutNullValues:[endpoint dictionary]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:keyedValues forKey:@"MSGSEndpoint"];
    [defaults synchronize];
}

#pragma mark -
#pragma mark Manage endpoint

- (void)registerEndpointWithDeviceToken:(NSData *)deviceToken
                           endpointType:(NSString *)endpointType
                                success:(void (^)(MSGSEndpoint *endpoint))success
                                failure:(void (^)(NSError *error))failure {
    [self registerEndpointWithDeviceToken:deviceToken
                             endpointType:[MSGSUtil deviceType]
                                  success:success
                                 failure:failure];
}

- (void)registerEndpointWithDeviceToken:(NSData *)deviceToken
                           endpointType:(NSString *)endpointType
                                success:(void (^)(MSGSEndpoint *endpoint))success
                                failure:(void (^)(NSError *error))failure {
    NSString *address = [MSGSUtil hexStringForData:deviceToken];
    if (self.endpoint != nil && [self.endpoint.address isEqualToString:address]) {
        success(self.endpoint);
        return;
    }
    
    if (self.endpoint == nil) {
        NSDictionary *keyedValues = @{ @"type": endpointType, @"address": address, @"name": [MSGSUtil deviceName] };
        [self.client registerEndpointWithDictionary:keyedValues success:^(MSGSEndpoint *endpoint) {
            self.endpoint = endpoint;
            success(endpoint);
        } failure:failure];
    } else {
        NSDictionary *keyedValues = @{ @"address": address, @"name": [MSGSUtil deviceName] };
        [[self.client forEndpointWithToken:self.endpoint.token] updateWithDictionary:keyedValues
                                                                             success:^(MSGSEndpoint *endpoint) {
                                                                                 self.endpoint = endpoint;
                                                                                 success(endpoint);
                                                                             } failure:failure];
    }
}

- (void)requireEndpointTokenOnFailure:(void (^)(NSError *error))failure {
    if (self.endpoint == nil) {
        NSDictionary *userInfo = @{
            MSGSErrorCodeKey: @"no_endpoint_registered",
            MSGSErrorMessageKey: @"No endpoint registered",
            NSLocalizedDescriptionKey: @"No endpoint registered"
        };
        
        failure([[NSError alloc] initWithDomain:MSGSErrorDomain code:500 userInfo:userInfo]);
    }
}

#pragma mark -
#pragma mark Manage subscriptions

- (void)fetchSubscriptionWithChannelCode:(NSString *)channelCode
                                 success:(void (^)(MSGSSubscription *subscription))success
                                 failure:(void (^)(NSError *error))failure {
    [self requireEndpointTokenOnFailure:failure];
    [[self.client forEndpointWithToken:self.endpoint.token] fetchSubscriptionWithChannelCode:channelCode success:success failure:failure];
}

- (void)fetchSubscriptionsWithLimit:(NSNumber *)limit
                             offset:(NSNumber *)offset
                               sort:(NSArray *)sort
                            success:(void (^)(NSArray *subscriptions, BOOL hasMore))success
                            failure:(void (^)(NSError *error))failure {
    [self requireEndpointTokenOnFailure:failure];
    [[self.client forEndpointWithToken:self.endpoint.token] fetchSubscriptionsWithLimit:limit offset:offset sort:sort success:success failure:failure];
}

- (void)fetchSubscriptionsWithTags:(NSArray *)tags
                             limit:(NSNumber *)limit
                            offset:(NSNumber *)offset
                              sort:(NSArray *)sort
                           success:(void (^)(NSArray *subscriptions, BOOL hasMore))success
                           failure:(void (^)(NSError *error))failure {
    [self requireEndpointTokenOnFailure:failure];
    [[self.client forEndpointWithToken:self.endpoint.token] fetchSubscriptionsWithTags:[NSSet setWithArray:tags] limit:limit offset:offset sort:sort success:success failure:failure];
}

- (void)countSubscriptionsWithTags:(NSArray *)tags
                           success:(void (^)(NSInteger count))success
                           failure:(void (^)(NSError *error))failure {
    [self requireEndpointTokenOnFailure:failure];
    [[self.client forEndpointWithToken:self.endpoint.token] countSubscriptionsWithTags:[NSSet setWithArray:tags] success:success failure:failure];
}

- (void)subscribeWithChannelCode:(NSString *)channelCode
                         success:(void (^)(MSGSSubscription *subscription))success
                         failure:(void (^)(NSError *error))failure {
    [self requireEndpointTokenOnFailure:failure];
    [[self.client forEndpointWithToken:self.endpoint.token] subscribeWithChannelCode:channelCode success:success failure:failure];
}

- (void)unsubscribeWithChannelCode:(NSString *)channelCode
                           success:(void (^)())success
                           failure:(void (^)(NSError *error))failure {
    [self requireEndpointTokenOnFailure:failure];
    [[self.client forEndpointWithToken:self.endpoint.token] unsubscribeWithChannelCode:channelCode success:success failure:failure];
}

@end