//
//  GasStationAddressCell.m
//  BletcShop
//
//  Created by Bletc on 2017/8/8.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "GasStationAddressCell.h"

@implementation GasStationAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)addressClick:(UITapGestureRecognizer *)sender {
    
    self.addressClickBlock();
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
