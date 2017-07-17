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
@interface NewMyPayMentsVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *cardCostButton;
@property (weak, nonatomic) IBOutlet UIButton *buyCardButton;
@property (weak, nonatomic) IBOutlet UIView *moveLine;
@property (nonatomic)NSInteger apriseOrPublish;// 0 代表评价--1 代表发布
@property (nonatomic,retain)NSMutableArray *orderArray;
@end

@implementation NewMyPayMentsVC
- (IBAction)btnClick:(UIButton *)sender {
    if (sender.tag==1) {
        _apriseOrPublish=0;
        [UIView animateWithDuration:0.3 animations:^{
            CGPoint center=self.moveLine.center;
            center.x=sender.center.x;
            self.moveLine.center=center;
        }];
        [_tableView reloadData];
    }else{
        _apriseOrPublish=1;
        [UIView animateWithDuration:0.3 animations:^{
            CGPoint center=self.moveLine.center;
            center.x=sender.center.x;
            self.moveLine.center=center;
        }];
        [_tableView reloadData];
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
    [self postRequstOrderInfo];
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
        cell.shopName.text=[[[[self.orderArray objectAtIndex:indexPath.row] objectForKey:@"content"] componentsSeparatedByString:PAY_USCS] firstObject];
        
        if ([_orderArray[indexPath.row][@"evaluate_state"] isEqualToString:@"false"]) {
            [cell.appriseBtn setTitle:@"评价" forState:UIControlStateNormal];
            [cell.appriseBtn setTitleColor:RGB(243, 73, 78) forState:UIControlStateNormal];
            cell.appriseBtn.layer.borderColor=RGB(243, 73, 78).CGColor;
            [cell.appriseBtn addTarget:self action:@selector(appriseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [cell.appriseBtn setTitle:@"已评价" forState:UIControlStateNormal];
            [cell.appriseBtn setTitleColor:RGB(181, 181, 181) forState:UIControlStateNormal];
             cell.appriseBtn.layer.borderColor=RGB(181, 181, 181).CGColor;
        }
        [cell.delBtn addTarget:self action:@selector(deletePayRecord:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }else{
        static NSString *resuseIdentify=@"NewCardBuyTabCell";
        NewCardBuyTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:resuseIdentify];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"NewCardBuyTableViewCell" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor=[UIColor clearColor];
        }
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
//获取消费记录
-(void)postRequstOrderInfo
{
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/user/cnGet",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         NSLog(@"result%@", result);
         
         self.orderArray = [result mutableCopy];
         [_tableView reloadData];
         
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
@end
