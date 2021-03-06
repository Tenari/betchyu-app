//  StakeDetailsVC.h
//  betchyu
//
//  Created by Daniel Zapata on 6/17/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.

#import <UIKit/UIKit.h>
#import "StakeDetailsView.h"
#import "BetSummaryVC.h"
#import "BTPaymentViewController.h"
#import "ProfileView.h"
#import "BetterBraintreeView.h"

@interface StakeDetailsVC : GAITrackedViewController <UIAlertViewDelegate>

@property (strong) TempBet *bet;
@property int currentStake;
@property StakeDetailsView * staticStuff;
@property BOOL nextTapped;

- (id)initWithBet:(TempBet *)betObj;

@end
