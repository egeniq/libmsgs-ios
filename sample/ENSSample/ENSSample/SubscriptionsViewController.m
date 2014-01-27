//
//  SubscriptionsViewController.m
//  ENSSample
//
//  Created by Thijs Damen on 03-06-12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SubscriptionsViewController.h"
#import "SubscriptionViewController.h"
#import "MSGSSimpleClient.h"

@interface SubscriptionsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIView *tableFooterView;
@property (nonatomic, strong) NSArray *subscriptions;

@end

@implementation SubscriptionsViewController

@synthesize tableView = tableView_;
@synthesize tableFooterView = tableFooterView_;
@synthesize subscriptions = subscriptions_;

- (id)init {
    self = [super initWithNibName:@"SubscriptionsViewController" bundle:nil];
    if (self) {
        self.title = NSLocalizedString(@"Subscriptions", @"Subscriptions title");
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
     self.tableView.tableFooterView = self.tableFooterView;
    
    [[MSGSSimpleClient sharedInstance] fetchSubscriptionsWithLimit:nil offset:nil sort:nil success:^(NSArray *subscriptions, BOOL hasMore) {
        self.subscriptions = subscriptions;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", @"Ok") otherButtonTitles:nil, nil] show];
    }];
}

#pragma mark -
#pragma mark TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MSGSSubscription *subscription = [self.subscriptions objectAtIndex:indexPath.row];
    SubscriptionViewController *viewController = [[SubscriptionViewController alloc] initWithSubscription:subscription];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark -
#pragma mark TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.subscriptions count] == 0) {
        self.tableView.tableFooterView.hidden = NO;
    } else {
        self.tableView.tableFooterView.hidden = YES;
    }
    return [self.subscriptions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    static NSString *tableViewCellIdentifier = @"TableViewCellIdentifier";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:tableViewCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableViewCellIdentifier];
    }
    
    MSGSSubscription *subscription = [self.subscriptions objectAtIndex:indexPath.row];
    cell.textLabel.text = subscription.channel.code;
    return cell;
}

@end
