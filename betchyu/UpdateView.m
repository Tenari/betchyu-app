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
        
        int w = frame.size.width;
        int h = frame.size.height;
        
        // visual size/spacing parameters dependant upon frame.width
        int margin = 15;
        int fontSize = 17;
        if (frame.size.width > 700) {
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
        self.box.keyboardType      = UIKeyboardTypeNumbersAndPunctuation;
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
            prompt.frame = CGRectMake(margin, margin, frame.size.width - margin*2, frame.size.height/2);
            prompt.textAlignment = NSTextAlignmentCenter;
        } else {
            [self addSubview:box];
        }
        
        // Add everything
        [self addSubview:prompt];
        [self addSubview:updateBtn];
    }
    return self;
}

-(NSString*)getPromptText {
    NSString *n = [[bet valueForKey:@"noun"] lowercaseString];
    NSString * ret;
    
    //default
    ret = @"Today's Amount:";
    
    if ([n isEqualToString:@"smoking"]) {
        ret   = @"Did you smoke today?";
    } else if ( [n isEqualToString:@"pounds"] ) {
        ret   = @"Today's Weight:\t\t\t\t\tlbs";
    } else if ( [n isEqualToString:@"miles"] ) {
        ret   = @"Today I ran:\t\t\t\t\t   miles";
    } else if ( [n isEqualToString:@"times"] ) {
        ret   = @"Today I worked out:\t\t\t   times";
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
    if ([self betIsBinary]) {
        ProgressTrackingVC *vc = [[ProgressTrackingVC alloc] init];
        vc.title = @"Track Your Progress";
        [((AppDelegate *)([[UIApplication sharedApplication] delegate])).navController pushViewController:vc animated:YES];
        return;
    }
    if ( self.box.text.length == 0 ) {
        [self errorBox:YES];
        [self performSelector:@selector(errorBox:) withObject:NO afterDelay:1];
        return; // should show error
    }
    
    NSMutableDictionary* params =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  [NSNumber numberWithFloat:[self.box.text floatValue]],    @"value",
                                  [bet valueForKey:@"id"],                                  @"bet_id",
                                  nil];
    
    if ([[[bet valueForKey:@"verb"] lowercaseString] isEqualToString:@"lose"]) {
        float change = [[bet valueForKey:@"initial"] floatValue]- [self.box.text floatValue];
        [params setObject:[NSNumber numberWithFloat:change] forKey:@"value"];
    }
    //make the call to the web API
    // POST /updates => {data}
    [[API sharedInstance] post:@"updates" withParams:params onCompletion:^(NSDictionary *json) {
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


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end