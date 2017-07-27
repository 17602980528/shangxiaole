//
//  BeautyIndustryVC.m
//  BletcShop
//
//  Created by Bletc on 2017/7/12.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "BeautyIndustryVC.h"
#import "UIImageView+WebCache.h"
#import <BaiduMapAPI_Utils/BMKGeometry.h>

#import "SDCycleScrollView.h"
#import "ShopListTableViewCell.h"
#import "DOPDropDownMenu.h"
#import "ProvinceModel.h"
#import "CityModel.h"
@interface BeautyIndustryVC ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,DOPDropDownMenuDelegate,DOPDropDownMenuDataSource>
{
    NSArray *arr;
    
    NSDictionary *curentEare;

    NSDictionary *currentCityDic;
    UIScrollView *middle_scrollView;
    
    BOOL needRefresh;
    
    
}
@property (weak, nonatomic) IBOutlet UITableView *table_view;

@property(nonatomic,strong)DOPDropDownMenu *dropDownMenu;
@property(nonatomic,strong)NSMutableArray *data_M_A;

@property(nonatomic,strong)NSMutableArray *topImg_M_A;
@property (nonatomic, strong) NSMutableArray *classifys;// 分类数组
@property(nonatomic, strong)NSMutableArray *dataSourceProvinceArray;
@property(nonatomic, strong)NSMutableArray *dataSourceCityArray;
@property (nonatomic, strong) NSArray *sorts;//智能排序
@property(nonatomic,strong)DOPIndexPath *indexpathSelect;
@property (nonatomic,copy)NSString *ereaString;
@property (nonatomic,copy)NSString *streetString;
@property (nonatomic,copy)NSString *classifyString;
@property (nonatomic, strong) NSMutableArray *adverList;// 上面的广告数组

@end

@implementation BeautyIndustryVC
-(NSMutableArray *)adverList{
    if (!_adverList) {
        _adverList = [NSMutableArray array];
    }
    return _adverList;
}
-(NSMutableArray *)dataSourceCityArray{
    if (!_dataSourceCityArray) {
        _dataSourceCityArray = [NSMutableArray array];
    }
    return _dataSourceCityArray;
}
-(NSMutableArray *)classifys{
    if (!_classifys) {
        _classifys = [NSMutableArray arrayWithArray:@[@"全部分类",@"美容",@"美发",@"养发",@"美甲",@"足疗按摩",@"皮革养护",@"汽车服务",@"洗衣",@"瑜伽舞蹈",@"瘦身纤体",@"宠物店",@"电影院",@"运动健身",@"零售连锁",@"餐饮食品",@"医药",@"游乐场",@"娱乐KTV",@"婚纱摄影",@"游泳馆",@"超市购物",@"甜点饮品",@"酒店",@"教育培训",@"商务会所"]];
    }
    return _classifys;
}

-(NSArray *)sorts{
    if (!_sorts) {
        _sorts =@[@"智能排序",@"好评优先",@"离我最近"];
    }
    return _sorts;
}

-(NSMutableArray*)topImg_M_A{
    if (!_topImg_M_A) {
        _topImg_M_A = [NSMutableArray array];
    }
    return _topImg_M_A;
}
-(NSMutableArray *)data_M_A{
    if (!_data_M_A) {
        _data_M_A = [NSMutableArray array];
    }
    return _data_M_A;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    currentCityDic = [[NSUserDefaults standardUserDefaults]objectForKey:@"currentCityDic"] ? [[NSUserDefaults standardUserDefaults]objectForKey:@"currentCityDic"] :[[NSUserDefaults standardUserDefaults]objectForKey:@"locationCityDic"] ;

    
    if (arr != [[NSUserDefaults standardUserDefaults]objectForKey:@"currentEreaList"] || [[NSUserDefaults standardUserDefaults]objectForKey:@"currentEareDic"] != curentEare) {
        curentEare = [[NSUserDefaults standardUserDefaults]objectForKey:@"currentEareDic"];
        NSLog(@"getData");
        [self getData];
    }

    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"美业频道";
    
    needRefresh = YES;
    _table_view.backgroundColor = RGB(240, 240, 240);

    [self creatTableViewHeaderView];
    
    
    [self getSubIcons];
    
    
}
-(void)getSubIcons{
    
    NSString *url = [NSString stringWithFormat:@"%@Extra/Trade/getSub",BASEURL];
    
    NSMutableDictionary*paramer = [NSMutableDictionary dictionary];
    [paramer setValue:_icon_dic[@"id"] forKey:@"up_id"];
    
    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        for (UIView *view in middle_scrollView.subviews) {
            [view removeFromSuperview];
        }
        
        for (NSInteger i = 0; i <[result count]; i ++) {
            NSDictionary *dic = result[i];
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(i*middle_scrollView.width/4, 0,middle_scrollView.width/4, middle_scrollView.height);
            [middle_scrollView addSubview:btn];
            
            middle_scrollView.contentSize = CGSizeMake(btn.right, 0);
            
            
            UIImageView *imgView = [[UIImageView alloc]init];
            
            [imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICONIMAGE,dic[@"icon_url"]]] placeholderImage:[UIImage imageNamed:@"icon3"]];
            [btn addSubview:imgView];
            
            
            [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.width.height.mas_equalTo(44);
                make.top.mas_offset(20);
                make.centerX.equalTo(btn);
            }];
            
            
            UILabel *titlelab = [[UILabel alloc]init];
            titlelab.textColor = RGB(51,51,51);
            titlelab.text = dic[@"text"];
            titlelab.font = [UIFont systemFontOfSize:13];
            titlelab.textAlignment = NSTextAlignmentCenter;
            [btn addSubview:titlelab];
            
            [titlelab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(btn).offset(-21);
                make.width.equalTo(btn);
                make.height.mas_equalTo(13);
                make.centerX.equalTo(imgView);
                
            }];
            
            
        }

        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

    
}

-(void)creatTableViewHeaderView{
    
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = RGB(240, 240, 240);
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREENWIDTH, 119*LZDScale) delegate:nil placeholderImage:[UIImage imageNamed:@"首页顶部海报"]];
    
    cycleScrollView.imageURLStringsGroup = self.topImg_M_A;
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    cycleScrollView.currentPageDotColor = [UIColor whiteColor];
    
    [cycleScrollView setValue:@"NO" forKeyPath:@"mainView.scrollsToTop"];
    
    cycleScrollView.clickItemOperationBlock = ^(NSInteger currentIndex) {
        
        
        NSLog(@"currentIndex----%ld",currentIndex);
    };
    
    [headerView addSubview:cycleScrollView];
    
    
     middle_scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, cycleScrollView.bottom+8, SCREENWIDTH, 110)];
    middle_scrollView.backgroundColor = [UIColor whiteColor];
    middle_scrollView.showsVerticalScrollIndicator = NO;
    middle_scrollView.showsHorizontalScrollIndicator = NO;
    middle_scrollView.scrollsToTop = NO;
    [headerView addSubview:middle_scrollView];
    
    for (NSInteger i = 0; i <4; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i*middle_scrollView.width/4, 0,middle_scrollView.width/4, middle_scrollView.height);
        [middle_scrollView addSubview:btn];
        
        UIImageView *imgView = [[UIImageView alloc]init];
        imgView.image = [UIImage imageNamed:@"icon3"];
        [btn addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
          
            make.width.height.mas_equalTo(44);
            make.top.mas_offset(20);
            make.centerX.equalTo(btn);
        }];
        
        
        UILabel *titlelab = [[UILabel alloc]init];
        titlelab.textColor = RGB(51,51,51);
        titlelab.text = @"美容";
        titlelab.font = [UIFont systemFontOfSize:13];
        titlelab.textAlignment = NSTextAlignmentCenter;
        [btn addSubview:titlelab];
        
        [titlelab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(btn).offset(-21);
            make.width.equalTo(btn);
            make.height.mas_equalTo(13);
            make.centerX.equalTo(imgView);
            
        }];
        

    }
    
    
    
  UIScrollView*  bottomView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, middle_scrollView.bottom+10, SCREENWIDTH, 90)];
    bottomView.backgroundColor=[UIColor whiteColor];
    bottomView.showsHorizontalScrollIndicator=NO;
    [headerView addSubview:bottomView];
    
    bottomView.scrollsToTop= NO;
    for (int i=0; i<3; i++) {
        UIImageView *placeImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10+i%3*(145+10), 10, 145, 70)];
        placeImageView.image=[UIImage imageNamed:@"icon3.png"];
        [bottomView addSubview:placeImageView];
        bottomView.contentSize=CGSizeMake(placeImageView.right+10, 0);
    }

    headerView.frame = CGRectMake(0, 0, SCREENWIDTH, bottomView.bottom+10);
    
    
    self.table_view.tableHeaderView = headerView;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return  self.data_M_A.count==0? 100  :97+4;
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40;
    
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 40)];
    backView.backgroundColor = RGB(240, 240, 240);
    
    
    if (!_dropDownMenu) {
        DOPDropDownMenu *dropDownMenu = [[DOPDropDownMenu alloc]initWithOrigin:CGPointMake(0, 0) andHeight:40];
        self.dropDownMenu = dropDownMenu;
        dropDownMenu.backgroundColor = [UIColor whiteColor];
        dropDownMenu.delegate = self;
        dropDownMenu.dataSource = self;
        [self.dropDownMenu selectDefalutIndexPath];
        NSLog(@"-_dropDownMenu--");
        
    }
   
    NSLog(@"-needRefresh--");

    if (needRefresh) {
        [backView addSubview: self.dropDownMenu];
    }


    __weak typeof(self) weakSelf = self;
   self.dropDownMenu.menuRowClcikBolck = ^(NSInteger currentIndex, BOOL show) {
        NSLog(@"-----%ld===%d",currentIndex,show);
        if (show) {
            
            needRefresh = NO;
            [weakSelf.view addSubview: weakSelf.dropDownMenu];

            if (weakSelf.table_view.tableHeaderView.height >= weakSelf.table_view.contentOffset.y) {
                [weakSelf.table_view scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];

            }
            
            
            

        }else{
            needRefresh = YES;

            [backView addSubview: weakSelf.dropDownMenu];
 
        }
        
        
    };
    
    return backView;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data_M_A.count==0 ? 1 : self.data_M_A.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentifier = @"cell";
    ShopListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (!cell) {
        cell = [[ShopListTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIndentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    if (self.data_M_A.count!=0) {
        NSDictionary *dic = self.data_M_A[indexPath.row];
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
        
        
        
        NSString *discount =[NSString getTheNoNullStr:[dic objectForKey:@"discount"] andRepalceStr:@""];
        
        
        NSString *giveString =[NSString getTheNoNullStr:[dic objectForKey:@"add"] andRepalceStr:@""];
        
        NSMutableArray *muta_a = [NSMutableArray array];
        
        
        if ([discount doubleValue]>0.0 && [discount doubleValue]<100.0) {
            
            [muta_a addObject:@"折"];
            
        }
        
        
        if ([giveString floatValue]>0.0) {
            [muta_a addObject:@"赠"];
            
            
            
        }
        
        if ([dic[@"coupon"] isEqualToString:@"yes"]) {
            [muta_a addObject:@"券"];
            
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
            
            if ([zhelab.text isEqualToString:@"折"]) {
                zhelab.backgroundColor = RGB(238,94,44);
                
            }
            
            if ([zhelab.text isEqualToString:@"赠"]) {
                zhelab.backgroundColor = RGB(86,171,228);
                
            }
            if ([zhelab.text isEqualToString:@"券"]) {
                zhelab.backgroundColor = RGB(255,0,0);
                
            }
        }
        
        cell.tradeLable.text=dic[@"trade"];
        CGRect trade_frame = cell.tradeLable.frame;
        trade_frame.size.width =[NSString calculateRowWidth: cell.tradeLable];
        cell.tradeLable.frame = trade_frame;

        
    }else{
        
        [[cell viewWithTag:9999] removeFromSuperview];
        
        
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 150)];
        backView.backgroundColor = RGB(240, 240, 240);
        backView.tag = 9999;
        [cell addSubview:backView];
        
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
    
    return cell;

    
}

#pragma mark DOPDownMenu 代理
-(NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu{
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

-(NSString*)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath{
    if (indexPath.column == 0) {
        return self.classifys[indexPath.row];
    } else if (indexPath.column == 1){
        
        ProvinceModel *m = _dataSourceProvinceArray[indexPath.row];
        
        return m.name;
    } else {
        return self.sorts[indexPath.row];
    }
    
}

-(NSInteger)menu:(DOPDropDownMenu *)menu numberOfItemsInRow:(NSInteger)row column:(NSInteger)column{
    
    if (column==1) {
        return self.dataSourceCityArray.count;

    }else{
        return -1;
    }
}

-(NSString*)menu:(DOPDropDownMenu *)menu titleForItemsInRowAtIndexPath:(DOPIndexPath *)indexPath{
    if (indexPath.column==1) {
        CityModel *m = self.dataSourceCityArray[indexPath.item];
        
        return m.name;
    }else
        return nil;
    
}

-(void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath{
    
    
    if (indexPath.item>=0) {
        self.indexpathSelect = indexPath;
        [self getAdverListRequestWithIndePath:indexPath];

    }else{
        
        if (indexPath.column ==0) {
            if([[self.classifys objectAtIndex:indexPath.row] isEqualToString:@"全部分类"]){
                self.classifyString =@"";
            }else
                self.classifyString = [self.classifys objectAtIndex:indexPath.row];
        }else if (indexPath.column == 1 ) {
            self.indexpathSelect =indexPath;
            
            
            ProvinceModel *m = _dataSourceProvinceArray[indexPath.row];
            
            [self getcityDataById:m.code AndIndexPath:indexPath];

            
        }
        
        
        [self getAdverListRequestWithIndePath:self.indexpathSelect];

    }
}

- (void)getData
{
    self.indexpathSelect = [DOPIndexPath indexPathWithCol:1 row:0 item:-1];
    
    //数据源数组:
    self.dataSourceProvinceArray = [NSMutableArray array];
    
    
    
    arr = [[NSUserDefaults standardUserDefaults]objectForKey:@"currentEreaList"];
    
    
    
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    NSString *currentEare = appdelegate.districtString.length>0?appdelegate.districtString:appdelegate.cityChoice;
    
    
    
    ProvinceModel *MM = [[ProvinceModel alloc]init];
    [MM setName:@"全城"];
    
    for (int i = 0; i < arr.count; i ++) {
        NSDictionary *dic = arr[i];
        
        ProvinceModel *model = [[ProvinceModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        //        NSLog(@"%@ * %@", model.fullname, model.id);
        if ([currentEare isEqualToString:model.name]) {
            [self.dataSourceProvinceArray insertObject:model atIndex:0];
            if (i ==0) {
                [self.dataSourceProvinceArray insertObject:MM atIndex:1];
                
            }
            
        }else{
            [self.dataSourceProvinceArray addObject:model];
            
            if (i ==0) {
                [self.dataSourceProvinceArray insertObject:MM atIndex:0];
                
            }
            
        }
        
    }
    
    
    
    
    
    
    if (self.dataSourceProvinceArray.count!=0) {
        ProvinceModel *M = [self.dataSourceProvinceArray firstObject];
        
        
        [self getcityDataById:M.code AndIndexPath:nil];
        
    }
}

//getcityDataById:这个方法里是网络请求数据的解析市数据信息
- (void)getcityDataById:(NSString *)proID AndIndexPath:(DOPIndexPath*)indexPath
{
    
    
    [self showHudInView:self.view hint:@"加载中..."];
    
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
            [self.dropDownMenu reloadRightData:indexPath];
            
        }else{
            
            
            
            [self.dropDownMenu reloadData];
            
            
            [self getAdverListRequestWithIndePath:self.indexpathSelect];
            
            //            [self performSelector:@selector(setdefaultTitle) withObject:nil afterDelay:0.2];
            
        }
        
        NSLog(@"=========%ld",self.dataSourceCityArray.count);
        
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self hideHud];
        NSLog(@"error-----%@",error);
    }];
    
    
    
    
}


//获取广告请求

-(void)getAdverListRequestWithIndePath:(DOPIndexPath*)indexPath{
    
    
    
    ProvinceModel*provinceM;
    CityModel *cityM;
    if (_dataSourceProvinceArray.count!=0) {
        provinceM =self.dataSourceProvinceArray[indexPath.row];
        self.ereaString = provinceM.name;
        
    }
    if (_dataSourceCityArray.count!=0 && indexPath.item>=0) {
        
        cityM = self.dataSourceCityArray[indexPath.item];
        self.streetString = [NSString getTheNoNullStr:cityM.name andRepalceStr:@""];
        
    }
    //    CityModel *cityM = self.dataSourceCityArray[indexPath.item];
    
    
    
    NSLog(@"----%ld==%ld==%ld",(long)indexPath.column,(long)indexPath.row,(long)indexPath.item);
    
    NSString *address = [NSString stringWithFormat:@"%@%@%@",currentCityDic[@"name"],[NSString getTheNoNullStr:provinceM.name andRepalceStr:@""],[NSString getTheNoNullStr:cityM.name andRepalceStr:@""]];
    
    
    NSLog(@"=componentsSeparatedByString===%@==+%@",address,[address componentsSeparatedByString:@"全城"]);
    
    if ([address containsString:@"全城"]) {
        
        address = [[address componentsSeparatedByString:@"全城"] firstObject];
        
        
        
    }
    
    self.ereaString = address;
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/search/multiGet",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:address forKey:@"eare"];
    [params setValue:self.classifyString forKey:@"trade"];
    DebugLog(@"===url=%@\n===paramer==%@",url,params);
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        if ([result isKindOfClass:[NSDictionary class]]) {
            
            
            NSArray *ad_A = result[@"advert"];
            
            
            [self.adverList removeAllObjects];
            
            
            for (NSDictionary *dic in ad_A) {
                [self.adverList addObject:dic];
                
                
            }
            
            
            [self postRequestShopWithAddress:address];
            
//            [_refreshheader endRefreshing];
//            [_refreshFooter endRefreshing];
//            
            [self.table_view reloadData];
        }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [_refreshheader endRefreshing];
//        [_refreshFooter endRefreshing];
        
        [self hideHud];
        NSLog(@"%@", error);
        
    }];
    
    
    
    
}


-(void)postRequestShopWithAddress:(NSString *)address
{
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/search/get",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"1" forKey:@"index"];
    [params setObject:address forKey:@"eare"];
    [params setValue:self.classifyString forKey:@"trade"];
    DebugLog(@"===url=%@\n===paramer==%@",url,params);
    
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
          NSLog(@"postRequestShop-----%@",result);
        
        [self hideHud];
        
        if ([result isKindOfClass:[NSArray class]]) {
            
           
            [self.data_M_A removeAllObjects];
                for (int i=0; i<[result count]; i++) {
                    [self.data_M_A addObject:result[i]];
                }
//            [_refreshheader endRefreshing];
//            [_refreshFooter endRefreshing];
            
            [self.table_view reloadData];
        }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [_refreshheader endRefreshing];
//        [_refreshFooter endRefreshing];
        
        [self hideHud];
        NSLog(@"%@", error);
        
    }];
    
}


@end
