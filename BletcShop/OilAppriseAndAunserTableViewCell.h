//
//  OilAppriseAndAunserTableViewCell.h
//  BletcShop
//
//  Created by apple on 2017/8/8.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHStarRateView.h"
@interface OilAppriseAndAunserTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *shopAnser;
@property (weak, nonatomic) IBOutlet UILabel *shopAnserTime;
@property (weak, nonatomic) IBOutlet UIImageView *userHead;
@property (weak, nonatomic) IBOutlet UILabel *userNick;
@property (weak, nonatomic) IBOutlet UILabel *userAppriseTime;
@property (weak, nonatomic) IBOutlet UIView *appriseStars;
@property (weak, nonatomic) IBOutlet UILabel *appriseContent;
@property (strong,nonatomic)XHStarRateView *starRateView;
@end
