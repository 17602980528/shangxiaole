//
//  HomeViewController.m
//  BletcShop
//
//  Created by Bletc on 2016/11/4.
//  Copyright © 2016年 bletc. All rights reserved.
//
#define KCURRENTCITYINFODEFAULTS [NSUserDefaults standardUserDefaults]


#import "HomeViewController.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "ShaperView.h"
#import "DLStarRatingControl.h"
#import "HomeViewCell.h"
#import "AddressPickerDemo.h"
#import "SearchTableViewController.h"
#import "GYChangeTextView.h"
#import "NewShopDetailVC.h"
#import "BaseNavigationController.h"
#import "AdvertiseViewController.h"
#import "NewShopViewController.h"
#import "PointConvertViewController.h"
#import "NewMessageVC.h"

//#import "LZDCenterViewController.h"
#import "TopActiveListTableVC.h"
#import "SDCycleScrollView.h"

#import "ScanViewController.h"
#import "HolidayActivertyVC.h"
#import "JFCityViewController.h"

#import "JFLocation.h"
#import "JFAreaDataManager.h"
#import "HotNewsVC.h"
#import "ChouJiangVC.h"
#import "LandingController.h"

#import "BeautyIndustryVC.h"

#import "ShoppingViewController.h"
#import "MemberCenterVC.h"

@interface HomeViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,GYChangeTextViewDelegate,SelectCityDelegate,JFLocationDelegate,SDCycleScrollViewDelegate>
{
    
    int currentIndex3;//请求页码
    int currentIndex1;//请求页码

    UIView*searchView;
    UIView *top_line;
    NSString *address_old;//之前的地址
    //广告轮播
    NSArray* _topAdverImages;
    NSInteger _pageID;
    
    UIPageControl *topPageControl;
   
    
    UIButton* _longAdvertise_btn;//长条广告
    
    //当前展示的页码。
    NSInteger _pageIndex;

    UIImageView *dingwei_img;
    UIButton *dingweiBtn;
    UITextField*search_tf; // placeholder
    UIView *topView;
    
    UITableView *table_View;
    
    SDRefreshFooterView *_refreshFooter;
    SDRefreshHeaderView *_refreshheader;
    //广告位
    UIScrollView    *_smallSV;
    UIPageControl   *_pc;
    UIView *PopupAdvertiseView;//弹出广告
    SDCycleScrollView *cycleScrollView2;
    
    UIImageView *dingweiXiaImg;
    
    NSDictionary *pop_data_Dic;
    
    UIImageView *erweimaImg;
    UIImageView *xiaoxiImg;
    UIImageView *search1;

}

@property(nonatomic,copy) NSString *city_district;//市区
@property (nonatomic, strong) GYChangeTextView *tView;

@property(nonatomic,strong)NSMutableArray* adverImages;
@property(nonatomic,strong) NSArray *icon_A;//20个小分类
@property(nonatomic,strong) NSArray *advertiseHeaderList;//头条信息
@property(nonatomic,strong) NSDictionary *longAdvertise_dic;//长条广告信息
@property(nonatomic,strong)NSMutableArray *titles;//顶部轮播广告

@property(nonatomic,strong)NSArray *circleAdverlist;//顶部轮播广告
@property(nonatomic,strong)UIView *headerView;//头view
@property(nonatomic,strong)NSMutableArray *data_A3; //广告位.第三部分列表
@property(nonatomic,strong)UIView *secondheaderView;//头2view

@property(nonatomic,strong)NSArray *data_A2;//广告位.第二部分列表

//地点选择
@property(nonatomic,strong)NSArray *areaListArray;
@property (nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,copy)NSString *cityChoice;//选择的地点


@property (nonatomic,assign)BOOL ifOpen;


@property(nonatomic,strong)NSTimer *changelabTimer;//定时器,轮播文字
@property(nonatomic,assign)NSInteger  index;


@property(nonatomic,strong)NSMutableArray *shopData_A;//保存所有数据
@property (nonatomic, strong) JFLocation *locationManager;
@property (nonatomic, strong) JFAreaDataManager *manager;


@end

@implementation HomeViewController
- (JFAreaDataManager *)manager {
    if (!_manager) {
        _manager = [JFAreaDataManager shareManager];
        [_manager areaSqliteDBData];
    }
    return _manager;
}

-(NSMutableArray*)titles{
    if (!_titles) {
        _titles = [NSMutableArray array];
    }
    return _titles;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    PopupAdvertiseView.hidden=NO;
    self.navigationController.navigationBar.hidden= YES;
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    if (self.tView && (self.advertiseHeaderList.count!=0)) {
        
        [self.tView startAnimation];
    }
    self.cityChoice = appdelegate.cityChoice;
    
    self.city_district = [NSString stringWithFormat:@"%@%@",appdelegate.cityChoice,[appdelegate.districtString isEqualToString:appdelegate.cityChoice] ? @"":appdelegate.districtString];
    
    printf("viewWillAppear ==%s\n %s",[self.cityChoice UTF8String] ,[self.city_district UTF8String]);

           [self initTopView];

    
    [cycleScrollView2 adjustWhenControllerViewWillAppera];

 
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.locationManager = [[JFLocation alloc] init];
    _locationManager.delegate = self;

#if TARGET_IPHONE_SIMULATOR
    
//    [KCURRENTCITYINFODEFAULTS setObject:@"西安市" forKey:@"locationCity"];
//    [KCURRENTCITYINFODEFAULTS setObject:@"西安市" forKey:@"currentcity"];
//    
//
    
    [self.manager currentCityDic:@"西安市" currentCityDic:^(NSDictionary *dic) {
        
        [KCURRENTCITYINFODEFAULTS setObject:dic forKey:@"locationCityDic"];
        
        [KCURRENTCITYINFODEFAULTS removeObjectForKey:@"currentEareDic"];
        
        [KCURRENTCITYINFODEFAULTS removeObjectForKey:@"currentCityDic"];
        
        
        NSLog(@"TARGET_IPHONE_SIMULATOR------%@",dic);
        
        [self.manager areaData:dic[@"code"] areaData:^(NSMutableArray *areaData) {
            
            
            [KCURRENTCITYINFODEFAULTS setObject:areaData forKey:@"currentEreaList"];
            
            
            
        }];
        
    }];

    
#elif TARGET_OS_IPHONE
    
    
#endif
    
    
    
    currentIndex3= 1;
    currentIndex1=1;
    
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    self.city_district = [appdelegate.city stringByAppendingString:appdelegate.addressDistrite];
    
    NSLog(@"viewDidLoad===%@",self.city_district);
    if (!self.city_district) {
        self.city_district = @"西安市雁塔区";
    }

    
    [self initTableView];

    
    
    address_old = appdelegate.districtString.length>0?appdelegate.districtString:appdelegate.cityChoice;

    
    
    //获取小分类保存在本地
    
    [self getAllIconData];

    
}
//创建顶部导航
-(void)initTopView{
    [topView removeFromSuperview];
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPath = [bundle pathForResource:@"area" ofType:@"plist"];
    NSDictionary *area_dic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSArray *allCityKeys = [area_dic allKeys];
    NSMutableDictionary *allCityss = [NSMutableDictionary dictionary];
    
    for (int i = 0; i < allCityKeys.count; i ++) {
        [allCityss addEntriesFromDictionary:[area_dic objectForKey:[allCityKeys objectAtIndex:i]]];
    }
    self.areaListArray = [[NSArray alloc] initWithArray: [allCityss objectForKey: self.cityChoice]];
    
    
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    //    self.city_district = [appdelegate.city stringByAppendingString:appdelegate.addressDistrite];
    
    NSLog(@"initTopView=====%@",self.city_district);
    if (!self.city_district) {
        self.city_district = @"西安市雁塔区";
    }
    appdelegate.areaListArray = self.areaListArray;
    
    
    topView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 64)];
    topView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:topView];
    
    top_line = [[UIView alloc]initWithFrame:CGRectMake(0, 63.5, SCREENWIDTH, 0.5)];
    top_line.backgroundColor =[UIColor clearColor];
    [topView addSubview:top_line];
    
    
    
    
    
    dingweiXiaImg = [[UIImageView alloc]initWithFrame:CGRectMake(11, 30, 15, 15)];
    dingweiXiaImg.image = [UIImage imageNamed:@"定位icon"];
    [topView addSubview:dingweiXiaImg];
    
    
    dingweiBtn = [[UIButton alloc]initWithFrame:CGRectMake(27, 20-5, 43, 44)];
    [dingweiBtn addTarget:self action:@selector(dingweiClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    [dingweiBtn setTitle:appdelegate.districtString.length>0?appdelegate.districtString:appdelegate.cityChoice forState:UIControlStateNormal];
    [dingweiBtn setTitleColor:RGB(255,255,255) forState:UIControlStateNormal];
    dingweiBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [topView addSubview:dingweiBtn];
    
    
    CGFloat ww = [dingweiBtn.titleLabel.text boundingRectWithSize:CGSizeMake(200, 44) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:dingweiBtn.titleLabel.font} context:nil].size.width;
    
    NSLog(@"--------------%f",ww);
    
    CGRect btn_frame = dingweiBtn.frame;
    btn_frame.size.width =  ww<43 ? 43:58;
    dingweiBtn.frame = btn_frame;
    
    
    dingwei_img = [[UIImageView alloc]initWithFrame:CGRectMake(dingweiBtn.right, dingweiBtn.top+(44-12)/2, 12, 12)];
    dingwei_img.image = [UIImage imageNamed:@"首页最上面"];
    [topView addSubview:dingwei_img];
    
    
    searchView=[[UIView alloc]init];
    searchView.frame=CGRectMake(dingwei_img.right+13, 24, SCREENWIDTH-dingwei_img.right-13-35-35-15, 28);
    searchView.backgroundColor=RGB(255,255,255);
    searchView.layer.cornerRadius=12;
//    searchView.alpha = 0.8;
    [topView addSubview:searchView];
    
    
     search1= [[UIImageView alloc]initWithFrame:CGRectMake(11, 5, 18, 18)];
    search1.image = [UIImage imageNamed:@"搜索icon"];
    [searchView addSubview:search1];
    
    
    search_tf=[[UITextField alloc]initWithFrame:CGRectMake(search1.right+10, 8, searchView.width-(search1.right+10), 20)];
    search_tf.placeholder=@"总有一款适合你";
    search_tf.delegate=self;
    [search_tf setValue:[UIFont systemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    [search_tf setValue:RGB(153, 153, 153) forKeyPath:@"_placeholderLabel.color"];
    search_tf.userInteractionEnabled=NO;
    search_tf.alpha=0.8;
    [searchView addSubview:search_tf];
    
    UIButton *search_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    search_btn.frame = searchView.frame;
    [search_btn addTarget:self action:@selector(searchViewClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:search_btn];
    
    
    for (int i =0; i<2; i ++) {
        
        
        UIButton *minePageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        minePageBtn.tag = i;
        minePageBtn.frame = CGRectMake(CGRectGetMaxX(searchView.frame)+15+i*35, CGRectGetMinY(searchView.frame)-3, 35, 35);
        [minePageBtn addTarget:self action:@selector(goMineCenter:) forControlEvents:UIControlEventTouchUpInside];
        
        [topView addSubview:minePageBtn];
        
        UIImageView *img_mine = [[UIImageView alloc]initWithFrame:CGRectMake(7.5, 7.5, 20, 20)];
        img_mine.image = [UIImage imageNamed:@"二维码扫描"];
        [minePageBtn addSubview:img_mine];
        if (i==1) {
            
            
            xiaoxiImg= img_mine;

//            UIView *redView = [[UIView alloc]initWithFrame:CGRectMake(16, 4, 4, 4)];
//            redView.backgroundColor = [UIColor redColor];
//            redView.layer.cornerRadius = redView.width/2;
//            redView.clipsToBounds = YES;
//            [img_mine addSubview:redView];
            
            img_mine.frame =CGRectMake(2.5+3, 5.5+3, 18, 18);
            img_mine.image = [UIImage imageNamed:@"提醒icon"];
            
            //            UIImageView *whitePoint = [[UIImageView alloc]initWithFrame:CGRectMake(img_mine.width-6-2, 0, 6, 6)];
            //            whitePoint.backgroundColor = [UIColor greenColor];
            //
            //            whitePoint.layer.cornerRadius = whitePoint.width/2;
            //            [img_mine addSubview:whitePoint];
            
        }else{
            erweimaImg = img_mine;
        }
        
        
    }
    NSLog(@"address_old------%@===%@",address_old,dingweiBtn.titleLabel.text);
    
    if (![address_old isEqualToString:dingweiBtn.titleLabel.text]) {
        address_old = dingweiBtn.titleLabel.text;
        [self getIcons:@""];
 
    }
    
    
    
    UIColor *color=[UIColor whiteColor];
    UIColor *lineCOlor =[UIColor lightGrayColor];
    CGFloat offset=table_View.contentOffset.y;
    if (offset<0) {
        top_line.backgroundColor = [lineCOlor colorWithAlphaComponent:0];
        topView.backgroundColor = [color colorWithAlphaComponent:0];
        
        
        
    }else {
        CGFloat alpha=1-((100-offset)/100);
        topView.backgroundColor=[color colorWithAlphaComponent:alpha];
        top_line.backgroundColor = [lineCOlor colorWithAlphaComponent:alpha];
        
        if (alpha>=0.5) {
            dingweiXiaImg.image = [UIImage imageNamed:@"红色定位icon"];
            searchView.backgroundColor=RGB(221,221,221);
            
            dingwei_img.image = [UIImage imageNamed:@"下A"];
            [dingweiBtn setTitleColor:RGB(119,119,119) forState:UIControlStateNormal];
            
            erweimaImg.image = [UIImage imageNamed:@"灰色二维码扫描"];
            xiaoxiImg.image = [UIImage imageNamed:@"灰色提醒icon"];
            search1.image = [UIImage imageNamed:@"灰色搜索icon"];

            
        }else{
            dingweiXiaImg.image = [UIImage imageNamed:@"定位icon"];
            searchView.backgroundColor=RGB(255,255,255);
            
            dingwei_img.image = [UIImage imageNamed:@"首页最上面"];
            [dingweiBtn setTitleColor:RGB(255,255,255) forState:UIControlStateNormal];
            
            erweimaImg.image = [UIImage imageNamed:@"二维码扫描"];
            xiaoxiImg.image = [UIImage imageNamed:@"提醒icon"];
            search1.image = [UIImage imageNamed:@"搜索icon"];

            
            
        }
        
    }

    
    
    
}

-(void)initTableView{
    table_View = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-self.tabBarController.tabBar.frame.size.height) style:UITableViewStyleGrouped];
    table_View.dataSource = self;
    table_View.delegate = self;
    table_View.separatorStyle= UITableViewCellSeparatorStyleNone;
    [self.view addSubview: table_View];
    
    _refreshheader = [SDRefreshHeaderView refreshView];
    [_refreshheader addToScrollView:table_View];
    _refreshheader.isEffectedByNavigationController = NO;
    
    __block HomeViewController *blockSelf = self;
    _refreshheader.beginRefreshingOperation = ^{
        currentIndex3 = 1;
        
        [blockSelf getIcons:@""];
    };
    
    
    _refreshFooter = [SDRefreshFooterView refreshView];
    [_refreshFooter addToScrollView:table_View];
    
    _refreshFooter.beginRefreshingOperation =^{
        [blockSelf postRequestAdv3WithMore:@"more"];
        
    };

    
    

    [self getIcons:@""];

    
    

}

/**
 *  获得版本号
 */
-(void)getVersion_code{
    NSDictionary *infoDic = [[NSBundle mainBundle]infoDictionary];
    // app版本
    NSString *app_Version = [infoDic objectForKey:@"CFBundleShortVersionString"];
    
    
    NSString *url = [NSString stringWithFormat:@"%@Extra/source/version",BASEURL];
    
    NSMutableDictionary *paramer = [NSMutableDictionary dictionary];
    [paramer setValue:@"ios" forKey:@"type"];
    
    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        NSLog(@"===--%@",result);
        NSLog(@" app版本  %ld",(long)[app_Version compare:result[@"version"] options:NSNumericSearch]);
        
        if ([app_Version compare:result[@"version"] options:NSNumericSearch] >= 0) {
            
            [self getPopupAdvertise];
                    }
        
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
//    if (section==0) {
//        NSLog(@"--viewForHeaderInSection---%@",self.headerView);
//            return self.headerView;
//        
//    }else
    
        if(section ==1){
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 40)];
        view.backgroundColor = [UIColor whiteColor];
        UILabel *like_lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, view.height)];
        like_lab.text = @"猜你喜欢";
        like_lab.textColor = RGB(102, 102, 102);
        like_lab.textAlignment = NSTextAlignmentCenter;
        like_lab.font = [UIFont systemFontOfSize:14];
        like_lab.backgroundColor = [UIColor whiteColor];
        [view addSubview:like_lab];
        
        CGFloat  WW = [like_lab.text boundingRectWithSize:CGSizeMake(200, 50) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:like_lab.font} context:nil].size.width;
        
        UIView *line1 = [[UIView alloc]init];
        line1.frame = CGRectMake(75, (like_lab.height-1)/2+like_lab.top, SCREENWIDTH/2-75-WW/2-20, 1);
        line1.backgroundColor = RGB(221,221,221);
        [view addSubview:line1];
        
        UIView *line2 = [[UIView alloc]init];
        line2.frame = CGRectMake( SCREENWIDTH/2+WW/2+20, line1.top, line1.width, line1.height);
        line2.backgroundColor = RGB(221,221,221);
        [view addSubview:line2];
        
        
        UIView *line3 = [[UIView alloc]init];
        line3.frame = CGRectMake(0, view.height-1, SCREENWIDTH, 1);
        line3.backgroundColor = RGB(229,229,229);
        [view addSubview:line3];

        
        return view;
    }else
        return nil;
    

    
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
     if (section ==0) {
         
       return   self.secondheaderView;
         
     }else
         return nil;

}



-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (section==0) {
//        NSLog(@"self.headerView.height-----%lf",self.headerView.height);
//
//        if (!self.headerView) {
//            return self.headerView.height;
//        }else{
//            self.headerView = [self creatHeaderView];
//            
//
//        }
//        
//        return self.headerView.height;
//
//    }else
        if(section==1){
        return 40;
    }else
        return 0.01;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
     if (section==0){
        
        return [self creatSecondheardView].height;
    }else
        return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 0.01;
    }else{
        HomeShopModel *model;
        
        if (self.data_A3.count!=0) {
            model = self.data_A3[indexPath.row];
            
        }
        
        return model.remark.length>0 ? 76:model.cellHight;
        
          }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 0;
    }else
    return self.data_A3.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HomeShopModel *model;
    
    if (self.data_A3.count!=0) {
         model = self.data_A3[indexPath.row];
        
        if (model.remark.length>0) {
            
            static NSString *cellID = @"homeCellId";
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            for (UIView *view in cell.contentView.subviews) {
                [view removeFromSuperview];
            }
            
            UIImageView *img_view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 76-1)];
            [img_view sd_setImageWithURL:[NSURL URLWithString:model.long_img_url] placeholderImage:[UIImage imageNamed:@"icon3"]];
            NSLog(@"long_img_url----_%@",model.long_img_url);
            [cell.contentView addSubview:img_view];
            
            
            UIView* lineView=[[UIView alloc]initWithFrame:CGRectMake(0, img_view.bottom, SCREENWIDTH, 1)];
            lineView.backgroundColor=[UIColor colorWithRed:234/255.0f green:234/255.0f blue:234/255.0f alpha:1.0f];
            
            [cell.contentView addSubview:lineView];
            
            
            return cell;
            
        }else{
            HomeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [HomeViewCell homeViewCellWithTableView:tableView];
            }
            cell.model = model;
            
            return cell;
            
        }

        
    }else{
        return nil;
    }
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HomeShopModel *model = self.data_A3[indexPath.row];
    if (model.remark.length>0) {
        NSLog(@"---长条广告不可点击--");
    }else{
        NSMutableDictionary *shopInfoDic = [self.shopData_A objectAtIndex:indexPath.row];
        NSLog(@"---%@--==%@",model.title_S,shopInfoDic);

        
        NewShopDetailVC *vc= [self startSellerView:shopInfoDic];
        vc.videoID=model.video;
        
        
        [self.navigationController pushViewController:vc animated:YES];

//        NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/merchant/videoGet",BASEURL];
//        NSMutableDictionary *params = [NSMutableDictionary dictionary];
//        //获取商家手机号
//        
//        [params setObject:shopInfoDic[@"muid"] forKey:@"muid"];
//        [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, NSArray* result)
//         {
//             NSLog(@"%@",result);
//             if (result.count>0) {
//                 __block HomeViewController* tempSelf = self;
//                 
//                 if ([result[0][@"state"] isEqualToString:@"true"]) {
//                     vc.videoID=result[0][@"video"];
//                     
//                 }else{
//                     vc.videoID=@"";
//                     
//                 }
//                 [tempSelf.navigationController pushViewController:vc animated:YES];
//             }else{
//                 __block HomeViewController* tempSelf = self;
//                 vc.videoID=@"";
//                 [tempSelf.navigationController pushViewController:vc animated:YES];
//             }
//             
//         } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
//             NSLog(@"%@", error);
//             __block HomeViewController* tempSelf = self;
//             vc.videoID=@"";
//             [tempSelf.navigationController pushViewController:vc animated:YES];
//         }];
        


    }
}

-(NewShopDetailVC *)startSellerView:(NSMutableDictionary*)dic{
    
    NewShopDetailVC *controller = [[NewShopDetailVC alloc]init];
    
    controller.infoDic = dic;
    
    controller.title = @"商铺信息";
    
    return controller;
    
}
//一区区头
-(UIView*)creatHeaderView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH/2+50)];
    
    
    //广告轮播
    UIView *slipBackView=[[UIView alloc]init];
    
    slipBackView.frame = CGRectMake(0, 0, SCREENWIDTH, 182*LZDScale);

    slipBackView.backgroundColor=RGB(240, 240, 240);
    [view addSubview:slipBackView];

    
    if (_adverImages.count !=0) {
        cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREENWIDTH, slipBackView.height) delegate:self placeholderImage:[UIImage imageNamed:@""]];
        cycleScrollView2.imageURLStringsGroup = _adverImages;
        cycleScrollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
//           cycleScrollView2.titlesGroup = self.titles;
        cycleScrollView2.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
        cycleScrollView2.hidesForSinglePage = YES;
        [slipBackView addSubview:cycleScrollView2];
    }else{
       
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:slipBackView.frame];
        imgView.image = [UIImage imageNamed:@"首页顶部海报"];
        [slipBackView addSubview:imgView];
    }
    
 
    
    
    
    
    
    _smallSV=[[UIScrollView alloc]init];
    _smallSV.pagingEnabled=YES;
    _smallSV.bounces=NO;
    _smallSV.delegate=self;
    _smallSV.backgroundColor = [UIColor whiteColor];
    _smallSV.showsVerticalScrollIndicator = NO;
    _smallSV.showsHorizontalScrollIndicator = NO;
    [view addSubview:_smallSV];
    
    
    NSInteger yeshu = 0;

    if (self.icon_A.count%10==0) {
        yeshu = self.icon_A.count/10;
    }else{
        yeshu = self.icon_A.count/10+1;
    }

    for (int j = 0; j < yeshu; j ++) {
        
        for (int i = j*10; i < (j+1)*10; i ++) {
            if (i >=self.icon_A.count) {
                break;
            }
            int X = (i-j*10)%5;
            int Y = (i-j*10)/5;
            
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(X *SCREENWIDTH/5+ SCREENWIDTH*j,5+Y *(SCREENWIDTH/5+10), SCREENWIDTH/5, SCREENWIDTH/5)];
            [btn addTarget:self action:@selector(topClick:) forControlEvents:UIControlEventTouchUpInside];
            
            
            btn.tag = i;
            [_smallSV addSubview:btn];
            
            UIImageView *imag = [[UIImageView alloc]initWithFrame:CGRectMake((btn.width-35)/2, (btn.width-35)/2, 35, 35)];
            [btn addSubview:imag];
            
            UILabel *lable_S =[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imag.frame)+5, btn.frame.size.width, 25)];
            lable_S.textColor = RGB(51,51,51);
            lable_S.font = [UIFont systemFontOfSize:12];
            lable_S.textAlignment = NSTextAlignmentCenter;
            [btn addSubview:lable_S];
            
            NSDictionary *dic  = self.icon_A[i];
            
            [imag sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",UPICONIMAGE,dic[@"icon_url"]]] placeholderImage:[UIImage imageNamed:@"icon3"]];
            [lable_S setText:[NSString getTheNoNullStr:dic[@"text"] andRepalceStr:@"美女服务"]];
            
                   
        }
    }


    
    _smallSV.frame  = CGRectMake(0, slipBackView.bottom, SCREENWIDTH, 10+ 2*(SCREENWIDTH/5+10)+10);

    
    _pc=[[UIPageControl alloc]initWithFrame:CGRectMake(SCREENWIDTH*0.2, _smallSV.bottom-20, SCREENWIDTH*0.6, 20)];
    _pc.currentPageIndicatorTintColor=NavBackGroundColor;
    _pc.pageIndicatorTintColor = [UIColor lightGrayColor];
    [_pc addTarget:self action:@selector(pcClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_pc];
    
    if (self.icon_A.count%10==0) {
        _smallSV.contentSize = CGSizeMake(SCREENWIDTH*self.icon_A.count/10, 0);
        _pc.numberOfPages = self.icon_A.count/10;
    }else{
        _smallSV.contentSize = CGSizeMake(SCREENWIDTH*(self.icon_A.count/10+1), 0);
        _pc.numberOfPages = self.icon_A.count/10+1;

    }
    _pc.hidesForSinglePage = YES;
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, _smallSV.bottom, SCREENWIDTH, 10)];
    line.backgroundColor =RGB(239,239,244);
    [view addSubview:line];
    
    UILabel *hot_label = [[UILabel alloc]initWithFrame:CGRectMake(0, line.bottom, SCREENWIDTH, 32)];
    hot_label.text = @"   今日头条";
    hot_label.font = [UIFont systemFontOfSize:12];
    hot_label.textColor = RGB(226,102,102);
    
    hot_label.backgroundColor = [UIColor whiteColor];
    [view addSubview:hot_label];
    
    
    CGFloat hot_ww = [self getSizeWithLab:hot_label andMaxSize:CGSizeMake(100, 100)].width;
    
    GYChangeTextView *tView = [[GYChangeTextView alloc] initWithFrame:CGRectMake(hot_ww+5, hot_label.top, SCREENWIDTH-hot_ww-20, hot_label.height)];
    [tView setValue:RGB(51, 51, 51) forKeyPath:@"textLabel.textColor"];
    [tView setValue:[UIFont systemFontOfSize:12] forKeyPath:@"textLabel.font"];

    tView.delegate = self;
    [view addSubview:tView];
    self.tView = tView;
    
    NSMutableArray *mut = [NSMutableArray array];
    if (self.advertiseHeaderList.count!=0) {
        for (NSDictionary *dic in self.advertiseHeaderList) {
            [mut addObject:dic[@"text"]];
        }
        
        [self.tView animationWithTexts:mut];
    }else{
        [self.tView stopAnimation];
    }
    
    
    
    

    view.frame = CGRectMake(0, 0, SCREENWIDTH, CGRectGetMaxY(hot_label.frame));
    
    
    NSLog(@"view.bottom-----%lf",view.bottom);


    return view;
}

//二区区头
-(UIView*)creatSecondheardView{
    UIView *back_view = [UIView new];
    
    for (int i =0 ; i <4; i++) {
       
        
        UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        button1.frame = CGRectMake(i%2*((SCREENWIDTH-1)/2+1), 10 +i/2*(81*LZDScale+1), (SCREENWIDTH-1)/2, 81*LZDScale);
        button1.backgroundColor = [UIColor whiteColor];
        [button1 addTarget:self action:@selector(advertiseClick:) forControlEvents:UIControlEventTouchUpInside];
        button1.tag=i;

        [back_view addSubview:button1];
        
        
        UILabel *lab1_2 = [[UILabel alloc]initWithFrame:CGRectMake(13, (button1.height-12)/2, button1.width/2, 12)];
        lab1_2.text = @"优惠停不下来";
        lab1_2.font = [UIFont systemFontOfSize:12];
        lab1_2.textColor = RGB(119,119,119);
        lab1_2.textAlignment = NSTextAlignmentLeft;
        [button1 addSubview:lab1_2];
        
        
        UILabel *lab1_1 = [[UILabel alloc]initWithFrame:CGRectMake(13, lab1_2.top-11-14, button1.width/2, 14)];
        lab1_1.text = @"新店入住";
        lab1_1.font = [UIFont systemFontOfSize:14];
        lab1_1.textColor = RGB(51,51,51);
        lab1_1.textAlignment = NSTextAlignmentLeft;
        
        [button1 addSubview:lab1_1];
        
        
        NSArray *arr = @[@"NEW",@"优惠",@"活动",@"VIP"];

        UILabel *lab1_3 = [[UILabel alloc]initWithFrame:CGRectMake(13, lab1_2.bottom+11, button1.width/2, 13)];
        lab1_3.text = arr[i];
        lab1_3.font = [UIFont systemFontOfSize:10];
        lab1_3.textColor = RGB(226,102,102);
        lab1_3.layer.borderColor = RGB(226,102,102).CGColor;
        lab1_3.layer.borderWidth = 1;
        lab1_3.layer.cornerRadius = 2;
        lab1_3.layer.masksToBounds = YES;
        lab1_3.textAlignment = NSTextAlignmentCenter;
        [button1 addSubview:lab1_3];

        CGFloat ww = [lab1_3.text boundingRectWithSize:CGSizeMake(100, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :lab1_3.font} context:nil].size.width;
        
        lab1_3.frame = CGRectMake(13, lab1_2.bottom+11, ww+3, 13);
        
        
        

        
        UIImageView *img_1 = [[UIImageView alloc]initWithFrame:CGRectMake(lab1_1.right, (button1.height-(button1.width-(lab1_1.right+15)))/2, button1.width-(lab1_1.right+15), button1.width-(lab1_1.right+15))];
        img_1.contentMode = UIViewContentModeScaleAspectFit;
        [button1 addSubview:img_1];
        
        
       
        
        NSDictionary *dic ;
        if (self.data_A2.count!=0) {
            
            dic = self.data_A2[i];
            lab1_1.text = dic[@"theme"];
            lab1_2.text = dic[@"content"];
            NSString *img_str = [NSString stringWithFormat:@"%@%@",FOURADVERTIMAGE,dic[@"image_url"]];
            [img_1 sd_setImageWithURL:[NSURL URLWithString:img_str] placeholderImage:[UIImage imageNamed:@"dfg"]];
            
            
        }
    }
    
    
    //长条广告
    _longAdvertise_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    _longAdvertise_btn.frame = CGRectMake(0, (81*LZDScale+1)*2+20, SCREENWIDTH, 76);
//    _longAdvertise_btn.backgroundColor = [UIColor orangeColor];
    
    if (self.longAdvertise_dic) {
        NSString *_longimg_str = [NSString stringWithFormat:@"%@%@",LONGADVERTIMAGE,self.longAdvertise_dic[@"image_url"]];
        
        [_longAdvertise_btn sd_setImageWithURL:[NSURL URLWithString:_longimg_str] forState:0 placeholderImage:[UIImage imageNamed:@"-2-01.jpg"]];
        [_longAdvertise_btn sd_setImageWithURL:[NSURL URLWithString:_longimg_str] forState:UIControlStateHighlighted placeholderImage:[UIImage imageNamed:@"-2-01.jpg"]];


    }
    
    [back_view addSubview:_longAdvertise_btn];
    


    
    back_view.frame = CGRectMake(0, 0, SCREENWIDTH, _longAdvertise_btn.bottom+10);
    
    return back_view;
}


#pragma  mark 数据请求
//获取小分类
-(void)getIcons:(NSString*)more{
    
    NSString *urls = [NSString stringWithFormat:@"%@UserType/HP/getData",BASEURL];
    
    
    
    if ([self.city_district containsString:@"全城"]) {
        self.city_district =  [self.city_district stringByReplacingOccurrencesOfString:@"全城" withString:@""];
    }

    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];

    NSMutableDictionary*paramer = [NSMutableDictionary dictionary];
    [paramer setValue:self.city_district forKey:@"location"];
    
    [paramer setValue:[NSString stringWithFormat:@"%lf",appdelegate.userLocation.location.coordinate.latitude] forKey:@"lat"];
    [paramer setValue:[NSString stringWithFormat:@"%lf",appdelegate.userLocation.location.coordinate.longitude] forKey:@"lng"];

    [_refreshheader endRefreshing];
    [self showHudInView:self.view hint:@"加载中..."];
    NSLog(@"-----%@",paramer);
    
    [KKRequestDataService requestWithURL:urls params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        [self hideHud];

        NSLog(@"url======%@",result);
        
        self.icon_A = result[@"trade_icon"];
        self.advertiseHeaderList =  result[@"headline"];
        
        self.circleAdverlist= result[@"top_ad"];
        
        
        [self.adverImages removeAllObjects];
        
        [self.titles removeAllObjects];
        
        for (int i=0; i<_circleAdverlist.count; i++) {
            [self.adverImages addObject:[NSString stringWithFormat:@"%@%@",HOME_LUNBO_IMAGE,_circleAdverlist[i][@"image_url"]]];
            
            [self.titles addObject:_circleAdverlist[i][@"title"]];
        }
        
        self.headerView = [self creatHeaderView];

        table_View.tableHeaderView = self.headerView;
        
        
        self.data_A2 = result[@"activity_ad"];
        
        
        if ([result[@"insert_ad"] isKindOfClass:[NSDictionary class]]) {
            self.longAdvertise_dic = (NSDictionary*)result[@"insert_ad"];
            
        }
        
        self.secondheaderView = [self creatSecondheardView];
        
        
        NSArray *arr = result[@"stores"];
        
        [self.data_A3 removeAllObjects];
        [self.shopData_A removeAllObjects];
        
        for (NSDictionary *dic in arr) {
            
            HomeShopModel *model = [[HomeShopModel alloc]initWithDictionary:dic];
            
            [self.data_A3 addObject:model];
            [self.shopData_A addObject:dic];
            
        }
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
            [self getVersion_code];
            
        });

        
        
        [table_View reloadData];
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"-----%@",error);

        [_refreshheader endRefreshing];
        [self hideHud];

    }];

    
    
}

//获取商家列表
-(void)postRequestAdv3WithMore:(NSString*)more
{
    
    [self showHudInView:self.view hint:@"加载中..."];
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/HP/dropLoad",BASEURL];
    
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];

    NSMutableDictionary *paramer = [NSMutableDictionary dictionary];
    
     [paramer setValue:[NSString stringWithFormat:@"%d",++currentIndex3] forKey:@"index"];

    [paramer setValue:self.city_district forKey:@"location"];
    
    [paramer setValue:[NSString stringWithFormat:@"%lf",appdelegate.userLocation.location.coordinate.latitude] forKey:@"lat"];
    [paramer setValue:[NSString stringWithFormat:@"%lf",appdelegate.userLocation.location.coordinate.longitude] forKey:@"lng"];


    NSLog(@"postRequestAdv3WithMore-url-%@-%@",url,paramer);
    
    
    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         [self hideHud];
         [_refreshFooter endRefreshing];

           NSLog(@"result3==%@",result);
         
         if ([result[@"insert_ad"] isKindOfClass:[NSDictionary class]]) {
             
             
             HomeShopModel *model = [[HomeShopModel alloc]initWithDictionary:result[@"insert_ad"]];
              model.remark = @"长条广告";

              [self.data_A3 addObject:model];
              [self.shopData_A addObject:result[@"insert_ad"]];
         }
         
         
         for (NSDictionary *dic in result[@"stores"]) {
             
             HomeShopModel *model = [[HomeShopModel alloc]initWithDictionary:dic];
             
             [self.data_A3 addObject:model];
             [self.shopData_A addObject:dic];
             
         }
    
         
       [table_View reloadData];
         
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         [self hideHud];
         [_refreshheader endRefreshing];
         [_refreshFooter endRefreshing];

         NSLog(@"postRequestAdv3WithMore=%@", error);
     }];
    
}
//获取弹出广告
-(void)getPopupAdvertise{
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/advert/popupGet",BASEURL];
    NSMutableDictionary *paramer = [NSMutableDictionary dictionary];
    [paramer setValue:self.city_district forKey:@"eare"];
    NSLog(@"getPopupAdvertise--%@",paramer);
    
    
    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         NSLog(@"getPopupAdvertise-result-%@",result);
         
         pop_data_Dic = [NSDictionary dictionaryWithDictionary:result];
         NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
         formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
         
         NSDate *startDate = [formatter dateFromString:[NSString getTheNoNullStr:result[@"start_time"] andRepalceStr:@""]];
        
         NSDate *endDate = [formatter dateFromString:[NSString getTheNoNullStr:result[@"end_time"] andRepalceStr:@""]];
         
         
         NSDate *currentDate = [NSDate date];

         double interVal1 = [currentDate timeIntervalSinceDate:startDate];
         
         double interVal2 = [currentDate timeIntervalSinceDate:endDate];
         NSLog(@"=====%f=%f",interVal1,interVal2);
         if (interVal1>0 && interVal2 <0) {
             
             NSString *img_url = [NSString getTheNoNullStr:result[@"image_url"] andRepalceStr:@""];

             if (img_url.length>0) {
                 [self creatPopupAdvertiseView:result];
                 
             }

         }
         
        
         
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         NSLog(@"getPopupAdvertise=%@", error);
     }];
}

//创建弹出广告视图
-(void)creatPopupAdvertiseView:(NSDictionary*)dic{
    
    NSString *img_url = [NSString getTheNoNullStr:dic[@"image_url"] andRepalceStr:@""];

      PopupAdvertiseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    
    PopupAdvertiseView.backgroundColor = [UIColor colorWithRed:51/255.f green:51/255.f blue:51/255.f alpha:0.7];
    
     NSArray* windows = [UIApplication sharedApplication].windows;
    UIWindow *curent_window = [windows lastObject];
    NSLog(@"------%@",curent_window.subviews);
    
    
    [curent_window addSubview: PopupAdvertiseView];
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.bounds =CGRectMake(0,0, SCREENWIDTH-20, (SCREENWIDTH-20)*0.8);
    imageView.center = CGPointMake(curent_window.center.x, curent_window.center.y-30);
                              
    imageView.userInteractionEnabled = YES;
    [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",POPADVERTIMAGE,img_url]] placeholderImage:[UIImage imageNamed:@"icon3"]];
    

    [PopupAdvertiseView addSubview:imageView];
    
    
    UITapGestureRecognizer *tapgesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(popImgClick)];
    [imageView addGestureRecognizer:tapgesture];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake((SCREENWIDTH-30)/2, imageView.bottom+50, 30, 30);
    [button setImage:[UIImage imageNamed:@"关闭"] forState:0];
    [button addTarget:self action:@selector(tapCl) forControlEvents:UIControlEventTouchUpInside];
    [PopupAdvertiseView addSubview:button];

//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCl)];
//    [PopupAdvertiseView addGestureRecognizer:tap];
    
}
-(void)tapCl{
    
    [PopupAdvertiseView removeFromSuperview];
}
//小分类按钮
-(void)topClick:(UIButton*)sender{
    
    NSLog(@"小分类" );
    if ([self.icon_A[sender.tag][@"state"] isEqualToString:@"true"]) {
    
        PUSH(BeautyIndustryVC)
    
        vc.icon_dic = self.icon_A[sender.tag];
        
    }else{
        
        PUSH(ShoppingViewController)
        vc.navigationItem.title = self.icon_A[sender.tag][@"text"];
        
//        AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
//        appdelegate.menuString = [self.icon_A objectAtIndex:sender.tag][@"text"];
//        NSLog(@"appdelegate.menuString%@",appdelegate.menuString);
//        //    self.tabBarController.selectedIndex = 1;
//        NSLog(@"%ld",(long)sender.tag);
//        
//        self.tabBarController.selectedIndex =1;
    }
   

}
//搜索
-(void)searchViewClick{
    NSLog(@"搜索");
    SearchTableViewController *VC = [[SearchTableViewController alloc]init];
    
    [self.navigationController pushViewController:VC animated:YES];
}

-(void)goMineCenter:(UIButton*)sender{
    NSLog(@"闹铃");
    if (sender.tag==0) {
        ScanViewController *VC = [[ScanViewController alloc]init];
        VC.shopOrUser=@"user";
        [self.navigationController pushViewController:VC animated:YES];

    }else{
        
//        [self showHint:@"暂未开放!"];
        
        
        NewMessageVC *VC = [[NewMessageVC alloc]init];
        [self.navigationController pushViewController:VC animated:YES];
    }
}
//定位
-(void)dingweiClick:(UIButton*)btn{
    NSLog(@"定位");
    
    
    JFCityViewController *cityViewController = [[JFCityViewController alloc] init];
    
    cityViewController.title = @"城市";
    __weak typeof(self) weakSelf = self;
    [cityViewController choseCityBlock:^(NSString *cityName,NSString *eareName){
        
        
        AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        appdelegate.cityChoice= [NSString getTheNoNullStr:cityName andRepalceStr:appdelegate.cityChoice];
        appdelegate.districtString = eareName.length>0 ? [NSString getTheNoNullStr:eareName andRepalceStr:appdelegate.districtString]:[NSString getTheNoNullStr:cityName andRepalceStr:appdelegate.cityChoice];
        
        NSLog(@"-----%@====%@\\\\",cityName,eareName);
        
        
        
        
        [dingweiBtn setTitle:eareName.length>0 ? eareName:cityName forState:UIControlStateNormal];
        
        
        weakSelf.city_district = [NSString stringWithFormat:@"%@%@",cityName,eareName];
        
        [weakSelf resetFrame];
        
        //        [self getIcons:@""];
        
        
        
    }];
    BaseNavigationController *navigationController = [[BaseNavigationController alloc]initWithRootViewController:cityViewController];
    
    [self presentViewController:navigationController animated:YES completion:nil];
    
    
    
    
    
}

-(void)advertiseClick:(UIButton*)sender{
    
    if (self.data_A2.count!=0) {
        NSDictionary *dic = self.data_A2[sender.tag];
        if (sender.tag ==0) {
            NewShopViewController *VC = [[NewShopViewController alloc]init];
            VC.activityId =dic[@"id"];
            VC.title = dic[@"theme"];
            [self.navigationController pushViewController:VC animated:YES];
        }
        if (sender.tag ==1) {
            
            [self twoActiveClcik:dic];
            
          
        }
        if (sender.tag ==2) {
           
            //            [self showHint:@"暂未开通!"];
            
            [self twoActiveClcik:dic];

          
            
        }


        if (sender.tag ==3) {
            
//            [self showHint:@"暂未开通!"];

            PUSH(MemberCenterVC)
            
//            LZDCenterViewController *VC = [[LZDCenterViewController alloc]init];
//       
//            
//            [self.navigationController pushViewController:VC animated:YES];
        }

    }
    
    NSLog(@"---广告---%ld",sender.tag);
}
#pragma mark GYChangeTextViewDelegate

- (void)gyChangeTextView:(GYChangeTextView *)textView didTapedAtIndex:(NSInteger)index {
    NSLog(@"%ld",index);
    HotNewsVC *vc=[[HotNewsVC alloc]init];
    vc.title = @"商消乐头条";
    vc.href=self.advertiseHeaderList[index][@"href"];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark UIScrollViewDelegate


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _smallSV) {
        int page = scrollView.contentOffset.x/scrollView.frame.size.width;//分页
        _pc.currentPage = page;
    }
    
    
    if (scrollView ==table_View) {
        UIColor *color=[UIColor whiteColor];
        UIColor *lineCOlor =[UIColor lightGrayColor];

        
        CGFloat offset=scrollView.contentOffset.y;
//        NSLog(@"================%lf",offset);
        if (offset<0) {
            top_line.backgroundColor = [lineCOlor colorWithAlphaComponent:0];

            topView.backgroundColor = [color colorWithAlphaComponent:0];
            

            
        }else {
            CGFloat alpha=1-((100-offset)/100);
            topView.backgroundColor=[color colorWithAlphaComponent:alpha];
            top_line.backgroundColor = [lineCOlor colorWithAlphaComponent:alpha];
            
            
            if (alpha>=0.5) {
                dingweiXiaImg.image = [UIImage imageNamed:@"红色定位icon"];
                searchView.backgroundColor=RGB(221,221,221);
                
                dingwei_img.image = [UIImage imageNamed:@"下A"];
                [dingweiBtn setTitleColor:RGB(119,119,119) forState:UIControlStateNormal];
                search1.image = [UIImage imageNamed:@"灰色搜索icon"];

                erweimaImg.image = [UIImage imageNamed:@"灰色二维码扫描"];
                xiaoxiImg.image = [UIImage imageNamed:@"灰色提醒icon"];
                
            }else{
                dingweiXiaImg.image = [UIImage imageNamed:@"定位icon"];
                searchView.backgroundColor=RGB(255,255,255);
                
                dingwei_img.image = [UIImage imageNamed:@"首页最上面"];
                [dingweiBtn setTitleColor:RGB(255,255,255) forState:UIControlStateNormal];
                
                erweimaImg.image = [UIImage imageNamed:@"二维码扫描"];
                xiaoxiImg.image = [UIImage imageNamed:@"提醒icon"];

                search1.image = [UIImage imageNamed:@"搜索icon"];

                
            }

            

        }

    }
}

-(void)pcClick:(UIPageControl*)pageControl{
    
    [UIView animateWithDuration:0.5 animations:^{
        
        _smallSV.contentOffset = CGPointMake(pageControl.currentPage*SCREENWIDTH, 0);
        
    }];
    
}





#pragma mark 私有方法
-(CGSize)getSizeWithLab:(UILabel*)lable andMaxSize:(CGSize)size{
    
    CGSize SZ = [lable.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:lable.font} context:nil].size ;
    
    return SZ
    ;
}



#pragma mark 选则城市delegate
-(void)senderSelectCity:(NSString *)selectCity{
    self.city_district = [selectCity stringByAppendingString:@"市"];
    
    

    
    NSLog(@"senderSelectCity==%@===%@",selectCity,self.city_district);

    [self getIcons:@""];
}


-(void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [self.tView stopAnimation];
    
    
}




-(void)resetFrame{
    
    
    dingwei_img.frame = CGRectMake(dingweiBtn.right, dingweiBtn.top+(44-12)/2, 12, 12);
    searchView.frame=CGRectMake(dingwei_img.right+13, 24, SCREENWIDTH-dingwei_img.right-13-35-35-15, 28);
    

    
}




-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    NSDictionary *dic = self.circleAdverlist[index];
    if ([[NSString getTheNoNullStr:dic[@"num"] andRepalceStr:@""] intValue]==0) {
        
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        
        hud.label.text =@"暂时没有数据!";
        hud.label.font = [UIFont systemFontOfSize:13];
        hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
        [hud hideAnimated:YES afterDelay:1.f];
        
        
        

        
        
    }else{
        TopActiveListTableVC *VC = [[TopActiveListTableVC alloc]init];
        VC.activityId = dic[@"id"];
        VC.navigationItem.title = dic[@"title"];
        [self.navigationController pushViewController:VC animated:YES];
    }
   
    
    
    
}


-(void)topActiveClick:(UITapGestureRecognizer*)tap{
   
}

//定位中...
- (void)locating {
    NSLog(@"定位中...");
}

//定位成功
- (void)currentLocation:(NSDictionary *)locationDictionary {
    NSLog(@"定位成功------%@",locationDictionary);

    [self getIcons:@""];

    NSString *city = [locationDictionary valueForKey:@"City"];
    //    if (![_resultLabel.text isEqualToString:city]) {
    //        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"您定位到%@，确定切换城市吗？",city] preferredStyle:UIAlertControllerStyleAlert];
    //        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    //        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    //            _resultLabel.text = city;
//    [KCURRENTCITYINFODEFAULTS setObject:city forKey:@"locationCity"];
//    [KCURRENTCITYINFODEFAULTS setObject:city forKey:@"currentcity"];
//    [self.manager cityNumberWithCity:city cityNumber:^(NSString *cityNumber) {
//        printf("cityNumber===%s",[cityNumber UTF8String]);
//        [KCURRENTCITYINFODEFAULTS setObject:cityNumber forKey:@"cityNumber"];
//    }];

    
    
    [self.manager currentCityDic:city currentCityDic:^(NSDictionary *dic) {
        
        [KCURRENTCITYINFODEFAULTS setObject:dic forKey:@"locationCityDic"];
        
        [KCURRENTCITYINFODEFAULTS removeObjectForKey:@"currentEareDic"];
        
        [KCURRENTCITYINFODEFAULTS removeObjectForKey:@"currentCityDic"];

        
        NSLog(@"定位成功------%@",dic);
        
        [self.manager areaData:dic[@"code"] areaData:^(NSMutableArray *areaData) {
            
            
            [KCURRENTCITYINFODEFAULTS setObject:areaData forKey:@"currentEreaList"];
            

            
        }];
        
    }];
    
   }




/// 拒绝定位
- (void)refuseToUsePositioningSystem:(NSString *)message {

    NSLog(@"%@",message);
    [self.manager currentCityDic:@"西安市" currentCityDic:^(NSDictionary *dic) {
        
        [KCURRENTCITYINFODEFAULTS setObject:dic forKey:@"locationCityDic"];
        
        [KCURRENTCITYINFODEFAULTS removeObjectForKey:@"currentEareDic"];
        
        [KCURRENTCITYINFODEFAULTS removeObjectForKey:@"currentCityDic"];
        
        
        NSLog(@"TARGET_IPHONE_SIMULATOR------%@",dic);
        
        [self.manager areaData:dic[@"code"] areaData:^(NSMutableArray *areaData) {
            
            
            [KCURRENTCITYINFODEFAULTS setObject:areaData forKey:@"currentEreaList"];
            
            
            
        }];
        
    }];

}

/// 定位失败
- (void)locateFailure:(NSString *)message {
    NSLog(@"%@",message);
    [self.manager currentCityDic:@"西安市" currentCityDic:^(NSDictionary *dic) {
        
        [KCURRENTCITYINFODEFAULTS setObject:dic forKey:@"locationCityDic"];
        
        [KCURRENTCITYINFODEFAULTS removeObjectForKey:@"currentEareDic"];
        
        [KCURRENTCITYINFODEFAULTS removeObjectForKey:@"currentCityDic"];
        
        
        NSLog(@"TARGET_IPHONE_SIMULATOR------%@",dic);
        
        [self.manager areaData:dic[@"code"] areaData:^(NSMutableArray *areaData) {
            
            
            [KCURRENTCITYINFODEFAULTS setObject:areaData forKey:@"currentEreaList"];
            
            
            
        }];
        
    }];

}


#pragma mark  美发专区 ,节日活动点击


-(void)twoActiveClcik:(NSDictionary *)activityDic{
    
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/advertActivity/getList",BASEURL];
    
    
    NSMutableDictionary *paramer = [NSMutableDictionary dictionary];
    [paramer setValue:activityDic[@"id"] forKey:@"advert_id"];
    
    [paramer setValue:@"1" forKey:@"index"];
    
    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         
         
         if ([result count]>0) {
             
             if ([activityDic[@"id"] intValue]==2) {
                 AdvertiseViewController *VC = [[AdvertiseViewController alloc]init];
                 VC.activityId =activityDic[@"id"];
                 VC.title = activityDic[@"theme"];
                 
                 [self.navigationController pushViewController:VC animated:YES];
                 
             }else{
                
                 HolidayActivertyVC *holidayVC=[[HolidayActivertyVC alloc]init];
                 holidayVC.activityId=activityDic[@"id"];
                 holidayVC.title = activityDic[@"theme"];
                 [self.navigationController pushViewController:holidayVC animated:YES];
                 
             }

             
             
             
         }else{
             
             
             [self showHint:@"活动暂未开始!"];
         }
         
        
         
         
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
         NSLog(@"%@", error);
     }];
    
    
}


//弹出广告点击
-(void)popImgClick{
    AppDelegate *delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSLog(@"--popImgClick--%@",pop_data_Dic);
//    if (delegate.IsLogin) {
        [self tapCl];
        ChouJiangVC *VC = [[ChouJiangVC alloc]init];
        VC.urlString = pop_data_Dic[@"url"];
        
        if ([VC.urlString hasPrefix:@"http://"]) {
            [self.navigationController pushViewController:VC animated:YES];
            
        }
//    }else{
//        LandingController *landVC=[[LandingController alloc]init];
//        PopupAdvertiseView.hidden=YES;
//        [self.navigationController pushViewController:landVC animated:YES];
//    }
    
}

-(void)getAllIconData{
    
    NSString *url = [NSString stringWithFormat:@"%@Extra/Trade/getUp",BASEURL];
    
    
    [KKRequestDataService requestWithURL:url params:nil httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        NSLog(@"getAllIconData-----%@",result);
        
        
        [[NSUserDefaults standardUserDefaults] setObject:result forKey:@"allIcon"];
        
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"getAllIconData-----%@",error);

    }];

    
}
#pragma mark 懒加载
-(NSMutableArray*)adverImages{
    if (!_adverImages) {
        _adverImages = [NSMutableArray array];
    }
    return _adverImages;
}

-(NSArray *)circleAdverlist{
    if (!_circleAdverlist) {
        _circleAdverlist = [NSArray array];
    }
    return _circleAdverlist;
}
-(NSDictionary*)longAdvertise_dic{
    if (!_longAdvertise_dic) {
        _longAdvertise_dic = [NSDictionary dictionary];
    }
    return _longAdvertise_dic;
}
-(NSArray *)advertiseHeaderList{
    if (!_advertiseHeaderList) {
        _advertiseHeaderList = [NSArray array];
    }
    return _advertiseHeaderList;
}
-(NSArray*)data_A2{
    if (!_data_A2) {
        _data_A2 = [NSArray array];
    }
    return _data_A2;
}
-(NSMutableArray*)data_A3{
    if (!_data_A3) {
        _data_A3 = [NSMutableArray array];
    }
    return _data_A3;
}
-(NSArray*)areaListArray{
    if (!_areaListArray) {
        _areaListArray =[NSArray array];
    }
    return _areaListArray;
}
-(NSArray*)icon_A{
    
    if (!_icon_A) {
        _icon_A = [NSArray array];
    }
    return _icon_A;
}
-(NSMutableArray*)shopData_A{
    if (!_shopData_A) {
        _shopData_A = [NSMutableArray array];
    }
    return _shopData_A;
}
@end
