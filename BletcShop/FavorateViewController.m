//
//  FavorateViewController.m
//  BletcShop
//
//  Created by Bletc on 16/5/31.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "FavorateViewController.h"
#import "UIImageView+WebCache.h"
#import "NewShopDetailVC.h"
#import "FavorateTableViewCell.h"

#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>

@interface FavorateViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIImageView *noneData;
}
@property(nonatomic,weak)UITableView *favorateTable;
@end

@implementation FavorateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(240, 240, 240);
    self.title = @"我的收藏";
    LEFTBACK
    [self _inittable];
    [self showLoadingView];
    [self postRequestFavorate];
}
-(void)_inittable
{
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64) style:UITableViewStyleGrouped];
    table.delegate = self;
    table.dataSource = self;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.showsVerticalScrollIndicator = NO;
    table.rowHeight = 95;
    table.backgroundColor = RGB(240, 240, 240);
    self.favorateTable = table;
    [self.view addSubview:table];
    
    noneData=[[UIImageView alloc]initWithFrame:CGRectMake((SCREENWIDTH-100)/2, 200, 100, 100)];
    noneData.image=[UIImage imageNamed:@"无数据.png"];
    [self.view addSubview:noneData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(void)postRequestFavorate
{
    

    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/collect/storeGet",BASEURL];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"user"];
    
    

    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         [self hintLoadingView];
         NSLog(@"result===%@", result);
         if (result&&[result count]>0) {
             self.favorateShopArray = [result mutableCopy];
             _favorateTable.hidden=NO;
             noneData.hidden=YES;
             [_favorateTable reloadData];
         }else{
             _favorateTable.hidden=YES;
             noneData.hidden=NO;
         }
         
        
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         [self hintLoadingView];
         NSLog(@"%@", error);
     }];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.favorateShopArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = self.favorateShopArray[indexPath.section];
    
    FavorateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FavorateTableCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"FavorateTableViewCell" owner:self options:nil] lastObject];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
        NSURL * nurl1=[[NSURL alloc] initWithString:[[SHOPIMAGE_ADDIMAGE stringByAppendingString:dic[@"image_url"]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
        [cell.cardImageView sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"icon3.png"] options:SDWebImageRetryFailed];
    
    cell.shopName.text=[NSString getTheNoNullStr:dic[@"store"] andRepalceStr:@""];
    cell.address.text=[NSString getTheNoNullStr:dic[@"address"] andRepalceStr:@""];
    
    CLLocationCoordinate2D c1 = (CLLocationCoordinate2D){[[dic objectForKey:@"latitude"] doubleValue], [[dic objectForKey:@"longtitude"] doubleValue]};
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    CLLocationCoordinate2D c2 = appdelegate.userLocation.location.coordinate;
    BMKMapPoint a=BMKMapPointForCoordinate(c1);
    BMKMapPoint b=BMKMapPointForCoordinate(c2);
    CLLocationDistance distance = BMKMetersBetweenMapPoints(a,b);
    
    int meter = (int)distance;
    if (meter>1000) {
        cell.distance.text = [[NSString alloc]initWithFormat:@"%.1fkm",meter/1000.0];
    }else
        cell.distance.text = [[NSString alloc]initWithFormat:@"%dm",meter];
    cell.item1.hidden=YES;
    cell.item2.hidden=YES;
    return cell;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{
    // 进入下层入口
    NSMutableDictionary *dic = [self.favorateShopArray objectAtIndex:indexPath.section];
    
    NewShopDetailVC *vc= [self startSellerView:dic];
    
    vc.videoID=[NSString getTheNoNullStr:dic[@"video"] andRepalceStr:@""];
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(NewShopDetailVC*)startSellerView:(NSMutableDictionary*)dic{
    NewShopDetailVC *controller = [[NewShopDetailVC alloc]init];
    
    controller.infoDic = dic;
    
    controller.title = @"商铺信息";
    return controller;
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self removeFavorateState:self.favorateShopArray[indexPath.section][@"muid"] index:indexPath.section];
}
-(void)removeFavorateState:(NSString *)muid index:(NSInteger)index{
    
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/collect/stateSet",BASEURL];
    
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:[appdelegate.userInfoDic objectForKey:@"uuid"] forKey:@"user"];
    [params setObject:muid forKey:@"merchant"];
    [params setObject:@"false" forKey:@"state"];
   
    NSLog(@"%@",params);
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         NSLog(@"%@", result);
         NSDictionary *dic = [result copy];
             if ([dic[@"result_code"] isEqualToString:@"false"])
             {
                 [self.favorateShopArray removeObjectAtIndex:index];
                 [self.favorateTable reloadData];
                 if (self.favorateShopArray.count==0) {
                     self.favorateTable.hidden=YES;
                     noneData.hidden=NO;
                 }
             }
         
        } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         //         [self noIntenet];
         NSLog(@"%@", error);
     }];

}
@end
