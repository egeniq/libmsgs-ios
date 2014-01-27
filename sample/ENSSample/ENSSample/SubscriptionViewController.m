//
//  SubscriptionViewController.m
//  ENSSample
//
//  Created by Thijs Damen on 03-06-12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SubscriptionViewController.h"
#import "MSGSSubscription.h"

@interface SubscriptionViewController ()

@property (nonatomic, strong) IBOutlet UILabel *channelCodeLabel;
@property (nonatomic, strong) IBOutlet UILabel *channelNameLabel;
@property (nonatomic, strong) MSGSSubscription *subscription;

@end

@implementation SubscriptionViewController

- (id)initWithSubscription:(MSGSSubscription *)subscription {
    self = [super initWithNibName:@"SubscriptionViewController" bundle:nil];
    if (self) {
        self.title = NSLocalizedString(@"Subscription", @"Subscription title");
        self.subscription = subscription;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.subscription) {
        self.channelCodeLabel.text = self.subscription.channel.code;
        self.channelNameLabel.text = self.subscription.channel.name;
    }
}
@end
