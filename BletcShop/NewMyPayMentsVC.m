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
        cell.appriseBtn.tag=indexPath.row;
        [cell.appriseBtn addTarget:self action:@selector(appriseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
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

@end
