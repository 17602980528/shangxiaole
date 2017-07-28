//
//  NewCardPayTableViewCell.h
//  BletcShop
//
//  Created by apple on 2017/7/13.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewCardPayTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *delBtn;
@property (weak, nonatomic) IBOutlet UIButton *appriseBtn;
@property (weak, nonatomic) IBOutlet UILabel *totalCosts;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UILabel *dateTime;
@property (weak, nonatomic) IBOutlet UIButton *goShopDetailButton;
@property (weak, nonatomic) IBOutlet UILabel *card_type;
@property (weak, nonatomic) IBOutlet UILabel *original_price;
@property (weak, nonatomic) IBOutlet UILabel *current_price;

@end
