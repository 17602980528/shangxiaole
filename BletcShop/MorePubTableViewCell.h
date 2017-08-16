//
//  MorePubTableViewCell.h
//  BletcShop
//
//  Created by apple on 2017/7/10.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHStarRateView.h"
@interface MorePubTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *shopNameBgView;
@property (weak, nonatomic) IBOutlet UIView *appriseStars;
@property (strong,nonatomic)XHStarRateView *starRateView;
@property (weak, nonatomic) IBOutlet UILabel *cardTrade;
@property (weak, nonatomic) IBOutlet UILabel *cardRemain;
@property (weak, nonatomic) IBOutlet UILabel *discription;
@property (weak, nonatomic) IBOutlet UIImageView *userHead;
@property (weak, nonatomic) IBOutlet UILabel *userNick;
@property (weak, nonatomic) IBOutlet UILabel *publishDate;
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UIButton *goShopBtn;
@property (weak, nonatomic) IBOutlet UIImageView *cardImageView;
@property (weak, nonatomic) IBOutlet UILabel *lllable;
@end
