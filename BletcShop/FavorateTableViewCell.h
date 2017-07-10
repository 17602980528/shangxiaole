//
//  FavorateTableViewCell.h
//  BletcShop
//
//  Created by apple on 2017/7/10.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavorateTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *cardImageView;
@property (weak, nonatomic) IBOutlet UILabel *trade;
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UILabel *item2;

@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *distance;
@property (weak, nonatomic) IBOutlet UILabel *item1;
@end
