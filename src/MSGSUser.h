//
//  MSGSUser.h
//  ENSSample
//
//  Created by Peter Verhage on 22-01-14.
//
//

#import <Foundation/Foundation.h>

@interface MSGSUser : NSObject

@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *externalUserId;

- (instancetype)init;
- (instancetype)initWithDictionary:(NSDictionary *)keyedValues;

@end
