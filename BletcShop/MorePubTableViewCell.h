//
//  MorePubTableViewCell.h
//  BletcShop
//
//  Created by apple on 2017/7/10.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHStarRateView.h"
@interface MorePubTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *shopNameBgView;
@property (weak, nonatomic) IBOutlet UIView *appriseStars;
@property (strong,nonatomic)XHStarRateView *starRateView;
@end
