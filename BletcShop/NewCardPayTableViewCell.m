//
//  NewCardPayTableViewCell.m
//  BletcShop
//
//  Created by apple on 2017/7/13.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "NewCardPayTableViewCell.h"

@implementation NewCardPayTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.delBtn.layer.borderColor=RGB(181, 181, 181).CGColor;
    self.delBtn.layer.borderWidth=1.5f;
    self.delBtn.clipsToBounds=YES;
    
    self.appriseBtn.layer.borderColor=RGB(243, 73, 78).CGColor;
    self.appriseBtn.layer.borderWidth=1.5f;
    self.appriseBtn.clipsToBounds=YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
