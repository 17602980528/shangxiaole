//
//  BeautyIndustryVC.m
//  BletcShop
//
//  Created by Bletc on 2017/7/12.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "BeautyIndustryVC.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import <BaiduMapAPI_Utils/BMKGeometry.h>
#import "ChouJiangVC.h"

#import "SDCycleScrollView.h"
#import "ShopListTableViewCell.h"
#import "DOPDropDownMenu.h"
#import "ProvinceModel.h"
#import "CityModel.h"
#import "ShoppingViewController.h"

#import "CustomSearchVC.h"
#import "NewShopDetailVC.h"
@interface BeautyIndustryVC ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,DOPDropDownMenuDelegate,DOPDropDownMenuDataSource>
{
    NSArray *arr;

    NSDictionary *curentEare;

    NSDictionary *currentCityDic;
    UIScrollView *middle_scrollView;
    UITapGestureRecognizer *_tap;
    
    NSString *city;
    NSString *distrt;;

    UIView *_back_scressn_view;//筛选view
    SDRefreshFooterView *_refreshFooter;
    SDRefreshHeaderView *_refreshheader;
    
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabview_top;
@property (weak, nonatomic) IBOutlet UILabel *navTitleLab;
@property (weak, nonatomic) IBOutlet UITableView *table_view;

@property (weak, nonatomic) IBOutlet UIView *nav_topView;
@property(nonatomic,strong)DOPDropDownMenu *dropDownMenu;
@property(nonatomic,strong)NSMutableArray *data_M_A;

@property(nonatomic,strong)NSMutableArray *topImg_M_A;
@property(nonatomic,strong)NSMutableArray *mid_advert_img;

@property(nonatomic, strong)NSMutableArray *dataSourceProvinceArray;
@property(nonatomic, strong)NSMutableArray *dataSourceCityArray;
@property (nonatomic, strong) NSArray *sorts;//智能排序
@property(nonatomic,strong)DOPIndexPath *indexpathSelect;

@property (nonatomic,copy)NSString *address;



@property(nonatomic,copy)NSString *sort_string;//智能排序;
@property(nonatomic,strong)NSDictionary *upSort_data_dic;

@property(nonatomic,assign)NSInteger page;
@end

@implementation BeautyIndustryVC

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;

}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    currentCityDic = [[NSUserDefaults standardUserDefaults]objectForKey:@"locationCityDic"] ? [[NSUserDefaults standardUserDefaults]objectForKey:@"locationCityDic"] :[[NSUserDefaults standardUserDefaults]objectForKey:@"currentCityDic"] ;
//
//    
//    if (arr != [[NSUserDefaults standardUserDefaults]objectForKey:@"currentEreaList"] || [[NSUserDefaults standardUserDefaults]objectForKey:@"currentEareDic"] != curentEare) {
//        curentEare = [[NSUserDefaults standardUserDefaults]objectForKey:@"currentEareDic"];
//        NSLog(@"getData");
//        [self getData];
//    }

    
}
- (IBAction)goback:(id)sender {
    POP
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;

    self.navTitleLab.text = _icon_dic[@"text"];
    if ([_icon_dic[@"id"]intValue]==200) {
        self.nav_topView.backgroundColor = [UIColor clearColor];

        for (UIView *v in self.nav_topView.subviews) {
            v.backgroundColor = [UIColor clearColor];
        }

        self.tabview_top.constant = 0;

    
    }

    
    self.page = 1;
    
    AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    self.address = city = appdelegate.city.length==0?@"西安市":appdelegate.city;
    self.sort_string = @"";
    _table_view.backgroundColor = RGB(240, 240, 240);

    
    
    
    
    _refreshheader = [SDRefreshHeaderView refreshView];
    [_refreshheader addToScrollView:self.table_view];
    _refreshheader.isEffectedByNavigationController = NO;
    
    __block typeof(self)blockSelf =self;
    _refreshheader.beginRefreshingOperation = ^{
        blockSelf.page=1;
        [blockSelf.data_M_A removeAllObjects];
        //请求数据
        [blockSelf getFilterStores];
    };
    
    
    _refreshFooter = [SDRefreshFooterView refreshView];
    [_refreshFooter addToScrollView:self.table_view];
    _refreshFooter.beginRefreshingOperation =^{
        //数据请求
        [blockSelf UPSort_dropLoad];
        
    };

    
    
    
    
    
//    [self creatTableViewHeaderView];
    
    [self showLoadingView];
    
    [self creatScreenView];
    
    
    
  
    
     [self getData];
    
    [self getData_UPSort];
    
}



-(void)creatScreenView{
    
    _back_scressn_view = [[UIView alloc]initWithFrame:CGRectMake(SCREENWIDTH, 0, SCREENWIDTH, SCREENHEIGHT)];
    _back_scressn_view.backgroundColor =RGBA_COLOR(204, 204, 204, 0.2);
    
    [self.view addSubview: _back_scressn_view];
    
    
    
    UIView *topV = [[UIView alloc]initWithFrame:CGRectMake(66, 0, SCREENWIDTH-66, 64)];
    topV.backgroundColor = [UIColor whiteColor];
    [_back_scressn_view addSubview:topV];
    
    _tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideScreenView)];
    [_back_scressn_view addGestureRecognizer:_tap];
    
    UILabel *title_lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 33, topV.width, 17)];
    title_lab.text = @"筛选条件";
    title_lab.textAlignment = NSTextAlignmentCenter;
    title_lab.textColor = RGB(51,51,51);
    title_lab.font = [UIFont boldSystemFontOfSize:18];
    [topV addSubview:title_lab];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 63, topV.width, 1)];
    line.backgroundColor = RGB(153, 153, 153);
    [topV addSubview:line];
    
    
    UIView *bottomV = [[UIView alloc]initWithFrame:CGRectMake(topV.left, topV.bottom, topV.width, SCREENHEIGHT-topV.bottom)];
    bottomV.backgroundColor = RGB(240,240,240);
    [_back_scressn_view addSubview:bottomV];

    DOPDropDownMenu *dropDownMenu = [[DOPDropDownMenu alloc]initWithOrigin:CGPointMake(0, 0) andHeight:40 andSuperView:bottomV];
    
    dropDownMenu.menuRowClcikBolck = ^(NSInteger currentIndex, BOOL show) {
      
        NSLog(@"%ld-%d",currentIndex,show);
        
        if (!show) {
            [self hideScreenView];
        }else{
            [_back_scressn_view removeGestureRecognizer:_tap];

        }
        
        
    };
    dropDownMenu.backgroundColor = [UIColor whiteColor];
    dropDownMenu.delegate = self;
    dropDownMenu.dataSource = self;
    [bottomV addSubview:dropDownMenu];
//    [self.dropDownMenu selectDefalutIndexPath];

    self.dropDownMenu = dropDownMenu;

}


-(void)creatTableViewHeaderView{
    
    NSLog(@"creatTableViewHeaderView");
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = RGB(240, 240, 240);
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 13)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:whiteView];
    
    UIView *slipBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 13, SCREENWIDTH, 119*LZDScale)];
    
    [headerView addSubview:slipBackView];

    
    if (self.topImg_M_A.count==0) {
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:slipBackView.frame];
        imgView.image = [UIImage imageNamed:@"首页顶部海报"];
        [slipBackView addSubview:imgView];

        
    }else{
        SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREENWIDTH, 119*LZDScale) delegate:nil placeholderImage:[UIImage imageNamed:@""]];

        cycleScrollView.imageURLStringsGroup = self.topImg_M_A;
        cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        cycleScrollView.currentPageDotColor = [UIColor whiteColor];
        
        [cycleScrollView setValue:@"NO" forKeyPath:@"mainView.scrollsToTop"];
        
        cycleScrollView.clickItemOperationBlock = ^(NSInteger currentIndex) {
            NSDictionary *dic = self.upSort_data_dic[@"top_advert"][currentIndex];
            
            
            if (![dic[@"state"] isEqualToString:@"false"]) {
                
                PUSH(ChouJiangVC)
                if ([dic[@"url"] hasPrefix:@"http"]) {
                    vc.urlString = [NSString stringWithFormat:@"%@",dic[@"url"]];
                    
                }else{
                    vc.urlString = [NSString stringWithFormat:@"http://%@",dic[@"url"]];
                    
                }
                vc.navigationItem.title =dic[@"title"];
            }
            
        };
        
        [slipBackView addSubview:cycleScrollView];
 
    }
    
    
    
     middle_scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, slipBackView.bottom+10, SCREENWIDTH, 110)];
    middle_scrollView.backgroundColor = [UIColor whiteColor];
    middle_scrollView.showsVerticalScrollIndicator = NO;
    middle_scrollView.showsHorizontalScrollIndicator = NO;
    middle_scrollView.scrollsToTop = NO;
    middle_scrollView.pagingEnabled = YES;
    [headerView addSubview:middle_scrollView];
    
    
    

    NSInteger yeshu = 0;
    
    if ([_upSort_data_dic[@"sub_sort"] count]%8==0) {
        yeshu = [_upSort_data_dic[@"sub_sort"] count]/8;
    }else{
        yeshu = [_upSort_data_dic[@"sub_sort"] count]/8+1;
    }

    
    middle_scrollView.contentSize = CGSizeMake(middle_scrollView.width*yeshu, 0);

    

    CGFloat ww = (middle_scrollView.width-10)/4;
    CGFloat hh = 32+10+13;
    
    if ([_upSort_data_dic[@"sub_sort"] count]>4) {
        middle_scrollView.frame = CGRectMake(0, slipBackView.bottom+10, SCREENWIDTH, 21+(hh+20)*2);
        
    }else{
        middle_scrollView.frame = CGRectMake(0, slipBackView.bottom+10, SCREENWIDTH, 21+(hh+20));
        
    }
    
    for (int i = 0; i <3; i ++) {
        
        for (int j = i*8; j < (i+1)*8; j ++) {
            if (j>=[_upSort_data_dic[@"sub_sort"] count]) {
                break;
            }
            
            int X = (j-i*8)%4;
            int Y = (j-i*8)/4;

            
        
        NSDictionary *dic = _upSort_data_dic[@"sub_sort"][j];
        
        LZDButton *btn = [LZDButton creatLZDButton];
        btn.frame = CGRectMake(5+X*ww+i*middle_scrollView.width, 21+Y*(hh+20),ww, hh);
        [middle_scrollView addSubview:btn];
        

        btn.block = ^(LZDButton *btn) {
            
            PUSH(ShoppingViewController);
            vc.navigationItem.title = dic[@"text"];
            vc.icon_dic = dic;
            
            
        };
            
      
        
        UIImageView *imgView = [[UIImageView alloc]init];
        
        [imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SUBICONIMAGE,dic[@"icon_url"]]] placeholderImage:[UIImage imageNamed:@"icon3"]];
        [btn addSubview:imgView];
        
        
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.height.mas_equalTo(32);
            make.width.mas_equalTo(32);
            make.top.mas_offset(0);
            make.centerX.equalTo(btn);
        }];
        
        
        UILabel *titlelab = [[UILabel alloc]init];
        titlelab.textColor = RGB(51,51,51);
        titlelab.text = dic[@"text"];
        titlelab.font = [UIFont systemFontOfSize:13];
        titlelab.textAlignment = NSTextAlignmentCenter;
        [btn addSubview:titlelab];
        
        [titlelab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(btn);
            make.width.equalTo(btn);
            make.height.mas_equalTo(13);
            make.centerX.equalTo(imgView);
            
        }];
        
        }
 
    }
    
    
    
  UIScrollView*  bottom_scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, middle_scrollView.bottom+10, SCREENWIDTH, 101)];
    bottom_scrollView.backgroundColor = [UIColor whiteColor];
    bottom_scrollView.showsVerticalScrollIndicator = NO;
    bottom_scrollView.showsHorizontalScrollIndicator = NO;
    bottom_scrollView.scrollsToTop = NO;
    bottom_scrollView.pagingEnabled = YES;
    [headerView addSubview:bottom_scrollView];

    
    for (int i = 0; i <self.mid_advert_img.count; i++) {
        
        NSDictionary *dic = _mid_advert_img[i];
        
        LZDButton *img_btn = [LZDButton creatLZDButton];
        img_btn.frame = CGRectMake(13 +i*((SCREENWIDTH-13*3)/2+13), 15, (SCREENWIDTH-13*3)/2, 71);
        [bottom_scrollView addSubview: img_btn];
        
        img_btn.block = ^(LZDButton *sender) {
            
            if (![dic[@"state"] isEqualToString:@"false"]) {
                PUSH(ChouJiangVC)
                if ([dic[@"url"] hasPrefix:@"http"]) {
                    vc.urlString = [NSString stringWithFormat:@"%@",dic[@"url"]];
                    
                }else{
                    vc.urlString = [NSString stringWithFormat:@"http://%@",dic[@"url"]];
                    
                }
                vc.navigationItem.title =dic[@"title"];
            }
            
           
        };
        
        [img_btn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",UP_MIDAD_IMAGE,dic[@"image"]]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"icon3"]];
        
        [img_btn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",UP_MIDAD_IMAGE,dic[@"image"]]] forState:UIControlStateHighlighted placeholderImage:[UIImage imageNamed:@"icon3"]];

        
        
        
        
        UILabel *topLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, img_btn.width, 13)];
        topLab.text = [NSString getTheNoNullStr:dic[@"title"] andRepalceStr:@"育儿知识"];
        topLab.textAlignment = NSTextAlignmentCenter;
        topLab.textColor = RGB(255,255,255);
        topLab.font = [UIFont systemFontOfSize:12];
        [img_btn addSubview:topLab];
        
        UILabel *midLab = [[UILabel alloc]initWithFrame:CGRectMake(0, topLab.bottom+9, img_btn.width, 10)];
        midLab.text =[NSString getTheNoNullStr:dic[@"content"] andRepalceStr:@"带娃宝典"] ;
        midLab.textAlignment = NSTextAlignmentCenter;
        midLab.textColor = RGB(255,255,255);
        midLab.font = [UIFont systemFontOfSize:10];
        [img_btn addSubview:midLab];

        
        UILabel *bottomLab = [[UILabel alloc]initWithFrame:CGRectMake((img_btn.width-30)/2, midLab.bottom+10, 28, 9)];
        bottomLab.text =[NSString getTheNoNullStr:dic[@"key"] andRepalceStr:@"NEW"] ;

        if (i==1) {
            bottomLab.text =@"HOT";

        }
        bottomLab.textAlignment = NSTextAlignmentCenter;
        bottomLab.textColor = RGB(81,80,80);
        bottomLab.font = [UIFont systemFontOfSize:9];
        bottomLab.backgroundColor = [UIColor whiteColor];
        bottomLab.layer.cornerRadius =2;
        bottomLab.layer.masksToBounds = YES;
        [img_btn addSubview:bottomLab];
        
        
        
    }
    
    
  
    


    
    
    if ([_icon_dic[@"id"]intValue]==200) {
    
        slipBackView.frame =CGRectMake(0, 0, SCREENWIDTH, 161*LZDScale);
        slipBackView.backgroundColor = [UIColor redColor];
        SDCycleScrollView *cyVIew = slipBackView.subviews[0];
        cyVIew.frame = slipBackView.frame;
        
        cyVIew.clickItemOperationBlock = ^(NSInteger currentIndex) {
            NSLog(@"健康养生");
        };
        
        middle_scrollView.hidden = YES;
        
        UIScrollView *top_scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, slipBackView.height-45-41, SCREENWIDTH, 45+41)];
        
        top_scrollView.showsVerticalScrollIndicator = NO;
        top_scrollView.showsHorizontalScrollIndicator = NO;
        [headerView addSubview:top_scrollView];
        
        
        for (int i = 0; i <[_upSort_data_dic[@"sub_sort"] count]; i++) {
            
            
            NSDictionary *dic = _upSort_data_dic[@"sub_sort"][i];
            
            LZDButton *btn = [LZDButton creatLZDButton];
            btn.frame = CGRectMake((41+18*2+9)*i, 0,41+18*2, top_scrollView.height);
            [top_scrollView addSubview:btn];
            
            top_scrollView.contentSize = CGSizeMake(btn.right, 0);
            btn.block = ^(LZDButton *btn) {
                
                PUSH(ShoppingViewController);
                vc.navigationItem.title = dic[@"text"];
                vc.icon_dic = dic;
                
                
            };
            
            
            
            UIImageView *imgView = [[UIImageView alloc]init];
            
            [imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SUBICONIMAGE,dic[@"icon_url"]]] placeholderImage:[UIImage imageNamed:@"icon3"]];
            [btn addSubview:imgView];
            
            
            [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.height.mas_equalTo(41);
                make.width.mas_equalTo(41);
                make.top.mas_offset(0);
                make.centerX.equalTo(btn);
            }];
            
            
            UILabel *titlelab = [[UILabel alloc]init];
            titlelab.textColor = RGB(51,51,51);
            titlelab.text = dic[@"text"];
            titlelab.font = [UIFont systemFontOfSize:13];
            titlelab.textAlignment = NSTextAlignmentCenter;
            [btn addSubview:titlelab];
            
            [titlelab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(41+15);
                make.width.equalTo(btn);
                make.height.mas_equalTo(13);
                make.centerX.equalTo(imgView);
                
            }];

        }
        
        

        
    
    UIView *bottom_view = [[UIView alloc]initWithFrame:CGRectMake(0, slipBackView.bottom+10, SCREENWIDTH, 44)];
    bottom_view.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:bottom_view];
    
    UILabel *labe = [[UILabel alloc]initWithFrame:CGRectMake(13, 0, 200, 44)];
    labe.text = @"为你推荐";
    labe.textColor = RGB(51,51,51);
    labe.font = [UIFont systemFontOfSize:14];
    [bottom_view addSubview:labe];
    
        
        bottom_scrollView.frame = CGRectMake(0, slipBackView.bottom+10+44, SCREENWIDTH, 148-44);
    
        for (UIView *view in bottom_scrollView.subviews) {
            [view removeFromSuperview];
        }
    
    
    
    for (int i = 0; i <self.mid_advert_img.count; i++) {
        
        NSDictionary *dic = _mid_advert_img[i];
        
        LZDButton *img_btn = [LZDButton creatLZDButton];
        img_btn.frame = CGRectMake(13 +i*((SCREENWIDTH-13*2-10)/3+5), 0, (SCREENWIDTH-13*2-10)/3, bottom_scrollView.height);
        [bottom_scrollView addSubview: img_btn];
       
        img_btn.block = ^(LZDButton *sender) {
            
            if (![dic[@"state"] isEqualToString:@"false"]) {
                PUSH(ChouJiangVC)
                if ([dic[@"url"] hasPrefix:@"http"]) {
                    vc.urlString = [NSString stringWithFormat:@"%@",dic[@"url"]];

                }else{
                    vc.urlString = [NSString stringWithFormat:@"http://%@",dic[@"url"]];

                }

                vc.navigationItem.title =dic[@"title"];
            }
        };
        
        bottom_scrollView.contentSize = CGSizeMake(img_btn.right+13, 0);
        
        UIImageView *imgView = [[UIImageView alloc]init];
        
        [imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",UP_MIDAD_IMAGE,dic[@"image"]]] placeholderImage:[UIImage imageNamed:@"icon3"]];
        imgView.layer.cornerRadius = 6;
        imgView.layer.masksToBounds = YES;
        imgView.frame = CGRectMake(0, 0, img_btn.width, 71);

        [img_btn addSubview:imgView];
        
        
        UILabel *titlelab = [[UILabel alloc]init];
        titlelab.textColor = RGB(51,51,51);
        titlelab.text = [NSString getTheNoNullStr:dic[@"title"] andRepalceStr:@"爽肤水"];
        titlelab.font = [UIFont systemFontOfSize:13];
        titlelab.textAlignment = NSTextAlignmentCenter;
        [img_btn addSubview:titlelab];
        
        titlelab.frame = CGRectMake(0, imgView.bottom+7, img_btn.width, 13);
       
        
        
        
    }

     
        
    }
    
    if ([_icon_dic[@"id"] intValue]==500) {
    
        for (UIView *view in bottom_scrollView.subviews) {
            [view removeFromSuperview];
        }


        
        
        for (int i = 0; i <self.mid_advert_img.count; i++) {
            
            NSDictionary *dic = _mid_advert_img[i];
            
            bottom_scrollView.backgroundColor = [UIColor clearColor];
            
            LZDButton *btn = [LZDButton creatLZDButton];
            btn.frame = CGRectMake(((SCREENWIDTH-3)/4+1)*i, 0,(SCREENWIDTH-3)/4, bottom_scrollView.height);
            [bottom_scrollView addSubview:btn];
            btn.backgroundColor = [UIColor whiteColor];
            
            bottom_scrollView.contentSize = CGSizeMake(btn.right, 0);
            
            btn.block = ^(LZDButton *btn) {
                
                if (![dic[@"state"] isEqualToString:@"false"]) {
                    PUSH(ChouJiangVC)
                    if ([dic[@"url"] hasPrefix:@"http"]) {
                        vc.urlString = [NSString stringWithFormat:@"%@",dic[@"url"]];

                    }else{
                        vc.urlString = [NSString stringWithFormat:@"http://%@",dic[@"url"]];

                    }
                    vc.navigationItem.title =dic[@"title"];
                }

                
                
            };

            UILabel *topLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 12, btn.width, 13)];
            topLab.text = [NSString getTheNoNullStr:dic[@"title"] andRepalceStr:@"育儿知识"];
            topLab.textAlignment = NSTextAlignmentCenter;
            topLab.textColor = RGB(51,51,51);
            topLab.font = [UIFont systemFontOfSize:14];
            [btn addSubview:topLab];
            
            UILabel *midLab = [[UILabel alloc]initWithFrame:CGRectMake(0, topLab.bottom+6, btn.width, 10)];
            midLab.text =[NSString getTheNoNullStr:dic[@"content"] andRepalceStr:@"带娃宝典"] ;
            midLab.textAlignment = NSTextAlignmentCenter;
            midLab.textColor = RGB(143,143,143);
            midLab.font = [UIFont systemFontOfSize:10];
            [btn addSubview:midLab];

            UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake((btn.width-43)/2,midLab.bottom+ 6, 43, 51)];
            [imgV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",UP_MIDAD_IMAGE,dic[@"image"]]] placeholderImage:[UIImage imageNamed:@"icon3"]];
            
            [btn addSubview:imgV];
            
            
            
            
        }
        
    }
    
    
    if ([_icon_dic[@"id"] intValue]==300||[_icon_dic[@"id"] intValue]==400) {
    
        slipBackView.frame = CGRectMake(0, 0, SCREENWIDTH, 133*LZDScale);
        
        
        SDCycleScrollView *cyVIew = slipBackView.subviews[0];
        cyVIew.frame = slipBackView.frame;
        
        CGRect fra =  middle_scrollView.frame;
        fra.origin.y =slipBackView.bottom+10;
           middle_scrollView.frame = fra ;

        

      bottom_scrollView.frame =  CGRectMake(0, middle_scrollView.bottom+10, SCREENWIDTH, 123)
        ;
//        CGRect fra = bottom_scrollView.frame;
//        fra.size.height = 123;
//        bottom_scrollView.frame = fra;
        
        for (UIView *view in bottom_scrollView.subviews) {
            [view removeFromSuperview];
        }
        
        
        
        for (int i = 0; i <self.mid_advert_img.count; i++) {
            
            NSDictionary *dic = _mid_advert_img[i];
            
            LZDButton *img_btn = [LZDButton creatLZDButton];
            img_btn.frame = CGRectMake(i*((SCREENWIDTH-6)/3+3), 0, (SCREENWIDTH-6)/3, bottom_scrollView.height);
            [bottom_scrollView addSubview: img_btn];
            
            img_btn.block = ^(LZDButton *sender) {
                
                if (![dic[@"state"] isEqualToString:@"false"]) {
                    PUSH(ChouJiangVC)
                    if ([dic[@"url"] hasPrefix:@"http"]) {
                        vc.urlString = [NSString stringWithFormat:@"%@",dic[@"url"]];
                        
                    }else{
                        vc.urlString = [NSString stringWithFormat:@"http://%@",dic[@"url"]];
                        
                    }

                    vc.navigationItem.title =dic[@"title"];
                }
            };
            
            bottom_scrollView.contentSize = CGSizeMake(img_btn.right+15, 0);
            
            
            UILabel *titlelab = [[UILabel alloc]init];
            titlelab.textColor = RGB(51,51,51);
            titlelab.text = [NSString getTheNoNullStr:dic[@"title"] andRepalceStr:@"爽肤水"];
            titlelab.font = [UIFont systemFontOfSize:13];
            titlelab.textAlignment = NSTextAlignmentCenter;
            [img_btn addSubview:titlelab];
            
            titlelab.frame = CGRectMake(0, 71+15+10, img_btn.width, 13);
            if ([_icon_dic[@"text"] isEqualToString:@"生活服务"]) {
                titlelab.frame = CGRectMake(0, 15, img_btn.width, 13);
                
            }
            
            

            
            UIImageView *imgView = [[UIImageView alloc]init];
            
            [imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",UP_MIDAD_IMAGE,dic[@"image"]]] placeholderImage:[UIImage imageNamed:@"icon3"]];
            [img_btn addSubview:imgView];
            
     
            imgView.frame = CGRectMake((img_btn.width-71)/2, 15, 71, 71);
            
        
            
            if ([_icon_dic[@"id"] intValue]==400) {
                imgView.frame = CGRectMake((img_btn.width-71)/2, 39, 71, 71);

            }

            
            imgView.layer.cornerRadius = 71/2;
            imgView.layer.masksToBounds = YES;
            
            
            
            
        }

        
        
    }
    
    headerView.frame = CGRectMake(0, 0, SCREENWIDTH, bottom_scrollView.bottom+10);

    self.table_view.tableHeaderView = headerView;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return  100.5;
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (self.data_M_A.count==0) {
        
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 150)];
        backView.backgroundColor = RGB(240, 240, 240);

        
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-30, 30, 60, 60)];
        imgView.image = [UIImage imageNamed:@"无数据"];
        [backView addSubview:imgView];
        
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, imgView.bottom +10, SCREENWIDTH, 20)];
        
        lab.textColor= RGB(51, 51, 51);
        lab.text = @"暂时没有数据哦!!!";
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = [UIFont systemFontOfSize:14];
        [backView addSubview:lab];

        return backView;
    }else
        return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
          return  self.data_M_A.count==0? 150  :0.01;

}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 40)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *like_lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, view.height)];
    like_lab.text = @"在你身边";
    like_lab.textColor = RGB(102, 102, 102);
    like_lab.textAlignment = NSTextAlignmentCenter;
    like_lab.font = [UIFont systemFontOfSize:12];
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
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data_M_A.count;
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
#pragma mark DOPDownMenu 代理
-(NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu{
    return 2;
}


- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column
{
    
    if (column == 0) {
        return self.sorts.count;
    }else {
        
        return self.dataSourceProvinceArray.count;
    }
}

-(NSString*)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath{
    if (indexPath.column == 0) {
        return self.sorts[indexPath.row];
    } else{
        
        ProvinceModel *m = _dataSourceProvinceArray[indexPath.row];
        
        return m.name;
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
-(void)hideScreenView{

    [_back_scressn_view addGestureRecognizer:_tap];

    [UIView animateWithDuration:0.3 animations:^{
        CGRect fram = _back_scressn_view.frame;
        fram.origin.x = SCREENWIDTH;
        _back_scressn_view.frame = fram;
        
    }];

}
-(void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath{
    
    self.page = 1;
    
        if (indexPath.column ==0) {
            
            self.sort_string = _sorts[indexPath.row];
            
            [self hideScreenView];
            
            [self  getFilterStores];
            
        }else if (indexPath.column == 1 ) {
            self.indexpathSelect =indexPath;
            
            
           
            if (indexPath.item>=0) {

                [self hideScreenView];
                

                if (indexPath.row!=0) {
                    CityModel *m = _dataSourceCityArray[indexPath.item];
                    
                    self.address = [NSString stringWithFormat:@"%@%@%@",city,distrt,m.name];
                }else{
                    self.address = city;
                }
               

                
            }else{
                ProvinceModel *m = _dataSourceProvinceArray[indexPath.row];
                
               
                
                if (indexPath.row!=0) {
                    distrt = m.name;

                    self.address = [NSString stringWithFormat:@"%@%@",city,distrt];
                }else{
                    self.address = city;
                }
                
                [self getcityDataById:m.code AndIndexPath:indexPath];

 
            }
            
            [self  getFilterStores];

            
        }
        
        


    
    
}

- (void)getData
{
    self.indexpathSelect = [DOPIndexPath indexPathWithCol:1 row:0 item:-1];
    
    //数据源数组:
    self.dataSourceProvinceArray = [NSMutableArray array];
    
    
    
    arr = [[NSUserDefaults standardUserDefaults]objectForKey:@"locationCityEreaList"];
    

    
    
    for (int i = 0; i < arr.count; i ++) {
        
        NSDictionary *dic = arr[i];
        
        ProvinceModel *model = [[ProvinceModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];

        
            [self.dataSourceProvinceArray addObject:model];
            
        
    }
    ProvinceModel *MM = [[ProvinceModel alloc]init];
    [MM setName:city];
    NSLog(@"--===============+%@",MM);

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
//        [self hideHud];

        //        NSLog(@"----%@",result);
        //遍历当前数组给madel赋值
        [self.dataSourceCityArray removeAllObjects];
        
        
        NSLog(@"indexPath-----%@=%ld=%ld=%ld",indexPath,indexPath.column ,indexPath.row,indexPath.item);
        
        if (!proID) {
            
            for (int i = 0; i <1; i ++) {
                CityModel *mod = [[CityModel alloc] init];
                
                
                if (i==0) {
                    
                    [mod setName: currentCityDic[@"name"]];
                    
                }else{
                    
                }
                
                NSLog(@"--===============+%@",mod);
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
            
        }
        
        
  
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error-----%@",error);
    }];
    
    
    
    
}



//筛选数据
-(void)getFilterStores{
    
//    //    [self showHudInView:self.view hint:@"加载中..."];;
    NSString *url = [NSString stringWithFormat:@"%@UserType/UPSort/getFilterStores",BASEURL];
    
    AppDelegate*app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSMutableDictionary*paramer = [NSMutableDictionary dictionary];
    [paramer setValue:_icon_dic[@"id"] forKey:@"up_id"];
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
        
//        [self hideHud];
        
//        NSLog(@"getFilterStores==%@",result);
        
        
        self.data_M_A = [result[@"stores"] mutableCopy];
        
        [self.table_view reloadData];
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_refreshheader endRefreshing];

//        [self hideHud];

    }];

    
    
}


//获取广告请求


-(void)getData_UPSort{
    
    
    //    [self showHudInView:self.view hint:@"加载中..."];;
    
    NSString *url = [NSString stringWithFormat:@"%@UserType/UPSort/getData",BASEURL];
    
    
    NSMutableDictionary*paramer = [NSMutableDictionary dictionary];
    [paramer setValue:_icon_dic[@"id"] forKey:@"up_id"];

    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        NSLog(@"getData_UPSort---%@",result);
        [self hintLoadingView];
        
//        [self hideHud];

        self.upSort_data_dic = [result copy];
        
        for (int i=0; i<[result[@"top_advert"] count]; i++) {
            
            
            [self.topImg_M_A addObject:[NSString stringWithFormat:@"%@%@",UP_TOPAD_IMAGE,result[@"top_advert"][i][@"image"]]];
            
            
        }

        self.mid_advert_img =  [result[@"mid_advert"] mutableCopy];
        
        
        
        [self creatTableViewHeaderView];
        
        self.data_M_A = [_upSort_data_dic[@"stores"] mutableCopy];
        
        [self.table_view reloadData];
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self hintLoadingView];

        NSLog(@"getData_UPSort---%@",error);
    }];

    
}
//下拉加载数据
-(void)UPSort_dropLoad{
    //    [self showHudInView:self.view hint:@"加载中..."];;

    NSString *url = [NSString stringWithFormat:@"%@UserType/UPSort/dropLoad",BASEURL];
    
    
    AppDelegate*app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSMutableDictionary*paramer = [NSMutableDictionary dictionary];
    [paramer setValue:_icon_dic[@"id"] forKey:@"up_id"];
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
    
    [paramer setValue:[NSString stringWithFormat:@"%ld",++_page] forKey:@"index"];
    NSLog(@"dropLoad==%@",paramer);
    
    
    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        [_refreshFooter endRefreshing];

        [self hideHud];
        
        [self.data_M_A addObjectsFromArray:result[@"stores"]];
        
       
   
        
        
        
        [self.table_view reloadData];
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_refreshFooter endRefreshing];

        [self hideHud];
        
    }];

    
}

- (IBAction)goSearchClcik:(id)sender {
    NSLog(@"搜索");
    PUSH(CustomSearchVC)
}
- (IBAction)screenClcick:(id)sender {
    NSLog(@"筛选");
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect fram = _back_scressn_view.frame;
        fram.origin.x = 0;
        _back_scressn_view.frame = fram;
        
    }];
    
}

-(NSMutableArray *)mid_advert_img{
    if (!_mid_advert_img) {
        _mid_advert_img = [NSMutableArray array];
    }
    return _mid_advert_img;
}

-(NSMutableArray *)dataSourceCityArray{
    if (!_dataSourceCityArray) {
        _dataSourceCityArray = [NSMutableArray array];
    }
    return _dataSourceCityArray;
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
-(NSDictionary *)upSort_data_dic{
    if (!_upSort_data_dic) {
        _upSort_data_dic = [NSDictionary dictionary];
    }
    return _upSort_data_dic;
}

@end
