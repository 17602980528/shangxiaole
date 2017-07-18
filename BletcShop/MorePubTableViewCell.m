//
//  MorePubTableViewCell.m
//  BletcShop
//
//  Created by apple on 2017/7/10.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "MorePubTableViewCell.h"

@implementation MorePubTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bgView.layer.cornerRadius=6.0f;
    self.bgView.clipsToBounds=YES;
    self.shopNameBgView.layer.cornerRadius=6.0f;
    self.shopNameBgView.clipsToBounds=YES;
    self.shopNameBgView.layer.borderColor=[RGB(229, 229, 229)CGColor];
    self.shopNameBgView.layer.borderWidth=1.0f;
    
    self.starRateView = [[XHStarRateView alloc] initWithFrame:CGRectMake(0, 0, self.appriseStars.frame.size.width,self.appriseStars.frame.size.height)];
    self.starRateView.userInteractionEnabled=NO;
    self.starRateView.isAnimation = YES;
    self.starRateView.rateStyle = IncompleteStar;
    self.starRateView.tag = 1;
    self.starRateView.currentScore=5.0;
    [self.appriseStars addSubview:self.starRateView];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end