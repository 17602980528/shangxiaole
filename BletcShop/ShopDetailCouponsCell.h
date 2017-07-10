//
//  ShopDetailCouponsCell.h
//  BletcShop
//
//  Created by Bletc on 2017/7/7.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopDetailCouponsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *upORdownImg;
@property (weak, nonatomic) IBOutlet UILabel *pricelab;
@property (weak, nonatomic) IBOutlet UILabel *descriplab;

@property (weak, nonatomic) IBOutlet UILabel *timeDesLab;

@property (weak, nonatomic) IBOutlet UILabel *getlab;
@property (weak, nonatomic) IBOutlet UIImageView *overdueImg;




+(instancetype)ShopDetailCouponsCellWithTableView:(UITableView*)tableView;

@end
