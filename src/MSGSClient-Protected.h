//
//  MSGSClient-Protected.h
//  ENSSample
//
//  Created by Peter Verhage on 24-01-14.
//
//

#import "MSGSClient.h"

@interface MSGSClient (Protected)

- (NSOperation *)getPath:(NSString *)path
              parameters:(NSDictionary *)parameters
                 success:(void (^)(id data))success
                 failure:(void (^)(NSError *error))failure;

- (NSOperation *)postPath:(NSString *)path
               parameters:(NSDictionary *)parameters
                  success:(void (^)(id data))success
                  failure:(void (^)(NSError *error))failure;

- (NSOperation *)deletePath:(NSString *)path
                 parameters:(NSDictionary *)parameters
                    success:(void (^)(id data))success
                    failure:(void (^)(NSError *error))failure;

@end