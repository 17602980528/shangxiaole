//
//  GetMoneyNowVC.m
//  BletcShop
//
//  Created by Bletc on 2016/11/14.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "GetMoneyNowVC.h"
#import "BankListViewController.h"
#import "GetMoneySuccessVC.h"
#import "GetMoneyFailVC.h"
#import "NewPayCustomView.h"
#import "ChangePayPassVC.h"
@interface GetMoneyNowVC ()<UITextFieldDelegate,PayCustomViewDelegate>
{
    UILabel *bankName;
    UILabel *bankAccount;
    UILabel *allMoney_lab;
    UITextField *text_Field;
    NewPayCustomView *payView;

}
@property(nonatomic,strong)NSArray*bankArray;  //绑定银行卡
@end

@implementation GetMoneyNowVC
-(NSArray *)bankArray{
    if (!_bankArray) {
        _bankArray = [NSArray array];
    }
    return _bankArray;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self postSocketMoney];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"提现";
    LEFTBACK
    self.view.backgroundColor = RGB(240, 240, 240);
    
    UIView *View1 = [[UIView alloc]initWithFrame:CGRectMake(0, 10, SCREENWIDTH, 88)];
    View1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:View1];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectBank)];
    [View1 addGestureRecognizer:tap];
    
//    UIImageView *img_view = [[UIImageView alloc]initWithFrame:CGRectMake(13, 17, 52, 56)];
//    img_view.backgroundColor = [UIColor redColor];
//    img_view.hidden = YES;

//    [View1 addSubview:img_view];
    
     bankName = [[UILabel alloc]initWithFrame:CGRectMake(16, 19, SCREENWIDTH-(16), 16)];
    bankName.textColor = RGB(51,51,51);
    bankName.font = [UIFont systemFontOfSize:17];
    [View1 addSubview:bankName];
    
     bankAccount = [[UILabel alloc]initWithFrame:CGRectMake(16, 51, SCREENWIDTH-(16), 15)];
    bankAccount.textColor = RGB(153,153,153);
    bankAccount.font = [UIFont systemFontOfSize:15];
    [View1 addSubview:bankAccount];
    
    
    UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-10-7.5, (View1.height-15)/2, 7.5, 15)];
    imageView1.image = [UIImage imageNamed:@"arraw_right"];
    [View1 addSubview:imageView1];


    UIView *View2 = [[UIView alloc]initWithFrame:CGRectMake(0, View1.bottom+10, SCREENWIDTH, 285)];
    View2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:View2];
    
    UILabel *title_lab1 = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, 100, 55)];
    title_lab1.text = @"可提金额";
    title_lab1.textColor = RGB(51,51,51);
    title_lab1.font = [UIFont systemFontOfSize:16];
    [View2 addSubview:title_lab1];
    
    UIButton *allCashButton=[UIButton buttonWithType:UIButtonTypeCustom];
    allCashButton.frame=CGRectMake(SCREENWIDTH-80, 0, 70, 55);
    [allCashButton setTitle:@"全部提现" forState:UIControlStateNormal];
    allCashButton.titleLabel.font=[UIFont systemFontOfSize:13];
    [allCashButton setTitleColor:RGB(56,185,234) forState:UIControlStateNormal];
    [allCashButton addTarget:self action:@selector(getAllCashesClick:) forControlEvents:UIControlEventTouchUpInside];
    [View2 addSubview:allCashButton];
    
    allMoney_lab = [[UILabel alloc]initWithFrame:CGRectMake(title_lab1.right, 0, SCREENWIDTH-112-80, 55)];
    allMoney_lab.text = @"￥0.00";
    allMoney_lab.textColor = RGB(136,136,136);
    allMoney_lab.font = [UIFont systemFontOfSize:13];
    allMoney_lab.textAlignment = NSTextAlignmentRight;
    [View2 addSubview:allMoney_lab];
    
    UIView *line1=[[UIView alloc]initWithFrame:CGRectMake(13, allMoney_lab.bottom, SCREENWIDTH-26, 1)];
    line1.backgroundColor=RGB(220,220,220);
    [View2 addSubview:line1];
    
    UILabel *title_lab2 = [[UILabel alloc]initWithFrame:CGRectMake(12, line1.bottom,100 , 55)];
    title_lab2.text = @"提现金额";
    title_lab2.textColor = RGB(51,51,51);
    title_lab2.font = [UIFont systemFontOfSize:16];
    [View2 addSubview:title_lab2];
    
    UILabel *hh=[[UILabel alloc]initWithFrame:CGRectMake(12, title_lab2.bottom+8, 15, 15)];
    hh.text=@"￥";
    hh.font=[UIFont systemFontOfSize:20];
    [View2 addSubview:hh];
    
    text_Field = [[UITextField alloc]initWithFrame:CGRectMake(hh.right+5, title_lab2.bottom, SCREENWIDTH-40, 30)];
    //text_Field.placeholder= @"输入提现金额";
    text_Field.keyboardType = UIKeyboardTypeNumberPad;
    text_Field.textColor= RGB(51,51,51);
    text_Field.font = [UIFont systemFontOfSize:20];
    text_Field.clearsOnBeginEditing = YES;
    text_Field.delegate= self;
    [View2 addSubview:text_Field];
    
    UIView *line2=[[UIView alloc]initWithFrame:CGRectMake(12, hh.bottom+27, SCREENWIDTH-26, 1)];
    line2.backgroundColor=RGB(220,220,220);
    [View2 addSubview:line2];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(56, line2.bottom +35, SCREENWIDTH-112, 36);
    button.backgroundColor = NavBackGroundColor;
    [button setTitle:@"立即提现" forState:0];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    button.layer.cornerRadius =12;
    button.layer.masksToBounds = YES;
    [button addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:RGB(255,255,255) forState:0];
    [View2 addSubview: button];
    
    UILabel *notice=[[UILabel alloc]initWithFrame:CGRectMake(0, button.bottom+15, SCREENWIDTH, 20)];
    notice.textAlignment=NSTextAlignmentCenter;
    notice.text=@"3至5个工作日内到账";
    notice.font=[UIFont systemFontOfSize:13];
    notice.textColor=RGB(136,136,136);
    [View2 addSubview:notice];
    
}
//全部提现
-(void)getAllCashesClick:(UIButton *)sender{
    text_Field.text=[allMoney_lab.text stringByReplacingOccurrencesOfString:@"￥" withString:@""];
}

-(void)selectBank{
    NSLog(@"选择银行");
    BankListViewController *VC = [[BankListViewController alloc]init];
    [self.navigationController pushViewController:VC animated:YES];

}
-(void)sureClick{
    NSLog(@"立即提现===%@",text_Field.text);
    [text_Field resignFirstResponder];
    AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSString *pay_passwd= [NSString getTheNoNullStr:appdelegate.userInfoDic[@"pay_passwd"] andRepalceStr:@""];
    
    if ([pay_passwd isEqualToString:@"未设置"]) {
        
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"您还没有设置支付密码!" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            ChangePayPassVC *vc=[[ChangePayPassVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            
        }];
        [sureAction setValue:RGB(243, 73, 78) forKey:@"titleTextColor"];
       // [cancelAction setValue:RGB(243, 73, 78) forKey:@"titleTextColor"];
         [alert addAction:cancelAction];
        [alert addAction:sureAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    }else{
        if ([text_Field.text intValue]==0) {
            [self tishi:@"请输入金额!"];
            
        }else if(![NSString isPureInt: text_Field.text]&&![NSString isPureFloat: text_Field.text]){
            [self tishi:@"请输入数字!"];
            
        }else if ([self.moneyString floatValue]>=[text_Field.text floatValue]) {
            //
            payView = [[NewPayCustomView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64)];
            payView.withdrawCashLable.text=[NSString stringWithFormat:@"%@元",text_Field.text];
            payView.delegate=self;
            [self.view addSubview:payView];
            
            NSLog(@"立即===%@",text_Field.text);
        }else{
            [self tishi:@"余额不足!"];
            
        }
    }
    
}

-(void)postSocketGetMoney
{
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/user/withdraw",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    [params setObject:appdelegate.userInfoDic[@"nickname"] forKey:@"nickname"];
    [params setObject:text_Field.text forKey:@"sum"];
    [params setObject:[[self.bankArray objectAtIndex:0] objectForKey:@"name"] forKey:@"name"];
    [params setObject:[[self.bankArray objectAtIndex:0] objectForKey:@"bank"] forKey:@"bank"];
    [params setObject:[[self.bankArray objectAtIndex:0] objectForKey:@"number"] forKey:@"account"];
    NSDateFormatter* matter = [[NSDateFormatter alloc]init];
    [matter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* date  = [NSDate date];
    NSString *NowDate = [matter stringFromDate:date];
    [params setObject:NowDate forKey:@"date"];
    NSLog(@"----%@",params);
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"resultresultresultresultresult%@", result);
        
        if ([result[@"result_code"] intValue]==1) {
            
            GetMoneySuccessVC *VC = [[GetMoneySuccessVC alloc]init];
            VC.dic = params;
            [self.navigationController pushViewController:VC animated:YES];
           
        }else{
            
            GetMoneyFailVC *VC = [[GetMoneyFailVC alloc]init];
            [self.navigationController pushViewController:VC animated:YES];
            
        }
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
}
-(void)loadAlterView{
    
    GetMoneySuccessVC *VC = [[GetMoneySuccessVC alloc]init];
    [self.navigationController pushViewController:VC animated:YES];

}

-(void)postSocketMoney
{
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/user/accountGet",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    [params setObject:@"remain" forKey:@"type"];
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"%@", result);
        self.moneyString = [NSString getTheNoNullStr:result[@"remain"] andRepalceStr:@"0.00"];
        self.moneyString = [self.moneyString stringByReplacingOccurrencesOfString:@"元" withString:@""];
        [self postSocketBank];
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
}
/**
 获取绑定银行卡
 */
-(void)postSocketBank
{
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/bank/bound",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"%@", result);
        NSMutableArray *arr = [result copy];

        if (arr.count!=0) {
            
            
            self.bankArray = arr;
            
            bankName.text = arr[0][@"bank"];
            NSString *number_s = arr[0][@"number"];
            if (number_s.length>4) {
                number_s = [number_s substringFromIndex:number_s.length-4];
            }
            
            bankAccount.text =  [NSString stringWithFormat:@"尾号(%@)",number_s];
            allMoney_lab.text = self.moneyString;
 
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
       
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [payView removeFromSuperview];
}

-(void)tishi:(NSString *)tishi{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    
    hud.label.text = NSLocalizedString(tishi, @"HUD message title");
    hud.label.font = [UIFont systemFontOfSize:13];
    hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
    [hud hideAnimated:YES afterDelay:2.f];

}
//
-(void)confirmPassRightOrWrong:(NSString *)pass{
    [self checkPayPassWd:pass];
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
            [payView removeFromSuperview];
            
            [self postSocketGetMoney];
           //
            
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

@end
