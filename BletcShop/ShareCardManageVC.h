//
//  ShareCardManageVC.h
//  BletcShop
//
//  Created by Bletc on 2017/7/21.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareCardManageVC : UIViewController

@property (nonatomic,copy) void (^refresheDate)();// 返回时刷新数据

/**
 卡的信息
 */
@property (nonatomic , strong) NSDictionary *card_dic;

@end
