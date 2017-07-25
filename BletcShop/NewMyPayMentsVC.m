//
//  NewMyPayMentsVC.m
//  BletcShop
//
//  Created by apple on 2017/7/13.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "NewMyPayMentsVC.h"
#import "NewCardPayTableViewCell.h"
#import "NewCardBuyTableViewCell.h"
#import "NewAppriseVC.h"
#import "MyOrderDetailVC.h"
#import "UIImageView+WebCache.h"
#import "NewShopDetailVC.h"
@interface NewMyPayMentsVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *cardCostButton;
@property (weak, nonatomic) IBOutlet UIButton *buyCardButton;
@property (weak, nonatomic) IBOutlet UIView *moveLine;
@property (weak, nonatomic) IBOutlet UIImageView *noDataNotice;
@property (nonatomic)NSInteger apriseOrPublish;// 0 代表评价--1 代表发布
@property (nonatomic,retain)NSMutableArray *orderArray;
@end

@implementation NewMyPayMentsVC
- (IBAction)btnClick:(UIButton *)sender {
    if (self.orderArray.count!=0) {
        [self.orderArray removeAllObjects];
        [_tableView reloadData];
    }
    if (sender.tag==1) {
        _apriseOrPublish=0;
        [UIView animateWithDuration:0.3 animations:^{
            CGPoint center=self.moveLine.center;
            center.x=sender.center.x;
            self.moveLine.center=center;
        }];
        [self postRequstOrderInfo];
    }else{
        _apriseOrPublish=1;
        [UIView animateWithDuration:0.3 animations:^{
            CGPoint center=self.moveLine.center;
            center.x=sender.center.x;
            self.moveLine.center=center;
        }];
        [self buyCardsRecorsPostRequest];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _apriseOrPublish=0;
    _tableView.estimatedRowHeight=200;
    _tableView.rowHeight=UITableViewAutomaticDimension;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_apriseOrPublish==0) {
         [self postRequstOrderInfo];
    }else{
        
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.orderArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_apriseOrPublish==0) {
        static NSString *resuseIdentify=@"NewCardPayssCell";
        NewCardPayTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:resuseIdentify];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"NewCardPayTableViewCell" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor=[UIColor clearColor];
        }
        cell.delBtn.tag=indexPath.row;
        cell.appriseBtn.tag=indexPath.row;
        cell.dateTime.text=_orderArray[indexPath.row][@"datetime"];
        cell.totalCosts.text=[NSString stringWithFormat:@"消费：%@元",_orderArray[indexPath.row][@"sum"]];
        cell.shopName.text=_orderArray[indexPath.row][@"store"];//[[[[self.orderArray objectAtIndex:indexPath.row] objectForKey:@"content"] componentsSeparatedByString:PAY_USCS] firstObject];
        NSURL * nurl1=[[NSURL alloc] initWithString:[[SHOPIMAGE_ADDIMAGE stringByAppendingString:[_orderArray[indexPath.row] objectForKey:@"image_url"]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
        [cell.headImageView sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"icon3.png"] options:SDWebImageRetryFailed];
        
        if ([_orderArray[indexPath.row][@"evaluate_state"] isEqualToString:@"false"]) {
            cell.appriseBtn.userInteractionEnabled=YES;
            [cell.appriseBtn setTitle:@"评价" forState:UIControlStateNormal];
            [cell.appriseBtn setTitleColor:RGB(243, 73, 78) forState:UIControlStateNormal];
            cell.appriseBtn.layer.borderColor=RGB(243, 73, 78).CGColor;
            [cell.appriseBtn addTarget:self action:@selector(appriseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            cell.userInteractionEnabled=NO;
            [cell.appriseBtn setTitle:@"已评价" forState:UIControlStateNormal];
            [cell.appriseBtn setTitleColor:RGB(181, 181, 181) forState:UIControlStateNormal];
             cell.appriseBtn.layer.borderColor=RGB(181, 181, 181).CGColor;
        }
        [cell.delBtn addTarget:self action:@selector(deletePayRecord:) forControlEvents:UIControlEventTouchUpInside];
        //
        NSString *string = [[[[self.orderArray objectAtIndex:indexPath.row] objectForKey:@"content"] componentsSeparatedByString:PAY_USCS] lastObject];
        
        if ([[string substringToIndex:4] isEqualToString:@"结算次数"]||[[string substringToIndex:4] isEqualToString:@"消费次数"]) {
            
            NSArray *arr = [NSArray array];
            arr= [string componentsSeparatedByString:PAY_UORC];
            for (NSString *stri in arr) {
                
                NSString *price = [[stri componentsSeparatedByString:PAY_NP]lastObject];
                price =  [[price componentsSeparatedByString:@"次"]firstObject];
                string = [NSString stringWithFormat:@"%d次",[string intValue]+[price intValue]];
                
            }
            
        }else{
            
            NSArray *arr = [NSArray array];
            
            arr= [string componentsSeparatedByString:PAY_UORC];
            for (NSString *stri in arr) {
                NSString *price = [[stri componentsSeparatedByString:PAY_NP]lastObject];
                price =  [[price componentsSeparatedByString:@"元"]firstObject];
                
                string = [NSString stringWithFormat:@"%.2f元",[string floatValue]+[price floatValue]];
                
            }
            
        }
        cell.totalCosts.text=[NSString stringWithFormat:@"消费：%@",string];
        cell.goShopDetailButton.tag=indexPath.row;
        [cell.goShopDetailButton addTarget:self action:@selector(goShopDetailButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }else{
        static NSString *resuseIdentify=@"NewCardBuyTabCell";
        NewCardBuyTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:resuseIdentify];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"NewCardBuyTableViewCell" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor=[UIColor clearColor];
        }
        cell.shopName.text=self.orderArray[indexPath.row][@"store"];
        cell.cardLevel.text=[NSString stringWithFormat:@"级别：%@",self.orderArray[indexPath.row][@"card_level"]];
        cell.cardType.text=[NSString stringWithFormat:@"类型：%@",self.orderArray[indexPath.row][@"card_type"]];
        cell.payMoney.text=[NSString stringWithFormat:@"消费：%@元",self.orderArray[indexPath.row][@"sum"]];
        cell.payTime.text=self.orderArray[indexPath.row][@"datetime"];
        cell.goShopDetailButton.tag=indexPath.row;
        [cell.goShopDetailButton addTarget:self action:@selector(goShopDetailButtontap:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    
}
-(void)appriseBtnClick:(UIButton *)sender{
    NSLog(@"sender.tag====%ld",(long)sender.tag);
    NewAppriseVC *newAppriseVC=[[NewAppriseVC alloc]init];
    newAppriseVC.evaluate_dic= self.orderArray[sender.tag];
    [self.navigationController pushViewController:newAppriseVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}
//获取消费记录---刷卡消费
#pragma mark ---刷卡消费记录
-(void)postRequstOrderInfo
{
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/Record/pay",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         NSLog(@"result%@", result);
         if (result&&[result count]>0) {
             self.orderArray = [result mutableCopy];
             _tableView.hidden=NO;
             _noDataNotice.hidden=YES;
             [_tableView reloadData];
         }else{
             _tableView.hidden=YES;
             _noDataNotice.hidden=NO;
         }
         
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
     }];
    
}

-(void)deletePayRecord:(UIButton *)sender{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否删除该条消费记录？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/user/cnDel",BASEURL];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
        [params setObject:[[self.orderArray objectAtIndex:sender.tag] objectForKey:@"datetime"] forKey:@"datetime"];
        
        [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
         {
             NSLog(@"result%@", result);
             if ([result[@"result_code"] intValue]==1) {
                 [self postRequstOrderInfo];
             }else{
                 
                 [self showHint:[NSString stringWithFormat:@"result_code:%@",result[@"result_code"]]];
                 
             }
             
         } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
             //         [self noIntenet];
             NSLog(@"%@", error);
         }];
        
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:sureAction];
    
    [self presentViewController:alert animated:YES completion:nil];

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *pay_tp;
    
    
    NSString *string = [[[[self.orderArray objectAtIndex:indexPath.row] objectForKey:@"content"] componentsSeparatedByString:PAY_USCS] lastObject];
    
    if ([[string substringToIndex:4] isEqualToString:@"结算次数"]||[[string substringToIndex:4] isEqualToString:@"消费次数"]) {
        pay_tp = @"计次数量";
        NSArray *arr = [NSArray array];
        arr= [string componentsSeparatedByString:PAY_UORC];
        for (NSString *stri in arr) {
            
            NSString *price = [[stri componentsSeparatedByString:PAY_NP]lastObject];
            price =  [[price componentsSeparatedByString:@"次"]firstObject];
            string = [NSString stringWithFormat:@"%d次",[string intValue]+[price intValue]];
            
            
        }
        
    }else{
        pay_tp = @"付款金额";
        
        NSArray *arr = [NSArray array];
        
        arr= [string componentsSeparatedByString:PAY_UORC];
        for (NSString *stri in arr) {
            NSString *price = [[stri componentsSeparatedByString:PAY_NP]lastObject];
            price =  [[price componentsSeparatedByString:@"元"]firstObject];
            
            string = [NSString stringWithFormat:@"%.2f元",[string floatValue]+[price floatValue]];
            
        }
        
    }
    
    MyOrderDetailVC *VC  = [[MyOrderDetailVC alloc]init];
    VC.order_dic = [self.orderArray objectAtIndex:indexPath.row];
    VC.allPay = string;
    VC.pay_type_s = pay_tp;
    
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark ---办卡记录

-(void)buyCardsRecorsPostRequest{
     NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/Record/card",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         NSLog(@"result%@", result);
         if (result&&[result count]>0) {
             self.orderArray = [result mutableCopy];
             _tableView.hidden=NO;
             _noDataNotice.hidden=YES;
             [_tableView reloadData];
         }else{
             _tableView.hidden=YES;
             _noDataNotice.hidden=NO;
         }
         
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
     }];

    
}
-(void)goShopDetailButtonClick:(UIButton *)sender{
    NewShopDetailVC *controller = [[NewShopDetailVC alloc]init];
    controller.videoID=@"";
    NSMutableDictionary *dic=[self.orderArray[sender.tag] mutableCopy];
    [dic setObject:dic[@"merchant"] forKey:@"muid"];
    controller.infoDic=dic;
    controller.title = @"商铺信息";
    [self.navigationController pushViewController:controller animated:YES];
}
-(void)goShopDetailButtontap:(UIButton *)sender{
    NewShopDetailVC *controller = [[NewShopDetailVC alloc]init];
    controller.videoID=@"";
    NSMutableDictionary *dic=[self.orderArray[sender.tag] mutableCopy];
    [dic setObject:dic[@"merchant"] forKey:@"muid"];
    controller.infoDic=dic;
    controller.title = @"商铺信息";
    [self.navigationController pushViewController:controller animated:YES];
}
@end
