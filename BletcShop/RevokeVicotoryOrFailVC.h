//
//  RevokeVicotoryOrFailVC.h
//  BletcShop
//
//  Created by apple on 2017/7/28.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^RevokeVicotoryOrFailVCBlock)(NSString *result);
@interface RevokeVicotoryOrFailVC : UIViewController
@property(nonatomic,copy)RevokeVicotoryOrFailVCBlock resultBlock;
@property(nonatomic,strong)NSDictionary *dic;
@end
