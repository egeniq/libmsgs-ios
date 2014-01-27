//
//  MSGSUserRequestHelper.m
//  ENSSample
//
//  Created by Peter Verhage on 22-01-14.
//
//

#import "MSGSUserRequestHelper.h"
#import "MSGSRequestHelper-Protected.h"

@implementation MSGSUserRequestHelper

- (id)initWithClient:(MSGSClient *)client token:(NSString *)token {
    return [super initWithClient:client basePath:[NSString stringWithFormat:@"users/%@", token]];
}

- (void)registerEndpointWithDictionary:(NSDictionary *)keyedValues
                               success:(void (^)(MSGSEndpoint *endpoint))success
                               failure:(void (^)(NSError *error))failure {
    [self postPath:@"endpoints"
        parameters:keyedValues
           success:^(id data) {
               success([[MSGSEndpoint alloc] initWithDictionary:data]);
           } failure:failure];
}

- (void)fetchEndpointsWithLimit:(NSNumber *)limit
                         offset:(NSNumber *)offset
                        success:(void (^)(NSArray *endpoints, BOOL hasMore))success
                        failure:(void (^)(NSError *error))failure {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    if (limit != nil) {
        [params setObject:limit forKey:@"limit"];
        [params setObject:offset != nil ? offset : @(0) forKey:@"offset"];
    }
    
    [self getPath:@"endpoints"
       parameters:params
          success:^(id data) {
              NSMutableArray *items = [[NSMutableArray alloc] init];
              for (id itemData in [data valueForKey:@"items"]) {
                  [items addObject:[[MSGSEndpoint alloc] initWithDictionary:itemData]];
              }
              
              BOOL hasMore = NO;
              if (limit != nil) {
                  hasMore = (offset != nil ? [offset integerValue] : 0) + [items count] < [[data objectForKey:@"total"] integerValue];
              }

              success(items, hasMore);
          } failure:failure];
}

- (MSGSEndpointRequestHelper *)forEndpointWithToken:(NSString *)token {
    return [[MSGSEndpointRequestHelper alloc] initWithClient:self.client token:token basePath:self.basePath];
}

@end
