//
//  CountPAYViewController.m
//  BletcShop
//
//  Created by apple on 16/8/24.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "CountPAYViewController.h"
#import "SoundPaly.h"
#import "ChangePayPassVC.h"
#import "PayCustomView.h"
#import "AccessCodeVC.h"
#import "PayVictoryVC.h"
@interface CountPAYViewController ()<UITextFieldDelegate,UIAlertViewDelegate,PayCustomViewDelegate>
{
    UITextField *textTF;
    NSInteger count;
    PayCustomView *view;
}
@end

@implementation CountPAYViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=RGB(234, 234, 234);
    self.navigationItem.title=@"计次卡支付";
    NSLog(@"%@",self.card_dic);
    LEFTBACK
    
    NSArray *array= [self.card_dic[@"price"] componentsSeparatedByString:@"元"];
    
    self.all=[array[0] floatValue];
    //修改
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 10, SCREENWIDTH, 206)];
    bgView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:bgView];
    
    UILabel *titleLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 28, SCREENWIDTH, 20)];
    titleLable.font=[UIFont systemFontOfSize:16];
    titleLable.textAlignment=NSTextAlignmentCenter;
    titleLable.textColor=RGB(51, 51, 51);
    titleLable.text=@"请创建消费次数";
    [bgView addSubview:titleLable];
    
    UIButton *redBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    redBtn.backgroundColor = [UIColor whiteColor];
    //[redBtn setTitle:@"-" forState:UIControlStateNormal];
    [redBtn setImage:[UIImage imageNamed:@"-"] forState:UIControlStateNormal];
    [redBtn setTitleColor:RGB(243, 73, 78) forState:UIControlStateNormal];
    redBtn.titleLabel.font=[UIFont systemFontOfSize:32];
    redBtn.frame=CGRectMake(40, 100, 40, 40);
    redBtn.layer.cornerRadius=20;
    redBtn.clipsToBounds=YES;
    redBtn.layer.borderWidth=1.0;
    redBtn.layer.borderColor=[RGB(243, 73, 78) CGColor];
    [redBtn addTarget:self action:@selector(redBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:redBtn];
    //右加
    UIButton *addBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame=CGRectMake(SCREENWIDTH-40-40, 100, 40,40);
    [addBtn setTitleColor:RGB(243, 73, 78) forState:UIControlStateNormal];
   // [addBtn setTitle:@"+" forState:UIControlStateNormal];
    [addBtn setImage:[UIImage imageNamed:@"+"] forState:UIControlStateNormal];
    addBtn.titleLabel.font=[UIFont systemFontOfSize:32];
    addBtn.layer.cornerRadius=20;
    addBtn.clipsToBounds=YES;
    addBtn.layer.borderWidth=1.0;
    addBtn.layer.borderColor=[RGB(243, 73, 78) CGColor];
    [addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    addBtn.backgroundColor = [UIColor whiteColor];

    [bgView addSubview:addBtn];
    //立即购买
    UIButton *buyBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    buyBtn.frame=CGRectMake(0, SCREENHEIGHT-64-44, SCREENWIDTH, 44);
    buyBtn.backgroundColor=NavBackGroundColor;
    [buyBtn setTitle:@"确认支付" forState:UIControlStateNormal];
    [buyBtn addTarget:self action:@selector(buyClick) forControlEvents:UIControlEventTouchUpInside];
    [buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:buyBtn];
    //显示次数的label
    textTF=[[UITextField alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-60, 95, 120, 50)];
    textTF.textAlignment=1;
    textTF.backgroundColor=RGB(243, 73, 78);
    textTF.textColor=[UIColor whiteColor];
    textTF.text=@"0";
    textTF.delegate=self;
    textTF.layer.cornerRadius=15;
    textTF.clipsToBounds=YES;
    [bgView addSubview:textTF];
    
    [bgView addSubview:textTF];
    
}
-(void)redBtnClick{
    if (count!=0) {
        count--;
        textTF.text=[[NSString alloc]initWithFormat:@"%ld",(long)count];
    }
}
-(void)addBtnClick{
    
    double price = [self.card_dic[@"price"] doubleValue];
    double card_remain = [self.card_dic[@"card_remain"] doubleValue];
    
    int rule =[self.card_dic[@"rule"] intValue];
    
    int time = (int)(card_remain/(price/rule));
    
    
//    int lastPerson = [self.card_dic[@"rule"] intValue];
    if (count<time) {
        count++;
        textTF.text=[[NSString alloc]initWithFormat:@"%ld",(long)count];
    }
}


/**
 确认支付
 */
-(void)buyClick{
    AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSString *pay_passwd= [NSString getTheNoNullStr:appdelegate.userInfoDic[@"pay_passwd"] andRepalceStr:@""];
    
    NSString *oneString = self.card_dic[@"price"];
    
    
    NSString *allString = self.card_dic[@"card_remain"];;
    
    
    double onePrice = [oneString doubleValue];
    double allPrice = [allString doubleValue];
    
    int cishu =[self.card_dic[@"rule"] intValue];
    int time = (int)(onePrice/(allPrice/cishu));
    NSLog(@"-----%ld---%d",[textTF.text integerValue],time);
    
    if ([textTF.text integerValue]>0 &&  [textTF.text integerValue]<=time) {
        
        if ([pay_passwd isEqualToString:@"未设置"]) {
            
            UIAlertView *alt = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还没有设置支付密码!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去设置", nil];
            alt.tag = 888;
            [alt show];
            
        }else{
            
            self.payCount=[textTF.text intValue];
            
            view=[[PayCustomView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
            view.delegate=self;
            [view.forgotButton addTarget:self action:@selector(forgetPayPass) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:view];
        }
        
    }else{
        if ([textTF.text integerValue]<=0) {
            [self showHint:@"请添加消费次数"];
            
        }else{
            [self showHint:@"可消费次数不足"];

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
    }else{
        //得到输入框
        
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
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/card/count_pay",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:self.user forKey:@"uuid"];
    [params setObject:self.card_dic[@"merchant"] forKey:@"muid"];
    [params setObject:self.card_dic[@"card_code"] forKey:@"cardCode"];
    [params setObject:self.card_dic[@"card_level"] forKey:@"cardLevel"];
    
    
    int cishu =[self.card_dic[@"rule"] intValue];
    float pay = (self.all/cishu)*self.payCount;
    [params setObject:@"计次卡" forKey:@"cardType"];
    
    
    
    [params setObject:[[NSString alloc] initWithFormat:@"%.2f",pay] forKey:@"sum"];
    
    NSLog(@"paramer===%@",params);
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         NSLog(@"self.payCardArray%@", result);
         
         
         if ([result[@"result_code"] intValue]==1) {
             SoundPaly *sound=[SoundPaly sharedManager:@"sms-received1" type:@"caf"];
             [sound play];
             
             UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"支付成功" preferredStyle:UIAlertControllerStyleAlert];
             UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                 self.refresheDate();
                 PayVictoryVC *vc=[[PayVictoryVC alloc]init];
                 NSMutableDictionary *dictionary=[NSMutableDictionary dictionaryWithDictionary:params];
                 [dictionary setObject:self.card_dic[@"store"] forKey:@"store"];
                 [dictionary setObject:[NSString stringWithFormat:@"%d",self.payCount] forKey:@"oldNeed"];
                 vc.dic=dictionary;
                 [self.navigationController pushViewController:vc animated:YES];
                 //POP
             }];
             
             [alertVC addAction:cancelAction];
             
             [self presentViewController:alertVC animated:YES completion:nil];
             

             
             
             
             //发送订单详情,获取店名
             
             //             [self getShopName];
         }
         
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"error=%@", error);
     }];
    
}
//发送订单详情


-(void)getShopName{
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/merchant/accountGet",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.card_dic[@"merchant"] forKey:@"muid"];
    [params setValue:@"store" forKey:@"type"];
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"result----%@",result);
        
        [self postOrderInfoWithShopName:result[@"store"]];
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    
}

-(void)postOrderInfoWithShopName:(NSString*)shopName
{
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/user/cnCmt",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    
    [params setObject:self.card_dic[@"user"] forKey:@"uuid"];
    
    
    NSString *orderInfoMessage = [[NSString alloc]initWithFormat:@"%@%@结算次数%@%@",self.card_dic[@"merchant"],PAY_USCS,PAY_NP,textTF.text];
    
    
    int cishu =[self.card_dic[@"rule"] intValue];
    float pay = (self.all/cishu)*self.payCount;
    
    [params setObject:[[NSString alloc] initWithFormat:@"%.2f",pay] forKey:@"sum"];
    
    
    
    [params setObject:orderInfoMessage forKey:@"content"];
    NSDateFormatter* matter = [[NSDateFormatter alloc]init];
    [matter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* date  = [NSDate date];
    NSString *NowDate = [matter stringFromDate:date];
    [params setObject:NowDate forKey:@"datetime"];
    
    NSLog(@"发送订单---%@",params);
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         NSLog(@"result%@", result);
         
         if ([result[@"result_code"] intValue]==1) {
             ;
             
             
         }
         else
             [self postOrderInfoWithShopName:shopName];
         
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         //         [self noIntenet];
         NSLog(@"%@", error);
     }];
    
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return NO;
}
-(void)dismissSelf{
    [self.navigationController popViewControllerAnimated:YES];
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
    
}
-(void)missPayAlert{
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [view removeFromSuperview];
}
@end
