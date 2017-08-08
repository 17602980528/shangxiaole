//
//  OilAppriseAndAunserTableViewCell.m
//  BletcShop
//
//  Created by apple on 2017/8/8.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "OilAppriseAndAunserTableViewCell.h"

@implementation OilAppriseAndAunserTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.starRateView = [[XHStarRateView alloc] initWithFrame:CGRectMake(0, 0, self.appriseStars.frame.size.width,self.appriseStars.frame.size.height)];
    self.starRateView.userInteractionEnabled=NO;
    self.starRateView.isAnimation = YES;
    self.starRateView.rateStyle = IncompleteStar;
    self.starRateView.tag = 1;
    self.starRateView.currentScore=3.5;
    [self.appriseStars addSubview:self.starRateView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
