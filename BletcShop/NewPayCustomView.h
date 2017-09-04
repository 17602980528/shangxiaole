//
//  NewPayCustomView.h
//  BletcShop
//
//  Created by apple on 2017/9/4.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYPasswordView.h"
@interface NewPayCustomView : UIView
@property (nonatomic, strong) SYPasswordView *pasView;
@property (nonatomic,copy)NSString *pass;
@property (nonatomic,assign)id delegate;
@property(nonatomic,strong)UILabel *withdrawCashLable;
@end

@protocol PayCustomViewDelegate <NSObject>

-(void)confirmPassRightOrWrong:(NSString *)pass;
@optional
-(void)missPayAlert;
@end
