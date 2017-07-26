//
//  HobbyChooseVC.h
//  BletcShop
//
//  Created by apple on 2017/7/25.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^HobbyChooseVCBlock)(NSDictionary *result_dic);

@interface HobbyChooseVC : UIViewController
@property(nonatomic,strong)NSArray *countArr;
@property (nonatomic,copy)HobbyChooseVCBlock resultBlock;//
@property(nonatomic,copy)NSString *hobby;

@end
