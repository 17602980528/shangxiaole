//
//  ShopDetailCouponsCell.m
//  BletcShop
//
//  Created by Bletc on 2017/7/7.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "ShopDetailCouponsCell.h"

@implementation ShopDetailCouponsCell


+(instancetype)ShopDetailCouponsCellWithTableView:(UITableView*)tableView;
{
    ShopDetailCouponsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"shopDetailCouponsCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"ShopDetailCouponsCell" owner:self options:nil] firstObject];
    }
    
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
