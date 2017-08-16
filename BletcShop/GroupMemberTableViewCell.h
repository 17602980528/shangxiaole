//
//  GroupMemberTableViewCell.h
//  BletcShop
//
//  Created by apple on 2017/8/11.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupMemberTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIImageView *selectImg;
@property  BOOL ischose;// <#Description#>

@end
