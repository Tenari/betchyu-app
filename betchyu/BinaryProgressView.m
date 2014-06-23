//  BinaryProgressView.m
//  betchyu
//
//  Created by Daniel Zapata on 6/19/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.

#import "BinaryProgressView.h"

@implementation BinaryProgressView

@synthesize yes;
@synthesize no;
@synthesize betID;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame AndBetId:(int)betId {
    self = [super initWithFrame:frame];
    if (self) {
        self.betID = betId;
        int w = frame.size.width;
        int h = frame.size.height;
        
        int sectH = h/3;
        int fontSize = sectH / 2.6f;
        int btnDim = w/10;
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = NO;
        self.clipsToBounds      = NO;
        self.layer.shadowColor  = [Bdark CGColor];
        self.layer.shadowRadius = 3.0f;
        self.layer.shadowOffset = CGSizeMake(0, 15);
        self.layer.shadowOpacity= 0.7f;
        self.layer.shadowPath   = [[UIBezierPath bezierPathWithRect:self.layer.bounds] CGPath];
        
        // Question Label
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd"];
        UILabel * q = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, w, sectH)];
        q.text      = @"Have you smoked yet?";
        q.font      = FregfS;
        q.textColor = Bmid;
        q.textAlignment = NSTextAlignmentCenter;
        
        // Yes No Label
        UILabel *yn = [[UILabel alloc] initWithFrame:CGRectMake(25, sectH, w, sectH)];
        yn.text     = @"Yes\t\t\t No";
        yn.font     = FregfS;
        yn.textColor= Bmid;
        yn.textAlignment = NSTextAlignmentCenter;
        
        // Yes btn
        self.yes = [[UIButton alloc] initWithFrame:CGRectMake(w/4.5, sectH+((sectH-btnDim)/2), btnDim, btnDim)];
        [yes setImage:[UIImage imageNamed:@"check-22.png"] forState:(UIControlStateSelected|UIControlStateHighlighted)];
        [yes setTitle:@"" forState:UIControlStateNormal];
        [yes addTarget:self action:@selector(selectedBinary:) forControlEvents:UIControlEventTouchUpInside];
        yes.layer.borderColor = Bmid.CGColor;
        yes.layer.borderWidth = 2;
        yes.layer.cornerRadius = btnDim/2;
        yes.tag = 1;
        
        // No btn
        self.no = [[UIButton alloc] initWithFrame:CGRectMake(3*w/5, sectH+((sectH-btnDim)/2), btnDim, btnDim)];
        [no setImage:[UIImage imageNamed:@"check-22.png"] forState:(UIControlStateSelected|UIControlStateHighlighted)];
        [no setTitle:@"" forState:UIControlStateNormal];
        [no addTarget:self action:@selector(selectedBinary:) forControlEvents:UIControlEventTouchUpInside];
        no.layer.borderColor = Bmid.CGColor;
        no.layer.borderWidth = 2;
        no.layer.cornerRadius = btnDim/2;
        no.tag = 0;
        
        // Update button
        UIButton *update = [[UIButton alloc] initWithFrame:CGRectMake(w/4, 2*sectH, w/2, sectH*0.7f)];
        update.backgroundColor = Bgreen;
        update.layer.cornerRadius = 9;
        [update setTitle:@"Update" forState:UIControlStateNormal];
        update.tintColor = [UIColor whiteColor];
        [update addTarget:self action:@selector(updatePressed:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [self addSubview:q];
        [self addSubview:yn];
        [self addSubview:yes];
        [self addSubview:no];
        [self addSubview:update];
    }
    return self;
}

-(void) updatePressed:(UIButton *)sender {
    int val = self.no.selected ? 1 : 0 ;
    if (val == 1) {
        [((AppDelegate *)([[UIApplication sharedApplication] delegate])).navController popViewControllerAnimated:YES];
        return;
    } // don't bother updating in the successful case
    
    NSMutableDictionary* params =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  [NSNumber numberWithInt:val],     @"value",
                                  [NSNumber numberWithInt:betID],   @"bet_id",
                                  nil];
    
    //make the call to the web API
    // POST /updates => {data}
    [[API sharedInstance] post:@"updates" withParams:params onCompletion:^(NSDictionary *json) {
        [self.delegate updated:params];
    }];
}

-(void) selectedBinary:(UIButton *)sender {
    if (sender.tag == 1) { // yes button is 1, no button is 0
        self.yes.selected = YES;
        self.yes.highlighted = YES;
        [self.yes setImage:[UIImage imageNamed:@"check-22.png"] forState:UIControlStateNormal];
        
        self.no.selected = NO;
        self.no.highlighted = NO;
        [self.no setImage:[UIImage imageNamed:@"this is not an image"] forState:UIControlStateNormal];
        
    } else {
        self.no.selected = YES;
        self.no.highlighted = YES;
        [self.no setImage:[UIImage imageNamed:@"check-22.png"] forState:UIControlStateNormal];
        
        self.yes.selected = NO;
        self.yes.highlighted = NO;
        [self.yes setImage:[UIImage imageNamed:@"this is not an image"] forState:UIControlStateNormal];
    }
}

@end