//
//  MoreViewCell.h
//  BletcShop
//
//  Created by apple on 2017/7/6.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *caches;
@property (weak, nonatomic) IBOutlet UIImageView *moreTip;
@property (weak, nonatomic) IBOutlet UIView *line;

@end
