//
//  MSGSChannel.h
//  ENSSample
//
//  Created by Peter Verhage on 22-01-14.
//
//

@interface MSGSChannel : NSObject

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSArray *tags;
@property (nonatomic, strong) id data;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSDate *updatedAt;
@property (nonatomic, strong) NSDate *lastNotificationAt;

- (instancetype)init;
- (instancetype)initWithDictionary:(NSDictionary *)keyedValues;

- (NSDictionary *)dictionary;

@end
