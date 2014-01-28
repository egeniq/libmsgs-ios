//
//  MSGSUtil.m
//  RTLNieuws365
//
//  Created by Peter Verhage on 27-01-14.
//  Copyright (c) 2014 Egeniq. All rights reserved.
//

#import "MSGSUtil.h"

@implementation MSGSUtil

+ (NSString *)addressForDeviceToken:(NSData *)deviceToken {
    const unsigned char *bytes = (const unsigned char *)[deviceToken bytes];
    NSUInteger numberOfBytes =  [deviceToken length];
    
    NSMutableString *hex = [[NSMutableString alloc] initWithCapacity:2 * numberOfBytes];
    for (NSUInteger i = 0; i < numberOfBytes; i++) {
        [hex appendFormat:@"%02x", bytes[i]];
    }
    
    return hex;
}

+ (NSString *)deviceType {
    NSString *type = nil;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        type = @"iphone";
    } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        type = @"ipad";
    } else {
        type = @"ios";
    }
    
    return type;
}

+ (NSString *)deviceName {
    NSString *name = UIDevice.currentDevice.name;
    return name;
}

@end
