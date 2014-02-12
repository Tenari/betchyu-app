//
//  FlyoutMenuVC.m
//  betchyu
//
//  Created by Adam Baratz on 12/21/13.
//  Copyright (c) 2013 BetchyuLLC. All rights reserved.
//

#import "FlyoutMenuVC.h"
#import "ProfileView.h"
#import "AboutUs.h"
#import "HowItWorksVC.h"
#import "AppDelegate.h"
#import "Feedback.h"

@interface FlyoutMenuVC ()

@end

@implementation FlyoutMenuVC

@synthesize passedFrame;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        passedFrame = frame;
    }
    return self;
}

-(void)loadView {
    self.view = [[UIView alloc] initWithFrame:self.passedFrame];
    self.view.backgroundColor = [UIColor colorWithRed:(69/255.0) green:(69/255.0) blue:(69/255.0) alpha:1.0];
    UIView *lineView;
    ///////////////////////
    // My Profile Button
    ///////////////////////
    // The line above it
    lineView = [[UIView alloc] initWithFrame:CGRectMake(25, 50, passedFrame.size.width, 2)];
    lineView.backgroundColor = [UIColor whiteColor];
    // convenience frame
    CGRect useRect = CGRectMake(25, 60, 280, 40);
    // the button
    UIButton *myProfile = [[UIButton alloc] initWithFrame:useRect];
    [myProfile addTarget:self action:@selector(profileButtonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
    // The separate Text label for easier control
    UILabel *myProfileLabel = [[UILabel alloc] initWithFrame:useRect];
    myProfileLabel.text = @"My Profile";
    myProfileLabel.textColor = [UIColor whiteColor];
    myProfileLabel.font = [UIFont fontWithName:@"ProximaNova-Regular" size:20];
    // add all the subviews
    [self.view addSubview:myProfile];
    [self.view addSubview:myProfileLabel];
    [self.view addSubview:lineView];
    
    ///////////////////////
    // How It Works Button
    ///////////////////////
    // The line above it
    lineView = [[UIView alloc] initWithFrame:CGRectMake(25, 110, passedFrame.size.width, 2)];
    lineView.backgroundColor = [UIColor whiteColor];
    // convenience frame
    useRect = CGRectMake(25, 120, 280, 40);
    // the button
    UIButton *howWork = [[UIButton alloc] initWithFrame:useRect];
    [howWork addTarget:self action:@selector(howItWorksPressed:) forControlEvents:UIControlEventTouchUpInside];
    // The separate Text label for easier control
    UILabel *howWorkLabel = [[UILabel alloc] initWithFrame:useRect];
    howWorkLabel.text = @"How It Works";
    howWorkLabel.textColor = [UIColor whiteColor];
    howWorkLabel.font = [UIFont fontWithName:@"ProximaNova-Regular" size:20];
    // add all the subviews
    [self.view addSubview:howWork];
    [self.view addSubview:howWorkLabel];
    [self.view addSubview:lineView];
    
    ///////////////////////
    // Feedback Button
    ///////////////////////
    // The line above it
    lineView = [[UIView alloc] initWithFrame:CGRectMake(25, 170, passedFrame.size.width, 2)];
    lineView.backgroundColor = [UIColor whiteColor];
    // convenience frame
    useRect = CGRectMake(25, 180, 280, 40);
    // the button
    UIButton *feedback = [[UIButton alloc] initWithFrame:useRect];
    [feedback addTarget:self action:@selector(feedbackPressed:) forControlEvents:UIControlEventTouchUpInside];
    // The separate Text label for easier control
    UILabel *feedbackLabel  = [[UILabel alloc] initWithFrame:useRect];
    feedbackLabel.text      = @"Feedback";
    feedbackLabel.textColor = [UIColor whiteColor];
    feedbackLabel.font      = [UIFont fontWithName:@"ProximaNova-Regular" size:20];
    // add all the subviews
    [self.view addSubview:feedback];
    [self.view addSubview:feedbackLabel];
    [self.view addSubview:lineView];
    
    ///////////////////////
    // About Us Button
    ///////////////////////
    // The line above it
    lineView = [[UIView alloc] initWithFrame:CGRectMake(25, 230, passedFrame.size.width, 2)];
    lineView.backgroundColor = [UIColor whiteColor];
    // convenience frame
    useRect = CGRectMake(25, 240, 280, 40);
    // the button
    UIButton *about = [[UIButton alloc] initWithFrame:useRect];
    [about addTarget:self action:@selector(aboutUsPressed:) forControlEvents:UIControlEventTouchUpInside];
    // The separate Text label for easier control
    UILabel *aboutLabel = [[UILabel alloc] initWithFrame:useRect];
    aboutLabel.text = @"About Us";
    aboutLabel.textColor = [UIColor whiteColor];
    aboutLabel.font = [UIFont fontWithName:@"ProximaNova-Regular" size:20];
    // add all the subviews
    [self.view addSubview:about];
    [self.view addSubview:aboutLabel];
    [self.view addSubview:lineView];
    
    ///////////////////////
    // Logout Button
    ///////////////////////
    // The line above it
    lineView = [[UIView alloc] initWithFrame:CGRectMake(25, passedFrame.size.height-50, passedFrame.size.width, 2)];
    lineView.backgroundColor = [UIColor whiteColor];
    // convenience frame
    CGRect logoutRect = CGRectMake(25, passedFrame.size.height-50, 280, 40);
    // the button
    UIButton *logout = [[UIButton alloc] initWithFrame:logoutRect];
    [logout addTarget:self action:@selector(logoutButtonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
    // The separate Text label for easier control
    UILabel *logoutLabel = [[UILabel alloc] initWithFrame:logoutRect];
    logoutLabel.text = @"Logout";
    logoutLabel.textColor = [UIColor whiteColor];
    logoutLabel.font = [UIFont fontWithName:@"ProximaNova-Regular" size:20];
    // add all the subviews
    [self.view addSubview:logout];
    [self.view addSubview:logoutLabel];
    [self.view addSubview:lineView];
    
}
-(void) logoutButtonWasPressed:(id)sender {
    // switch back to the main menu for when they log back in
    [(MTStackViewController *)((AppDelegate *)([[UIApplication sharedApplication] delegate])).window.rootViewController toggleLeftViewControllerAnimated:YES];
    // actual FB API call to log out
    [FBSession.activeSession closeAndClearTokenInformation];
}
-(void) profileButtonWasPressed:(id)sender {
    UIViewController *vc =[[UIViewController alloc] init];
    vc.view = [[ProfileView alloc] initWithFrame:self.passedFrame AndOwner:self];
    // Show it.
    [self.navigationController pushViewController:vc animated:true];
}
-(void) howItWorksPressed:(id)sender {
    UIPageViewController *pvc = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    pvc.dataSource = self;
    pvc.view.frame = self.view.frame;
    
    HowItWorksVC *firstPage = [self viewControllerAtIndex:0];
    NSArray *viewControllers = [NSArray arrayWithObject:firstPage];
    
    [pvc setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    AppDelegate *app =(AppDelegate *)([[UIApplication sharedApplication] delegate]);
    
    [app.window setRootViewController:pvc];
    [app.window makeKeyAndVisible];
}
-(void) aboutUsPressed:(id)sender {
    UIViewController *vc =[[UIViewController alloc] init];
    vc.view = [[AboutUs alloc] initWithFrame:self.passedFrame AndOwner:self];
    // Show it.
    [self.navigationController pushViewController:vc animated:true];
}
-(void) feedbackPressed:(id)sender {
    UIViewController *vc =[[UIViewController alloc] init];
    vc.view = [[Feedback alloc] initWithFrame:self.passedFrame AndOwner:self];
    // Show it.
    [self.navigationController pushViewController:vc animated:true];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIPageViewControllerDataSource methods implementation
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(HowItWorksVC *)viewController index];
    
    if (index == 0) {
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(HowItWorksVC *)viewController index];
    
    
    index++;
    
    if (index == 6) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
    
}

- (HowItWorksVC *)viewControllerAtIndex:(NSUInteger)index {
    
    HowItWorksVC *childViewController = [[HowItWorksVC alloc] initWithNibName:nil bundle:nil];
    childViewController.index = index;
    
    return childViewController;
    
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    // The number of items reflected in the page indicator.
    return 6;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    // The selected item reflected in the page indicator.
    return 0;
}

@end
