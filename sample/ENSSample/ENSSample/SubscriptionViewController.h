//
//  SubscriptionViewController.h
//  ENSSample
//
//  Created by Thijs Damen on 03-06-12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MSGSSubscription;

@interface SubscriptionViewController : UIViewController

- (id)initWithSubscription:(MSGSSubscription *)subscription;

@end
