//
//  MoneyPAYViewController.m
//  BletcShop
//
//  Created by apple on 16/8/24.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "MoneyPAYViewController.h"
#import "SoundPaly.h"
#import "ChangePayPassVC.h"
#import "PayCustomView.h"
#import "AccessCodeVC.h"
#import "PayVictoryVC.h"
@interface MoneyPAYViewController ()<UIAlertViewDelegate,PayCustomViewDelegate,UITextFieldDelegate>
{
    UITextField *textTF;
    PayCustomView *view;
    UILabel *discount;
    UILabel *realPay;
    UIView *bigView;
}
@end

@implementation MoneyPAYViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=RGB(234, 234, 234);
    self.navigationItem.title=@"储值卡支付";
    LEFTBACK
    
    bigView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64)];
    bigView.backgroundColor=RGB(234, 234, 234);
    [self.view addSubview:bigView];
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 113)];
    backView.backgroundColor = [UIColor whiteColor];
    [bigView addSubview:backView];
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 20, SCREENWIDTH, 16)];
    titleLabel.text=@"输入金额";
    titleLabel.textColor=RGB(51, 51, 51);
    titleLabel.font=[UIFont systemFontOfSize:16.0f];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    [backView addSubview:titleLabel];
    
    UILabel *dol=[[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-50, titleLabel.bottom+10, 30, 25)];
    dol.text=@"￥:";
    dol.font=[UIFont systemFontOfSize:20];
    dol.textAlignment=NSTextAlignmentCenter;
    dol.textColor=RGB(51, 51, 51);
    [backView addSubview:dol];
    
    textTF=[[UITextField alloc]initWithFrame:CGRectMake(dol.right, titleLabel.bottom+10, 150,25)];
    textTF.borderStyle=UITextBorderStyleNone;
    textTF.returnKeyType=UIReturnKeyDone;
    textTF.delegate=self;
    textTF.font=[UIFont systemFontOfSize:20.0f];
    textTF.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
    textTF.placeholder=@"";
    [backView addSubview:textTF];
    
    [textTF becomeFirstResponder];
    
    UILabel *noticeLable=[[UILabel alloc]initWithFrame:CGRectMake(0, textTF.bottom+10, SCREENWIDTH, 15)];
    noticeLable.textAlignment=NSTextAlignmentCenter;
    noticeLable.textColor=RGB(153,153,153);
    noticeLable.font=[UIFont systemFontOfSize:14];
    noticeLable.text=@"请按商铺原价输入消费金额";
    [backView addSubview:noticeLable];
    
    
    UIView *bottomBackView=[[UIView alloc]initWithFrame:CGRectMake(0, backView.bottom+10, SCREENWIDTH, 170)];
    bottomBackView.backgroundColor=[UIColor whiteColor];
    [bigView addSubview:bottomBackView];
    
    UILabel *discountLable=[[UILabel alloc]initWithFrame:CGRectMake(13, 0, 120, 56)];
    discountLable.textAlignment=NSTextAlignmentLeft;
    discountLable.font=[UIFont systemFontOfSize:16];
    discountLable.text=@"折扣力度:";
    discountLable.textColor=RGB(51, 51, 51);
    [bottomBackView addSubview:discountLable];
    
    UILabel *disPercent=[[UILabel alloc]initWithFrame:CGRectMake(discountLable.right, 0, SCREENWIDTH-13-120-13, 56)];
    disPercent.textAlignment=NSTextAlignmentRight;
    disPercent.textColor=RGB(51, 51, 51);
    disPercent.font=[UIFont systemFontOfSize:16];
    disPercent.text=[NSString stringWithFormat:@"%@%%",self.card_dic[@"rule"]];
    [bottomBackView addSubview:disPercent];
    
    UIView *line1=[[UIView alloc]initWithFrame:CGRectMake(0, disPercent.bottom, SCREENWIDTH, 1)];
    line1.backgroundColor=RGB(220, 220, 220);
    [bottomBackView addSubview:line1];
    
    UILabel *deceaseMoney=[[UILabel alloc]initWithFrame:CGRectMake(13, line1.bottom,120, 56)];
    deceaseMoney.textAlignment=NSTextAlignmentLeft;
    deceaseMoney.font=[UIFont systemFontOfSize:16];
    deceaseMoney.text=@"优惠金额:";
    deceaseMoney.textColor=RGB(51, 51, 51);
    [bottomBackView addSubview:deceaseMoney];
    
    discount=[[UILabel alloc]initWithFrame:CGRectMake(deceaseMoney.right, line1.bottom, SCREENWIDTH-13-120-13, 56)];
    discount.textAlignment=NSTextAlignmentRight;
    discount.text=@"￥：0.00元";
    discount.textColor=RGB(51, 51, 51);
    discount.font=[UIFont systemFontOfSize:16.0f];
    [bottomBackView addSubview:discount];

    UIView *line2=[[UIView alloc]initWithFrame:CGRectMake(0, discount.bottom, SCREENWIDTH, 1)];
    line2.backgroundColor=RGB(220, 220, 220);
    [bottomBackView addSubview:line2];
    
    UILabel *realPayLable=[[UILabel alloc]initWithFrame:CGRectMake(13, line2.bottom,120, 56)];
    realPayLable.textAlignment=NSTextAlignmentLeft;
    realPayLable.font=[UIFont systemFontOfSize:16];
    realPayLable.text=@"实际消费金额:";
    realPayLable.textColor=RGB(51, 51, 51);
    [bottomBackView addSubview:realPayLable];
    
    realPay=[[UILabel alloc]initWithFrame:CGRectMake(realPayLable.right, line2.bottom, SCREENWIDTH-13-120-13, 56)];
    realPay.text=@"￥：0.00元";
    realPay.textAlignment=NSTextAlignmentRight;
    realPay.textColor=RGB(51, 51, 51);
    realPay.font=[UIFont systemFontOfSize:16.0f];
    [bottomBackView addSubview:realPay];
    
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:realPay.text];

    [AttributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:23.0] range:NSMakeRange(2, realPay.text.length-3)];
    
    [AttributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(2,  realPay.text.length-3)];
    realPay.attributedText=AttributedStr;
    
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame=CGRectMake(0, SCREENHEIGHT-64-44, SCREENWIDTH, 44);
    button.backgroundColor=NavBackGroundColor;
    [button setTitle:@"确认支付" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bigView addSubview:button];
    NSLog(@"self.card_dic=====%@",self.card_dic);
}
-(void)btnClick:(UIButton *)sender{
    [textTF resignFirstResponder];
    
    
    AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSString *pay_passwd= [NSString getTheNoNullStr:appdelegate.userInfoDic[@"pay_passwd"] andRepalceStr:@""];
    
    
    
    //判断输入的金额和卡的余额对比，如果小于，就弹出输入密码警告框，否就弹出提示，余额不够
    
    NSArray *array=[self.card_dic[@"card_remain"] componentsSeparatedByString:@"元"];
    //    NSLog(@"---%lf",)
    if ([textTF.text floatValue]>0&&[textTF.text floatValue]<=[array[0] floatValue]) {
        
        if ([pay_passwd isEqualToString:@"未设置"]) {
            
            UIAlertView *alt = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还没有设置支付密码!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去设置", nil];
            alt.tag = 888;
            [alt show];
            
        }else{
            
             bigView.frame=CGRectMake(0, -113, SCREENWIDTH, SCREENHEIGHT-64);
            
            view=[[PayCustomView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
            view.delegate=self;
            [view.forgotButton addTarget:self action:@selector(forgetPayPass) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:view];
            
        }
        
    }else{
        if ([textTF.text isEqualToString:@""]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"没有输入金额,请输入金额", @"HUD message title");
            hud.label.font = [UIFont systemFontOfSize:13];
            [hud hideAnimated:YES afterDelay:2.f];
        }else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"输入金额大于当前卡余额", @"HUD message title");
            hud.label.font = [UIFont systemFontOfSize:13];
            [hud hideAnimated:YES afterDelay:2.f];
        }
    }
    
    
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag ==888) {
        NSLog(@"去设置");
        if (buttonIndex==1) {
            ChangePayPassVC *vc=[[ChangePayPassVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }
    
}

-(void)checkPayPassWd:(NSString *)payPassWd{
    
    AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@Extra/passwd/checkPayPasswd",BASEURL];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    
    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    [params setObject:payPassWd forKey:@"pay_passwd"];
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
       

        
        NSLog(@"result---_%@",result);
        if ([result[@"result_code"] isEqualToString:@"access"]) {
            [view removeFromSuperview];
            
             bigView.frame=CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64);
            
            [self postSocketCardPayAction];
            
        }else{
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.label.text = @"支付密码错误,请重新输入!";
            hud.mode = MBProgressHUDModeText;
            hud.label.font =[UIFont systemFontOfSize:13];
            [hud hideAnimated:YES afterDelay:1.5];
        }
        
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
-(void)postSocketCardPayAction
{
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/card/value_pay",BASEURL];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:self.user forKey:@"uuid"];
    [params setObject:self.card_dic[@"merchant"] forKey:@"muid"];
    [params setObject:self.card_dic[@"card_code"] forKey:@"cardCode"];
    [params setObject:self.card_dic[@"card_level"] forKey:@"cardLevel"];
    
    [params setObject:@"储值卡" forKey:@"cardType"];
    NSString *payMoneyString = [NSString stringWithFormat:@"%.2f",[textTF.text floatValue]*[self.card_dic[@"rule"] floatValue]/100];
    
    [params setObject:payMoneyString forKey:@"sum"];
    
    NSLog(@"params===%@",params);
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         NSLog(@"self.payCardArray=result=%@", result);
         if ([result[@"result_code"] intValue]==1) {
             
             SoundPaly *sound=[SoundPaly sharedManager:@"sms-received1" type:@"caf"];
             [sound play];
             
             
             
             UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"支付成功" preferredStyle:UIAlertControllerStyleAlert];
             UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
               
                 self.refresheDate();
                 PayVictoryVC *vc=[[PayVictoryVC alloc]init];
                 NSMutableDictionary *dictionary=[NSMutableDictionary dictionaryWithDictionary:params];
                 [dictionary setObject:self.card_dic[@"store"] forKey:@"store"];
                 [dictionary setObject:textTF.text forKey:@"oldNeed"];
                 vc.dic=dictionary;
                 [self.navigationController pushViewController:vc animated:YES];
                 
                // [self.navigationController popViewControllerAnimated:YES];

             }];
             
            
             [alertController addAction:sure];
             
             
             [self presentViewController:alertController animated:YES completion:nil];


             //提交消费记录,先获取店铺名
             //             [self getShopName];
             
             
         }
         
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
     }];
    
}
//发送订单详情

//-(void)getShopName{
//    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/merchant/accountGet",BASEURL];
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    [params setValue:self.card_dic[@"merchant"] forKey:@"muid"];
//    [params setValue:@"store" forKey:@"type"];
//    
//    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
//        
//        NSLog(@"result----%@",result);
//        
//        [self postOrderInfoWithShopName:result[@"store"]];
//        
//        
//    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//    }];
//    
//    
//}
//-(void)postOrderInfoWithShopName:(NSString*)shopName
//{
//    
//    
//    
//    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/user/cnCmt",BASEURL];
//    
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    [params setObject:self.card_dic[@"user"] forKey:@"uuid"];
//    
//    
//    
//    NSString *orderInfoMessage = [[NSString alloc]initWithFormat:@"%@%@结算金额%@%@元",self.card_dic[@"merchant"],PAY_USCS,PAY_NP,textTF.text];
//    
//    [params setObject:orderInfoMessage forKey:@"content"];
//    
//    NSDateFormatter* matter = [[NSDateFormatter alloc]init];
//    [matter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSDate* date  = [NSDate date];
//    NSString *NowDate = [matter stringFromDate:date];
//    [params setObject:NowDate forKey:@"datetime"];
//    [params setObject:textTF.text forKey:@"sum"];
//    NSLog(@"params----%@",params);
//    
//    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
//     {
//         NSLog(@"result%@", result);
//         if ([result[@"result_code"] intValue]==1) {
//             ;
//             
//             
//         }
//         else
//             [self postOrderInfoWithShopName:shopName];
//         
//     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
//         //         [self noIntenet];
//         NSLog(@"%@", error);
//     }];
//    
//}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [view removeFromSuperview];
    bigView.frame=CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64);
}

-(void)confirmPassRightOrWrong:(NSString *)pass{
   
    [self checkPayPassWd:pass];
}
-(void)forgetPayPass{
    AccessCodeVC *vc=[[AccessCodeVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return NO;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    CGFloat disc=[self.card_dic[@"rule"] floatValue]/100;
    CGFloat inputMoney=[textTF.text floatValue];
    
    realPay.text=[NSString stringWithFormat:@"￥：%.2f元",disc*inputMoney];
    discount.text=[NSString stringWithFormat:@"￥：%.2f元",inputMoney-disc*inputMoney];
    
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:realPay.text];
    
    [AttributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:23.0] range:NSMakeRange(2, realPay.text.length-3)];
    
    [AttributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(2,  realPay.text.length-3)];
    realPay.attributedText=AttributedStr;
    return YES;
}
-(void)missPayAlert{
    bigView.frame=CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64);
}
@end
