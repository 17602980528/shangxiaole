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
@property(nonatomic,weak)UITableView *favorateTable;

@end

@implementation FavorateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"我的收藏";
    
    [self _inittable];

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
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(void)postRequestFavorate
{
    
    [self showHudInView:self.view hint:@"加载中..."];
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/collect/storeGet",BASEURL];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"user"];
    
    

    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         [self hideHud];
         NSLog(@"result===%@", result);

         self.favorateShopArray = [result mutableCopy];
         
         [_favorateTable reloadData];
        
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         [self hideHud];
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
    
//    static NSString *cellIndentifier = @"cellIndentifier";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
//    
//    for (UIView *view in cell.subviews) {
//        [view removeFromSuperview];
//    }
//    if(cell==nil)
//    {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
//        cell.backgroundColor = [UIColor whiteColor];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//
//    }
//    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//    UIImageView *cardImageView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 10, 105, 65)];
//      [cell addSubview:cardImageView];
//    
//    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(cardImageView.right+11, 15, SCREENWIDTH/3, 15)];
//    nameLabel.textAlignment = NSTextAlignmentLeft;
//    nameLabel.font = [UIFont systemFontOfSize:15];
//    nameLabel.tag = 1000;
//    nameLabel.textColor = RGB(51,51,51);
//    [cell addSubview:nameLabel];
//    UILabel *descripLabel = [[UILabel alloc]initWithFrame:CGRectMake(cardImageView.right+11, nameLabel.bottom+12, SCREENWIDTH/2, 40)];
//    descripLabel.textAlignment = NSTextAlignmentLeft;
//    descripLabel.font = [UIFont systemFontOfSize:13];
//    descripLabel.textColor = RGB(102,102,102);
//    descripLabel.numberOfLines=2;
//    descripLabel.tag = 1000;
//    [cell addSubview:descripLabel];
//    
//    UILabel *distanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, SCREENWIDTH-10, 10)];
//    distanceLabel.textAlignment = NSTextAlignmentRight;
//    distanceLabel.font = [UIFont systemFontOfSize:12];
//    descripLabel.textColor = RGB(102,102,102);
//    distanceLabel.tag = 1000;
//    [cell addSubview:distanceLabel];
//    
//    
    NSDictionary *dic = self.favorateShopArray[indexPath.section];
//
//    
//    nameLabel.text =[NSString getTheNoNullStr:dic[@"store"] andRepalceStr:@""];
//    descripLabel.text =[NSString getTheNoNullStr:dic[@"address"] andRepalceStr:@""];
//    
//    
//    CLLocationCoordinate2D c1 = (CLLocationCoordinate2D){[[dic objectForKey:@"latitude"] doubleValue], [[dic objectForKey:@"longtitude"] doubleValue]};
//    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
//    CLLocationCoordinate2D c2 = appdelegate.userLocation.location.coordinate;
//    BMKMapPoint a=BMKMapPointForCoordinate(c1);
//    BMKMapPoint b=BMKMapPointForCoordinate(c2);
//    CLLocationDistance distance = BMKMetersBetweenMapPoints(a,b);
//    
//    
//    int meter = (int)distance;
//    if (meter>1000) {
//        distanceLabel.text = [[NSString alloc]initWithFormat:@"%.1fkm",meter/1000.0];
//    }else
//        distanceLabel.text = [[NSString alloc]initWithFormat:@"%dm",meter];

//    CGFloat distance_ww = [UILabel getSizeWithLab:distanceLabel andMaxSize:CGSizeMake(100, 100)].width;
//
//    CGRect oldFrame = nameLabel.frame;
//    oldFrame.size.width = SCREENWIDTH-oldFrame.origin.x-distance_ww-15;
//    nameLabel.frame = oldFrame;
//    
//    
//    NSURL * nurl1=[[NSURL alloc] initWithString:[[SHOPIMAGE_ADDIMAGE stringByAppendingString:dic[@"image_url"]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
//    [cardImageView sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"icon3.png"] options:SDWebImageRetryFailed];
//    
//    UIView *viewLine = [[UIView alloc]initWithFrame:CGRectMake(0, 85, SCREENWIDTH, 10)];
//    viewLine.backgroundColor = RGB(240, 240, 240);
//    [cell addSubview:viewLine];
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
    
    return cell;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

//{
//    // 进入下层入口
//    NSMutableDictionary *dic = [self.favorateShopArray objectAtIndex:indexPath.row];
//    
//    [self startSellerView:dic];
//}

{
    
    // 进入下层入口
    NSMutableDictionary *dic = [self.favorateShopArray objectAtIndex:indexPath.section];
    
    NewShopDetailVC *vc= [self startSellerView:dic];
    
    vc.videoID=[NSString getTheNoNullStr:dic[@"video"] andRepalceStr:@""];
    [self.navigationController pushViewController:vc animated:YES];
    
    
//    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/merchant/videoGet",BASEURL];
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    //获取商家手机号
//    
//    [params setObject:dic[@"muid"] forKey:@"muid"];
//    
//    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, NSArray* result)
//     {
//         NSLog(@"%@",result);
//         if (result.count>0) {
//             __block FavorateViewController* tempSelf = self;
//             if ([result[0][@"state"] isEqualToString:@"true"]) {
//                 vc.videoID=result[0][@"video"];
//
//             }else{
//                 vc.videoID=@"";
//
//             }
//             [tempSelf.navigationController pushViewController:vc animated:YES];
//         }else{
//             __block FavorateViewController* tempSelf = self;
//             vc.videoID=@"";
//             [tempSelf.navigationController pushViewController:vc animated:YES];
//         }
//         
//     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
//         NSLog(@"%@", error);
//         __block FavorateViewController* tempSelf = self;
//         vc.videoID=@"";
//         [tempSelf.navigationController pushViewController:vc animated:YES];
//     }];
    
    
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
             }
         
        } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         //         [self noIntenet];
         NSLog(@"%@", error);
     }];

}
@end
