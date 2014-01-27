//
//  MSGSSimpleClient.m
//  ENSSample
//
//  Created by Peter Verhage on 27-01-14.
//
//

#import "MSGSSimpleClient.h"

@interface MSGSSimpleClient ()

@property (nonatomic, strong) MSGSClient *client;

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
#pragma mark Manage endpoint

- (NSString *)hexStringFromDeviceToken:(NSData *)deviceToken {
    const unsigned char *bytes = (const unsigned char *)[deviceToken bytes];
    NSUInteger numberOfBytes =  [deviceToken length];
    
    NSMutableString *hex = [[NSMutableString alloc] initWithCapacity:2 * numberOfBytes];
    for (NSUInteger i = 0; i < numberOfBytes; i++) {
        [hex appendFormat:@"%02x", bytes[i]];
    }
    
    return hex;
}

- (NSString *)endpointAddress {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults stringForKey:@"MSGSEndpointAddress"];
}

- (void)setEndpointAddress:(NSString *)address {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:address forKey:@"MSGSEndpointAddress"];
    [defaults synchronize];
}

- (NSString *)endpointToken {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults stringForKey:@"MSGSEndpointToken"];
}

- (void)setEndpointToken:(NSString *)token {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:token forKey:@"MSGSEndpointToken"];
    [defaults synchronize];
}

- (void)registerEndpointWithDeviceToken:(NSData *)deviceToken
                                success:(void (^)(MSGSEndpoint *endpoint))success
                                failure:(void (^)(NSError *error))failure {
    NSString *address = [self hexStringFromDeviceToken:deviceToken];
    if (self.endpointToken != nil && [self.endpointAddress isEqualToString:address]) {
        return;
    }
    
    NSString *type = nil;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        type = @"iphone";
    } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        type = @"ipad";
    } else {
        type = @"ios";
    }
    
    NSString *name = UIDevice.currentDevice.name;
    
    if (self.endpointToken == nil) {
        NSDictionary *endpoint = @{ @"type": type, @"address": address, @"name": name};
        [self.client registerEndpointWithDictionary:endpoint success:^(MSGSEndpoint *endpoint) {
            self.endpointAddress = endpoint.address;
            self.endpointToken = endpoint.token;
            success(endpoint);
        } failure:failure];
    } else {
        NSDictionary *endpoint = @{ @"type": type, @"address": address, @"name": name};
        [[self.client forEndpointWithToken:self.endpointToken] updateWithDictionary:endpoint
                                                                            success:^(MSGSEndpoint *endpoint) {
                                                                                self.endpointAddress = endpoint.address;
                                                                                self.endpointToken = endpoint.token;
                                                                                success(endpoint);
                                                                            } failure:failure];
    }
}

- (void)requireEndpointTokenOnFailure:(void (^)(NSError *error))failure {
    if (self.endpointToken == nil) {
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
    [[self.client forEndpointWithToken:self.endpointToken] fetchSubscriptionWithChannelCode:channelCode success:success failure:failure];
}

- (void)fetchSubscriptionsWithLimit:(NSNumber *)limit
                             offset:(NSNumber *)offset
                               sort:(NSArray *)sort
                            success:(void (^)(NSArray *subscriptions, BOOL hasMore))success
                            failure:(void (^)(NSError *error))failure {
    [self requireEndpointTokenOnFailure:failure];
    [[self.client forEndpointWithToken:self.endpointToken] fetchSubscriptionsWithLimit:limit offset:offset sort:sort success:success failure:failure];
}

- (void)fetchSubscriptionsWithTags:(NSArray *)tags
                             limit:(NSNumber *)limit
                            offset:(NSNumber *)offset
                              sort:(NSArray *)sort
                           success:(void (^)(NSArray *subscriptions, BOOL hasMore))success
                           failure:(void (^)(NSError *error))failure {
    [self requireEndpointTokenOnFailure:failure];
    [[self.client forEndpointWithToken:self.endpointToken] fetchSubscriptionsWithTags:tags limit:limit offset:offset sort:sort success:success failure:failure];
}


- (void)subscribeWithChannelCode:(NSString *)channelCode
                         success:(void (^)(MSGSSubscription *subscription))success
                         failure:(void (^)(NSError *error))failure {
    [self requireEndpointTokenOnFailure:failure];
    [[self.client forEndpointWithToken:self.endpointToken] subscribeWithChannelCode:channelCode success:success failure:failure];
}

- (void)unsubscribeWithChannelCode:(NSString *)channelCode
                           success:(void (^)())success
                           failure:(void (^)(NSError *error))failure {
    [self requireEndpointTokenOnFailure:failure];
    [[self.client forEndpointWithToken:self.endpointToken] unsubscribeWithChannelCode:channelCode success:success failure:failure];
}

@end