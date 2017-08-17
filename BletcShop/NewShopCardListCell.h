//
//  NewShopCardListCell.h
//  BletcShop
//
//  Created by Bletc on 2017/5/12.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewShopCardListCell : UITableViewCell
@property (nonatomic , weak) UIImageView *cardImg;// <#Description#>
@property (nonatomic , weak) UILabel *vipLab;// <#Description#>
@property (nonatomic , weak) UILabel *content_lab;// <#Description#>
@property (nonatomic , weak) UILabel *cardPriceLable;// <#Description#>
@property (nonatomic , weak) UILabel *discountLable;// <#Description#>
@property (nonatomic , weak) UILabel *timeLable;// <#Description#>
@property (nonatomic , weak) UIImageView *back_view;

@property(nonatomic,weak)LZDButton *shouSuoBtn;//收缩按钮
@property (nonatomic , weak) UILabel *typeLable;// 卡的类型


@property (weak, nonatomic)  UIView *line;
@property (weak, nonatomic)UILabel *shulabView;
@property (nonatomic , weak) UILabel *detaillab;// <#Description#>
@property (nonatomic , weak) UILabel *old_pricelab;// <#Description#>

@property (nonatomic , weak) UILabel *detail_content_lab;// <#Description#>


@property BOOL isUnfold;
@end
