//
//  MSGSChannel.m
//  ENSSample
//
//  Created by Peter Verhage on 22-01-14.
//
//

#import "MSGSChannel.h"

@implementation MSGSChannel

- (instancetype)init {
    self = [super init];
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)keyedValues {
    self = [super init];
    if (self != nil) {
        self.code = keyedValues[@"code"];
        self.name = keyedValues[@"name"];
        self.tags = keyedValues[@"tags"] == [NSNull null] ? nil : keyedValues[@"tags"];
        self.data = keyedValues[@"data"] == [NSNull null] ? nil : keyedValues[@"data"];
    }
    
    return self;
}


@end
