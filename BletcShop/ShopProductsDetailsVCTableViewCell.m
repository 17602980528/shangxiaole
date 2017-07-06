//
//  ShopProductsDetailsVCTableViewCell.m
//  BletcShop
//
//  Created by apple on 2017/7/4.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "ShopProductsDetailsVCTableViewCell.h"

@implementation ShopProductsDetailsVCTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.productImage.layer.cornerRadius=3.0f;
    self.productImage.clipsToBounds=YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
