//
//  UpdateView.m
//  betchyu
//
//  Created by Adam Baratz on 6/13/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.
//

#import "UpdateView.h"

@implementation UpdateView

@synthesize bet;
@synthesize box;
@synthesize btnLocked;

// the init method assumes that the bet is updated normally, until the end, where it modifies if it's binary/reverse
// view has 3 (or less) components:
//  - the text prompt
//  - the update drop-down Box
//  - the 'Update' button
- (id)initWithFrame:(CGRect)frame AndBet:(NSDictionary *)b
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialize the property
        self.bet = b;
        self.btnLocked = NO;
        
        int w = frame.size.width;
        int h = frame.size.height;
        
        // visual size/spacing parameters dependant upon frame.width
        int margin = 15;
        int fontSize = 17;
        if (frame.size.width > 500) {
            fontSize = 20;
            margin = 17;
        }
        
        // build the prompt component
        UILabel *prompt = [UILabel new];
        prompt.font     = [UIFont fontWithName:@"ProximaNova-Regular" size:fontSize];
        prompt.text     = [self getPromptText];
        prompt.frame    = CGRectMake(margin, margin, w, h/3);//w/1.5 - margin*2
        prompt.textColor= Bdark;
        
        // text field box
        self.box                   = [[UITextField alloc] initWithFrame:CGRectMake(w/2, margin, w/3 - margin*1.3, h/3)];
        self.box.keyboardType      = UIKeyboardTypeNumberPad;
        self.box.backgroundColor   = [UIColor clearColor];
        self.box.borderStyle       = UITextBorderStyleLine;
        self.box.textAlignment     = NSTextAlignmentCenter;
        self.box.font              = [UIFont fontWithName:@"ProximaNova-Regular" size:fontSize];
        self.box.tintColor         = Borange;
        self.box.textColor         = Borange;
        self.box.layer.borderColor = [Bmid CGColor];
        self.box.layer.borderWidth = 2.0f;
        self.box.delegate = self;
        self.box.adjustsFontSizeToFitWidth = YES;
        
        UIButton *updateBtn          = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        updateBtn.frame              = CGRectMake(w/4, h/2 + 9, w/2, h/2 - 18);
        updateBtn.backgroundColor    = Bgreen;
        updateBtn.layer.cornerRadius = 7;
        updateBtn.tintColor          = [UIColor whiteColor];
        updateBtn.titleLabel.font    = [UIFont fontWithName:@"ProximaNova-Bold" size:fontSize];
        [updateBtn setTitle:@"Update" forState:UIControlStateNormal];
        [updateBtn addTarget:self action:@selector(update:) forControlEvents:UIControlEventTouchUpInside];
        
        
        if ( [self betIsBinary] ) {
            /*prompt.frame = CGRectMake(margin, margin, frame.size.width - margin*2, frame.size.height/2);
            prompt.textAlignment = NSTextAlignmentCenter;*/
            BinaryProgressView * bpv = [[BinaryProgressView alloc] initWithFrame:self.bounds AndBet:bet];
            bpv.delegate = self;
            [self addSubview:bpv];
        } else {
            // Add everything
            [self addSubview:box];
            [self addSubview:prompt];
            [self addSubview:updateBtn];
        }
    }
    return self;
}

-(NSString*)getPromptText {
    NSString *n = [[bet valueForKey:@"noun"] lowercaseString];
    NSString * ret;
    
    //default
    ret = @"Today's Amount:";
    int w = self.frame.size.width;
    
    if ([n isEqualToString:@"smoking"]) {
        ret   = @"Did you smoke today?";
    } else if ( [n isEqualToString:@"pounds"] ) {
        ret   = w > 500 ? @"Today's Weight:\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\tlbs" : @"Today's Weight:\t\t\t\t\tlbs";
    } else if ( [n isEqualToString:@"miles"] ) {
        ret   = w > 500 ? @"Today I ran:\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\tmiles" :@"Today I ran:\t\t\t\t\t   miles";
    } else if ( [n isEqualToString:@"times"] ) {
        ret   = w > 500 ? @"Today I worked out:\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\ttimes" : @"Today I worked out:\t\t\t   times";
    }
    return ret;
}

-(BOOL)betIsBinary {
    NSString *n = [[bet valueForKey:@"noun"] lowercaseString];
    
    if ([n isEqualToString:@"smoking"]) {
        return YES;
    }
    return NO;
}


-(void)update:(id)sender {
    if (self.btnLocked) { return; }
    int max = [[self.bet valueForKey:@"initial"] integerValue] == 0 ? [[self.bet valueForKey:@"amount"] integerValue] *10 : 550;
    if ( self.box.text.length == 0 ||  [self.box.text floatValue] > max || [self.box.text floatValue] < 0) {
        [self errorBox:YES];
        [self performSelector:@selector(errorBox:) withObject:NO afterDelay:1];
        return; // should show error
    }
    
    self.btnLocked = YES;
    [[AlertMaker sharedInstance] cancelOldAndScheduleNewNotification];
    
    float amount = [[bet valueForKey:@"amount"] floatValue];
    float progress = ([[bet valueForKey:@"progress"] floatValue] / 100.0 * amount);
    
    NSMutableDictionary* params =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  [NSNumber numberWithFloat:[self.box.text floatValue]],    @"value",
                                  [bet valueForKey:@"id"],                                  @"bet_id",
                                  nil];
    
    if ([[[bet valueForKey:@"verb"] lowercaseString] isEqualToString:@"lose"]) {
        float change = [[bet valueForKey:@"initial"] floatValue]- [self.box.text floatValue];
        if (change >= amount) { // win condition for weight loss bets
            [self putWin];
            return; // prevents the POST below from happening
        }
        [params setObject:[NSNumber numberWithFloat:change] forKey:@"value"];
    } else {
        // win condition for standard bets
        if ([self.box.text floatValue] + progress >= amount)  {
            // if they won, don't bother posting the update, just make the bet be won
            [self putWin];
            return; // prevents the POST below from happening
        }
    }
    //make the call to the web API
    // POST /updates => {data}
    // the post come back with the new bet data
    [[API sharedInstance] post:@"updates" withParams:params onCompletion:^(NSDictionary *json) {
        [[AlertMaker sharedInstance] pickAndShowCorrectUpdatedAlertFrom:json];
        [((AppDelegate *)([[UIApplication sharedApplication] delegate])).navController popToRootViewControllerAnimated:NO];
        
        MyBetDetailsVC *vc = [[MyBetDetailsVC alloc] initWithJSONBet:json];
        vc.title = @"My Bet";
        [((AppDelegate *)([[UIApplication sharedApplication] delegate])).navController pushViewController:vc animated:NO];
    }];
    
}
-(void)putWin {
    NSMutableDictionary * params2 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                     ((AppDelegate *)([[UIApplication sharedApplication] delegate])).ownId, @"user",
                                     [bet valueForKey:@"id"], @"bet_id",
                                     @"true", @"win",
                                     nil];
    [[API sharedInstance] put:@"/pay" withParams:params2 onCompletion:^(NSDictionary *json) {
        if (((NSArray *)[bet valueForKey:@"opponents"]).count == 0) {
            [[[UIAlertView alloc] initWithTitle:@"YOU WIN"
                                        message:@"Congratulations, you've just won this bet, and it will now be visible on your 'Past Bets' screen. There's no prize, though, because no friend accepted your bet..."
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles: nil]
             show];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"YOU WIN"
                                        message:@"Congratulations, you've just won this bet, and it will now be visible on your 'Past Bets' screen. Expect a gift card in your email in a few days."
                                       delegate:nil
                              cancelButtonTitle:@"Sweet"
                              otherButtonTitles: nil]
             show];
        }
        [((AppDelegate *)([[UIApplication sharedApplication] delegate])).navController popToRootViewControllerAnimated:YES];
    }];
}

-(void)errorBox:(BOOL)error {
    if (error) {
        self.box.layer.borderColor = [Bred CGColor];
    } else {
        self.box.layer.borderColor = [Bmid CGColor];
    }
}

#pragma mark UITextFieldDelegate shit

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    UIScrollView *sup = ((UIScrollView *)self.superview);
    CGPoint bottomOffset = CGPointMake(0, sup.contentSize.height - sup.bounds.size.height);
    [sup setContentOffset:bottomOffset animated:YES];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]].location == NSNotFound) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark BinaryProgressViewDelegate shit
// when this is called, it means they lost the bet
- (void)updated:(NSDictionary *)params {
    if (self.btnLocked) { return; }
    self.btnLocked = YES;
    NSMutableDictionary * params2 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                     ((AppDelegate *)([[UIApplication sharedApplication] delegate])).ownId, @"user",
                                     [params valueForKey:@"bet_id"], @"bet_id",
                                     @"f", @"win",
                                     nil];
    [[API sharedInstance] put:@"/pay" withParams:params2 onCompletion:^(NSDictionary *json) {
        [((AppDelegate *)([[UIApplication sharedApplication] delegate])).navController popToRootViewControllerAnimated:YES];
    }];
    
}

@end
