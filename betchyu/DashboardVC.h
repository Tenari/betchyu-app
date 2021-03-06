//  DashboardVC.h
//  betchyu
//
//  Created by Daniel Zapata on 6/2/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.

#import <UIKit/UIKit.h>
#import "Dashboard.h"
#import "API.h"
#import <Braintree/BTEncryption.h>
#import "BTPaymentViewController.h"
#import "CreateBetVC.h"
#import "SettingsVC.h"
#import "GAITrackedViewController.h"

@interface DashboardVC : GAITrackedViewController

@property NSString * numberOfInvites;
@property UILabel * numNotif;
@property BOOL hasShownHowItWorks;
@property BOOL canLeavePage;
@property CreateBetVC *createGoalController;
@property SettingsVC * howItWorksContainerVC;
@property UIActivityIndicatorView *spinner;

@property NSArray *pendingBets;
@property NSArray *myBets;
@property NSArray *friendsBets;

- (id)initWithInviteNumber:(NSString *)numInvs;
- (void)getAndAddPendingBets:(id)useless;

@end
