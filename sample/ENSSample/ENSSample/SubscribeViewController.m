//
//  SubscribeViewController.m
//  ENSSample
//
//  Created by Thijs Damen on 03-06-12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SubscribeViewController.h"
#import "ENSNotificationManager.h"


@interface SubscribeViewController ()

@property (nonatomic, strong) IBOutlet UITextField *channelNameTextField;
@property (nonatomic, strong) IBOutlet UILabel *errorLabel;

- (IBAction)subscribe;

@end

@implementation SubscribeViewController

@synthesize channelNameTextField = channelNameTextField_;
@synthesize errorLabel = errorLabel_;

- (id)init {
    self = [super initWithNibName:@"SubscribeViewController" bundle:nil];
    if (self) {
        self.title = NSLocalizedString(@"Subscribe", @"Subscribe title");
    }
    return self;
}

- (void)viewDidLoad {
    self.errorLabel.hidden = YES;
}

- (void)subscribe {
    NSString *channelName = self.channelNameTextField.text;
    
    [[ENSNotificationManager sharedInstance] subscribeToChannel:channelName onComplete:^(NSString *subscriptionId) {
        [self.navigationController popViewControllerAnimated:YES];
    } onError:^(NSString *errorCode, NSString *errorMessage) {
        self.errorLabel.text = errorMessage;
        self.errorLabel.hidden = NO;
    }];
}

@end
