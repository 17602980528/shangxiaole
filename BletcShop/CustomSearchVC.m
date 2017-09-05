//
//  CustomSearchVC.m
//  BletcShop
//
//  Created by apple on 2017/7/31.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "CustomSearchVC.h"
#import "HistoryTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "NewShopDetailVC.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "ShaperView.h"
#import "DLStarRatingControl.h"

#import "ShopListTableViewCell.h"
@interface CustomSearchVC ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
{
    UITableView *historyTableView;
    UITextField *titleView;
    NSString *fileName;
    SDRefreshFooterView *_refreshFooter;
    SDRefreshHeaderView *_refreshheader;
}
@property(nonatomic)int indexss;
@property(nonatomic,strong)NSMutableArray *historyArray;

@property(nonatomic,strong)UITableView *tableView;
@property (strong,nonatomic) NSMutableArray  *searchList;//商家数据
@end

@implementation CustomSearchVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden=NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self postRequestHotSearch];//
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(popSelfVC)];
    
    UIView *navView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 64)];
    navView.backgroundColor=RGB(255, 255, 255);
    [self.view addSubview:navView];
    
    UIButton *rightButton=[UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame=CGRectMake(SCREENWIDTH-60, 20, 60, 40);
    rightButton.titleLabel.font=[UIFont systemFontOfSize:14.0f];
    [rightButton setTitleColor:RGB(87, 87, 87) forState:UIControlStateNormal];
    [rightButton setTitle:@"取消" forState:UIControlStateNormal];
    [navView addSubview:rightButton];
    [rightButton addTarget:self action:@selector(popSelfVC) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView *middleView=[[UIView alloc]initWithFrame:CGRectMake(13, 27, SCREENWIDTH-73, 30)];
    middleView.layer.cornerRadius=12;
    middleView.clipsToBounds=YES;
    middleView.backgroundColor=RGB(240, 240, 240);
    [navView addSubview:middleView];
    
    UIImageView *imageview=[[UIImageView alloc]initWithFrame:CGRectMake(10, 8, 14, 14)];
    imageview.image=[UIImage imageNamed:@"sousuo"];
    [middleView addSubview:imageview];
    
    titleView=[[UITextField alloc]initWithFrame:CGRectMake(35, 0, middleView.width-35, 30)];
    titleView.clearButtonMode=UITextFieldViewModeWhileEditing;
    titleView.delegate=self;
    titleView.font=[UIFont systemFontOfSize:13.0f];
    titleView.returnKeyType=UIReturnKeySearch;
    titleView.placeholder=@"    请输入店铺名";
    [titleView becomeFirstResponder];
    [middleView addSubview:titleView];
    
    //下面为商家tableview
    
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, navView.bottom, SCREENWIDTH, SCREENHEIGHT-64) style:UITableViewStyleGrouped];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.tableView.hidden=YES;
    
    _indexss=1;
    
    _refreshheader = [SDRefreshHeaderView refreshView];
    [_refreshheader addToScrollView:self.tableView];
    _refreshheader.isEffectedByNavigationController = NO;
    
    __block CustomSearchVC *blockSelf = self;
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

    //历史搜索tableview
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==self.tableView) {
         return [self.searchList count];
    }else{
         return self.historyArray.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==self.tableView) {
        static NSString *cellIndentifier = @"cell";
        ShopListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if (!cell) {
            cell = [[ShopListTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIndentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
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
        
        return cell;

    }else if (tableView==historyTableView){
        
        HistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"HistoryTableViewCell" owner:self options:nil] lastObject];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        cell.deleteButton.tag=indexPath.row;
        [cell.deleteButton addTarget:self action:@selector(deleteHistory:) forControlEvents:UIControlEventTouchUpInside];
        cell.shopName.text=self.historyArray[indexPath.row];
        return cell;
    }
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==historyTableView) {
        titleView.text= self.historyArray[indexPath.row];
        [titleView resignFirstResponder];
        
        _indexss=1;
        [self postRequestSearch];
        
    }else if (tableView==self.tableView){
        NSMutableDictionary *shopInfoDic = [self.searchList objectAtIndex:indexPath.row];
        
        NewShopDetailVC *vc= [self startSellerView:shopInfoDic];
        vc.videoID=[NSString getTheNoNullStr:shopInfoDic[@"video"] andRepalceStr:@""];
        [self.navigationController pushViewController:vc animated:YES];
    }
   
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==self.tableView) {
        return 100.5;
    }else{
        return 40;
    }
    
}
-(NewShopDetailVC *)startSellerView:(NSMutableDictionary*)dic{
    
    NewShopDetailVC *controller = [[NewShopDetailVC alloc]init];
    
    controller.infoDic = dic;

    return controller;
    
}
//for searchtableview
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"hello world");
    
    _indexss=1;
    [self postRequestSearch];
    
    [textField resignFirstResponder];
   
    return NO;
}
//for searchtableview
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    self.tableView.hidden=NO;
     //write to file
    NSString *searchName=[textField.text noWhiteSpaceString];
    
    NSInteger  state=0;
    
    if (![searchName isEqualToString:@""]) {
        if (self.historyArray.count==0) {
             [self.historyArray addObject:searchName];
        }else{
            for (int i=0; i<self.historyArray.count; i++) {
                NSString *shopName=self.historyArray[i];
                
                if ([searchName isEqualToString:shopName]) {
                    state=1;
                }
            }
            if (state==0) {
                 //[self.historyArray addObject:searchName];
                [self.historyArray insertObject:searchName atIndex:0];
            }
        }
        
    }
    //[self.historyArray removeAllObjects];
    NSLog(@"=====%@",self.historyArray);
    
    [self.historyArray writeToFile:fileName atomically:YES];
    
    [historyTableView reloadData];
     historyTableView.hidden=YES;
    
    return YES;
}
//for searchtableview
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    self.tableView.hidden=YES;
    historyTableView.hidden=NO;
    return YES;
}
//for searchtableview
-(void)popSelfVC{
    [self.navigationController popViewControllerAnimated:YES];
}
//for searchtableview
//搜索
-(void)goSearch:(UIButton *)sender{
    titleView.text=sender.titleLabel.text;
    [titleView resignFirstResponder];
    
    _indexss=1;
    [self postRequestSearch];

}
//删除历史记录
-(void)deleteHistory:(UIButton *)sender{
    [self.historyArray removeObjectAtIndex:sender.tag];
    [historyTableView reloadData];
    [self.historyArray writeToFile:fileName atomically:YES];
}
//for searchtableview
-(void)postRequestSearch
{
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/merchant/search",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:titleView.text forKey:@"store"];
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
         [_refreshheader endRefreshing];
         [_refreshFooter endRefreshing];
         NSLog(@"%@", error);
     }];
    
}
- (CGFloat)calculateRowWidth:(NSString *)string {
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:10]};  //指定字号
    CGRect rect = [string boundingRectWithSize:CGSizeMake(0, 12)/*计算宽度时要确定高度*/ options:NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size.width;
}
//获取热门搜索
-(void)postRequestHotSearch{
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/search/getHotSearch",BASEURL];

    [KKRequestDataService requestWithURL:url params:nil httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         NSLog(@"%@",result);
         if (result&&[result [@"hot_search"] count]>0) {
             UIView *tableHeaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 118)];
             tableHeaderView.backgroundColor=RGB(240, 240, 240);
             
             UILabel *hotSearch=[[UILabel alloc]initWithFrame:CGRectMake(13, 13, SCREENWIDTH-13, 13)];
             hotSearch.font=[UIFont systemFontOfSize:14];
             hotSearch.text=@"热门搜索";
             hotSearch.textAlignment=NSTextAlignmentLeft;
             hotSearch.textColor=RGB(243, 73, 78);
             [tableHeaderView addSubview:hotSearch];
             
             UIView *hotView=[[UIView alloc]initWithFrame:CGRectMake(0, hotSearch.bottom+13, SCREENWIDTH, 40)];
             hotView.backgroundColor=[UIColor whiteColor];
             [tableHeaderView addSubview:hotView];
             NSArray *hotNameArray=(NSArray *)result[@"hot_search"];// @[@"商消乐",@"季节风",@"尚艺轩",@"孙小妖果铺"];
             for (int i=0; i<hotNameArray.count; i++) {
                 UIButton *hotButton=[UIButton buttonWithType:UIButtonTypeCustom];
                 hotButton.frame=CGRectMake(i%4*SCREENWIDTH/4, i/4*40, SCREENWIDTH/4, 40);
                 [hotButton setTitle:hotNameArray[i] forState:UIControlStateNormal];
                 [hotButton setTitleColor:RGB(87, 87, 87) forState:UIControlStateNormal];
                 hotButton.titleLabel.font=[UIFont systemFontOfSize:14];
                 [hotView addSubview:hotButton];
                 hotButton.tag=i;
                 [hotButton addTarget:self action:@selector(goSearch:) forControlEvents:UIControlEventTouchUpInside];
             }
             CGRect frameForHotView=hotView.frame;
             frameForHotView.size.height=(hotNameArray.count+4-1)/4*40;
             hotView.frame=frameForHotView;
             
             CGRect frameForHeadView=tableHeaderView.frame;
             frameForHeadView.size.height=118-40+(hotNameArray.count+4-1)/4*40;
             tableHeaderView.frame=frameForHeadView;
             
             UILabel *historySearch=[[UILabel alloc]initWithFrame:CGRectMake(13, hotView.bottom+13, SCREENWIDTH-13, 13)];
             historySearch.font=[UIFont systemFontOfSize:14];
             historySearch.text=@"历史搜索";
             historySearch.textColor=RGB(87, 87, 87);
             [tableHeaderView addSubview:historySearch];
             
             historyTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64-216-40)];
             historyTableView.delegate=self;
             historyTableView.dataSource=self;
             historyTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
             [self.view addSubview:historyTableView];
             
             historyTableView.tableHeaderView=tableHeaderView;
             
             NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
             fileName = [path stringByAppendingPathComponent:@"historydata.plist"];
             
             
             NSArray *resultss = [NSArray arrayWithContentsOfFile:fileName];
             
             NSLog(@"result===%@", result);
             if (resultss) {
                 self.historyArray=[NSMutableArray arrayWithArray:resultss];
             }else{
                 self.historyArray=[NSMutableArray arrayWithCapacity:0];
             }

         }
         
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
      
         NSLog(@"%@", error);
     }];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
