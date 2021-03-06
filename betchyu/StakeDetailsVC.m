//  StakeDetailsVC.m
//  betchyu
//
//  Created by Daniel Zapata on 6/17/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.

#import "StakeDetailsVC.h"

@interface StakeDetailsVC ()

@end

@implementation StakeDetailsVC

@synthesize bet;
@synthesize currentStake;
@synthesize staticStuff;
@synthesize nextTapped;

- (id)initWithBet:(TempBet *)betObj
{
    self = [super init];
    if (self) {
        self.screenName = @"Stake Details (step 4)";
        self.nextTapped = NO;
        // Custom initialization
        bet = betObj;
        currentStake = 10;
        bet.stakeAmount = [NSNumber numberWithInt:currentStake];
        
        // remove the "Stake Details" from the back button on following pages
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    }
    return self;
}

- (void)loadView {
    CGRect f = [UIScreen mainScreen].applicationFrame;
    int w = f.size.width;
    // load static stuff via the StakeDetailsView
      // does not contain the buttons +/-/reviewBet
    self.staticStuff   = [[StakeDetailsView alloc] initWithFrame:CGRectMake(0, 0, w, 600) AndStakeType:bet.stakeType];
    staticStuff.totalAmountLabel.text = [NSString stringWithFormat:@"In total there is $%i at stake.", currentStake*bet.friends.count];
    staticStuff.clipsToBounds       = NO;
    staticStuff.layer.masksToBounds = NO;
    staticStuff.layer.shadowColor   = Bdark.CGColor;
    staticStuff.layer.shadowOffset  = CGSizeMake(0, 0);
    staticStuff.layer.shadowOpacity = 0.9f;
    staticStuff.layer.shadowRadius  = 3.0f;
    CGRect b = staticStuff.layer.bounds;
    b.size.height = b.size.height - 64;
    staticStuff.layer.shadowPath    = [[UIBezierPath bezierPathWithRect:b] CGPath];
    
    // The button prompting them to move on
    int btnH = 60;
    UIButton * reviewBet = [[UIButton alloc] initWithFrame:CGRectMake(0, staticStuff.frame.size.height-btnH-64, w, btnH)];
    reviewBet.backgroundColor   = Bgreen;
    reviewBet.tintColor         = [UIColor whiteColor];
    [reviewBet setTitle:@"Review Bet" forState:UIControlStateNormal];
    reviewBet.titleLabel.font   = [UIFont fontWithName:@"ProximaNova-Bold" size:15];
    [reviewBet addTarget:self action:@selector(reviewBet:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow-16.png"]];
    arrow.image     = [arrow.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    arrow.tintColor = [UIColor whiteColor];
    arrow.frame     = CGRectMake(w-30, 22, 8, 15);
    [reviewBet addSubview:arrow];
    [staticStuff addSubview:reviewBet];
    
    int plusYoff = staticStuff.amountLabel.frame.origin.y + 5;
    int plusWidth = 32;
    UIButton *plus = [[UIButton alloc]initWithFrame:CGRectMake(4*w/5 - plusWidth, plusYoff, plusWidth, plusWidth)];
    plus.layer.cornerRadius = plusWidth/2;
    plus.layer.borderColor = Borange.CGColor;
    plus.layer.borderWidth = 2;
    [plus addTarget:self action:@selector(increaseStake:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *plusSign = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, plusWidth, plusWidth)];
    plusSign.text=@"+";
    plusSign.font = [UIFont fontWithName:@"ProximaNova-Bold" size:22];
    plusSign.textColor = Borange;
    plusSign.textAlignment = NSTextAlignmentCenter;
    [plus addSubview:plusSign];
    [staticStuff addSubview:plus];
    
    UIButton *minus = [[UIButton alloc]initWithFrame:CGRectMake(w/5, plusYoff, plusWidth, plusWidth)];
    minus.layer.cornerRadius = plusWidth/2;
    minus.layer.borderColor = Borange.CGColor;
    minus.layer.borderWidth = 2;
    [minus addTarget:self action:@selector(lowerStake:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *minusSign = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, plusWidth, plusWidth)];
    minusSign.text=@"-";
    minusSign.font = [UIFont fontWithName:@"ProximaNova-Bold" size:22];
    minusSign.textColor = Borange;
    minusSign.textAlignment = NSTextAlignmentCenter;
    [minus addSubview:minusSign];
    [staticStuff addSubview:minus];
    
    //set up the view
    self.view = [[UIView alloc] initWithFrame:f];
    self.view.backgroundColor = Blight;
    [self.view addSubview:staticStuff];
}

-(void)increaseStake:(id)sender {
    if ([bet.stakeType hasSuffix:@"Gift Card"]) {
        NSArray *stakeAmounts = @[@5,@10,@15,@20,@25,@30,@40,@50,@60,@75,@100];
        for (int i = 0; i<stakeAmounts.count-1; i++) {
            if (currentStake == [[stakeAmounts objectAtIndex:i]integerValue]) {
                currentStake = [[stakeAmounts objectAtIndex:i+1]integerValue];
                break;
            }
        }
    } else {
        currentStake++;
    }
    [self updateLabels];
}
-(void)lowerStake:(id)sender {
    if ([bet.stakeType hasSuffix:@"Gift Card"]) {
        NSArray *stakeAmounts = @[@5,@10,@15,@20,@25,@30,@40,@50,@60,@75,@100];
        for (int i = 1; i<stakeAmounts.count; i++) {
            if (currentStake == [[stakeAmounts objectAtIndex:i]integerValue]) {
                currentStake = [[stakeAmounts objectAtIndex:i-1]integerValue];
                break;
            }
        }
    } else {
        currentStake--;
    }
    [self updateLabels];
}

// updates what the user can see and the data object representing the bet
- (void) updateLabels {
    if ([bet.stakeType hasSuffix:@"Gift Card"]) {
        staticStuff.amountLabel.text      = [NSString stringWithFormat:@"$%i", currentStake];
        staticStuff.totalAmountLabel.text = [NSString stringWithFormat:@"In total there is $%i at stake.", currentStake*bet.friends.count];
    } else {
#warning gotta fill this in when we have bet types other than giftcards
    }
    bet.stakeAmount = [NSNumber numberWithInt:currentStake];
}


-(void)reviewBet:(id)sender {
    if (self.nextTapped) { return; }
    self.nextTapped = YES;  // lock this method so we don't double request
    
    NSString *path = [NSString stringWithFormat:@"card/%@", ((AppDelegate *)([[UIApplication sharedApplication] delegate])).ownId];
    [[API sharedInstance] get:path withParams:nil onCompletion:^(NSDictionary *json) {
        if ([[json valueForKey:@"msg"] isEqualToString:@"no card found, man"]) {
            //make and display the VC
            [[[UIAlertView alloc] initWithTitle: @"Last Step!"
                                        message: @"To make this real, we need your payment info. Once your friend confirms, the bet is on! Only the loser will be charged at the end."
                                       delegate: self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
        } else {
            //skip asking for the card.
            [self betchyu];
            
            // make the summary VC
            BetSummaryVC *vc = [[BetSummaryVC alloc]initWithBet:self.bet];
            vc.title = @"Bet Summary";
            // show the summary vc
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}

//method to send the bet data to the server
- (void) betchyu {
    // MAKE THE NEW BET
    NSString *ownerString = ((AppDelegate *)([[UIApplication sharedApplication] delegate])).ownId;
    NSMutableDictionary* params =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  bet.amount,            @"amount",
                                  bet.noun,              @"noun",
                                  bet.verb,              @"verb",
                                  bet.duration,          @"duration",
                                  bet.stakeAmount,       @"stakeAmount",
                                  bet.stakeType,         @"stakeType",
                                  ownerString,           @"owner",
                                  bet.initial,           @"initial",
                                  nil];
    
    //make the call to the web API
    // POST /bets => {data}
    [[API sharedInstance] post:@"bets" withParams:params onCompletion:^(NSDictionary *json) {
        //success
        for (NSMutableDictionary<FBGraphUser> *friend in bet.friends) {
            NSMutableDictionary *newParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                              [friend objectForKey:@"id"],                   @"invitee",
                                              ownerString,                 @"inviter",
                                              @"open",                     @"status",
                                              [json objectForKey:@"id"],   @"bet_id",
                                              nil];
            // POST /invites => {data}
            [[API sharedInstance] post:@"invites" withParams:newParams onCompletion:^(NSDictionary *json) {
                // handle response
                NSLog(@"%@", json);
            }];
        }
    }];
    [[[UIAlertView alloc] initWithTitle: @"Congratulations!"
                                message: @"An invitation has been sent to your friends' Betchyu app."
                               delegate: nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

#pragma mark - UIAlertViewDelegate methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([alertView.title isEqualToString:@"Credit Card"]) {
        if ([alertView.message isEqualToString:@"Card is approved"]) {
            [self betchyu];
            // Then dismiss the paymentViewController
            // the loading thing is removed before the alert comes up
            [self.navigationController popViewControllerAnimated:NO];
            
            // make the summary VC
            BetSummaryVC *vc = [[BetSummaryVC alloc]initWithBet:self.bet];
            vc.title = @"Bet Summary";
            // show the summary vc
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            // the card was bad, so do nothing
        }
    } else if ([alertView.title isEqualToString:@"Email"]) {
        // don't do shit
    } else {
        // TRACK THIS SHIT AND ANALYZE IT
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        
        [tracker set:kGAIScreenName value:@"Card Info (step 5)"];
        [tracker send:[[GAIDictionaryBuilder createAppView] build]];
        
        // showing BrainTree's CrediCard processing page, after the user clicks the OK button on the alert we gave them
        BTPaymentViewController *paymentViewController = [BTPaymentViewController paymentViewControllerWithVenmoTouchEnabled:NO];
        CGRect f = CGRectMake(0, -63, self.view.frame.size.width, 90);
        BetterBraintreeView *sub = [[BetterBraintreeView alloc] initWithFrame:f];
        [paymentViewController.view addSubview:sub];
        [paymentViewController.tableView setContentInset:UIEdgeInsetsMake(78,0,0,0)];
        // setup it's delegate
        [BraintreeDelegateController sharedInstance].del = self;//the UIAlertViewDelegate
        [BraintreeDelegateController sharedInstance].bet = self.bet;
        [BraintreeDelegateController sharedInstance].ident = nil;
        [BraintreeDelegateController sharedInstance].email = sub.email;
        paymentViewController.delegate = [BraintreeDelegateController sharedInstance];
        // Now, display the navigation controller that contains the payment form
        [self.navigationController pushViewController:paymentViewController animated:YES];
    }
}


@end
