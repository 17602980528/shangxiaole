//
//  OilListTableViewCell.h
//  BletcShop
//
//  Created by apple on 2017/8/7.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHStarRateView.h"
@interface OilListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *shopImage;
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UIView *shopStars;
@property (weak, nonatomic) IBOutlet UILabel *shopSale;
@property (weak, nonatomic) IBOutlet UILabel *shopDistance;
@property (weak, nonatomic) IBOutlet UILabel *shopAddtress;
@property (strong,nonatomic)XHStarRateView *starRateView;
@end
