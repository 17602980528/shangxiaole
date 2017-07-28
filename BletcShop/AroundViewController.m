//
//  AroundViewController.m
//  BletcShop
//
//  Created by Bletc on 2017/7/25.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "AroundViewController.h"
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import "UIImageView+WebCache.h"
#import "BaseNavigationController.h"
#import "JFCityViewController.h"
#import "ShopListTableViewCell.h"
#import "SDCycleScrollView.h"
#import "NewShopDetailVC.h"
#import "SearchTableViewController.h"

#import "ChouJiangVC.h"



@interface AroundViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    LZDButton *oldBtn;
    SDRefreshFooterView *_refreshFooter;
    SDRefreshHeaderView *_refreshheader;
    

}
@property (weak, nonatomic) IBOutlet UILabel *addressLab;

@property (weak, nonatomic) IBOutlet UITableView *tabview;
@property(nonatomic,strong)NSMutableArray *data_M_A;
@property (nonatomic,copy)NSString *classifyString;

@property(nonatomic,strong)NSArray *trade_A;
@property(nonatomic,strong)NSMutableArray* adverImages;
@property (strong, nonatomic) IBOutlet UIView *topLeftView;
@property (strong, nonatomic) IBOutlet UIView *topRightView;
@property(nonatomic)NSInteger page;
@property(nonatomic,copy)NSString *city_district;//定位到的市区;
@property(nonatomic,strong)  NSArray *advert_A;//轮播广告

@end
@implementation AroundViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [appdelegate.locService startUserLocationService];
    
    
    [self postGetMutiAdvertistShops:_city_district];

    
}
- (IBAction)addressClick:(UITapGestureRecognizer *)sender {
    NSLog(@"定位");
    
    
    
    
}
- (IBAction)searchClcik:(UITapGestureRecognizer *)sender {
    
    NSLog(@"--searchClick--");
    PUSH(SearchTableViewController)

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title  = @"周边";

    self.page =1;
    self.classifyString = @"";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.topRightView];

    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.topLeftView];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];

    self.addressLab.text = appdelegate.districtString.length >0? appdelegate.districtString : @"雁塔区";
    

    
    self.city_district = [NSString stringWithFormat:@"%@%@",appdelegate.cityChoice,[appdelegate.districtString isEqualToString:appdelegate.cityChoice] ? @"":appdelegate.districtString];

    
   
    
//    [self postGetMutiAdvertistShops:_city_district];
    
    
    
    
    _refreshheader = [SDRefreshHeaderView refreshView];
    [_refreshheader addToScrollView:self.tabview];
    _refreshheader.isEffectedByNavigationController = NO;
    
    __block typeof(self)tempSelf =self;
    _refreshheader.beginRefreshingOperation = ^{
        tempSelf.page=1;
        [tempSelf.data_M_A removeAllObjects];
        //请求数据
        [tempSelf postGetMutiAdvertistShops:tempSelf.city_district];
    };
    
    
    _refreshFooter = [SDRefreshFooterView refreshView];
    [_refreshFooter addToScrollView:self.tabview];
    _refreshFooter.beginRefreshingOperation =^{
        tempSelf.page++;
        //数据请求
        NSLog(@"====>>>>%ld",tempSelf.page);
        [tempSelf postRequestShopWithAddress:tempSelf.city_district];
        
    };

}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.data_M_A.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 97+4;

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;//215
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}


//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    
//    
//    
//    
//}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentifier = @"cell";
    ShopListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (!cell) {
        cell = [[ShopListTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIndentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    
  
    if (self.data_M_A.count>0) {
        
        NSDictionary *dic  =  _data_M_A[indexPath.row];

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
        
        
        
        //        NSString *discount =[NSString getTheNoNullStr:[dic objectForKey:@"discount"] andRepalceStr:@""];
        //
        //
        //        NSString *giveString =[NSString getTheNoNullStr:[dic objectForKey:@"add"] andRepalceStr:@""];
        //
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
        trade_frame.size.width =[NSString calculateRowWidth: cell.tradeLable];
        cell.tradeLable.frame = trade_frame;
    }
    
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dic = self.data_M_A [indexPath.row];
    NSLog(@"-----%@",dic);
    
    PUSH(NewShopDetailVC)
    vc.infoDic = [dic mutableCopy];
    vc.videoID=[NSString getTheNoNullStr:dic[@"video"] andRepalceStr:@""];

    
    

}

-(void)creatHeadView:(NSDictionary *)data_dic{
    
    UIView *bgView=[[UIView alloc]init];
    
    
    
    
   UIScrollView * topScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 54)];
    topScrollView.backgroundColor=[UIColor whiteColor];
    topScrollView.showsHorizontalScrollIndicator=NO;
    [bgView addSubview:topScrollView];
    
    
    for (int i=0; i<self.trade_A.count; i++) {
        
        LZDButton *btn = [LZDButton creatLZDButton];
        btn.frame = CGRectMake(13+(81+8)*i, 14, 81, 29);
        [btn setTitle:_trade_A[i][@"text"] forState:0];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        btn.layer.cornerRadius = 14;
        btn.layer.masksToBounds = YES;
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = RGB(220,220,220).CGColor;
        [btn setTitleColor:RGB(143,143,143) forState:0];
        btn.tag=i;
        [topScrollView addSubview:btn];
        
        btn.block = ^(LZDButton *sender) {
          
            if (sender !=oldBtn) {
                sender.backgroundColor = RGB(228,96,98);
                [sender setTitleColor:[UIColor whiteColor] forState:0];
                
                oldBtn.backgroundColor = [UIColor whiteColor];
                [oldBtn setTitleColor:RGB(143,143,143) forState:0];
                
                if (sender.tag==0) {
                    self.classifyString = @"";

                }else{
                    self.classifyString = self.trade_A[sender.tag][@"text"];

                }
                [self postGetMutiAdvertistShops:_city_district];
                oldBtn = sender;
            }
            
            
        };
        
        if (oldBtn) {
            if (i==oldBtn.tag) {
                oldBtn = btn;
                btn.backgroundColor = RGB(228,96,98);
                
                [btn setTitleColor:[UIColor whiteColor] forState:0];

            }
        }else{
            if (i==0) {
                oldBtn = btn;
                btn.backgroundColor = RGB(228,96,98);
                
                [btn setTitleColor:[UIColor whiteColor] forState:0];
                

            }
        }
        
        
        
        
        topScrollView.contentSize = CGSizeMake(btn.right+13, 0);
        
    }
    
    
    if (_adverImages.count !=0) {
       SDCycleScrollView* cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 54, SCREENWIDTH, 119*LZDScale) delegate:nil placeholderImage:[UIImage imageNamed:@"icon3"]];
        cycleScrollView2.imageURLStringsGroup = _adverImages;
        cycleScrollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        //           cycleScrollView2.titlesGroup = self.titles;
        cycleScrollView2.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
        cycleScrollView2.hidesForSinglePage = YES;
        [bgView addSubview:cycleScrollView2];
        
        cycleScrollView2.clickItemOperationBlock = ^(NSInteger currentIndex) {
          
            PUSH(ChouJiangVC)
            vc.urlString = [NSString stringWithFormat:@"http://%@",self.advert_A[currentIndex][@"url"]];
            
            NSLog(@"-----%ld",currentIndex);
        };
        
    }else{
        
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 54, SCREENWIDTH, 119*LZDScale)];
        imgView.image = [UIImage imageNamed:@"首页顶部海报"];
        [bgView addSubview:imgView];
    }
    
    
    UILabel *like_lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 54+119*LZDScale, SCREENWIDTH, 43)];
    like_lab.text = @"为你推荐";
    like_lab.textColor = RGB(98,98,98);
    like_lab.textAlignment = NSTextAlignmentCenter;
    like_lab.font = [UIFont systemFontOfSize:10];
    like_lab.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:like_lab];
    
    CGFloat  WW = [like_lab.text boundingRectWithSize:CGSizeMake(200, 50) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:like_lab.font} context:nil].size.width;
    
    UIView *line1 = [[UIView alloc]init];
    line1.frame = CGRectMake(95, (like_lab.height-1)/2+like_lab.top, SCREENWIDTH/2-95-WW/2-20, 1);
    line1.backgroundColor = RGB(181,181,181);
    [bgView addSubview:line1];
    
    UIView *line2 = [[UIView alloc]init];
    line2.frame = CGRectMake( SCREENWIDTH/2+WW/2+20, line1.top, line1.width, line1.height);
    line2.backgroundColor =  line1.backgroundColor;
    [bgView addSubview:line2];

    
    bgView.frame = CGRectMake(0, 0, SCREENWIDTH, like_lab.bottom);
    
    self.tabview.tableHeaderView =  bgView;
}


-(void)postGetMutiAdvertistShops:(NSString*)address{
    
    [self showHudInView:self.view hint:@"加载中..."];
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/NB/getData",BASEURL];
    
    
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    NSMutableDictionary*paramer = [NSMutableDictionary dictionary];
    
    [paramer setValue:address forKey:@"location"];
    
    [paramer setValue:[NSString stringWithFormat:@"%lf",appdelegate.userLocation.location.coordinate.latitude] forKey:@"lat"];
    [paramer setValue:[NSString stringWithFormat:@"%lf",appdelegate.userLocation.location.coordinate.longitude] forKey:@"lng"];
    
    [paramer setValue:_classifyString forKey:@"trade"];
    

    DebugLog(@"===url=%@\n===paramer==%@",url,paramer);
    
    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        [_refreshheader endRefreshing];
        [_refreshFooter endRefreshing];
        [self hideHud];

        NSLog(@"getAdverListRequestWithIndePath-----%@",result);
        if ([result isKindOfClass:[NSDictionary class]]) {
            
            self.trade_A =result[@"hot_sort"];
            
            self.data_M_A = [result[@"stores"] mutableCopy];
            
            
            self.advert_A = result[@"advert"];
            
            [self.adverImages removeAllObjects];
            
            
            for (int i=0; i<[result[@"advert"] count]; i++) {
                

                [self.adverImages addObject:[NSString stringWithFormat:@"%@%@",HOME_LUNBO_IMAGE,result[@"advert"][i][@"image"]]];
                

            }

            
            NSLog(@"self.tabview.tableHeaderView------%@",self.tabview.tableHeaderView)  ;
            
            if (!self.tabview.tableHeaderView) {
                [self creatHeadView:(NSDictionary*)result];

            }
            
        }
        
        [self.tabview reloadData];

        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_refreshheader endRefreshing];
        [_refreshFooter endRefreshing];
        [self hideHud];

        NSLog(@"%@", error);
        
    }];

    
}


-(void)postRequestShopWithAddress:(NSString *)address
{
    
    [self showHudInView:self.view hint:@"加载中..."];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];

    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/search/get",BASEURL];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSString stringWithFormat:@"%ld",_page] forKey:@"index"];
    
    [params setObject:address forKey:@"eare"];
    [params setObject:_classifyString forKey:@"trade"];
    
    
    
    [params setValue:address forKey:@"location"];
    
    [params setValue:[NSString stringWithFormat:@"%lf",appdelegate.userLocation.location.coordinate.latitude] forKey:@"lat"];
    [params setValue:[NSString stringWithFormat:@"%lf",appdelegate.userLocation.location.coordinate.longitude] forKey:@"lng"];
    

    
    
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        [_refreshheader endRefreshing];
        [_refreshFooter endRefreshing];

        [self hideHud];
        NSLog(@"postRequestShop-----%@",result);
        if ([result isKindOfClass:[NSArray class]]) {
            if (self.page==1) {
//
                self.data_M_A=[NSMutableArray arrayWithArray:result];
//
            }else{
                for (int i=0; i<[result count]; i++) {
                    [self.data_M_A addObject:result[i]];
                }
            }
            
            
        
            [self.tabview reloadData];
        }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self hideHud];

        [_refreshheader endRefreshing];
        [_refreshFooter endRefreshing];
        
        NSLog(@"%@", error);
        
    }];
    
}



#pragma mark 懒加载
-(NSArray *)advert_A{
    if (!_advert_A) {
        _advert_A = [NSArray array];
    }
    return _advert_A;
}
-(NSArray *)trade_A{
    if (!_trade_A) {
        _trade_A = [NSArray array];
    }
    return _trade_A;
}
-(NSMutableArray *)adverImages{
    if (!_adverImages) {
        _adverImages = [NSMutableArray array];
    }
    return _adverImages;
}
-(NSMutableArray *)data_M_A{
    if (!_data_M_A) {
        _data_M_A = [NSMutableArray array];
    }
    return _data_M_A;
}


@end
