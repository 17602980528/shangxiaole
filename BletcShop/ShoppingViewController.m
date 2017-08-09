//
//  ShoppingViewController.m
//  BletcShop
//
//  Created by wuzhengdong on 16/1/25.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "ShoppingViewController.h"
#import "UIImageView+WebCache.h"
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>

#import "DOPDropDownMenu.h"

#import "NewShopDetailVC.h"
#import "ShopListTableViewCell.h"
#import "ShaperView.h"

#import "JFAreaDataManager.h"

#import "ProvinceModel.h"
#import "CityModel.h"
#import "SDCycleScrollView.h"

@interface ShoppingViewController ()<UITableViewDataSource,UITableViewDelegate,DOPDropDownMenuDataSource,DOPDropDownMenuDelegate,SDCycleScrollViewDelegate>
{
    
    SDRefreshFooterView *_refreshFooter;
    SDRefreshHeaderView *_refreshheader;
    
    NSArray *arr;
    
    
    NSDictionary *currentCityDic;
    SDCycleScrollView *cycleScrollView2;
    
    UIScrollView *bottomView;
    
}
@property (nonatomic,copy)NSString *classifyString;
@property (nonatomic,copy)NSString *ereaString;

@property (nonatomic,copy)NSString *city;

@property (nonatomic,copy)NSString *address;
@property(nonatomic,copy)NSString *sort_string;//智能排序;

@property(nonatomic)int indexss;

@property(nonatomic,strong)UIView *headerView;//头view
@property(nonatomic,strong)DOPIndexPath *indexpathSelect;

@property(nonatomic,weak)UITableView *shopTabel;//商户的列表

@property(nonatomic, strong)NSMutableArray *dataSourceProvinceArray;
@property(nonatomic, strong)NSMutableArray *dataSourceCityArray;
//
@property(nonatomic,strong)NSMutableArray *data1;

@property (nonatomic, strong) NSArray *sorts;//智能排序
@property (nonatomic, weak) DOPDropDownMenu *menu;//下拉列表
@property (nonatomic, strong) NSMutableArray *classifys;// 分类数组




@end

@implementation ShoppingViewController




-(NSMutableArray *)classifys{
    if (!_classifys) {
        
        _classifys = [NSMutableArray array];
        
        
        NSArray *icons = [[NSUserDefaults standardUserDefaults]objectForKey:@"allIcon"];
        
        for (NSDictionary *dic in icons) {
            if (![dic[@"text"]isEqualToString:_icon_dic[@"text"]]) {
                [_classifys addObject:dic[@"text"]];

            }
            
        }
        
        [_classifys insertObject:_icon_dic[@"text"] atIndex:0];
        [_classifys insertObject:@"全部分类" atIndex:1];
        
    }
    return _classifys;
}

-(NSArray *)sorts{
    if (!_sorts) {
        _sorts = @[@"智能排序",@"好评优先",@"离我最近"];
    }
    return _sorts;
}


-(NSMutableArray *)dataSourceCityArray{
    if (!_dataSourceCityArray) {
        _dataSourceCityArray = [NSMutableArray array];
    }
    return _dataSourceCityArray;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [cycleScrollView2 adjustWhenControllerViewWillAppera];
    
    currentCityDic = [[NSUserDefaults standardUserDefaults]objectForKey:@"locationCityDic"] ? [[NSUserDefaults standardUserDefaults]objectForKey:@"locationCityDic"] :[[NSUserDefaults standardUserDefaults]objectForKey:@"currentCityDic"] ;
    
    

    
    
    

//    [_menu selectDefalutIndexPath];



}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.indexss=1;
    LEFTBACK
    [self showLoadingView];
    AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    self.address = self.city = appdelegate.city.length==0?@"西安市":appdelegate.city;
    self.sort_string = @"";
    self.classifyString =_icon_dic[@"text"];

    
    
    currentCityDic = [[NSUserDefaults standardUserDefaults]objectForKey:@"locationCityDic"] ? [[NSUserDefaults standardUserDefaults]objectForKey:@"locationCityDic"] :[[NSUserDefaults standardUserDefaults]objectForKey:@"currentCityDic"] ;
    
    [self getData];
    
    
    [self _initTable];
    [self _initFootTab];
    
    [self storeFilter_getData];
    
    
   
    
    
}


-(void)_initFootTab
{
    // 添加下拉菜单
    DOPDropDownMenu *menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:44 andSuperView:self.view];
    menu.delegate = self;
    menu.dataSource = self;
    menu.isClickHaveItemValid = YES;
    [self.view addSubview:menu];
    _menu = menu;
    
    // 创建menu 第一次显示 不会调用点击代理，可以用这个手动调用
//    [menu selectDefalutIndexPath];
    
}




//商户列表
-(void)_initTable
{
    UITableView *shopTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, SCREENWIDTH, SCREENHEIGHT-(44+64)) style:UITableViewStyleGrouped];
    shopTable.delegate = self;
    shopTable.dataSource = self;
    shopTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    shopTable.backgroundColor = RGB(240, 240, 240);

    self.shopTabel = shopTable;
    [self.view addSubview:shopTable];

    
    _refreshheader = [SDRefreshHeaderView refreshView];
    [_refreshheader addToScrollView:self.shopTabel];
    _refreshheader.isEffectedByNavigationController = NO;
    
    __block ShoppingViewController *blockSelf = self;
    _refreshheader.beginRefreshingOperation = ^{
        blockSelf.indexss=1;
        
        [blockSelf.data1 removeAllObjects];
        [blockSelf storeFilter_getFilterStores];
    };
    
    
    _refreshFooter = [SDRefreshFooterView refreshView];
    [_refreshFooter addToScrollView:self.shopTabel];
    
    _refreshFooter.beginRefreshingOperation =^{
        blockSelf.indexss++;
        
        [blockSelf StoreFilter_dropLoad];
        
    };
    
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 进入下层入口
    NSMutableDictionary *dic = [self.data1 objectAtIndex:indexPath.row];
    
    
    NewShopDetailVC *vc= [self startSellerView:dic];
    vc.videoID=@"";
    
    vc.videoID=[NSString getTheNoNullStr:dic[@"video"] andRepalceStr:@""];
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

-(NewShopDetailVC *)startSellerView:(NSMutableDictionary*)dic{
    
    NewShopDetailVC *controller = [[NewShopDetailVC alloc]init];
    
    controller.infoDic = dic;
    
    controller.title = @"商铺信息";
    
    return controller;
    
}

//点击广告处理
//-(void)postRemainClickCount:(NSDictionary *)dic{
//    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/advert/click",BASEURL];
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    //获取商家手机号
//    [params setObject:dic[@"muid"] forKey:@"muid"];
//    [params setObject:@"near" forKey:@"advert_type"];
//    [params setObject:[getUUID getUUID] forKey:@"local_id"];
//    [params setObject:dic[@"address"] forKey:@"advert_id"];
//    [params setObject:dic[@"position"] forKey:@"advert_position"];
//    NSLog(@"%@",params);
//    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
//     {
//         NSLog(@"result==%@",result);
//         
//         
//     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
//         NSLog(@"%@", error);
//         
//     }];
//    
//}


//下拉列表的代理方法
- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu
{
    return 3;
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column
{
    if (column == 0) {
        return self.classifys.count;
    }else if (column == 1){
        
        return self.dataSourceProvinceArray.count;

    }else {
        return self.sorts.count;
    }
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.column == 0) {
        return self.classifys[indexPath.row];
    } else if (indexPath.column == 1){
        
        ProvinceModel *m = _dataSourceProvinceArray[indexPath.row];
        NSLog(@"titleForRowAtIndexPath=%@",m.name);
        
        return m.name;
        //        return self.areas[indexPath.row];
    } else {
        return self.sorts[indexPath.row];
    }
    
}





- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfItemsInRow:(NSInteger)row column:(NSInteger)column
{
    
    if (column==1) {
        NSLog(@"numberOfItemsInRow=====%ld",self.dataSourceCityArray.count);
        
        return self.dataSourceCityArray.count;
        
    }else return -1;
    
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForItemsInRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.column == 1) {
        
        CityModel *m = self.dataSourceCityArray[indexPath.item];
        NSLog(@"titleForItemsInRowAtIndexPath=%@",m.name);
        
        return m.name;
    }else
        
        return nil;
}



- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath
{
    

        
        if (indexPath.column == 0) {
            if([[self.classifys objectAtIndex:indexPath.row] isEqualToString:@"全部分类"]){
                self.classifyString =@"";
            }else
                self.classifyString = [self.classifys objectAtIndex:indexPath.row];
            
            [self  storeFilter_getFilterStores];

            
        }else if (indexPath.column == 1 ) {
            self.indexpathSelect =indexPath;
            
            
           
            
            if (indexPath.item >= 0) {
                
                if (indexPath.row!=0) {
                    CityModel *m = _dataSourceCityArray[indexPath.item];
                    
                    self.address = [NSString stringWithFormat:@"%@%@%@",_city,_ereaString,m.name];
                }else{
                    self.address = _city;
                }
                

                
            }else{
               
                ProvinceModel *m = _dataSourceProvinceArray[indexPath.row];
                
                [self getcityDataById:m.code AndIndexPath:indexPath];
                
                if (indexPath.row!=0) {
                    self.ereaString = m.name;
                    
                    self.address = [NSString stringWithFormat:@"%@%@",_city,_ereaString];

                }else{
                    self.address = _city;
 
                }
                

            }
            [self  storeFilter_getFilterStores];

            
        }else if (indexPath.column==2){
            
            self.sort_string = _sorts[indexPath.row];
            
            
            [self  storeFilter_getFilterStores];

        }
        
        self.indexss=1;

        

        
        
   
    
}


//店铺列表的代理方法

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.01;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
  
        return self.data1.count;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifier = @"cell";
    ShopListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (!cell) {
        cell = [[ShopListTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIndentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    

        
        if (self.data1.count>0) {
            NSDictionary *dic=[self.data1 objectAtIndex:indexPath.row];
           
        
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
    
}

//getData这个方法里是网络请求数据的解析省份数据信息
- (void)getData
{
    self.indexpathSelect = [DOPIndexPath indexPathWithCol:1 row:0 item:-1];
    
    //数据源数组:
    self.dataSourceProvinceArray = [NSMutableArray array];
    
    
    
    arr = [[NSUserDefaults standardUserDefaults]objectForKey:@"locationCityEreaList"];
    
    
    
//    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
//    NSString *currentEare = appdelegate.districtString.length>0?appdelegate.districtString:appdelegate.cityChoice;
    
    
    
   
    for (int i = 0; i < arr.count; i ++) {
        NSDictionary *dic = arr[i];
        
        ProvinceModel *model = [[ProvinceModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
 
        [self.dataSourceProvinceArray addObject:model];
            
 
        
    }
    
    
    ProvinceModel *MM = [[ProvinceModel alloc]init];
    [MM setName:_city];
    [self.dataSourceProvinceArray insertObject:MM atIndex:0];

    
    
    
    if (self.dataSourceProvinceArray.count!=0) {
        ProvinceModel *M = [self.dataSourceProvinceArray firstObject];
        
        
        [self getcityDataById:M.code AndIndexPath:nil];
        
    }
}

//getcityDataById:这个方法里是网络请求数据的解析市数据信息
- (void)getcityDataById:(NSString *)proID AndIndexPath:(DOPIndexPath*)indexPath
{
    
    
    NSString *url = [NSString stringWithFormat:@"%@Extra/address/getStreet",BASEURL];;
    
    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
    [parame setValue:proID forKey:@"district_id"];
    
    NSLog(@"url====+%@=====%@",url,parame);
    [KKRequestDataService requestWithURL:url params:parame httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        //        NSLog(@"----%@",result);
        //遍历当前数组给madel赋值
        [self.dataSourceCityArray removeAllObjects];
        
        
        NSLog(@"indexPath-----%@=%ld=%ld=%ld",indexPath,indexPath.column ,indexPath.row,indexPath.item);
        
        if (!proID) {
            
            for (int i = 0; i <1; i ++) {
                CityModel *mod = [[CityModel alloc] init];
                
                
                if (i==0) {
                    //                    [mod setName:@"全城"];
                    
                    [mod setName: currentCityDic[@"name"]];
                    
                }else{
                    
                }
                
                [self.dataSourceCityArray insertObject:mod atIndex:i];
                
            }
            
            
        }else
        {
            for (NSDictionary *diction in result)
            {
                CityModel *model = [[CityModel alloc] init];
                [model setValuesForKeysWithDictionary:diction];
                [self.dataSourceCityArray addObject:model];
            }
        }
        
        
        
        
        
        
        if (indexPath) {
            [self.menu reloadRightData:indexPath];
            
        }else{
            
            
            
            [_menu reloadData];
            
            

            

            
        }
        
        NSLog(@"=========%ld",self.dataSourceCityArray.count);
        
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error-----%@",error);
    }];
    
    
    
    
}


//一进入页面获取数据
-(void)storeFilter_getData{
    
    
  [[self.shopTabel viewWithTag:9999] removeFromSuperview];
    
    NSString *url = [NSString stringWithFormat:@"%@UserType/StoreFilter/getData",BASEURL];
    
    
    NSMutableDictionary*paramer = [NSMutableDictionary dictionary];
    [paramer setValue:_icon_dic[@"text"] forKey:@"trade"];
    
    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        [self hintLoadingView];

        self.data1 = [result[@"stores"] mutableCopy];
        
        if (_data1.count==0) {
            
           
            [self initNoDataView];
            
        }
        [self.shopTabel reloadData];
        
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self hintLoadingView];

    }];
 
    
    
}




//筛选数据
-(void)storeFilter_getFilterStores{
    [[self.shopTabel viewWithTag:9999] removeFromSuperview];

    //    [self showHudInView:self.view hint:@"加载中..."];;
    NSString *url = [NSString stringWithFormat:@"%@UserType/StoreFilter/getFilterStores",BASEURL];
    
    AppDelegate*app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSMutableDictionary*paramer = [NSMutableDictionary dictionary];
    [paramer setValue:_classifyString forKey:@"trade"];
    [paramer setValue:_address forKey:@"location"];
    
    [paramer setValue:[NSString stringWithFormat:@"%lf",app.userLocation.location.coordinate.latitude] forKey:@"lat"];
    
    [paramer setValue:[NSString stringWithFormat:@"%lf",app.userLocation.location.coordinate.longitude] forKey:@"lng"];
    
    if ([_sort_string isEqualToString:_sorts[1]]) {
        [paramer setValue:@"best" forKey:@"pri"];
        
    }else if ([_sort_string isEqualToString:_sorts[2]]){
        [paramer setValue:@"near" forKey:@"pri"];
        
    }else{
        [paramer setValue:@"" forKey:@"pri"];
        
    }
    
    NSLog(@"getFilterStores==%@",paramer);
    
    
    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        [_refreshheader endRefreshing];
        
        
        NSLog(@"getFilterStores==%@",result);
        
        
        self.data1 = [result[@"stores"] mutableCopy];
        
        if (_data1.count==0) {
            
            
            [self initNoDataView];
            
        }
        [self.shopTabel reloadData];
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_refreshheader endRefreshing];
        
        
    }];
    
    
    
}


//下拉加载数据
-(void)StoreFilter_dropLoad{
    //    [self showHudInView:self.view hint:@"加载中..."];;
    
    NSString *url = [NSString stringWithFormat:@"%@UserType/StoreFilter/dropLoad",BASEURL];
    
    
    AppDelegate*app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSMutableDictionary*paramer = [NSMutableDictionary dictionary];
    [paramer setValue:_classifyString forKey:@"trade"];
    [paramer setValue:_address forKey:@"location"];
    
    [paramer setValue:[NSString stringWithFormat:@"%lf",app.userLocation.location.coordinate.latitude] forKey:@"lat"];
    
    [paramer setValue:[NSString stringWithFormat:@"%lf",app.userLocation.location.coordinate.longitude] forKey:@"lng"];
    
    if ([_sort_string isEqualToString:_sorts[1]]) {
        [paramer setValue:@"best" forKey:@"pri"];
        
    }else if ([_sort_string isEqualToString:_sorts[2]]){
        [paramer setValue:@"near" forKey:@"pri"];
        
    }else{
        [paramer setValue:@"" forKey:@"pri"];
        
    }
    
    [paramer setValue:[NSString stringWithFormat:@"%d",_indexss] forKey:@"index"];
    NSLog(@"dropLoad==%@",paramer);
    
    
    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        [_refreshFooter endRefreshing];
        
        [self hideHud];
        
        NSLog(@"dropLoad==%@",result);
        [self.data1 addObjectsFromArray:result[@"stores"]];
        
        
        
        
        
        
        [self.shopTabel reloadData];
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_refreshFooter endRefreshing];
        
        [self hideHud];
        
    }];
    
    
}


-(void)initNoDataView{
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, (SCREENHEIGHT-64-40 -150)/2, SCREENWIDTH, 150)];
    backView.backgroundColor = RGB(240, 240, 240);
    
    backView.tag=9999;
    [self.shopTabel addSubview:backView];
    
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-30, 30, 60, 60)];
    imgView.image = [UIImage imageNamed:@"无数据"];
    [backView addSubview:imgView];
    
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, imgView.bottom +10, SCREENWIDTH, 20)];
    
    lab.textColor= RGB(51, 51, 51);
    lab.text = @"暂时没有数据哦!!!";
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont systemFontOfSize:14];
    [backView addSubview:lab];

}

- (CGFloat)calculateRowWidth:(NSString *)string {
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:10]};  //指定字号
    CGRect rect = [string boundingRectWithSize:CGSizeMake(0, 12)/*计算宽度时要确定高度*/ options:NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size.width;
}
@end
