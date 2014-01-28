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

- (void)fetchWithSuccess:(void (^)(MSGSEndpoint *endpoint))success
                 failure:(void (^)(NSError *error))failure;

- (void)updateWithDictionary:(NSDictionary *)keyedValues
                     success:(void (^)(MSGSEndpoint *endpoint))success
                     failure:(void (^)(NSError *error))failure;

- (void)deleteWithSuccess:(void (^)())success
                  failure:(void (^)(NSError *error))failure;

@end
