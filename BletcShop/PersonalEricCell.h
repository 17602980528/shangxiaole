//
//  PersonalEricCell.h
//  BletcShop
//
//  Created by apple on 2017/6/27.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Myitem;
@interface PersonalEricCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *bgImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLable;
@property (strong, nonatomic) IBOutlet UILabel *desLale;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *headImageView;
@property(nonatomic,strong)Myitem *cellItem;
@property (strong, nonatomic) IBOutlet UIImageView *headImg;
+(PersonalEricCell *)cellForTableView:(UITableView *)tableView;
@end
