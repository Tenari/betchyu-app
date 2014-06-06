//
//  BetTrackingVC.m
//  betchyu
//
//  Created by Daniel Zapata on 12/19/13.
//  Copyright (c) 2013 BetchyuLLC. All rights reserved.
//

#import "BetTrackingVC.h"
#import "BigButton.h"
#import "API.h"
#import "ExistingBetDetailsVC.h"

@interface BetTrackingVC ()

@end

@implementation BetTrackingVC

@synthesize betJSON;
@synthesize bet;
@synthesize updateText;
@synthesize slider;
@synthesize currentBooleanDate;
@synthesize previousUpdates;
@synthesize boolGraphSub;
@synthesize isFinished;

@synthesize hostView;

- (id)initWithJSON:(NSDictionary *)json {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        [NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehavior10_4];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //[NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        self.betJSON = json;
        self.bet = [[TempBet alloc] init];
        self.bet.duration = [betJSON valueForKey:@"endDate"];
        self.bet.createdAt = [dateFormatter dateFromString: [[betJSON valueForKey:@"created_at"] substringWithRange:NSMakeRange(0, 10)]];
        self.bet.verb = [betJSON valueForKey:@"verb"];
        self.bet.noun = [betJSON valueForKey:@"noun"];
        self.bet.amount = [betJSON valueForKey:@"amount"];
        self.bet.stakeAmount = [betJSON valueForKey:@"stakeAmount"];
        self.bet.stakeType = [betJSON valueForKey:@"stakeType"];
        self.bet.owner = [betJSON valueForKey:@"owner"];
        self.bet.initial = [betJSON valueForKey:@"initial"];
        
        self.previousUpdates = [NSArray array];
        
        self.isFinished = NO;
    }
    return self;
}

-(void)loadView {
    UIView *mainView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    [mainView setBackgroundColor:[UIColor colorWithRed:(39/255.0) green:(37/255.0) blue:(37/255.0) alpha:1.0]];
    
    if ([bet.verb isEqualToString:@"Stop"]) {
        self.view = [self makeBooleanUpdater:mainView];
    } else if ([bet.verb isEqualToString:@"Lose"]){   // the customization for the weight-loss bet-type
        self.view = [self makeWeightUpdater:mainView];
    } else {
        self.view = [self makeNormalUpdater:mainView];
    }
}
// Helper Method to create copy from bet type
-(NSString *)trackingHeading {
    if ([bet.verb isEqualToString:@"Stop"]) {
        return @"I DIDN'T SMOKE:";
    } else if ([bet.verb isEqualToString:@"Run"]){
        return @"TOTAL, I'VE RUN:";
    } else if ([bet.verb isEqualToString:@"Workout"]){
        return @"I'VE WORKED OUT:";
    } else if ([bet.verb isEqualToString:@"Lose"]){
        return @"TODAY, I WEIGH:";
    } else {
        return [NSString stringWithFormat:@"I'VE %@ED:", bet.verb];
    }
}

-(UIView *)makeBooleanUpdater:(UIView *)currentView {
    int w = currentView.frame.size.width;
    int h = currentView.frame.size.height;
    UIColor *bOr = [UIColor colorWithRed:1.0 green:(117.0/255.0) blue:(63/255.0) alpha:1.0];
    
    // The tracking summary heading
    UILabel *heading      = [[UILabel alloc] initWithFrame:CGRectMake(0, 75, w, 40)];
    heading.textAlignment = NSTextAlignmentCenter;
    heading.font          = [UIFont fontWithName:@"ProximaNova-Black" size:35];
    heading.textColor     = [UIColor whiteColor];
    heading.text          = [self trackingHeading];
    
    // The tracking day text
    self.updateText               = [[UILabel alloc] initWithFrame:CGRectMake(10, 120, w-20, 30)];
    self.updateText.textAlignment = NSTextAlignmentCenter;
    self.updateText.font          = [UIFont fontWithName:@"ProximaNova-Regular" size:25];
    self.updateText.textColor     = bOr;
    
    // update YES btn
    BigButton *update = [[BigButton alloc] initWithFrame:CGRectMake(20, 155, (w-40)/2-10, 50) primary:0 title:@"YES"];
    [update addTarget:self action:@selector(makeBoolUpdate:) forControlEvents:UIControlEventTouchUpInside];
    
    // update NO btn
    BigButton *updateNo = [[BigButton alloc] initWithFrame:CGRectMake((w-40)/2+20, 155, (w-40)/2-10, 50) primary:1 title:@"NO"];
    [updateNo addTarget:self action:@selector(makeBoolUpdate:) forControlEvents:UIControlEventTouchUpInside];
    
    // the data graph substitute
    self.boolGraphSub               = [[UILabel alloc] initWithFrame:CGRectMake(20, 175, w-40, h-175)];
    self.boolGraphSub.numberOfLines = 0;
    self.boolGraphSub.textAlignment = NSTextAlignmentCenter;
    self.boolGraphSub.font          = [UIFont fontWithName:@"ProximaNova-Black" size:30];
    self.boolGraphSub.textColor     = [UIColor whiteColor];
    int toGo = [self numberOfDaysTheBetLasts] - self.previousUpdates.count;
    self.boolGraphSub.text          = [NSString stringWithFormat:@"Days In A Row: %i\nDays To Go: %i", self.previousUpdates.count, toGo];
    
    
    // Add the subviews
    [currentView addSubview:self.slider];
    [currentView addSubview:heading];
    [currentView addSubview:self.updateText];
    [currentView addSubview:update];
    [currentView addSubview:updateNo];
    [currentView addSubview:self.boolGraphSub];
    
    [self booleanDateUpdate];
    
    return currentView;
}
// cusomized view for tracking weight, where we just ask them for their current weight
-(UIView *)makeWeightUpdater:(UIView *)currentView {
    currentView = [self makeNormalUpdater:currentView];
    
    // this valueForKey:@"current" requires the initially created Bet to include a current => WEIGHT_DATA mapping in it, which is a TODO
    float val = bet.initial == 0 ? 200.0 : [bet.initial floatValue];
    self.slider.minimumValue = val - [bet.amount floatValue];
    self.slider.maximumValue = val + 3;
    self.slider.value = val;
    self.slider.transform = CGAffineTransformRotate(self.slider.transform, 180.0/180*M_PI);
    self.slider.minimumTrackTintColor = [UIColor whiteColor];
    self.slider.maximumTrackTintColor = [UIColor colorWithRed:1.0 green:(117.0/255.0) blue:(63/255.0) alpha:1.0];
    
    // add start/end bars
    CGRect f = self.slider.frame;
    int unit = f.size.width / (slider.maximumValue - slider.minimumValue);
    UIView *startBar = [[UIView alloc] initWithFrame:CGRectMake(f.origin.x + (3*unit), f.origin.y +14, 2, 22)];
    startBar.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
    [currentView addSubview:startBar];
    
    /*UIView *endBar = [[UIView alloc] initWithFrame:CGRectMake(f.origin.x + f.size.width - (3*unit), f.origin.y +14, 2, 22)];
    endBar.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
    [currentView addSubview:endBar];*/
    
    return currentView;
}
-(UIView *)makeNormalUpdater:(UIView *)currentView {
    int w = currentView.frame.size.width;
    int h = currentView.frame.size.height;
    UIColor *bOr = [UIColor colorWithRed:1.0 green:(117.0/255.0) blue:(63/255.0) alpha:1.0];
    
    // The tracking summary heading
    UILabel *heading      = [[UILabel alloc] initWithFrame:CGRectMake(0, 75, w, 40)];
    heading.textAlignment = NSTextAlignmentCenter;
    heading.font          = [UIFont fontWithName:@"ProximaNova-Black" size:35];
    heading.textColor     = [UIColor whiteColor];
    heading.text          = [self trackingHeading];
    
    // The tracking summary text
    self.updateText               = [[UILabel alloc] initWithFrame:CGRectMake(10, 140, w-20, 30)];
    self.updateText.textAlignment = NSTextAlignmentCenter;
    self.updateText.font          = [UIFont fontWithName:@"ProximaNova-Regular" size:25];
    self.updateText.textColor     = bOr;
    [self currentStateText];
    
    // tracking slider
    self.slider              = [[UISlider alloc] initWithFrame:CGRectMake(20, 170, w-40, 50)];
    self.slider.minimumValue = 0.0;
    self.slider.maximumValue = [bet.amount floatValue];
    [self.slider setMinimumTrackTintColor:bOr];
    [self.slider addTarget:self
                action:@selector(updateSliderValue:)
      forControlEvents:UIControlEventValueChanged];
    
    // update btn
    BigButton *update;
    if (h > 500) {
        update = [[BigButton alloc] initWithFrame:CGRectMake(20, h-90, w-40, 70) primary:0 title:@"UPDATE"];
    } else {
        update = [[BigButton alloc] initWithFrame:CGRectMake(20, h-65, w-40, 70) primary:0 title:@"UPDATE"];
    }
    [update addTarget:self action:@selector(makeUpdate:) forControlEvents:UIControlEventTouchUpInside];
    
    // the data graph
    /*self.graph = [[ProgressGraphView alloc] initWithFrame:CGRectMake(20, 230, w-40, h/3) AndDataArray:[NSArray array]];
    self.graph.backgroundColor = [UIColor whiteColor];*/
    
    // Add the subviews
    [currentView addSubview:self.slider];
    [currentView addSubview:heading];
    [currentView addSubview:self.updateText];
    [currentView addSubview:update];
    
    return currentView;
}

// ===== NORMAL BET-TYPE METHODS ====== //
-(void)updateSliderValue: (id)sender {
    int amount = (int)(((UISlider *)sender).value);
    updateText.text = [[@(amount) stringValue] stringByAppendingString:[@" " stringByAppendingString:bet.noun]];
}
// sets the UISlider starting value and the text starting description based on the result of an API call
-(void)currentStateText {
    NSString* path =[NSString stringWithFormat:@"bets/%@/updates", [betJSON valueForKey:@"id"]];
    
    //make the call to the web API
    // GET /bets/:bet_id/updates => {data}
    [[API sharedInstance] get:path withParams:nil onCompletion:^(NSDictionary *json) {
        //success
        self.previousUpdates = (NSArray*)json;
        if (((NSArray*)json).count > 0) {
            int val = [[[((NSArray*)json) objectAtIndex:(((NSArray*)json).count-1)] valueForKey:@"value"] intValue];
            self.updateText.text = [NSString stringWithFormat:@"%i %@", val, bet.noun];
            self.slider.value = [[NSNumber numberWithInt:val] floatValue];
            //bet.current = @(val);
        } else {
            if (self.slider.value == 0.0) {
                self.updateText.text = [NSString stringWithFormat:@"0 %@", bet.noun];
                self.slider.value = self.slider.value == 0.0 ? 0.0 : self.slider.value;
            } else {
                self.updateText.text = [NSString stringWithFormat:@"%i %@", (int)self.slider.value, bet.noun];
            }
        }
        //[self initPlot];
        [self.hostView makeVisual];
        [self handleBetFinish];
    }];
}
- (void)makeUpdate:(id)sender {
    if (self.isFinished) { return; } // bail because bet is done.
    
    NSMutableDictionary* params =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  [NSNumber numberWithFloat:self.slider.value], @"value",
                                  [betJSON valueForKey:@"id"],                  @"bet_id",
                                  nil];
    //make the call to the web API
    // POST /updates => {data}
    [[API sharedInstance] post:@"updates" withParams:params onCompletion:
     ^(NSDictionary *json) {
         //success
         [self currentStateText];
     }];
}

// ===== BOOLEAN BET-TYPE METHODS ====== //
- (void)makeBoolUpdate:(BigButton *)sender {
    
    if (self.isFinished) { return; /* bail because bet is done. */ }
    
    if ([currentBooleanDate compare:[NSDate date]] > 0) {
        [[[UIAlertView alloc] initWithTitle: @"Sorry..."
                                    message: @"That day hasn't happened just yet."
                                   delegate: nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        return;
    }
    int val = [sender.currentTitle isEqualToString:@"YES"] ? 1 : 0 ;
    
    /*if (previousUpdates.count ==) {
        
    }*/
    
    NSMutableDictionary* params =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  [NSNumber numberWithInt:val], @"value",
                                  [betJSON valueForKey:@"id"],  @"bet_id",
                                  nil];
    
    //make the call to the web API
    // POST /updates => {data}
    [[API sharedInstance] post:@"updates" withParams:params onCompletion:^(NSDictionary *json) {
        //success
        
        // REDRAW self.graph
        
        //[self.navigationController popToRootViewControllerAnimated:YES];
        [self booleanDateUpdate];
    }];
    
}
-(void)booleanDateUpdate {
    NSString* path =[NSString stringWithFormat:@"bets/%@/updates", [betJSON valueForKey:@"id"]];
    
    //make the call to the web API
    // GET /bets/:bet_id/updates => {data}
    [[API sharedInstance] get:path withParams:nil onCompletion:
     ^(NSDictionary *json) {
         //success
         self.previousUpdates = (NSArray *)json;
         
         if (((NSArray*)json).count > 0) {
             NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
             dayComponent.day = ((NSArray*)json).count;
             
             NSCalendar *theCalendar = [NSCalendar currentCalendar];
             currentBooleanDate = [theCalendar dateByAddingComponents:dayComponent toDate:bet.createdAt options:0];
         } else {
             currentBooleanDate = bet.createdAt;
         }
         
         NSString *dateString = [[NSString stringWithFormat:@"%@", currentBooleanDate] substringWithRange:NSMakeRange(0, 10)];
         self.updateText.text = [NSString stringWithFormat:@"on %@", dateString];
         int toGo = [self numberOfDaysTheBetLasts] - self.previousUpdates.count;
         self.boolGraphSub.text = [NSString stringWithFormat:@"Days In A Row: %i\nDays To Go: %i", self.previousUpdates.count, toGo];
         [self handleBetFinish];
     }];
}

// helper methods
-(NSArray *)eachDateStringForTheBet {
    NSMutableArray *dates = [NSMutableArray array];
    NSDate *date;
    for (long i = 0; i < [self numberOfDaysTheBetLasts]; i++) {
        NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
        dayComponent.day = i;
        
        NSCalendar *theCalendar = [NSCalendar currentCalendar];
        date = [theCalendar dateByAddingComponents:dayComponent toDate:bet.createdAt options:0];
        [dates addObject:[[NSString stringWithFormat:@"%@", date] substringWithRange:NSMakeRange(5, 5)]];
    }
    
    return [dates subarrayWithRange:NSMakeRange(0, dates.count)];
}
-(void)handleBetFinish {
    if (self.isFinished) { return; }
    // useful vars
    /*NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit
                                                        fromDate:bet.endDate
                                                          toDate:[NSDate date]
                                                         options:0];*/
    // handle boolean-type bets
    if ([bet.noun isEqualToString:@"Smoking"]) {
        for (NSDictionary *obj in self.previousUpdates) {
            if ([[obj valueForKey:@"value"] integerValue] == 0){
                // handle loss and break execution
                [self loseTheBet];
                return;
            }
        }
        if (self.previousUpdates.count != [self numberOfDaysTheBetLasts]) { // there have not been enough updates to know if the bet is over
            return;
        } else {
            // else they won, handle win and break execution
            /*UIAlertView *alert = [[UIAlertView alloc] init];
            [alert setTitle:@"Goal Completed!"];
            [alert setMessage:@"You have won this bet! Has your friend paid you yet?"];
            [alert setDelegate:self];
            [alert addButtonWithTitle:@"Yes"];
            [alert addButtonWithTitle:@"No"];
            [alert show];
            self.isFinished = YES;*/
            [self winTheBet];
            return;
        }
    } else if ([bet.noun isEqualToString:@"pounds"]) {
        // if the latest update is smaller than the goal weight
        if ((self.previousUpdates.count > 0) &&
            (([bet.initial intValue] - [bet.amount intValue]) == [[[previousUpdates lastObject] valueForKey:@"value"] integerValue])) {
            
            // they win
            [self winTheBet];
        } else { //if (components.day >= 1) {
            [self loseTheBet];
        }
        // else, it's all good.
        return;  // bail to prevent other checks from being run--we ran everything we need to already.
    }
    
    // handle normal-type bets
    int current = (int)slider.value;
    // If user has WON the bet
    if (current >= [bet.amount intValue]) {
        [self winTheBet];
    } else { //if (components.day >= 1) {  // the user has not won the bet, and the bet time has expired,
        // the user LOST the bet
        [self loseTheBet];
    }
}

// shows a pop-up to alert the user that he lost the bet
// and tells the server to update the bet/submit the transaction for completion
-(void)loseTheBet {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Goal Failed!"
                                                    message:@"You lost this bet! The card you entered originally will now be charged."
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    // delegate method tells them the bet is done and goes to the homepage when they press OK
    
    self.isFinished = YES;
    
    // send a message to server informing of the grand occurences
    NSMutableDictionary* params =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  [betJSON valueForKey:@"id"], @"bet_id",
                                  [betJSON valueForKey:@"owner"], @"user",
                                  nil];
    // PUT /pay = {bet_id=> bet#, user => self#}
    [[API sharedInstance] put:@"pay" withParams:params onCompletion:^(NSDictionary *json) {
        NSLog(@"%@", json);
    }];
}
// shows an alert to tell the user that he won the bet
// sends an update to the server to submit the transaction for completion
-(void)winTheBet {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Goal Completed!"
                                                    message:@"You won this bet! The prize will now be purchased by your friend."
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    // delegate method tells them the bet is done and goes to the homepage when they press OK
    
    self.isFinished = YES;
    
    // Inform Lord SERVERus immediatley, slave!
    NSMutableDictionary* params =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  [betJSON valueForKey:@"id"], @"bet_id",
                                  [betJSON valueForKey:@"opponent"], @"user", // we won, so it's the opponent who's gotta pay
                                  nil];
    // PUT /pay = {bet_id=> bet#, user => opponent#}
    [[API sharedInstance] put:@"pay" withParams:params onCompletion:^(NSDictionary *json) {
        NSLog(@"%@", json);
    }];
}

// navigation method(s)
-(void)showDetailsPage:(id)sender {
    ExistingBetDetailsVC *vc =[[ExistingBetDetailsVC alloc] initWithJSON:self.betJSON];
    vc.isOwn = YES;
    // Show it.
    [self.navigationController pushViewController:vc animated:true];
}

#pragma mark - UIViewController lifecycle methods
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (![bet.verb isEqualToString:@"Stop"]) {
        //[self initPlot];
        int h = self.view.frame.size.height;
        int w = self.view.frame.size.width;
        
        if (h > 500) {
            self.hostView = [(Graph *) [Graph alloc] initWithFrame:CGRectMake(20, 230, w-40, h/3)];
        } else {
            self.hostView = [(Graph *) [Graph alloc] initWithFrame:CGRectMake(20, 215, w-40, h/3)];
        }
        self.hostView.delegate = self;
        if ([bet.verb isEqualToString:@"Lose"]) { self.hostView.isWeightLoss = YES; }
        [self.hostView makeVisual];
        [self.view addSubview:self.hostView];
    } else {
        [self booleanDateUpdate];
    }
    [self handleBetFinish];
}
- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"info_button.png"] style:UIBarButtonItemStylePlain target:self action:@selector(showDetailsPage:)];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - GraphDelagate methods
-(int)max {
    return (int)self.slider.maximumValue;
}
-(int) min {
    return (int)self.slider.minimumValue;
}
-(NSArray *) valsArr {
    return self.previousUpdates;
}
-(int) xCoordForIndex:(int)index {
    if ([bet.verb isEqualToString:@"Stop"]) {
        //
    } else {
        /*
        [NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehavior10_4];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //[NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *objDate = [dateFormatter dateFromString: [[[self.previousUpdates objectAtIndex:index] valueForKey:@"created_at"] substringWithRange:NSMakeRange(0, 10)]];
        NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit
                                                            fromDate:objDate
                                                              toDate:bet.endDate
                                                             options:0];
        return [bet.duration intValue] - [components day];*/
    }
    return 0;
}

#pragma mark - UIAlertViewDelegate methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    /*
    if ([alertView.title isEqualToString:@"Goal Completed!"]) {
        if (buttonIndex == 0) {
            // Yes, bet payment was received
            NSString* path =[NSString stringWithFormat:@"bets/%@", [betJSON valueForKey:@"id"]];
            NSMutableDictionary* params =[NSMutableDictionary dictionaryWithObjectsAndKeys:@"true", @"received", nil];
            // PUT /bets/:id = {received=> true}
            [[API sharedInstance] put:path withParams:params onCompletion:
             ^(NSDictionary *json) {
                 //success do nothing...
                 [self popUpToFinishBet];
                 [self.navigationController popToRootViewControllerAnimated:YES];
             }];
        }
        else if (buttonIndex == 1) {
            // No, bet payment was not received
            // do nothing.
            [self showDetailsPage:nil];
        }
    } else {
        if (buttonIndex == 0) {
            // Yes, bet payment was paid
            NSString* path =[NSString stringWithFormat:@"bets/%@", [betJSON valueForKey:@"id"]];
            NSMutableDictionary* params =[NSMutableDictionary dictionaryWithObjectsAndKeys:@"true", @"paid", nil];
            // PUT /bets/:id = {received=> true}
            [[API sharedInstance] put:path withParams:params onCompletion:
             ^(NSDictionary *json) {
                 //success do nothing...
                 [self popUpToFinishBet];
                 [self.navigationController popToRootViewControllerAnimated:YES];
             }];
        }
        else if (buttonIndex == 1) {
            // No, bet payment was not paid
            // do nothing.
            [self showDetailsPage:nil];
        }
    }*/
    if ([alertView.title hasPrefix:@"Goal"]) {
        [self popUpToFinishBet];
    } else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
-(void) popUpToFinishBet {
    [[[UIAlertView alloc] initWithTitle:@"Bet Finished!"
                                message:@"You're now done with this bet, and it won't show up on your list any more."
                               delegate:self
                      cancelButtonTitle:@"OK!"
                      otherButtonTitles:nil]
     show];
}

@end
