//
//  MSGSUserRequestHelper.h
//  ENSSample
//
//  Created by Peter Verhage on 22-01-14.
//
//

#import "MSGSRequestHelper.h"
#import "MSGSEndpointRequestHelper.h"
#import "MSGSEndpoint.h"

@interface MSGSUserRequestHelper : MSGSRequestHelper

- (id)initWithClient:(MSGSClient *)client token:(NSString *)token;

- (NSOperation *)registerEndpointWithDictionary:(NSDictionary *)keyedValues
                                        success:(void (^)(MSGSEndpoint *endpoint))success
                                        failure:(void (^)(NSError *error))failure;

- (NSOperation *)fetchEndpointsWithLimit:(NSNumber *)limit
                                  offset:(NSNumber *)offset
                                 success:(void (^)(NSArray *endpoints, BOOL hasMore))success
                                 failure:(void (^)(NSError *error))failure;

- (MSGSEndpointRequestHelper *)forEndpointWithToken:(NSString *)token;

@end