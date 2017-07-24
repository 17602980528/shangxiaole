//
//  NewCardBuyTableViewCell.h
//  BletcShop
//
//  Created by apple on 2017/7/13.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewCardBuyTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UILabel *cardLevel;
@property (weak, nonatomic) IBOutlet UILabel *cardType;
@property (weak, nonatomic) IBOutlet UILabel *payMoney;
@property (weak, nonatomic) IBOutlet UILabel *payTime;

@end
