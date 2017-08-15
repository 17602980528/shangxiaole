//
//  PlatCouponTableViewCell.h
//  BletcShop
//
//  Created by apple on 2017/8/15.
//  Copyright © 2017年 bletc. All rights reserved.
//
static NSString *identifiers = @"platCouponCellId";
#import <UIKit/UIKit.h>

@interface PlatCouponTableViewCell : UITableViewCell
@property(nonatomic,strong)CAGradientLayer *gradientLayer;


@property (nonatomic , strong) UILabel *shopNamelab;// 店名

@property (nonatomic , strong) UILabel *couponMoney;// 价格
@property (nonatomic , strong) UILabel *deadTime;// 限制时间
@property (nonatomic , strong) UILabel *limitLab;// 满多少可用
@property (nonatomic , strong) UIImageView *headImg;// 头像
@property (nonatomic , strong) UIImageView *showImg;// 过期
@property (nonatomic , strong) UIImageView *onlineState;//线上线下
//
@property (nonatomic , strong) UILabel *detail;//

@property (nonatomic,strong)UIView *bgView;
@property (nonatomic,strong)UIButton *turnButton;
@property (nonatomic,strong)UILabel *contentLable;
@property(nonatomic,strong)UIImageView *jian;
@property(nonatomic,strong)UIImageView *expiredView;
@property(nonatomic,strong)UIView *topView;
@property(nonatomic,strong)UIImageView *youjian;
+(instancetype)couponCellWithTableView:(UITableView*)tableView;
@end
