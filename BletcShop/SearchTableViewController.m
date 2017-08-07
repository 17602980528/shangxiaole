//
//  SearchTableViewController.m
//  BletcShop
//
//  Created by Bletc on 16/6/20.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "SearchTableViewController.h"
#import "UIImageView+WebCache.h"
#import "NewShopDetailVC.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "ShaperView.h"
#import "DLStarRatingControl.h"

#import "ShopListTableViewCell.h"


@interface SearchTableViewController ()
@property(nonatomic)int indexss;

@end

@implementation SearchTableViewController
{
    __block int _indexss;
    SDRefreshFooterView *_refreshFooter;
    SDRefreshHeaderView *_refreshheader;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"搜索商家";
    LEFTBACK
    _indexss=1;
    self.searchList=[[NSMutableArray alloc]initWithCapacity:0];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (_searchController==nil) {
        _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    }
    
    
    _searchController.searchResultsUpdater = self;
    _searchController.delegate = self;
    _searchController.dimsBackgroundDuringPresentation = NO;
    
    _searchController.hidesNavigationBarDuringPresentation = NO;
    _searchController.searchBar.delegate =self;
    _searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
    
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.tableView.keyboardDismissMode=UIScrollViewKeyboardDismissModeOnDrag;
    _refreshheader = [SDRefreshHeaderView refreshView];
    [_refreshheader addToScrollView:self.tableView];
    _refreshheader.isEffectedByNavigationController = NO;
    
    __block SearchTableViewController *blockSelf = self;
    _refreshheader.beginRefreshingOperation = ^{
        _indexss=1;
        [blockSelf postRequestSearch];
    };
    
    
    _refreshFooter = [SDRefreshFooterView refreshView];
    [_refreshFooter addToScrollView:self.tableView];
    
    _refreshFooter.beginRefreshingOperation =^{
        blockSelf.indexss++;
        [blockSelf postRequestSearch];
        
    };
    
    
}




#pragma mark - Table view data source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    //    DebugLog(@"dataList=====%lu",(unsigned long)self.dataList.count);
    
    
    if (self.searchController.active) {
        return [self.searchList count];
    }else{
        return [self.dataList count];
        return 0;
    }
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.5;
}

//返回单元格内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifier = @"cell";
    ShopListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (!cell) {
        cell = [[ShopListTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIndentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    



    if (self.searchController.active){
        if (self.searchList.count>0) {
          
            NSDictionary *dic = self.searchList[indexPath.row];
                
                
                //店铺名
                cell.nameLabel.text=[dic objectForKey:@"store"];
                //销量
                cell.sellerLabel.text=[NSString stringWithFormat:@"| 已售%@笔",[dic objectForKey:@"sold"]];
                //距离
                CLLocationCoordinate2D c1 = CLLocationCoordinate2DMake([[dic objectForKey:@"latitude"] doubleValue], [[dic objectForKey:@"longtitude"] doubleValue]);
                AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
                
                
                BMKMapPoint a=BMKMapPointForCoordinate(c1);
                BMKMapPoint b=BMKMapPointForCoordinate(appdelegate.userLocation.location.coordinate);
                CLLocationDistance distance = BMKMetersBetweenMapPoints(a,b);
                
                int meter = (int)distance;
                if (meter>1000) {
                    cell.distanceLabel.text = [[NSString alloc]initWithFormat:@"距离%.1fkm",meter/1000.0];
                }else
                    cell.distanceLabel.text = [[NSString alloc]initWithFormat:@"距离%dm",meter];
                NSURL * nurl1=[[NSURL alloc] initWithString:[[SHOPIMAGE_ADDIMAGE stringByAppendingString:[dic objectForKey:@"image_url"]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
                [cell.shopImageView sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"icon3.png"] options:SDWebImageRetryFailed];
                
                
                
                //评星
                
                NSString *starsss = [NSString getTheNoNullStr:[dic objectForKey:@"stars"] andRepalceStr:@"0"];
                cell.starView.currentScore=[starsss floatValue];
                
                
            NSDictionary *pri_dic = dic[@"pri"];
            
            
            NSMutableArray *muta_a = [NSMutableArray array];
            
            
            if ([pri_dic[@"discount"] boolValue]) {
                
                [muta_a addObject:@"折"];
                
            }
            
            if ([pri_dic[@"coupon"] boolValue]) {
                [muta_a addObject:@"券"];
                
                
                
            }
            if ([pri_dic[@"add"] boolValue]) {
                [muta_a addObject:@"赠"];
                
                
                
            }
            if ([pri_dic[@"insure"] boolValue]) {
                [muta_a addObject:@"保"];
                
                
                
            }

                
                for (UIView *view in cell.subviews) {
                    if (view.tag>=999) {
                        [view removeFromSuperview];
                    }
                }
                for (int i = 0; i <muta_a.count; i ++) {
                    
                    
                    UILabel *zhelab=[[UILabel alloc]initWithFrame:CGRectMake(cell.nameLabel.left +i*(16+15), cell.nameLabel.bottom+13, 16, 16)];
                    zhelab.text=muta_a[i];
                    zhelab.textAlignment=1;
                    zhelab.tag =i+999;
                    zhelab.textColor=[UIColor whiteColor];
                    zhelab.font=[UIFont systemFontOfSize:12.0f];
                    zhelab.layer.cornerRadius = 2;
                    zhelab.layer.masksToBounds = YES;
                    [cell addSubview:zhelab];
                    
                    if ([zhelab.text isEqualToString:@"券"]) {
                        zhelab.backgroundColor = RGB(255,0,0);
                    }
                    if ([zhelab.text isEqualToString:@"赠"]) {
                        zhelab.backgroundColor = RGB(86,171,228);
                    }
                    if ([zhelab.text isEqualToString:@"折"]) {
                        zhelab.backgroundColor = RGB(226,102,102);
                    }
                    if ([zhelab.text isEqualToString:@"保"]) {
                        zhelab.backgroundColor = RGB(0,160,233);
                    }
                }
                
                cell.tradeLable.text=dic[@"trade"];
                CGRect trade_frame = cell.tradeLable.frame;
                trade_frame.size.width =[self calculateRowWidth: cell.tradeLable.text];
                cell.tradeLable.frame = trade_frame;
                
                
            
            
        }
    }else{
        [cell.textLabel setText:self.dataList[indexPath.row]];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    
    if ([self.delegate respondsToSelector:@selector(beginSearch:)]) {
        [self.delegate beginSearch:searchBar];
    }
    NSLog(@"searchBarShouldBeginEditing%@",self.searchList);
    return YES;
}
- (void)beginSearch:(UISearchBar *)searchBar{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)endSearch:(UISearchBar *)searchBar{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
//- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
//{
//    [self.delegate endSearch:searchBar];
//}
/**
 *  搜索结束回调用于更新UI
 *
 *  @param searchBar
 *
 *  @return
 */
-(void)postRequestSearch
{
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/merchant/search",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[self.searchController.searchBar text] forKey:@"store"];
    [params setObject:[NSString stringWithFormat:@"%d",_indexss] forKey:@"index"];
    
    DebugLog(@"url ===%@\n paramers ==%@",url,params);
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         NSLog(@"%@",result);
         if (_indexss==1) {
             
             self.searchList=[NSMutableArray arrayWithArray:result];
             
         }else{
             for (int i=0; i<[result count]; i++) {
                 [self.searchList addObject:result[i]];
             }
         }
         [_refreshheader endRefreshing];
         [_refreshFooter endRefreshing];
         
         NSLog(@"postRequestSearch===%@",self.searchList);
         [self.tableView reloadData];
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         //         [self noIntenet];
         NSLog(@"%@", error);
     }];
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    NSMutableDictionary *shopInfoDic = [self.searchList objectAtIndex:indexPath.row];
    
    NewShopDetailVC *vc= [self startSellerView:shopInfoDic];
    vc.videoID=[NSString getTheNoNullStr:shopInfoDic[@"video"] andRepalceStr:@""];
    [self.navigationController pushViewController:vc animated:YES];
//    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/merchant/videoGet",BASEURL];
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    //获取商家手机号
//    
//    [params setObject:shopInfoDic[@"muid"] forKey:@"muid"];
//    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, NSArray* result)
//     {
//         NSLog(@"%@",result);
//         if (result.count>0) {
//             __block SearchTableViewController* tempSelf = self;
//             if ([result[0][@"state"] isEqualToString:@"true"]) {
//                 vc.videoID=result[0][@"video"];
//                 
//             }else{
//                 vc.videoID=@"";
//                 
//             }
//             [tempSelf.navigationController pushViewController:vc animated:YES];
//         }else{
//             __block SearchTableViewController* tempSelf = self;
//             vc.videoID=@"";
//             [tempSelf.navigationController pushViewController:vc animated:YES];
//         }
//         
//
//     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
//         NSLog(@"%@", error);
//         __block SearchTableViewController* tempSelf = self;
//         vc.videoID=@"";
//         [tempSelf.navigationController pushViewController:vc animated:YES];
//     }];

    
}


-(NewShopDetailVC *)startSellerView:(NSMutableDictionary*)dic{
    
    NewShopDetailVC *controller = [[NewShopDetailVC alloc]init];
    
    controller.infoDic = dic;
    
    controller.title = @"商铺信息";
    NSLog(@"navigationController%@",self.navigationController);
    
    return controller;
    
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    NSLog(@"searchBarShouldEndEditing");
    _indexss=1;
    [self.delegate endSearch:searchBar];
    [self postRequestSearch];
    
    return YES;
}

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    NSString *searchString = [self.searchController.searchBar text];
    
    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", searchString];
    
    //    if (self.searchList!= nil&&self.searchList.count>0) {
    //        [self.searchList removeAllObjects];
    //    }
    //过滤数据
    self.searchList= [NSMutableArray arrayWithArray:[_dataList filteredArrayUsingPredicate:preicate]];
    //刷新表格
    NSLog(@"updateSearchResultsForSearchController%@",self.searchList);
    [self.tableView reloadData];
    
}
//在viewWillDisappear中要将UISearchController移除, 否则切换到下一个View中, 搜索框仍然会有短暂的存在
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.searchController.active) {
        self.searchController.active = NO;
        [self.searchController.searchBar removeFromSuperview];
    }
}

- (CGFloat)calculateRowWidth:(NSString *)string {
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:10]};  //指定字号
    CGRect rect = [string boundingRectWithSize:CGSizeMake(0, 12)/*计算宽度时要确定高度*/ options:NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size.width;
}

@end
