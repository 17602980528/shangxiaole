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
@property (nonatomic)NSInteger apriseOrPublish;// 0 代表刷卡--1 代表办卡
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
    self.navigationItem.title = @"我的消费";
    [self showLoadingView];

    LZDButton *back =[LZDButton creatLZDButton];
    back.frame = CGRectMake(13, 31, 10, 20);
    [back setImage:[UIImage imageNamed:@"返回箭头"] forState:0];
    back.block = ^(LZDButton *sender) {
    
        [self.navigationController popToRootViewControllerAnimated:YES];
    };
      self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:back];
    
    self.apriseOrPublish=0;
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
        cell.shopName.text=_orderArray[indexPath.row][@"store"];
        
        NSURL * nurl1=[[NSURL alloc] initWithString:[[SHOPIMAGE_ADDIMAGE stringByAppendingString:[_orderArray[indexPath.row] objectForKey:@"image_url"]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
        [cell.headImageView sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"icon3.png"] options:SDWebImageRetryFailed];
        
        if ([_orderArray[indexPath.row][@"evaluate_state"] isEqualToString:@"false"]) {
            cell.appriseBtn.userInteractionEnabled=YES;
            [cell.appriseBtn setTitle:@"评价" forState:UIControlStateNormal];
            [cell.appriseBtn setTitleColor:RGB(243, 73, 78) forState:UIControlStateNormal];
            cell.appriseBtn.layer.borderColor=RGB(243, 73, 78).CGColor;
            [cell.appriseBtn addTarget:self action:@selector(appriseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            cell.appriseBtn.userInteractionEnabled=NO;
            [cell.appriseBtn setTitle:@"已评价" forState:UIControlStateNormal];
            [cell.appriseBtn setTitleColor:RGB(181, 181, 181) forState:UIControlStateNormal];
             cell.appriseBtn.layer.borderColor=RGB(181, 181, 181).CGColor;
        }
        [cell.delBtn addTarget:self action:@selector(deletePayRecord:) forControlEvents:UIControlEventTouchUpInside];
        //
//        NSString *string = [[[[self.orderArray objectAtIndex:indexPath.row] objectForKey:@"content"] componentsSeparatedByString:PAY_USCS] lastObject];
        
        
        NSDictionary *dic =[self.orderArray objectAtIndex:indexPath.row];
        
        NSString * ss = [dic objectForKey:@"content"];
        
        NSData *data = [ss dataUsingEncoding:NSUTF8StringEncoding];
        
      id data_id =  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        
        NSArray *arr = data_id;
        
        
        
        if ([dic[@"card_type"] isEqualToString:@"计次卡"]) {
            
            cell.card_type.text = @"消费卡种：计次卡";
            
            
            cell.current_price.text = @"";
            cell.original_price.text = @"";

            cell.totalCosts.text=[NSString stringWithFormat:@"消费：%@次",arr[3][@"value"]];

        }
        
        if ([dic[@"card_type"] isEqualToString:@"储值卡"]){
            cell.card_type.text = @"消费卡种：储值卡";

           
            cell.current_price.text = [NSString stringWithFormat:@"现价：%@",arr[3][@"value"]];
            cell.totalCosts.text=[NSString stringWithFormat:@"消费：%@",arr[3][@"value"]];
            
            cell.original_price.text = @"";

     
            
        }
        
        if ([dic[@"card_type"] isEqualToString:@"套餐卡"]){
            
            cell.card_type.text = @"消费卡种：套餐卡";
            cell.original_price.text = [NSString stringWithFormat:@"%@: %@",arr[2][@"item"],arr[2][@"value"]];
            cell.current_price.text = @"";
//            NSString *myString =@"";
            
            
            

            
//            for (int i = 0; i <arr.count/2; i++) {
//                
//                NSString *ss = arr[i*2];
//                
//                NSString *price = [NSString stringWithFormat:@"%@1次",[[ss componentsSeparatedByString:PAY_NP]lastObject]];
//
//                if (myString.length ==0) {
//                    myString = price;
//                }else{
//                    
//                    myString = [[myString stringByAppendingString:@"x"] stringByAppendingString:price];
// 
//                }
//            }
//            
//            cell.original_price.text = myString;
//
//            cell.totalCosts.text=[NSString stringWithFormat:@"消费：%ld项",arr.count];

            
        }
        if ([dic[@"card_type"] isEqualToString:@"体验卡"]){
            cell.card_type.text = @"消费卡种：体验卡";
            cell.current_price.text = @"";
            cell.original_price.text = @"";

            cell.totalCosts.text=[NSString stringWithFormat:@"消费：%@",arr[2][@"value"]];
            

            
        }
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
        NSDictionary *dic =self.orderArray[indexPath.row];
        
        cell.shopName.text=dic[@"store"];
        
        if ([dic[@"card_level"] isEqualToString:dic[@"card_type"]]) {
            cell.cardLevel.text=[NSString stringWithFormat:@"类型：%@",dic[@"card_type"]];
            cell.cardType.text=@"";
            
        }else{
            cell.cardLevel.text=[NSString stringWithFormat:@"级别：%@",dic[@"card_level"]];
            cell.cardType.text=[NSString stringWithFormat:@"类型：%@",dic[@"card_type"]];
        }
       
        
        
        cell.payMoney.text=[NSString stringWithFormat:@"消费：%@元",dic[@"sum"]];
        cell.payTime.text=dic[@"datetime"];
        cell.goShopDetailButton.tag=indexPath.row;
        [cell.goShopDetailButton addTarget:self action:@selector(goShopDetailButtontap:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.card_img.backgroundColor = [UIColor colorWithHexString:dic[@"card_temp_color"]];
        cell.card_lev.text = [NSString stringWithFormat:@"VIP%@",dic[@"card_level"]];
        
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:cell.card_lev.text];
        
        [attr setAttributes:@{NSForegroundColorAttributeName:RGB(253,108,110),NSFontAttributeName:[UIFont boldSystemFontOfSize:17]} range:NSMakeRange(0, 3)];
        
        [attr setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} range:NSMakeRange(3, cell.card_lev.text.length-3)];
        
        cell.card_lev.attributedText = attr;

        
        return cell;
    }
    
}
-(void)appriseBtnClick:(UIButton *)sender{
    NSLog(@"sender.tag====%ld",(long)sender.tag);
    NewAppriseVC *newAppriseVC=[[NewAppriseVC alloc]init];
    newAppriseVC.evaluate_dic= self.orderArray[sender.tag];
    [self.navigationController pushViewController:newAppriseVC animated:YES];
}


//获取消费记录---刷卡消费
#pragma mark ---刷卡消费记录
-(void)postRequstOrderInfo
{
    
    //    [self showHudInView:self.view hint:@"加载中..."];;
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/Record/pay",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         [self hintLoadingView];

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
         [self hintLoadingView];

         NSLog(@"%@", error);
     }];
    
}

-(void)deletePayRecord:(UIButton *)sender{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否删除该条消费记录？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/record/payDel",BASEURL];
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
    
    
    if (_apriseOrPublish==0) {
        
        NSLog(@"----刷卡消费-");

        NSDictionary *dic =[self.orderArray objectAtIndex:indexPath.row];
        
        NSString * ss = [dic objectForKey:@"content"];
        
        NSData *data = [ss dataUsingEncoding:NSUTF8StringEncoding];
        
        id data_id =  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        
        NSArray *arr = data_id;

        
    NSString *pay_tp;
    
    
    
    if ([dic[@"card_type"] isEqualToString:@"计次卡"]) {
        pay_tp = @"计次数量";
     
        
    }else{
        pay_tp = @"付款金额";
        
     
        
    }
    
    MyOrderDetailVC *VC  = [[MyOrderDetailVC alloc]init];
    VC.order_dic = [self.orderArray objectAtIndex:indexPath.row];
    VC.data_A = arr;
    VC.pay_type_s = pay_tp;
    
    [self.navigationController pushViewController:VC animated:YES];
        
        
    }else{
        
        
        NSLog(@"----办卡消费-");
    }

}

#pragma mark ---办卡记录

-(void)buyCardsRecorsPostRequest{
    //    [self showHudInView:self.view hint:@"加载中..."];;

     NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/Record/card",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         [self hideHud];
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
         [self hideHud];

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
