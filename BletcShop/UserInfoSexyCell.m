//
//  UserInfoSexyCell.m
//  BletcShop
//
//  Created by apple on 2017/7/7.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "UserInfoSexyCell.h"

@implementation UserInfoSexyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor=RGB(240, 240, 240);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
