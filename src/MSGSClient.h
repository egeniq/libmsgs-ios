//
//  MSGSClient.h
//  ENSSample
//
//  Created by Peter Verhage on 22-01-14.
//
//

#import <Foundation/Foundation.h>
#import "MSGSEndpointRequestHelper.h"
#import "MSGSUserRequestHelper.h"
#import "MSGSUser.h"
#import "MSGSEndpoint.h"


FOUNDATION_EXPORT NSString * const MSGSErrorDomain;
FOUNDATION_EXPORT NSString * const MSGSErrorCodeKey;
FOUNDATION_EXPORT NSString * const MSGSErrorMessageKey;

@interface MSGSClient : NSObject

@property (nonatomic, strong, readonly) NSOperationQueue *operationQueue;

- (id)initWithBaseURL:(NSURL *)baseURL apiKey:(NSString *)apiKey;

- (void)registerUserWithDictionary:(NSDictionary *)keyedValues
                           success:(void (^)(MSGSUser *user))success
                           failure:(void (^)(NSError *error))failure;


- (MSGSUserRequestHelper *)forUserWithToken:(NSString *)token;

- (void)registerEndpointWithDictionary:(NSDictionary *)keyedValues
                               success:(void (^)(MSGSEndpoint *endpoint))success
                               failure:(void (^)(NSError *error))failure;

- (MSGSEndpointRequestHelper *)forEndpointWithToken:(NSString *)token;

@end