//
//  NoEvaluateController.m
//  BletcShop
//
//  Created by Yuan on 16/1/26.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "NoEvaluateController.h"
#import "UIImageView+WebCache.h"
#import "AppraiseViewController.h"
#import "AddFriendTableViewCell.h"
#import "NewAppriseVC.h"
#import "NewShopDetailVC.h"
@interface NoEvaluateController ()
{
    UIImageView *noneData;
}
@property(nonatomic,weak)UITableView *noEvaluateTable;
@property (nonatomic,retain)NSMutableArray *noEvaluateShopArray;

@end

@implementation NoEvaluateController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(240, 240, 240);
    LEFTBACK
    [self _inittable];
    [self postRequestEvaluate];
}

-(void)postRequestEvaluate
{
//    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/evaluate/listGet",BASEURL];
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/evaluate/userGet",BASEURL];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];

    NSLog(@"%@",params);
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         NSLog(@"result===%@", result);
         if (result&&[result count]>0) {
             NSMutableArray *evaluateArray = [result mutableCopy];
             self.noEvaluateShopArray = evaluateArray;;
             [self.noEvaluateTable reloadData];
             self.noEvaluateTable.hidden=NO;
             noneData.hidden=YES;
         }else{
             self.noEvaluateTable.hidden=YES;
             noneData.hidden=NO;
         }
        
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         //         [self noIntenet];
         NSLog(@"%@", error);
     }];
    
}
-(void)_inittable
{
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.showsVerticalScrollIndicator = NO;
    table.rowHeight = 104;
    table.backgroundColor=RGB(240, 240, 240);
    self.noEvaluateTable = table;
    table.estimatedRowHeight=500;
    table.rowHeight=UITableViewAutomaticDimension;
    
    [self.view addSubview:table];
    
    noneData=[[UIImageView alloc]initWithFrame:CGRectMake((SCREENWIDTH-100)/2, 200, 100, 100)];
    noneData.image=[UIImage imageNamed:@"无数据.png"];
    [self.view addSubview:noneData];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%@", self.noEvaluateShopArray);
    return self.noEvaluateShopArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *resuseIdentify=@"AddFriendTableCell";
    AddFriendTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:resuseIdentify];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"AddFriendTableViewCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor clearColor];
    }
    NSString *string=[NSString stringWithFormat:@"%@%@",HEADIMAGE,self.noEvaluateShopArray[indexPath.row][@"headimage"]];
    NSURL * nurl1=[NSURL URLWithString:[string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    [cell.headImage sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"头像"] options:SDWebImageRetryFailed];
    cell.starRateView.currentScore=[self.noEvaluateShopArray[indexPath.row][@"stars"] floatValue];
    cell.nickName.text=self.noEvaluateShopArray[indexPath.row][@"nickname"];
    cell.shopName.text=self.noEvaluateShopArray[indexPath.row][@"store"];
    cell.appriseLable.text=self.noEvaluateShopArray[indexPath.row][@"content"];
    cell.publishTime.text=self.noEvaluateShopArray[indexPath.row][@"datetime"];
    cell.goShopDetailButton.tag=indexPath.row;
    [cell.goShopDetailButton addTarget:self action:@selector(goShopDetailButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}
-(void)goShopDetailButtonClick:(UIButton *)sender{
    NewShopDetailVC *controller = [[NewShopDetailVC alloc]init];
    controller.videoID=@"";
    NSMutableDictionary *dic=[self.noEvaluateShopArray[sender.tag] mutableCopy];
    [dic setObject:dic[@"merchant"] forKey:@"muid"];
    controller.infoDic=dic;
    controller.title = @"商铺信息";
    [self.navigationController pushViewController:controller animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
