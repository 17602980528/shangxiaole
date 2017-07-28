//
//  ComplainUnnormalVC.h
//  BletcShop
//
//  Created by apple on 2017/7/27.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ComplainUnnormalVCBlock)(NSString *result);

@interface ComplainUnnormalVC : UIViewController
@property (nonatomic,copy)ComplainUnnormalVCBlock resultBlock;//
@property(nonatomic,strong)NSDictionary *dic;
@end
