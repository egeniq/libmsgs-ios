//
//  SubscriptionViewController.m
//  ENSSample
//
//  Created by Thijs Damen on 03-06-12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SubscriptionViewController.h"
#import "ENSSubscription.h"

@interface SubscriptionViewController ()

@property (nonatomic, strong) IBOutlet UILabel *channelIdentifierLabel;
@property (nonatomic, strong) IBOutlet UILabel *dateStartLabel;
@property (nonatomic, strong) IBOutlet UILabel *dateEndLabel;
@property (nonatomic, strong) IBOutlet UILabel *timeStartLabel;
@property (nonatomic, strong) IBOutlet UILabel *timeEndLabel;
@property (nonatomic, strong) IBOutlet UILabel *dayOfWeekStartLabel;
@property (nonatomic, strong) IBOutlet UILabel *dayOfWeekEndLabel;
@property (nonatomic, strong) ENSSubscription *subscription;

@end

@implementation SubscriptionViewController

@synthesize channelIdentifierLabel = channelIdentifierLabel_;
@synthesize dateStartLabel = dateStartLabel_;
@synthesize dateEndLabel = dateEndLabel_;
@synthesize timeStartLabel = timeStartLabel_;
@synthesize timeEndLabel = timeEndLabel_;
@synthesize dayOfWeekStartLabel = dayOfWeekStartLabel_;
@synthesize dayOfWeekEndLabel = dayOfWeekEndLabel_;
@synthesize subscription = subscription_;

- (id)initWithSubscription:(ENSSubscription *)subscription {
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
        NSDateFormatter *dateDateFormatter = [[NSDateFormatter alloc] init];
        [dateDateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDateFormatter *timeDateFormatter = [[NSDateFormatter alloc] init];
        [timeDateFormatter setDateFormat:@"HH:mm"];

        self.channelIdentifierLabel.text = self.subscription.channelId;
        self.dateEndLabel.text = [dateDateFormatter stringFromDate:self.subscription.dateEnd];
        self.dateStartLabel.text = [dateDateFormatter stringFromDate:self.subscription.dateStart];
        self.timeEndLabel.text = [timeDateFormatter stringFromDate:self.subscription.timeEnd];
        self.timeStartLabel.text = [timeDateFormatter stringFromDate:self.subscription.timeStart];
        self.dayOfWeekEndLabel.text = self.subscription.dayOfWeekEnd;
        self.dayOfWeekStartLabel.text = self.subscription.dayOfWeekStart;
    }
}
@end
