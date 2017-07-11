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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
