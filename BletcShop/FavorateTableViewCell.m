//
//  FavorateTableViewCell.m
//  BletcShop
//
//  Created by apple on 2017/7/10.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "FavorateTableViewCell.h"
#import "Masonry.h"
@implementation FavorateTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UIView *deleteBgView = [UIView new];
    deleteBgView.backgroundColor = RGB(243, 73, 78);
    [self.contentView addSubview:deleteBgView];
    
    UIButton *deleteBtn = [UIButton new];

    [deleteBtn setImage:[UIImage imageNamed:@"垃圾桶"] forState:UIControlStateNormal];
    [deleteBgView addSubview:deleteBtn];
    
    [deleteBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset([UIScreen mainScreen].bounds.size.width);
        make.top.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(1);
        make.width.equalTo(self.contentView);
    }];
    
    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(70);
        make.top.equalTo(deleteBgView);
        make.bottom.equalTo(deleteBgView);
        make.left.equalTo(deleteBgView);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
