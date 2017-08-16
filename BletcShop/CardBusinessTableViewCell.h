//
//  CardBusinessTableViewCell.h
//  BletcShop
//
//  Created by apple on 2017/6/28.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardMarketModel.h"
static NSString *identifierEric = @"CardBusinessCell";
@interface CardBusinessTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UILabel *pricelab;
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UIImageView *cardImageView;//会员卡图片
@property (nonatomic , strong) CardMarketModel *model;
@property (strong, nonatomic) IBOutlet UILabel *nickNamelab;
@property (strong, nonatomic) IBOutlet UILabel *timeLab;//多长时间前发布
@property (strong, nonatomic) IBOutlet UILabel *otherTimeLable;//多长时间前登录过app
@property (strong, nonatomic) IBOutlet UILabel *descripLab;//会员卡描述
@property (strong, nonatomic) IBOutlet UILabel *headDescripLab;//分享或让
@property (strong, nonatomic) IBOutlet UILabel *shopLab;//商家名称
@property (strong, nonatomic) IBOutlet UILabel *addresslab;
@property (strong, nonatomic) IBOutlet UILabel *noticeLable;
@property (strong, nonatomic) IBOutlet UILabel *tradeLable;
@property (strong, nonatomic) IBOutlet UIButton *addFriendBtn;
@property (weak, nonatomic) IBOutlet UILabel *card_Level;
@property (weak, nonatomic) IBOutlet UIButton *contactButton;

+(instancetype)creatCellWithTableView:(UITableView*)tableView;

@end
