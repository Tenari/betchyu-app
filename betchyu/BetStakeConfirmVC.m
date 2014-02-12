//
//  BetStakeConfirmVC.m
//  iBetchyu
//
//  Created by Betchyu Computer on 11/24/13.
//  Copyright (c) 2013 Betchyu Computer. All rights reserved.
//

#import "BetStakeConfirmVC.h"
#import "BigButton.h"
#import "BetFinalizeVC.h"

@interface BetStakeConfirmVC ()

@end

@implementation BetStakeConfirmVC

@synthesize stakeLabel;
@synthesize verboseLabel;
@synthesize stakeImageHeight;
@synthesize bet;
@synthesize currentStake;
@synthesize fbFriendVC;

- (id)initWithBet:(TempBet *)betObj {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        self.stakeImageHeight = 280;
        self.bet = betObj;
        if ([bet.ownStakeType isEqualToString:@"Amazon Gift Card"]) {
            self.currentStake = 10;
        } else {
            self.currentStake = 1;
        }
    }
    return self;
}

- (void) loadView {
    // Create main UIScrollView (the container for what follows)
    UIScrollView *mainView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    int h = mainView.frame.size.height - 40;
    int w = mainView.frame.size.width;
    mainView.contentSize   = CGSizeMake(w, h);
    [mainView setBackgroundColor:[UIColor colorWithRed:(39/255.0) green:(37/255.0) blue:(37/255.0) alpha:1.0]];
    
    /////////////////////
    // Stake Amount UI //
    /////////////////////
    UIImageView *stakePic = [[UIImageView alloc] initWithImage:
                             [UIImage imageNamed:
                              [bet.ownStakeType stringByAppendingString:@".jpg"]]];
    stakePic.frame = CGRectMake(0, 0, w, h/2);
    
    UIButton *up = [[UIButton alloc] initWithFrame:CGRectMake(w/2 - 25, 20, 50, 50)];
    [up setTitle:@"+" forState:UIControlStateNormal];
    up.font = [UIFont fontWithName:@"ProximaNova-Black" size:40];
    [up setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
    [up addTarget:self action:@selector(increaseStake:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *dwn = [[UIButton alloc] initWithFrame:CGRectMake(w/2 - 25, 180, 50, 50)];
    [dwn setTitle:@"-" forState:UIControlStateNormal];
    dwn.font = [UIFont fontWithName:@"ProximaNova-Black" size:40];
    [dwn setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
    [dwn addTarget:self action:@selector(lowerStake:) forControlEvents:UIControlEventTouchUpInside];
    
    stakeLabel               = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, w, 70)];
    stakeLabel.textAlignment = NSTextAlignmentCenter;
    stakeLabel.textColor     = [UIColor whiteColor];
    stakeLabel.font          = [UIFont fontWithName:@"ProximaNova-Black" size:40];
    stakeLabel.shadowColor   = [UIColor blackColor];
    stakeLabel.shadowOffset  = CGSizeMake(-1, 1);
    
    [mainView addSubview:stakePic];
    [mainView addSubview:up];
    [mainView addSubview:dwn];
    [mainView addSubview:stakeLabel];
    
    verboseLabel               = [[UILabel alloc] initWithFrame:CGRectMake(10, h/2, w-20, 80)];
    verboseLabel.numberOfLines = 0;
    verboseLabel.textColor     = [UIColor whiteColor];
    verboseLabel.font          = [UIFont fontWithName:@"ProximaNova-Regular" size:20];
    [self updateLabels];
    [mainView addSubview:verboseLabel];
    
    /////////////////
    // Next Button //
    /////////////////
    BigButton *nextBtn = [[BigButton alloc] initWithFrame:CGRectMake(20, h-120, w-40, 100)
                                                  primary:0
                                                    title:@"Set Stake"];
    [nextBtn addTarget:self
                action:@selector(setBetStake:)
      forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:nextBtn];
    
    
    // add the UIScrollView we've been compiling to the actual screen.
    self.view = mainView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Move on to selecting their friend
-(void)setBetStake:(id)sender {
    [[[UIAlertView alloc] initWithTitle: @"Reminder"
                                message: @"It is up to you and your friend to pay this stake after the bet. Betchyu just helps you track things."
                               delegate: nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
    
    if (!fbFriendVC) {
        fbFriendVC = [[FBFriendPickerViewController alloc] initWithNibName:nil bundle:nil];
        // Set the friend picker delegate
        fbFriendVC.delegate = self;
        
        fbFriendVC.title = @"Select friends";
    }
    
    [fbFriendVC loadData];
    [self presentViewController:self.fbFriendVC animated:YES completion:^(void){
        [self addSearchBarToFriendPickerView];
    }];
}
-(void)increaseStake:(id)sender {
    if ([bet.ownStakeType isEqualToString:@"Amazon Gift Card"]) {
        if (currentStake == 1){
            currentStake += 4;
        } else {
            currentStake += 5;
        }
    } else {
        currentStake++;
    }
    [self updateLabels];
}
-(void)lowerStake:(id)sender {
    if (currentStake == 1) {
        return;
    }
    if ([bet.ownStakeType isEqualToString:@"Amazon Gift Card"]) {
        if (currentStake == 5){
            currentStake -= 4;
        } else {
            currentStake -= 5;
        }
    } else {
        currentStake--;
    }
    [self updateLabels];
}

- (void) updateLabels {
    if ([bet.ownStakeType isEqualToString:@"Amazon Gift Card"]) {
        stakeLabel.text = [NSString stringWithFormat:@"$%i", currentStake];
    } else {
        if (currentStake == 1) {
            stakeLabel.text = [[[@(currentStake) stringValue] stringByAppendingString:@" "] stringByAppendingString:bet.ownStakeType];
        } else {
            stakeLabel.text = [NSString stringWithFormat:@"%i %@s", currentStake, bet.ownStakeType];
        }
    }
    verboseLabel.text = [@"If I successfully complete my challenge, you owe me " stringByAppendingString:stakeLabel.text];
    bet.ownStakeAmount = [NSNumber numberWithInt:currentStake];
    bet.opponentStakeAmount = bet.ownStakeAmount;
}

//////////////////////
// search bar stuff
//////////////////////
- (void)addSearchBarToFriendPickerView {
    if (self.searchBar == nil) {
        CGFloat searchBarHeight = 44.0;
        self.searchBar =
        [[UISearchBar alloc]
         initWithFrame:
         CGRectMake(0,0,
                    self.view.bounds.size.width,
                    searchBarHeight)];
        self.searchBar.autoresizingMask = self.searchBar.autoresizingMask |
        UIViewAutoresizingFlexibleWidth;
        self.searchBar.delegate = self;
        self.searchBar.showsCancelButton = YES;
        /*self.searchBar.barTintColor = [UIColor colorWithRed:1.0 green:(117.0/255.0) blue:(63/255.0) alpha:1.0];
        self.searchBar.translucent = NO;*/
        
        [self.fbFriendVC.canvasView addSubview:self.searchBar];
        CGRect newFrame = self.fbFriendVC.view.bounds;
        newFrame.size.height -= searchBarHeight;
        newFrame.origin.y = searchBarHeight;
        self.fbFriendVC.tableView.frame = newFrame;
    }
}

- (void) handleSearch:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    self.searchText = searchBar.text;
    [self.fbFriendVC updateView];
}

- (void)searchBarSearchButtonClicked:(UISearchBar*)searchBar {
    [self handleSearch:searchBar];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
    self.searchText = nil;
    [searchBar resignFirstResponder];
    [self.fbFriendVC updateView];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.searchText = searchText;
    [self.fbFriendVC updateView];
}

////////////////////////
// friend picker stuff
////////////////////////
- (void)friendPickerViewControllerSelectionDidChange:(FBFriendPickerViewController *)friendPicker {
    // need to clear the search, so that the facebookVC will re-determine the selection list.
    // this prevents bugs with search-selected people not being included in the actual invitations
    self.searchText = nil;
    [self.searchBar resignFirstResponder];
    [self.fbFriendVC updateView];
    // this re-updates the list of friends we're gonna use to make invitations.
    bet.friends = friendPicker.selection;
}

// handles the user touching the done button on the FB friend selector
- (void)facebookViewControllerDoneWasPressed:(id)sender {
    NSLog(@"%@", bet.friends);
    // handle the user NOT selecting a friend... bad users.
    if (bet.friends.count == 0) {
        [[[UIAlertView alloc] initWithTitle: @"Hey!"
                                    message: @"You have to pick a friend to continue."
                                   delegate: nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        return;
    } else {
        [self makePost:[NSNumber numberWithInt:0]];
    }
    [self dismissViewControllerAnimated:YES completion:^(void){}];
    
    BetFinalizeVC *vc = [[BetFinalizeVC alloc] initWithBet:bet];
    vc.title = @"Finalize Goal";
    
    [self.navigationController pushViewController:vc animated:YES];
}
// handles the user touching the done button on the FB friend selector
- (void)facebookViewControllerCancelWasPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)friendPickerViewController:(FBFriendPickerViewController *)friendPicker
                 shouldIncludeUser:(id<FBGraphUser>)user
{
    if (self.searchText && ![self.searchText isEqualToString:@""]) {
        NSRange result = [user.name
                          rangeOfString:self.searchText
                          options:NSCaseInsensitiveSearch];
        if (result.location != NSNotFound) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return YES;
    }
    return YES;
}

/**
 * A function for parsing URL parameters.
 */
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}


// index is the objectAtIndex of bet.friends used to get the friend's user id
- (void)makePost:(NSNumber *)index {
    
    // get facebook friend's ID from selection
    NSString* fid = ((id<FBGraphUser>)[bet.friends objectAtIndex:[index integerValue]]).id;
    
    //Make the post.
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                   @"Invitation to Betchyu", @"name",
                                   @"I just made a goal on Betchyu! Do you think I can do it?", @"caption",
                                   @"http://betchyu.com", @"link",
                                   fid, @"to",
                                   @"http://i.imgur.com/zq6D8lk.png", @"picture",
                                   @"Betchyu", @"name", nil];
    
    // attemp to post the story to friends walls
    [FBWebDialogs presentFeedDialogModallyWithSession:nil parameters:params handler:
     ^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
         if (error) {
             // Error launching the dialog or publishing a story.
             NSLog(@"Error publishing story.");
         } else {
             if (result == FBWebDialogResultDialogNotCompleted) {
                 // User clicked the "x" icon
                 NSLog(@"User canceled story publishing.");
             } else {
                 // Handle the publish feed callback
                 NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                 if (![urlParams valueForKey:@"post_id"]) {
                     // User clicked the Cancel button
                     NSLog(@"User canceled story publishing.");
                 } else {
                     // User clicked the Share button
                     NSString *msg = [NSString stringWithFormat:
                                      @"Posted story, id: %@",
                                      [urlParams valueForKey:@"post_id"]];
                     NSLog(@"%@", msg);
                 }
             }
         }
         if (bet.friends.count > [index integerValue]+1) {
             [self performSelector:@selector(makePost:) withObject:[NSNumber numberWithInt:([index integerValue]+1)] afterDelay:0];
         }
     }];
}
@end
