//
//  MSGSEndpointRequestHelper.h
//  ENSSample
//
//  Created by Peter Verhage on 22-01-14.
//
//

#import "MSGSRequestHelper.h"
#import "MSGSEndpoint.h"

@interface MSGSEndpointRequestHelper : MSGSRequestHelper

- (id)initWithClient:(MSGSClient *)client token:(NSString *)token;
- (id)initWithClient:(MSGSClient *)client token:(NSString *)token basePath:(NSString *)basePath;

- (NSOperation *)fetchWithSuccess:(void (^)(MSGSEndpoint *endpoint))success
                          failure:(void (^)(NSError *error))failure;

- (NSOperation *)updateWithDictionary:(NSDictionary *)keyedValues
                              success:(void (^)(MSGSEndpoint *endpoint))success
                              failure:(void (^)(NSError *error))failure;

- (NSOperation *)deleteWithSuccess:(void (^)())success
                           failure:(void (^)(NSError *error))failure;

@end
