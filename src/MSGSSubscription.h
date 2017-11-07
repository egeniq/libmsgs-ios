//
//  MSGSSubscription.h
//  ENSSample
//
//  Created by Peter Verhage on 22-01-14.
//
//

#import "MSGSChannel.h"

@interface MSGSSubscription : NSObject

@property (nonatomic, strong) MSGSChannel *channel;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSDate *updatedAt;

- (instancetype)init;
- (instancetype)initWithDictionary:(NSDictionary *)keyedValues;

- (NSDictionary *)dictionary;

@end
