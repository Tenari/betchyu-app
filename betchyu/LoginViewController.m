//  LoginViewController.m
//  iBetchyu
//
//  Created by Daniel Zapata on 11/16/13.
//  Copyright (c) 2013 Betchyu Computer. All rights reserved.

#import "LoginViewController.h"
#import "AppDelegate.h"

@interface LoginViewController ()
-(IBAction)performLogin:(id)sender;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end

@implementation LoginViewController
@synthesize spinner;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.screenName = @"Login Screen";
    }
    return self;
}

-(void)loadView {
    // Create main UIScrollView (the container for home page buttons)
    UIScrollView *mainView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    int h = mainView.frame.size.height;
    int w = mainView.frame.size.width;
    mainView.contentSize   = CGSizeMake(w, h);
    [mainView setBackgroundColor:[UIColor colorWithRed:1.0 green:(117.0/255.0) blue:(63/255.0) alpha:1.0]];
    
    
    // make the logo
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
    logo.frame = CGRectMake(w/2 - w/8, h/10, w/4, w/4);
    
    // The Title Text
    UILabel *betchyu      = [[UILabel alloc] initWithFrame:CGRectMake(10, h/3, w-20, 55)];
    betchyu.textAlignment = NSTextAlignmentCenter;
    betchyu.font          = [UIFont fontWithName:@"ProximaNova-Black" size:50];
    betchyu.textColor     = [UIColor whiteColor];
    betchyu.text          = @"BETCHYU";
    
    // The Title Text
    UILabel *motto      = [[UILabel alloc] initWithFrame:CGRectMake(10, h/3 + 55, w-20, 50)];
    motto.textAlignment = NSTextAlignmentCenter;
    motto.font          = [UIFont fontWithName:@"ProximaNova-Regular" size:16];
    motto.textColor     = [UIColor blackColor];
    motto.text          = @"Cracking the Code on Motivation";
    
    // Make the homepage Buttons
    // "facebook login" button
    UIButton *login = [[UIButton alloc] initWithFrame:CGRectMake(40, 2*h/3, w-80, 50)];
    login.backgroundColor = [UIColor colorWithRed:(71.0/255.0) green:(99.0/255.0) blue:(158.0/255.0) alpha:1.0];
    login.layer.cornerRadius = 6;
    login.clipsToBounds = YES;
    [login setTitle:@"Login with Facebook" forState:UIControlStateNormal];
    [login addTarget:self action:@selector(performLogin:) forControlEvents:UIControlEventTouchUpInside];
    
    //add the subviews
    [mainView addSubview:logo];
    [mainView addSubview:betchyu];
    [mainView addSubview:motto];
    [mainView addSubview:login];
    
    
    self.view = mainView;
}

- (IBAction)performLogin:(id)sender{
    [self.spinner startAnimating];
    
    AppDelegate* appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate openSession];
}
- (void)loginFailed
{
    // User switched back to the app without authorizing. Stay here, but
    // stop the spinner.
    [self.spinner stopAnimating];
}

@end
