//
//  CardmarketDetailVC.m
//  BletcShop
//
//  Created by Bletc on 2017/1/16.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "CardmarketDetailVC.h"
#import "CardMarketCell.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"
#import "UPPaymentControl.h"
#import "LandingController.h"
#import "RailNameConfirmVC.h"
#import "UIImageView+WebCache.h"
#import "NewShopDetailVC.h"
@interface CardmarketDetailVC ()<UITextFieldDelegate>
{
    UITableView *table_View;
    UIView *buyView;
    
    UIButton *selectBtn;
    NSString *priceString;
    
    UITextField *priceTextField;
    UILabel *serviceLab;
    UILabel *zheLab;
    UILabel *allpayLab;

    NSString *serviceCharge_s;//手续费
    NSString *chargeMoney;//折后价
    NSString *allPayMoney;//总价

    
}
@property(nonatomic,strong)UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headerImg;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *dateTime;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;

@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UIImageView *cardImg;
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UILabel *tradeLab;
@property (weak, nonatomic) IBOutlet UILabel *card_level;

@end

@implementation CardmarketDetailVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getOrderPayResult:) name:ORDER_PAY_NOTIFICATION object:nil];//监听一个通知

    [self creatBuyView];

    
   
}
//移除通知
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];

    selectBtn = nil;
    [buyView removeFromSuperview];
   
    
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
        
//        
//        PaySuccessVc *VC = [[PaySuccessVc alloc]init];
//        VC.orderInfoType = self.orderInfoType;
//        VC.card_dic = self.card_dic;
//        VC.type_new = self.level;
//        VC.money_str = [self.actualMoney substringFromIndex:5];
//        
//        [self.navigationController pushViewController:VC animated:YES];
        
        
        
        
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"恭喜" message:@"您已成功支付啦!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        
                [alert show];
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否放弃当前交易?" delegate:self cancelButtonTitle:@"放弃" otherButtonTitles:@"去支付", nil];
        alert.tag =1111;
        [alert show];
        
    }
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
LEFTBACK
    self.navigationItem.title = @"卡片详情";
    self.view.backgroundColor = RGB(240, 240, 240);

    priceString = [NSString stringWithFormat:@"%.2f",[_model.card_remain floatValue]*[_model.rate floatValue]*0.01];
    
    
    

    [self initTableView];
    
}

-(void)initTableView{
 
    
//    table_View = [[UITableView alloc]initWithFrame:CGRectMake(0, 375, SCREENWIDTH, SCREENHEIGHT-10-49) style:UITableViewStyleGrouped];
//    table_View.dataSource = self;
//    table_View.delegate = self;
//    table_View.separatorStyle= UITableViewCellSeparatorStyleNone;
//    table_View.estimatedRowHeight = 92;
//    table_View.bounces = NO;
//    
//    [self.view addSubview: table_View];
//    
    
    
    [self.headerImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HEADIMAGE,_model.headimage]] placeholderImage:[UIImage imageNamed:@"userHeader"]];
    
    self.userName.text = _model.nickname;
    self.priceLab.text = [NSString stringWithFormat:@"¥%@",_model.card_remain];
    self.dateTime.text = [NSString stringWithFormat:@"%@发布",_model.datetime];
    self.cardImg.backgroundColor = [UIColor colorWithHexString:_model.card_temp_color];
    
    self.card_level.text = [NSString stringWithFormat:@"VIP%@",_model.card_level];
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:self.card_level.text];
    
    [attr setAttributes:@{NSForegroundColorAttributeName:RGB(253,108,110),NSFontAttributeName:[UIFont boldSystemFontOfSize:27]} range:NSMakeRange(0, 3)];
    
    [attr setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} range:NSMakeRange(3, self.card_level.text.length-3)];
    
    self.card_level.attributedText = attr;

    
    
    NSString *type;
    if ([_model.method isEqualToString:@"transfer"]) {
        type = @"转让";
        self.contentLab.text = [NSString stringWithFormat:@"【%@】现有%@%@元%@%@一张(%.1f折卡),%.1f折%@,需要的朋友尽快下手",type,_model.store,_model.card_remain,_model.card_level,_model.card_type,[_model.rule floatValue]*0.1,[_model.rate floatValue]*0.1,type];
        
    }else{
        type = @"分享";
        self.contentLab.text = [NSString stringWithFormat:@"【%@】现有%@%@元%@%@一张(%g折卡),需要的朋友尽快下手,手续费仅(%@%%)",type,_model.store,_model.card_remain,_model.card_level,_model.card_type,[_model.rule floatValue]*0.1,_model.rate];
        
    }

    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc]initWithString:self.contentLab.text];
    
    [attri setAttributes:@{NSForegroundColorAttributeName:RGB(243,73,78)} range:NSMakeRange(0, 4)];
    self.contentLab.attributedText = attri;
    
    
    self.shopName.text = _model.store;
    self.tradeLab.text = [NSString stringWithFormat:@" %@ ",_model.trade];
    
    
    
    
    
    
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT-49-64, SCREENWIDTH, 49)];
    footView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:footView];
    
    
    UIButton *jiesuanBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    jiesuanBtn.frame=CGRectMake(SCREENWIDTH-90, 0, 90, 49);
    [jiesuanBtn setTitle:@"我想要" forState:UIControlStateNormal];
    jiesuanBtn.backgroundColor=NavBackGroundColor;
    [jiesuanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [footView addSubview:jiesuanBtn];
    [jiesuanBtn addTarget:self action:@selector(goJieSuan) forControlEvents:UIControlEventTouchUpInside];
    

    
    UILabel *moneyLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH-100, 49)];
    moneyLabel.text=[NSString stringWithFormat:@"付款:%@",priceString];
    self.moneyLabel=moneyLabel;
    moneyLabel.textAlignment=NSTextAlignmentRight;
    moneyLabel.font=[UIFont systemFontOfSize:15.0f];
    [footView addSubview:moneyLabel];
    
    if ([_model.method isEqualToString:@"share"]) {
        moneyLabel.hidden = YES;
    }

  
    
    
}

//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 0.01;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 0.01;
//}
//
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return 1;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//   
//    
//    return self.model.cellHight;
//    
//}
//-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    CardMarketCell *cell = [CardMarketCell creatCellWithTableView:tableView];
//    cell.model = self.model;
////    cell.pricelab.hidden = YES;
//    
//    return cell;
//}

-(void)creatBuyView{
    
    buyView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, SCREENHEIGHT)];
    buyView.backgroundColor = [UIColor colorWithRed:51/255.f green:51/255.f blue:51/255.f alpha:0.7];
    
    
    UIWindow *curent_window = [UIApplication sharedApplication].keyWindow;
    
    [curent_window addSubview: buyView];
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT- 340, SCREENWIDTH, 500)];
    backView.backgroundColor = [UIColor whiteColor];
    [buyView addSubview:backView];
    
    UIImageView *cancelImg = [[UIImageView alloc]initWithFrame:CGRectMake(20, 14, 15, 15)];
//    cancelImg.backgroundColor = [UIColor redColor];
    cancelImg.image = [UIImage imageNamed:@"card_icon_close"];
    [backView addSubview:cancelImg];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 38)];
    titleLab.text = @"支付方式";;
    titleLab.font = [UIFont systemFontOfSize:17];
    titleLab.textColor = RGB(51,51,51);
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.userInteractionEnabled = YES;
    [backView addSubview:titleLab];
    
    
   

    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(12, titleLab.bottom, SCREENWIDTH-24, 1)];
    line.backgroundColor = RGB(234,234,234);
    [backView addSubview:line];
    
    
    for (int i = 0; i <2; i ++) {
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(13, line.bottom+51*i+(51-31)/2, 31, 31)];
        [backView addSubview:imageView];
        
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(imageView.right+10, line.bottom+51*i, 100, 51)];
        lable.textColor = RGB(51,51,51);
        lable.font = [UIFont systemFontOfSize:15];
        lable.numberOfLines=0;
        [backView addSubview:lable];
        
      
        
        UIButton *button= [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, line.bottom+51*i, SCREENWIDTH, 51);
        [button addTarget:self action:@selector(chosePayType:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:button];
        button.tag = i;
        
        UIImageView *image_select = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-30-13, (51-30)/2, 30, 30)];
        [button addSubview:image_select];
        
        if (i ==0) {
            lable.text = @"支付宝支付";
            image_select.image = [UIImage imageNamed:@"settlement_choose_n"];
                
            imageView.image = [UIImage imageNamed:@"支付宝支付L"];
            
            
            if (!selectBtn) {
                selectBtn = button;

            }
            
        }else{
            lable.text = @"银联支付";
            imageView.image = [UIImage imageNamed:@"银联支付L"];
            image_select.image = [UIImage imageNamed:@"settlement_unchoose_n"];
            
            }
            
            
        }
        
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancleClick)];
    [titleLab addGestureRecognizer:tap];
    
    
    
    UILabel *moneylab = [[UILabel alloc]initWithFrame:CGRectMake(17, line.bottom +51*2+20, 150, 14)];
    moneylab.text = @"支付金额：";
    moneylab.textColor = RGB(51,51,51);
    moneylab.font = [UIFont systemFontOfSize:15];
    [backView addSubview:moneylab];
    
    
   
    
    UILabel *pricelab = [[UILabel alloc]initWithFrame:CGRectMake(0, line.bottom +51*2+17, SCREENWIDTH-24, 19)];
    pricelab.text = [NSString stringWithFormat:@"%@元",priceString];
    pricelab.textColor = RGB(51,51,51);
    pricelab.font = [UIFont systemFontOfSize:21];
    pricelab.textAlignment = NSTextAlignmentRight;
    [backView addSubview:pricelab];
    
    
    if ([_model.method isEqualToString:@"share"]) {
        moneylab.text = @"输入支付金额：";;
        pricelab.hidden = YES;
        
        priceTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, line.bottom +51*2+17, SCREENWIDTH-24, 19)];
        priceTextField.placeholder = @"请输入消费金额";
        priceTextField.delegate = self;
        priceTextField.textColor = RGB(51,51,51);
        priceTextField.font = [UIFont systemFontOfSize:15];
        priceTextField.textAlignment = NSTextAlignmentRight;
        priceTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        priceTextField.returnKeyType = UIReturnKeyDone;
        [backView addSubview:priceTextField];
        
        zheLab = [[UILabel alloc]initWithFrame:CGRectMake(17, moneylab.bottom +15, 300, 14)];
        zheLab.text = @"折后价格:0.00";
        zheLab.font = [UIFont systemFontOfSize:13];
        zheLab.textColor = RGB(51, 51, 51);
        [backView addSubview:zheLab];
        
        serviceLab = [[UILabel alloc]initWithFrame:CGRectMake(17, zheLab.bottom +10, 150, 14)];
        serviceLab.text = [NSString stringWithFormat:@"手续费(%@%%):0.00",_model.rate];
        serviceLab.font = [UIFont systemFontOfSize:13];
        serviceLab.textColor = RGB(51, 51, 51);
        [backView addSubview:serviceLab];
    
    
         allpayLab = [[UILabel alloc]initWithFrame:CGRectMake(17, moneylab.bottom +15, SCREENWIDTH - 30, 20)];
        allpayLab.text = @"实际支付:0.00";
        allpayLab.font = [UIFont systemFontOfSize:21];
        allpayLab.textColor = RGB(51, 51, 51);
        allpayLab.textAlignment = NSTextAlignmentRight;
        [backView addSubview:allpayLab];
        
        NSMutableAttributedString *mbas = [[NSMutableAttributedString alloc]initWithString:allpayLab.text];
        [mbas setAttributes:@{NSFontAttributeName :[UIFont systemFontOfSize:15]} range:NSMakeRange(0, 5)];
        allpayLab.attributedText = mbas;
    }
  
    UIButton *buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    buyButton.frame = CGRectMake(49, 340-44-20, SCREENWIDTH-49*2, 44);
    buyButton.backgroundColor = NavBackGroundColor;
    [buyButton setTitle:@"付款" forState:0];
    buyButton.titleLabel.font = [UIFont systemFontOfSize:17];
    buyButton.layer.cornerRadius = 4;
    [backView addSubview:buyButton];
    [buyButton addTarget:self action:@selector(goBuy) forControlEvents:UIControlEventTouchUpInside];
    

    
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = buyView.frame;
        frame.origin.y = -150;
        buyView.frame = frame;
    }];
    
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    float mm = [priceTextField.text floatValue]*[_model.rule floatValue]*0.01;
    
    chargeMoney = [NSString stringWithFormat:@"%.2f",mm];

    
    zheLab.text = [NSString stringWithFormat:@"折后价格:%@",chargeMoney];

    float serviceCharge = [priceTextField.text floatValue]*[_model.rate floatValue]*0.01;
    
   serviceCharge_s = [NSString stringWithFormat:@"%.2f",serviceCharge];
    
    serviceLab.text = [NSString stringWithFormat:@"手续费(%@%%):%@",_model.rate,serviceCharge_s];
    
    allPayMoney = [NSString stringWithFormat:@"%.2f",mm +serviceCharge];
    
    allpayLab.text = [NSString stringWithFormat:@"实际支付:%@",allPayMoney];
    
    NSMutableAttributedString *mbas = [[NSMutableAttributedString alloc]initWithString:allpayLab.text];
    [mbas setAttributes:@{NSFontAttributeName :[UIFont systemFontOfSize:15]} range:NSMakeRange(0, 5)];
    allpayLab.attributedText = mbas;

}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self goJieSuan];

    return  YES;
}

-(void)chosePayType:(UIButton*)sender{
    
    for (UIView *subV  in selectBtn.subviews) {
        if ([subV isKindOfClass:[UIImageView class]]) {
            UIImageView *imgV = (UIImageView *)subV;
            imgV.image = [UIImage imageNamed:@"settlement_unchoose_n"];
        }
        
    }

    for (UIView *subV  in sender.subviews) {
        if ([subV isKindOfClass:[UIImageView class]]) {
            UIImageView *imgV = (UIImageView *)subV;
            imgV.image = [UIImage imageNamed:@"settlement_choose_n"];
        }
        
    }
    selectBtn = sender;
    
    
}
-(void)cancleClick{
    
    if (priceTextField) {
        [priceTextField resignFirstResponder];
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = buyView.frame;
        frame.origin.y = SCREENHEIGHT;
        buyView.frame = frame;
    }];
}
-(void)goJieSuan{
    
    
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    if (!appdelegate.IsLogin) {
        LandingController *landVc = [[LandingController alloc]init];
        [self.navigationController pushViewController:landVc animated:YES];
    }else{
        
        if ([appdelegate.userInfoDic[@"uuid"] isEqualToString:self.model.uuid]) {
            
            NSString *str = @"蹭";
            if ([_model.method isEqualToString:@"transfer"]) {
                str = @"购买";
            }

            UIAlertView *alt = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"不能%@自己的卡!",str] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alt show];
            
        }else{
            
            
            [self postGetAuthState];
            
           
        }
        
       
    }
   }

//付款
-(void)goBuy{
    
    NSLog(@"=====%ld",selectBtn.tag);
    
    
    if (priceTextField ) {
        
        if ( (priceTextField.text.length ==0)) {
            [self showHint:@"请输入金额"];

        } else if (![NSString isPureInt:priceTextField.text]  && ![NSString isPureFloat:priceTextField.text]){
            [self showHint:@"请输入数字"];
            
        }else{
            
            if ([chargeMoney floatValue] >[_model.card_remain floatValue]) {
                [self showHint:@"会员卡余额不足!"];
                
                
            }else{
                
                [self gotoPay];

            }

        }
    }
    else{
        
        [self gotoPay];
        
    }
    
    
   
    
}

-(void)gotoPay{
    
    [self cancleClick];

        switch (selectBtn.tag) {
            case 0:
                [self initAlipayInfo];
                break;
            case 1:
                [self postPaymentsRequest];
                break;
                
                
            default:
                break;
        }

  
   
}


/**
 银联支付
 */
-(void)postPaymentsRequest
{
    [self showHUd];
    
//    NSString *url = @"http://101.201.100.191//upacp_demo_app/demo/api_05_app/TPConsume.php";
    NSString *url ;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    
    [params setValue:appdelegate.userInfoDic[@"uuid"] forKey:@"b_uuid"];
    [params setValue:_model.uuid forKey:@"s_uuid"];
    [params setValue:_model.muid forKey:@"muid"];
    [params setValue:_model.card_code forKey:@"card_code"];
    [params setValue:_model.card_level forKey:@"card_level"];
    
    
    if ([_model.method isEqualToString:@"share"]) {
        NSLog(@"蹭卡");
        

        
#ifdef DEBUG
       url = @"http://101.201.100.191//unionpay/demo/api_05_app/Share.php";
        
        
#else
        url = @"http://101.201.100.191//upacp_demo_app/demo/api_05_app/Share.php";
        
        
#endif
        
        [params setValue:_model.card_type forKey:@"card_type"];
        [params setValue:allPayMoney forKey:@"b_sum"];
        
        
        
        [params setValue:chargeMoney forKey:@"s_sum"];
        
    }else{
        NSLog(@"买二手卡");
        

        url = @"http://101.201.100.191//upacp_demo_app/demo/api_05_app/Transfer.php";
        

        [params setValue:priceString forKey:@"sum"];
        
    }
    
    /*
    
     "b_sum" = "9.50";
     "b_uuid" = "u_uuid0148";
     "card_code" = "vipc_3ba8f333e1";
     "card_level" = "\U666e\U5361";
     "card_type" = "\U50a8\U503c\U5361";
     muid = "m_d7c116a9cc";
     "s_sum" = "9.00";
     "s_uuid" = "u_c5aaaf9307";
     "total_amount" = "9.50";
    **/
    
    
    
    NSLog(@"params-----%@===%@",params,url);
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        [self hideHud];

        NSLog(@"银联支付===%@", result);
        NSArray *arr = result;
        
#ifdef DEBUG
        [[UPPaymentControl defaultControl] startPay:[arr objectAtIndex:0] fromScheme:APPScheme mode:@"01" viewController:self];
        
        
#else
        [[UPPaymentControl defaultControl] startPay:[arr objectAtIndex:0] fromScheme:APPScheme mode:@"00" viewController:self];
        
        
#endif
        
        
        
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self hideHud];

        NSLog(@"error%@", error);
        
    }];
    
}
- (void)handlePaymentResult:(NSURL*)url completeBlock:(UPPaymentResultBlock)completionBlock

{
    
    NSLog(@"UPPaymentResultBlock====%@",completionBlock);
    
}
-(void)initAlipayInfo{
    
    
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    NSMutableDictionary*paramer = [NSMutableDictionary dictionary];
    [paramer setValue:_model.uuid forKey:@"s_uuid"];
    [paramer setValue:appdelegate.userInfoDic[@"uuid"] forKey:@"b_uuid"];
    [paramer setValue:_model.muid forKey:@"muid"];
    [paramer setValue:_model.card_code forKey:@"card_code"];
    [paramer setValue:_model.card_level forKey:@"card_level"];

    [paramer setValue:_model.card_type forKey:@"card_type"];

    NSString *url;

    if ([_model.method isEqualToString:@"share"]) {
        NSLog(@"蹭卡");

        url= @"http://101.201.100.191/cnconsum/Pay/aliPay/user/CardMarket/share.php";
        
        [paramer setValue:allPayMoney forKey:@"b_sum"];
        [paramer setValue:chargeMoney forKey:@"s_sum"];
        
        [paramer setValue:allPayMoney forKey:@"total_amount"];


        
    }else{
        NSLog(@"买二手卡");
        url= @"http://101.201.100.191/cnconsum/Pay/aliPay/user/CardMarket/transfer.php";

        [paramer setValue:priceString forKey:@"sum"];
        [paramer setValue:priceString forKey:@"total_amount"];

    }

    
    
    
    NSLog(@"paramer= %@",paramer);
    
    [self showHudInView:self.view hint:@"请求中..."];
    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        [self hideHud];
        
        [[AlipaySDK defaultService] payOrder:result[@"orderInfo"] fromScheme:APPScheme callback:^(NSDictionary *resultDic)
         {
             NSLog(@"BuyCardChoicePayViewControllerreslut = %@",resultDic);
             NSInteger orderState=[resultDic[@"resultStatus"] integerValue];
             if (orderState==9000) {
                 
                 UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"恭喜" message:@"您已成功支付啦!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                 
                 [alert show];
                 
             }else{
                 UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否放弃当前交易?" delegate:self cancelButtonTitle:@"放弃" otherButtonTitles:@"去支付", nil];
                 alert.tag =1111;
                 [alert show];
                 //
             }
             
             
             
         }];
        
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self hideHud];
        
        NSLog(@"---%@",error);
    }];

    
    
}
- (void)processOrderWithPaymentResult:(NSURL *)resultUrl
                      standbyCallback:(CompletionBlock)completionBlock
{
    
}
- (void)payOrder:(NSString *)orderStr
      fromScheme:(NSString *)schemeStr
        callback:(CompletionBlock)completionBlock;
{
    
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag ==1111) {
        if (buttonIndex ==1) {
            
            if (selectBtn.tag==0) {
                [self initAlipayInfo];
            }else if (selectBtn.tag==1){
                
                [self postPaymentsRequest];
            }
            
        }
    }else{
        
        self.block();
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
}

-(void)postGetAuthState{
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/info/getAuthResult",BASEURL];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[appdelegate.userInfoDic objectForKey:@"uuid"] forKey:@"uuid"];
    
    NSLog(@"paramer ==%@url==%@",params,url);
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         NSLog(@"result====%@", result);
         NSDictionary *dic = [result copy];
         if ([dic[@"state"] isEqualToString:@"access"]) {
            
             
             [UIView animateWithDuration:0.5 animations:^{
                 CGRect frame = buyView.frame;
                 frame.origin.y = 0;
                 buyView.frame = frame;
             }];

             
             
         }else if ([dic[@"state"] isEqualToString:@"fail"]||[dic[@"state"] isEqualToString:@"not_auth"]) {
             
             NSString *mes =@"实名认证失败,是否重新认证?";
             
             if ([dic[@"state"] isEqualToString:@"not_auth"]){
                 
                 mes =@"尚未实名认证,是否去认证?";
             }
             
             UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:mes preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                 
             }];
             UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"去认证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                 
                 
                 RailNameConfirmVC *VC = [[RailNameConfirmVC alloc]init];
                 [self.navigationController pushViewController:VC animated:YES];
                 
             }];
             
             [alert addAction:cancelAction];
             [alert addAction:sureAction];
             
             [self presentViewController:alert animated:YES completion:nil];
             
         }else if ([dic[@"state"] isEqualToString:@"auditing"]) {
             
             UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"实名认证,正在审核中" preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                 
             }];
             [alert addAction:cancelAction];
             
             [self presentViewController:alert animated:YES completion:nil];
             
             
         }else{
             
             [self showHint:@"未知错误!"];
             
         }
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         //         [self noIntenet];
         NSLog(@"%@", error);
     }];
}
- (IBAction)shopClick:(id)sender {
    
    PUSH(NewShopDetailVC)
    
    vc.infoDic = [NSMutableDictionary dictionaryWithObject:_model.muid forKey:@"muid"];
    vc.videoID = @"";
}


@end
