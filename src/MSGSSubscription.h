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

- (instancetype)init;
- (instancetype)initWithDictionary:(NSDictionary *)keyedValues;

@end
