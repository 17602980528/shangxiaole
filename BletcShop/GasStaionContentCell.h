//
//  GasStaionContentCell.h
//  BletcShop
//
//  Created by Bletc on 2017/8/8.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GasStaionContentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *contenLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moreBnt_height;



@end
