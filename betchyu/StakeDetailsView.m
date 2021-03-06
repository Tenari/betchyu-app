//
//  StakeDetailsView.m
//  betchyu
//
//  Created by Adam Baratz on 6/17/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.
//

#import "StakeDetailsView.h"

@implementation StakeDetailsView

@synthesize stakeType;
@synthesize amountLabel;
@synthesize totalAmountLabel;

- (id)initWithFrame:(CGRect)frame AndStakeType:(NSString *)type
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        stakeType = type;
        int w = frame.size.width;
        
        int headerHeight = 70;
        int headerCircleWidth = 50;
        int headerImgXoff = 9;
        int headerImgYoff = 12;
        
        
        // Header Label
        UIView *header          = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, headerHeight)];
        header.backgroundColor  = [UIColor whiteColor];
        
        UILabel *headerLbl      = [[UILabel alloc]initWithFrame:CGRectMake(70, 0, w- 90, headerHeight)];
        headerLbl.text          = [NSString stringWithFormat:@"I will bet each opponent a gift card to %@.", [[type componentsSeparatedByString:@" "] objectAtIndex:0]];
        headerLbl.textColor     = Borange;
        headerLbl.font          = [UIFont fontWithName:@"ProximaNova-Regular" size:17];
        headerLbl.lineBreakMode = NSLineBreakByWordWrapping;
        headerLbl.numberOfLines = 0;
        [header addSubview:headerLbl];
        
        UIView * headerCircle = [[UIView alloc]initWithFrame:CGRectMake(10, 8, headerCircleWidth, headerCircleWidth)];
        headerCircle.layer.borderColor = Borange.CGColor;
        headerCircle.layer.borderWidth = 2;
        headerCircle.layer.cornerRadius = headerCircleWidth/2;
        UIImageView *headerImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"card-09.png"]];
        headerImg.frame = CGRectMake(headerImgXoff, headerImgYoff, headerCircleWidth-2*headerImgXoff, headerCircleWidth - 2*headerImgYoff);
        [headerCircle addSubview:headerImg];
        [header addSubview:headerCircle];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, header.frame.size.height - 2, w, 2)];
        line.backgroundColor = Bmid;
        [header addSubview:line];
        
        // Main Big Image
        int mainImgYoff = header.frame.size.height + header.frame.origin.y + 10; // 10 for padding
        
        UIView *mainImgContainer = [[UIView alloc] initWithFrame:CGRectMake(w/3, mainImgYoff, w/3, w/3)];
        mainImgContainer.layer.cornerRadius = mainImgContainer.frame.size.width/2;
        mainImgContainer.layer.borderColor = Borange.CGColor;
        mainImgContainer.layer.borderWidth = 3;
        mainImgContainer.clipsToBounds = YES;
        mainImgContainer.layer.masksToBounds = YES;
        UIImageView * mainImgImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",stakeType]]];
        mainImgImg.frame = CGRectMake(4, 4, w/3 - 8, w/3 - 8);
        [mainImgContainer addSubview:mainImgImg];
        
        // @"For the Amount of" Label
        int forTheAmountOfYoff = mainImgYoff + w/3 + 10; // 10 for padding
        int forTheAmountOfHeight = 30;
        int forTheAmountOfFontSize = 18;
        UILabel *forTheAmountOf = [[UILabel alloc] initWithFrame:CGRectMake(0, forTheAmountOfYoff, w, forTheAmountOfHeight)];
        forTheAmountOf.text = @"For the amount of:";
        forTheAmountOf.font = [UIFont fontWithName:@"ProximaNova-Bold" size:forTheAmountOfFontSize];
        forTheAmountOf.textAlignment = NSTextAlignmentCenter;
        forTheAmountOf.textColor = Borange;
        
        // amountLabel is a property so that it can be updated by VC
        int amountLabelYoff     = forTheAmountOfYoff + forTheAmountOfHeight + 10; // 10 for padding
        int amountLabelFontSize = 42;
        self.amountLabel        = [[UILabel alloc] initWithFrame:CGRectMake(0, amountLabelYoff, w, amountLabelFontSize + 8)];
        amountLabel.text        = @"$10";
        amountLabel.font        = [UIFont fontWithName:@"ProximaNova-Bold" size:amountLabelFontSize];
        amountLabel.textAlignment = NSTextAlignmentCenter;
        amountLabel.textColor   = Borange;
        
        // - button
        // + button are both taken care of by the VC
        
        // Intotal stake Label  is a property so that it can be updated by VC
        int totalAmountLabelYoff     = amountLabelYoff + amountLabelFontSize + 20; // 10 for padding
        self.totalAmountLabel        = [[UILabel alloc] initWithFrame:CGRectMake(0, totalAmountLabelYoff, w, forTheAmountOfHeight)];
        totalAmountLabel.text        = @"In total there is $30 at stake.";
        totalAmountLabel.font        = [UIFont fontWithName:@"ProximaNova-Bold" size:forTheAmountOfFontSize];
        totalAmountLabel.textAlignment = NSTextAlignmentCenter;
        totalAmountLabel.textColor   = Borange;
        totalAmountLabel.clipsToBounds = NO;
        totalAmountLabel.layer.masksToBounds = NO;
        UIView *l = [[UIView alloc]initWithFrame:CGRectMake(15, -5, w-30, 2)];
        l.backgroundColor = Blight;
        [totalAmountLabel addSubview:l];
        
        // Review Bet button is taken care of by the VC
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, totalAmountLabelYoff + forTheAmountOfHeight + 140);
        
        // set up the self stuff
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:header];
        [self addSubview:mainImgContainer];
        [self addSubview:forTheAmountOf];
        [self addSubview:amountLabel];
        [self addSubview:totalAmountLabel];
    }
    return self;
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
