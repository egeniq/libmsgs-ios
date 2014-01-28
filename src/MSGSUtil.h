//
//  MSGSUtil.h
//  RTLNieuws365
//
//  Created by Peter Verhage on 27-01-14.
//  Copyright (c) 2014 Egeniq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSGSUtil : NSObject

+ (NSString *)addressForDeviceToken:(NSData *)deviceToken;
+ (NSString *)deviceType;
+ (NSString *)deviceName;

@end
