//
//  MSGSEndpoint.h
//  ENSSample
//
//  Created by Peter Verhage on 22-01-14.
//
//

#import <Foundation/Foundation.h>

@interface MSGSEndpoint : NSObject

@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSNumber *endpointSubscriptionsActive;
@property (nonatomic, strong) NSNumber *userSubscriptionsActive;
@property (nonatomic, strong) id data;

- (instancetype)init;
- (instancetype)initWithDictionary:(NSDictionary *)keyedValues;

- (NSDictionary *)dictionary;

@end
