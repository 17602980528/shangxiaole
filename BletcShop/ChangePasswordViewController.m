//
//  ChangePasswordViewController.m
//  BletcShop
//
//  Created by apple on 16/9/8.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "NewPasswordViewController.h"

@interface ChangePasswordViewController ()
{
    UITextField *phoneTF;
    UITextField *nameTF;
    UITextField *cardTF;
    UITextField *certifyTF;
}
@property(nonatomic,copy)NSString *array_code;
@end

@implementation ChangePasswordViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=RGB(240, 240, 240);
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 64)];
    navView.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 18, 70, 44)];
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backRegist) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:RGB(51,51,51) forState:0];
    [self.view addSubview:navView];
    [navView addSubview:btn];
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-50, 18, 100, 44)];
    label.font=[UIFont systemFontOfSize:18.0f];
    label.text=@"忘记密码";
    label.textAlignment=1;
    label.textColor=RGB(51,51,51);
    [navView addSubview:label];
    

    UILabel *userInfoLab=[[UILabel alloc]initWithFrame:CGRectMake(19, 108, 100, 13)];
    userInfoLab.text=@"用户信息";
    [self.view addSubview:userInfoLab];
    
    
  
    //用户信息
    
    NSArray *place_H_A = @[@"请输入真实姓名",@"请输入身份证号码",@"请输入11位手机号码",@"请输入您的验证码"];
    
    for (int i = 0; i <place_H_A.count; i ++) {
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, userInfoLab.bottom +18+i*51, SCREENWIDTH, 1)];
        line.backgroundColor = RGB(217,216,217);
        [self.view addSubview:line];
        
        
        UITextField *TF=[[UITextField alloc]initWithFrame:CGRectMake(19,line.bottom, SCREENWIDTH-25, 50)];
        TF.placeholder=place_H_A[i];
        TF.font = [UIFont systemFontOfSize:13];
        
        [self.view addSubview:TF];
        if (i==0) {
            nameTF= TF;
        }
        if (i==1) {
            cardTF = TF;
        }
       

        if (i==2) {
            phoneTF = TF;
            phoneTF.keyboardType=UIKeyboardTypeNumberPad;

            UIButton *phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            phoneBtn.bounds = CGRectMake(0, 0, 115, 32);
            phoneBtn.center = CGPointMake(SCREENWIDTH-19-115/2, TF.center.y);
            [phoneBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
            [phoneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [phoneBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
            [phoneBtn setBackgroundColor:RGB(243,73,78)];
            phoneBtn.layer.cornerRadius = 12;
            [phoneBtn addTarget:self action:@selector(getProCode) forControlEvents:UIControlEventTouchUpInside];
            phoneBtn.titleLabel.font = [UIFont systemFontOfSize:13];
            [self.view addSubview:phoneBtn];
            self.getCodeBtn=phoneBtn;

            
        }
       
        if (i ==3) {
            certifyTF = TF;
            certifyTF.keyboardType=UIKeyboardTypeNumberPad;

            UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, TF.bottom, SCREENWIDTH, 1)];
            line1.backgroundColor = RGB(217,216,217);
            [self.view addSubview:line1];
        }
        
    }
    
    
    
  
       //点击校验
       //下一步
    UIButton *nextBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [nextBtn setBackgroundColor:RGB(243,73,78)];
    nextBtn.frame=CGRectMake(20, 375, SCREENWIDTH-40, 40);
    nextBtn.layer.cornerRadius=12.0;
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    nextBtn.titleLabel.font=[UIFont systemFontOfSize:13];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:nextBtn];
    [nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)getProCode
{
    if (phoneTF.text.length==11) {

        //[self showIndicatorView];
        
        NSString *url  = @"http://101.201.100.191/cnconsum/App/Extra/VerifyCode/sendSignMsg";
        
        NSMutableDictionary *paramer = [NSMutableDictionary dictionaryWithObject:[NSString getSecretStringWithPhone:phoneTF.text] forKey:@"base_str"];
        [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
            NSLog(@"-result---%@",result);
            if (result) {
                if ([result[@"state"] isEqualToString:@"access"]) {
                    [self TimeNumAction];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.array_code = [NSString stringWithFormat:@"%@",result[@"sms_code"]];
                    });
                }else if ([result[@"state"] isEqualToString:@"sign_check_fail"]){
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"验签失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertView show];
                }else if([result[@"state"] isEqualToString:@"time_out"]){
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"时间超时" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertView show];
                }else if([result[@"state"] isEqualToString:@"num_invalidate"]){
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"手机号格式错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertView show];
                }
            }
            
            
        } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发送失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            
        }];
        
    }else{
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"手机号码格式有误" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [alertView show];
    }
    
}
-(void)TimeNumAction
{
    if ([phoneTF.text isEqual: @""])
    {
        //[self textExample];
        
    }else
    {
        //[self getProCode];
        __block int timeout = 59; //倒计时时间
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(_timer, ^{
            if(timeout<=0){ //倒计时结束，关闭
                dispatch_source_cancel(_timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    [self.getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                    self.getCodeBtn.userInteractionEnabled = YES;
                    [self.getCodeBtn setBackgroundColor:RGB(243,73,78)];
                });
            }else{
                int seconds = timeout % 60 ;
                NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    //NSLog(@"____%@",strTime);
                    [UIView beginAnimations:nil context:nil];
                    [UIView setAnimationDuration:1];
                    [self.getCodeBtn setTitle:[NSString stringWithFormat:@"%@秒后重新发送",strTime] forState:UIControlStateNormal];
                    self.getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
                    [UIView commitAnimations];
                    self.getCodeBtn.userInteractionEnabled = NO;
                    [self.getCodeBtn setBackgroundColor:tableViewBackgroundColor];
                    
                });
                timeout--;
            }
        });
        dispatch_resume(_timer);
    }
}
-(void)nextBtnClick{
    
#ifdef DEBUG
    [self postRequest];

#else
  
    if (![phoneTF.text isEqualToString:@""]&&![nameTF.text isEqualToString:@""]&&![certifyTF.text isEqualToString:@""]&&![cardTF.text isEqualToString:@""]&&phoneTF.text.length==11&&cardTF.text.length==18&&[self.array_code isEqualToString:certifyTF.text]) {
        [self postRequest];
    }else if (phoneTF.text.length!=11){
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"手机号码格式有误" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
        [alertView show];
    }else if (cardTF.text.length!=18){
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"身份证号码有误" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
        [alertView show];
    }else if (![self.array_code isEqualToString:certifyTF.text]){
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"验证码有误" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
        [alertView show];
    }else if ([nameTF.text isEqualToString:@""]){
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"姓名不能为空" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
        [alertView show];
    }
    
#endif

}
-(void)postRequest{
    NSString *url =[[NSString alloc]initWithFormat:@"%@Extra/passwd/accountVerify",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:phoneTF.text forKey:@"phone"];
    //此处需判断是谁进入了该页面，商户还是用户
    [params setObject:self.type forKey:@"type"];
    [params setObject:nameTF.text forKey:@"name"];
    [params setObject:cardTF.text forKey:@"id"];
    
    DebugLog(@"===%@",params);
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         NSLog(@"%@", result)
         ;
         if ([result[@"result_code"] isEqualToString:@"access"]) {
        
             NewPasswordViewController *newVC=[[NewPasswordViewController alloc]init];
             newVC.type=self.type;
             newVC.phone=phoneTF.text;

             [self presentViewController:newVC animated:YES completion:nil];
             
         }else if([result[@"result_code"] isEqualToString:@"not_found"])
         {
             [self tishi:@"用户不存在"];
         
         }else if([result[@"result_code"] isEqualToString:@"name_wrong"])
         {
             [self tishi:@"姓名错误"];
             
         }else if([result[@"result_code"] isEqualToString:@"id_wrong"])
         {
             [self tishi:@"身份证号错误"];
             
         }else{
             
             [self tishi:result[@"result_code"]];

         }
         
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         NSLog(@"%@", error);
         
     }];

    
}
-(void)backRegist{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/**
 提示

 @param tishi 提示内容
 */
-(void)tishi:(NSString*)tishi{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = NSLocalizedString(tishi, @"HUD message title");
    
    hud.label.font = [UIFont systemFontOfSize:13];
    hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
    hud.userInteractionEnabled = YES;
    
    [hud hideAnimated:YES afterDelay:2.f];
}

@end
