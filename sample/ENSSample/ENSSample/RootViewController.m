//
//  RootViewController.m
//  ENSSample
//
//  Created by Thijs Damen on 03-06-12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "ENSNotificationManager.h"
#import "AppDelegate.h"
#import "SubscriptionsViewController.h"
#import "SubscribeViewController.h"

@interface RootViewController ()

- (IBAction)currentSubscriptions;
- (IBAction)subscribe;

@property (nonatomic, retain) IBOutlet UILabel *notRegisteredLabel;

@end

@implementation RootViewController

@synthesize notRegisteredLabel = notRegisteredLabel_;

- (id)init {
    self = [super initWithNibName:@"RootViewController" bundle:nil];
    if (self) {
        self.title = NSLocalizedString(@"ENS Sample Home", @"Home title");
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", @"Back button title") style:UIBarButtonItemStyleBordered target:nil action:nil];
        [[self navigationItem] setBackBarButtonItem:backButton];
    }
    return self;
}

- (void)currentSubscriptions {
    SubscriptionsViewController *viewController = [[SubscriptionsViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)subscribe {
    SubscribeViewController *viewController = [[SubscribeViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([[ENSNotificationManager sharedInstance] deviceIsRegistered]) {
        self.notRegisteredLabel.hidden = YES;
    }
}



@end
