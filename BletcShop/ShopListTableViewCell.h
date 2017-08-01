//
//  ShopListTableViewCell.h
//  BletcShop
//
//  Created by Bletc on 16/8/4.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHStarRateView.h"

@interface ShopListTableViewCell : UITableViewCell
@property (nonatomic , strong) UIImageView *shopImageView;// <#Description#>
@property (nonatomic , strong) UILabel *nameLabel;// <#Description#>
@property (nonatomic , strong) UILabel *distanceLabel;// <#Description#>
@property (nonatomic , strong)  UILabel *sellerLabel;// <#Description#>
@property (nonatomic , strong)  XHStarRateView *starView;// <#Description#>
@property (nonatomic , strong)  UILabel *zhelab;// <#Description#>
@property (nonatomic , strong) UILabel *givelab;
@property (nonatomic,strong) UILabel *couponLable;
@property (nonatomic,strong)UILabel *tradeLable;
@property (nonatomic , strong) LZDButton *delete_btn;// <#Description#>


@end
