//
//  AddFriendTableViewCell.h
//  BletcShop
//
//  Created by apple on 2017/6/30.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHStarRateView.h"
@interface AddFriendTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UIImageView *headImage;
@property (strong, nonatomic) IBOutlet UILabel *nickName;
@property (strong, nonatomic) IBOutlet UIView *appriseStars;
@property (strong, nonatomic) IBOutlet UILabel *publishTime;
@property (strong, nonatomic) IBOutlet UIView *shopNameBgView;
@property (strong, nonatomic) IBOutlet UILabel *shopName;
@property (strong, nonatomic) IBOutlet UILabel *appriseLable;
@property (strong, nonatomic) IBOutlet UIButton *goShopDetailButton;
@property (strong,nonatomic)XHStarRateView *starRateView;
@end
