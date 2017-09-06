//
//  NewPayCustomView.m
//  BletcShop
//
//  Created by apple on 2017/9/4.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "NewPayCustomView.h"

@implementation NewPayCustomView

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:0.3];
        
        UIView *whiteView=[[UIView alloc]initWithFrame:CGRectMake(53, SCREENHEIGHT-216-227-40-64, frame.size.width-106, 227)];
        whiteView.backgroundColor=[UIColor whiteColor];
        whiteView.layer.cornerRadius=12.0f;
        whiteView.clipsToBounds=YES;
        [self addSubview:whiteView];
        
        UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, whiteView.frame.size.width, 55)];
        title.text=@"请输入支付密码";
        title.textAlignment=NSTextAlignmentCenter;
        [whiteView addSubview:title];
        
        UIImageView *imageview=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"card_icon_close"]];
        imageview.frame=CGRectMake(whiteView.frame.size.width-25, 20, 15, 15);
        [whiteView addSubview:imageview];
        
        UIButton *dismissButton=[UIButton buttonWithType:UIButtonTypeCustom];
        dismissButton.frame=title.frame;
        [dismissButton addTarget:self action:@selector(dismissCustomView) forControlEvents:UIControlEventTouchUpInside];
        [whiteView addSubview:dismissButton];
        
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, dismissButton.bottom, dismissButton.frame.size.width, 1)];
        lineView.backgroundColor=RGB(234, 234, 234);
        [whiteView addSubview:lineView];
        
        UILabel *detailTitle=[[UILabel alloc]initWithFrame:CGRectMake(0, lineView.bottom+15, whiteView.frame.size.width, 15)];
        detailTitle.text=@"提现";
        detailTitle.textColor=RGB(51,51,51);
        detailTitle.textAlignment=NSTextAlignmentCenter;
        detailTitle.font=[UIFont systemFontOfSize:15];
        [whiteView addSubview:detailTitle];
        
        UILabel *cashLable=[[UILabel alloc]initWithFrame:CGRectMake(0, detailTitle.bottom+20, whiteView.frame.size.width, 24)];
        cashLable.text=@"￥0.00";
        cashLable.textAlignment=NSTextAlignmentCenter;
        cashLable.font=[UIFont systemFontOfSize:20];
        cashLable.textColor=RGB(0,0,0);
        [whiteView addSubview:cashLable];
        
        self.withdrawCashLable=cashLable;
        
        _pasView = [[SYPasswordView alloc] initWithFrame:CGRectMake(13, cashLable.bottom+35, whiteView.frame.size.width -26 , 40)];
        _pasView.delegate=self;
        [_pasView.textField becomeFirstResponder];
        [whiteView addSubview:_pasView];
        
    }
    return self;
}
-(void)passLenghtEqualsToSix:(NSString *)pass{
    self.pass=pass;
    if ([_delegate respondsToSelector:@selector(confirmPassRightOrWrong:)]) {
        [_delegate confirmPassRightOrWrong:pass];
    }
}
-(void)observationPassLength:(NSString *)pwd{
    
}
-(void)dismissCustomView{
    [self removeFromSuperview];
    if ([_delegate respondsToSelector:@selector(missPayAlert)]) {
        [_delegate missPayAlert];
    }
}

@end
