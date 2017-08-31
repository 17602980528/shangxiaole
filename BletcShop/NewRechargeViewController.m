//
//  NewRechargeViewController.m
//  BletcShop
//
//  Created by apple on 16/11/21.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "NewRechargeViewController.h"
#import "MyMoneybagController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"
#import "UPPaymentControl.h"
#import "NewRechargeSuccessVC.h"

@interface NewRechargeViewController ()<UIAlertViewDelegate,UITextFieldDelegate>

@end

@implementation NewRechargeViewController
{
    NSInteger payIndex;
    UIButton *chooseState;
    UIButton *chooseState2;
    UITextField *moneyTextFD;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getOrderPayResult:) name:ORDER_PAY_NOTIFICATION object:nil];//监听一个通知
    
}
//移除通知
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(void)getOrderPayResult:(NSNotification*)notification{
    BOOL payResult = NO;
    if ([notification.object isKindOfClass:[NSDictionary class]]) {
        NSDictionary *result = (NSDictionary*) notification.object;
        
        payResult = [result[@"resultStatus"] integerValue]==9000 ? YES:NO;
        
        [self showtishi:payResult];
    }
    else if ([notification.object isKindOfClass:[NSString class]]){
        NSString *result = (NSString*) notification.object;
        
        payResult = [result isEqualToString:@"success"] ? YES:NO;
        [self showtishi:payResult];
        
    }
    
    
}
-(void)showtishi:(BOOL)payResult{
    
    if (payResult) {
        
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"恭喜" message:@"您已成功支付啦!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
//        
//        [alert show];
        NewRechargeSuccessVC *VC = [[NewRechargeSuccessVC alloc]init];
        VC.money_s = [NSString stringWithFormat:@"¥%@",moneyTextFD.text];
        [self.navigationController pushViewController:VC animated:YES];
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否放弃当前交易?" delegate:self cancelButtonTitle:@"放弃" otherButtonTitles:@"去支付", nil];
        alert.tag =1111;
        [alert show];

        
    }
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    payIndex=-1;
    LEFTBACK
    self.view.backgroundColor=RGB(240, 240, 240);
    self.navigationItem.title=@"充值";
    UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(0, 10, SCREENWIDTH, 132+2)];
    backView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:backView];
    UILabel *priceLabel=[[UILabel alloc]initWithFrame:CGRectMake(12, 0, 65, 44)];
    priceLabel.text=@"金额(￥)";
    priceLabel.textAlignment=NSTextAlignmentLeft;
    priceLabel.font=[UIFont systemFontOfSize:16.0f];
    [backView addSubview:priceLabel];
    
    moneyTextFD=[[UITextField alloc]initWithFrame:CGRectMake(82, 0, SCREENWIDTH-82, 44)];
    moneyTextFD.placeholder=@"请输入充值金额";
    moneyTextFD.keyboardType=UIKeyboardTypeEmailAddress;
    moneyTextFD.textColor=[UIColor blueColor];
    moneyTextFD.delegate = self;
    moneyTextFD.font=[UIFont systemFontOfSize:16.0f];
    [backView addSubview:moneyTextFD];
    
    UIView *lineView1=[[UIView alloc]initWithFrame:CGRectMake(12, 44, SCREENWIDTH-24, 1)];
    lineView1.backgroundColor=RGB(234, 234, 234);
    [backView addSubview:lineView1];
    
    UIImageView *imageView1=[[UIImageView alloc]initWithFrame:CGRectMake(12, 45+7, 30, 30)];
    imageView1.image=[UIImage imageNamed:@"支付宝支付L"];
    [backView addSubview:imageView1];
    UILabel *alipayLab = [[UILabel alloc]initWithFrame:CGRectMake(imageView1.right+10, imageView1.top, 100, imageView1.height)];
    alipayLab.text = @"支付宝支付";
    alipayLab.textColor = RGB(51, 51, 51);
    alipayLab.font = [UIFont systemFontOfSize:15];
    [backView addSubview:alipayLab];
    
    UIView *lineView2=[[UIView alloc]initWithFrame:CGRectMake(12, 89, SCREENWIDTH-24, 1)];
    lineView2.backgroundColor=RGB(234, 234, 234);
    [backView addSubview:lineView2];
    
    UIImageView *imageView2=[[UIImageView alloc]initWithFrame:CGRectMake(12, 90+7, 30, 30)];
    imageView2.image=[UIImage imageNamed:@"银联支付L"];
    [backView addSubview:imageView2];
    
    UILabel *uPpayLab = [[UILabel alloc]initWithFrame:CGRectMake(imageView2.right+10, imageView2.top, 100, imageView2.height)];
    uPpayLab.text = @"银联支付";
    uPpayLab.textColor = RGB(51, 51, 51);
    uPpayLab.font = [UIFont systemFontOfSize:15];
    [backView addSubview:uPpayLab];

    
    UIButton *confirmBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame=CGRectMake(12, 10+134+37, SCREENWIDTH-24, 49);
    confirmBtn.backgroundColor=NavBackGroundColor;
    [confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    confirmBtn.titleLabel.font=[UIFont systemFontOfSize:18.0f];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:confirmBtn];
    [confirmBtn addTarget:self action:@selector(goPay) forControlEvents:UIControlEventTouchUpInside];
    confirmBtn.layer.cornerRadius = 5;
    
    for (int i = 0; i < 2; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, lineView1.bottom +45*i, SCREENWIDTH, 45);
        button.tag  = i+1;
        [backView addSubview:button];
        
        if (i==0) {
            [button addTarget:self action:@selector(alipPay:) forControlEvents:UIControlEventTouchUpInside];

        }
        if (i==1) {
            [button addTarget:self action:@selector(unionPay:) forControlEvents:UIControlEventTouchUpInside];
            
        }

    }
    
    
    chooseState=[[UIButton alloc]initWithFrame:CGRectMake(SCREENWIDTH-50, 40+7, 40, 40)];
    [chooseState setBackgroundImage:[UIImage imageNamed:@"settlement_unchoose_n"] forState:UIControlStateNormal];
    chooseState.tag=1;
    [backView addSubview:chooseState];
    [chooseState addTarget:self action:@selector(alipPay:) forControlEvents:UIControlEventTouchUpInside];
    
    chooseState2=[[UIButton alloc]initWithFrame:CGRectMake(SCREENWIDTH-50, 85+7, 40, 40)];
    [chooseState2 setBackgroundImage:[UIImage imageNamed:@"settlement_unchoose_n"] forState:UIControlStateNormal];
    chooseState2.tag=2;
    [backView addSubview:chooseState2];
    [chooseState2 addTarget:self action:@selector(unionPay:) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)alipPay:(UIButton *)sender{
    payIndex=chooseState.tag;
    [chooseState setBackgroundImage:[UIImage imageNamed:@"settlement_choose_n"] forState:UIControlStateNormal];
    [chooseState2 setBackgroundImage:[UIImage imageNamed:@"settlement_unchoose_n"] forState:UIControlStateNormal];
}
-(void)unionPay:(UIButton *)sender{
    payIndex=chooseState2.tag;
    [chooseState2 setBackgroundImage:[UIImage imageNamed:@"settlement_choose_n"] forState:UIControlStateNormal];
    [chooseState setBackgroundImage:[UIImage imageNamed:@"settlement_unchoose_n"] forState:UIControlStateNormal];
}

-(void)goPay{
    [moneyTextFD resignFirstResponder];
    if (moneyTextFD.text.length==0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"请输入金额", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:13];
        [hud hideAnimated:YES afterDelay:2.f];
    }else{
       
        
        
        if (payIndex==1) {
            //alipay
            [self initAlipayInfo];
        }else if (payIndex==2){
            //yinlian pay
            AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
            appdelegate.moneyText=moneyTextFD.text;
            [self postPaymentsRequest];
        }else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"请选择支付方式", @"HUD message title");
            hud.label.font = [UIFont systemFontOfSize:13];
            [hud hideAnimated:YES afterDelay:2.f];
        }
    }
    
}
-(void)postPaymentsRequest
{
    
    [self showHUd];
#ifdef DEBUG
    NSString *url = @"http://101.201.100.191//unionpay/demo/api_05_app/TPConsume.php";
    
    
#else
    NSString *url = @"http://101.201.100.191//upacp_demo_app/demo/api_05_app/TPConsume.php";
    
    
#endif
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    [params setObject:appdelegate.userInfoDic[@"nickname"] forKey:@"nickname"];
    
    NSDateFormatter* matter = [[NSDateFormatter alloc]init];
    [matter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* date  = [NSDate date];
    NSString *NowDate = [matter stringFromDate:date];
    [params setObject:NowDate forKey:@"datetime"];
    
    [params setObject:@"余额充值" forKey:@"type"];
    [params setObject:moneyTextFD.text forKey:@"sum"];
    [params setObject:@"null" forKey:@"pay_type"];
    
    
    NSInteger actMoney1 =[moneyTextFD.text floatValue]*100;
    NSString *actMoney = [[NSString alloc]initWithFormat:@"%ld",actMoney1];
    [params setObject:actMoney forKey:@"txnAmt"];
    
    
    NSLog(@"params---%@",params);
    
    
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        [self hideHud];
        NSLog(@"%@", result);
        NSArray *arr = result;
        
#ifdef DEBUG
        [[UPPaymentControl defaultControl] startPay:[arr objectAtIndex:0] fromScheme:APPScheme mode:@"01" viewController:self];
        
        
#else
        [[UPPaymentControl defaultControl] startPay:[arr objectAtIndex:0] fromScheme:APPScheme mode:@"00" viewController:self];
        
        
#endif
        
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
}
-(void)initAlipayInfo{
 
    
    NSString *url = @"http://101.201.100.191/cnconsum/Pay/aliPay/user/Wallet/recharge.php";
    
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];

    NSMutableDictionary*paramer = [NSMutableDictionary dictionary];
    [paramer setValue:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    [paramer setValue:appdelegate.userInfoDic[@"nickname"] forKey:@"nickname"];
    [paramer setValue:moneyTextFD.text forKey:@"total_amount"];
    [paramer setValue:moneyTextFD.text forKey:@"sum"];

    NSLog(@"paramer= %@",paramer);
    
    [self showHudInView:self.view hint:@"请求中..."];
    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        [self hideHud];
        
        [[AlipaySDK defaultService] payOrder:result[@"orderInfo"] fromScheme:APPScheme callback:^(NSDictionary *resultDic)
         {
             NSLog(@"reslut = %@",resultDic);
             NSInteger orderState=[resultDic[@"resultStatus"] integerValue];
             if (orderState==9000) {
                 //支付成功,这里放你们想要的操作
                 
                 NewRechargeSuccessVC *VC = [[NewRechargeSuccessVC alloc]init];
                 VC.money_s = [NSString stringWithFormat:@"¥%@",moneyTextFD.text];
                 [self.navigationController pushViewController:VC animated:YES];
                 //                 UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"恭喜" message:@"您已成功支付啦!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                 //
                 //                 [alert show];
                 
             }else{
                 UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否放弃当前交易?" delegate:self cancelButtonTitle:@"放弃" otherButtonTitles:@"去支付", nil];
                 alert.tag =1111;
                 [alert show];
                 
             }
             
             
         }];
        
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self hideHud];

        NSLog(@"---%@",error);
    }];

}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag ==1111) {
        if (buttonIndex ==1) {
            
            if (payIndex==1) {
                [self initAlipayInfo];
            }else if (payIndex==2){
                [self postPaymentsRequest];
            }
            
        }
    }
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
