//
//  MSGSUtil.h
//  ENSSample
//
//  Created by Peter Verhage on 27-01-14.
//  Copyright (c) 2014 Egeniq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSGSUtil : NSObject

+ (NSString *)deviceType;
+ (NSString *)deviceName;
+ (NSString *)hexStringForData:(NSData *)data;
+ (NSDictionary *)dictionaryWithoutNullValues:(NSDictionary *)keyedValues;

@end
