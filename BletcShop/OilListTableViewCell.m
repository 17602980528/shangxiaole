//
//  OilListTableViewCell.m
//  BletcShop
//
//  Created by apple on 2017/8/7.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "OilListTableViewCell.h"

@implementation OilListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius=5.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
