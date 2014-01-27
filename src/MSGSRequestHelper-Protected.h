//
//  MSGSRequestHelper-Protected.h
//  ENSSample
//
//  Created by Peter Verhage on 24-01-14.
//
//

#import "MSGSRequestHelper.h"
#import "MSGSClient.h"
#import "MSGSClient-Protected.h"

@interface MSGSRequestHelper (Protected)

@property (nonatomic, copy, readonly) NSString *basePath;
@property (nonatomic, strong, readonly) MSGSClient *client;

- (void)getPath:(NSString *)path
     parameters:(NSDictionary *)parameters
        success:(void (^)(id data))success
        failure:(void (^)(NSError *error))failure;

- (void)postPath:(NSString *)path
      parameters:(NSDictionary *)parameters
         success:(void (^)(id data))success
         failure:(void (^)(NSError *error))failure;


- (void)deletePath:(NSString *)path
        parameters:(NSDictionary *)parameters
           success:(void (^)(id data))success
           failure:(void (^)(NSError *error))failure;

@end