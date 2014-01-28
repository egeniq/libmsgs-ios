//
//  MSGSClient.m
//  ENSSample
//
//  Created by Peter Verhage on 22-01-14.
//
//

#import "MSGSClient.h"
#import "MSGSAFHTTPClient.h"
#import "MSGSAFJSONRequestOperation.h"

NSString * const MSGSErrorDomain = @"io.msgs";
NSString * const MSGSErrorCodeKey = @"MSGSErrorCodeKey";
NSString * const MSGSErrorMessageKey = @"MSGSErrorMessageKey";

@interface MSGSClient ()

@property (nonatomic, strong) MSGSAFHTTPClient *client;

@end

@implementation MSGSClient

- (id)initWithBaseURL:(NSURL *)baseURL apiKey:(NSString *)apiKey {
    NSParameterAssert(baseURL);
    NSParameterAssert(apiKey);
    
    self = [super init];
    if (self != nil) {
        self.client = [[MSGSAFHTTPClient alloc] initWithBaseURL:baseURL];
        [self.client registerHTTPOperationClass:[MSGSAFJSONRequestOperation class]];
        [self.client setDefaultHeader:@"Accept" value:@"application/json"];
        [self.client setDefaultHeader:@"X-MsgsIo-APIKey" value:apiKey];
    }
    
    return self;
}

- (NSOperationQueue *)operationQueue {
    return self.client.operationQueue;
}

- (void)registerUserWithDictionary:(NSDictionary *)keyedValues
                           success:(void (^)(MSGSUser *user))success
                           failure:(void (^)(NSError *error))failure {
    [self postPath:@"users"
        parameters:keyedValues
           success:^(id data) {
               if (success != nil) {
                   success([[MSGSUser alloc] initWithDictionary:data]);
               }
           } failure:failure];
}


- (MSGSUserRequestHelper *)forUserWithToken:(NSString *)token {
    return [[MSGSUserRequestHelper alloc] initWithClient:self token:token];
}

- (void)registerEndpointWithDictionary:(NSDictionary *)keyedValues
                               success:(void (^)(MSGSEndpoint *endpoint))success
                               failure:(void (^)(NSError *error))failure {
    [self postPath:@"endpoints"
        parameters:keyedValues
           success:^(id data) {
               if (success != nil) {
                   success([[MSGSEndpoint alloc] initWithDictionary:data]);
               }
           } failure:failure];
}

- (MSGSEndpointRequestHelper *)forEndpointWithToken:(NSString *)token {
    return [[MSGSEndpointRequestHelper alloc] initWithClient:self token:token];
}

- (NSError *)processFailureForOperation:(MSGSAFHTTPRequestOperation *)operation error:(NSError *)error {
    id data = [(MSGSAFJSONRequestOperation *)operation responseJSON];
    
    NSDictionary *userInfo = @{
        MSGSErrorCodeKey: data == nil ? @"unknown_error" : [data objectForKey:@"code"],
        MSGSErrorMessageKey: data == nil ? @"An unknown error occured" : [data objectForKey:@"message"],
        NSLocalizedDescriptionKey: data == nil ? @"An unknown error occured" : [data objectForKey:@"message"],
        NSUnderlyingErrorKey: error
    };
    
    return [NSError errorWithDomain:MSGSErrorDomain code:error.code userInfo:userInfo];
}

- (void)getPath:(NSString *)path
     parameters:(NSDictionary *)parameters
        success:(void (^)(id data))success
        failure:(void (^)(NSError *error))failure {
    [self.client getPath:path parameters:parameters success:^(MSGSAFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(MSGSAFHTTPRequestOperation *operation, NSError *error) {
        if (failure != nil) {
            failure([self processFailureForOperation:operation error:error]);
        }
    }];
}

- (void)postPath:(NSString *)path
      parameters:(NSDictionary *)parameters
         success:(void (^)(id data))success
         failure:(void (^)(NSError *error))failure {
    [self.client postPath:path parameters:parameters success:^(MSGSAFHTTPRequestOperation *operation, id responseObject) {
        if (success != nil) {
            success(responseObject);
        }
    } failure:^(MSGSAFHTTPRequestOperation *operation, NSError *error) {
        if (failure != nil) {
            failure([self processFailureForOperation:operation error:error]);
        }
    }];
}

- (void)deletePath:(NSString *)path
        parameters:(NSDictionary *)parameters
           success:(void (^)(id data))success
           failure:(void (^)(NSError *error))failure {
    [self.client deletePath:path parameters:parameters success:^(MSGSAFHTTPRequestOperation *operation, id responseObject) {
        if (success != nil) {
            success(responseObject);
        }
    } failure:^(MSGSAFHTTPRequestOperation *operation, NSError *error) {
        if (failure != nil) {
            failure([self processFailureForOperation:operation error:error]);
        }
    }];
}

@end
