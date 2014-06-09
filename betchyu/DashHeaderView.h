//
//  DashHeaderView.h
//  betchyu
//
//  Created by Adam Baratz on 6/2/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface DashHeaderView : UIView

@property FBProfilePictureView * profPic;
@property UIView * profBorder;

- (void) setUpProfilePic:(BOOL)notCalled;

@end