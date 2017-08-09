//
//  OilMapVC.m
//  BletcShop
//
//  Created by apple on 2017/8/7.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "OilMapVC.h"
#import "OilHomeListVC.h"//加油点列表
#import "OneKeyOilVC.h"//一键加油
#import "BuyOilCardVC.h"
#import "BuyOilCardVC.h"
#import "EricAnnotition.h"
#import "BaiduMapManager.h"
@interface OilMapVC ()<BMKMapViewDelegate>
{
    UIView *topViw;
    NSArray *locationArr;
    BOOL onlyOnce;
    CLLocationCoordinate2D userLoc;
    UIScrollView *_scrollView;
}
@end

@implementation OilMapVC
//加油点列表
-(void)goOilShopList{
    OilHomeListVC *oilHomeListVC=[[OilHomeListVC alloc]init];
    [self.navigationController pushViewController:oilHomeListVC animated:YES];
}
-(void)oneKeyOilBtnClicks:(UITapGestureRecognizer *)tap{
    OneKeyOilVC *vc=[[OneKeyOilVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)buyOilCardsBtnClick:(UITapGestureRecognizer *)tap{
    BuyOilCardVC *vc=[[BuyOilCardVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)mapRelationBtnClick:(UIButton *)sender{
    switch (sender.tag) {
        case 0:
        {
            [self.mapView setCenterCoordinate:userLoc];
            [self.mapView setZoomLevel:15];
        }
            break;
        case 1:
        {
            [self.mapView setZoomLevel:18];
        }
            break;
        case 2:
        {
            [self locService];
        }
            break;
        case 3:
        {
            [self.mapView setZoomLevel:13];
        }
            break;
            
        default:
            break;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"常用油品";
    LEFTBACK
    onlyOnce=NO;
    
    UIButton *rightItemButoon=[UIButton buttonWithType:UIButtonTypeCustom];
    rightItemButoon.frame=CGRectMake(0, 0, 20, 20);
    [rightItemButoon setImage:[UIImage imageNamed:@"陈列 icon"] forState:UIControlStateNormal];
    
    [rightItemButoon addTarget:self action:@selector(goOilShopList) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightItemButoon];
    
    locationArr=@[@{@"latitude":@"34.239566",@"lontitude":@"108.873341",@"shop":@"中国石化（聚家花园东北）",@"image":@"oil0.jpg",@"address":@"天台路与与天台一路交汇向北60m"},@{@"latitude":@"34.250927",@"lontitude":@"108.862463",@"shop":@"中国石化（西三环一站）",@"image":@"oil1.jpg",@"address":@"二环路沿线商业经济带大庆路136号"},@{@"latitude":@"34.251389",@"lontitude":@"108.868668",@"shop":@"中国石化（红光路）",@"image":@"oil2.jpg",@"address":@"莲湖区大庆路120号付60号"},@{@"latitude":@"34.239566",@"lontitude":@"108.873341",@"shop":@"中国石化（宏宝加油站）",@"image":@"oil3.jpg",@"address":@"陕西省西安市莲湖区大兴东路73号"},@{@"latitude":@"34.21073",@"lontitude":@"108.896078",@"shop":@"中国石化（恒瑞加油站）",@"image":@"oil4.jpg",@"address":@"陕西省西安市莲湖区大兴东路"},@{@"latitude":@"34.265357",@"lontitude":@"108.877525",@"shop":@"中国石化（枣园西路店）",@"image":@"oil5.jpg",@"address":@"西二环北段59号附近"},@{@"latitude":@"34.243865",@"lontitude":@"108.841901",@"shop":@"中国石化（枣园北路店）",@"image":@"oil6.jpg",@"address":@"新荣粮油配送南"}];
    
    
    
    
    [self locService];
    
   // [self.mapView showsUserLocation];
    // 显示地图
    [self.view addSubview:self.mapView];
    //地图拉回到坐标所在位置
    
    
    topViw=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 50)];
    topViw.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:topViw];
    
    NSArray *oilKind=@[@"95#",@"92#",@"柴油"];
    
    for (int i=0; i<3; i++) {
        UIButton *oilKindButton=[UIButton buttonWithType:UIButtonTypeCustom];
        oilKindButton.tag=i;
        oilKindButton.frame=CGRectMake((SCREENWIDTH-300)/4+i%3*(100+(SCREENWIDTH-300)/4), 11, 100, 28);
        oilKindButton.titleLabel.font=[UIFont systemFontOfSize:14.0f];
        oilKindButton.layer.cornerRadius=14.0f;
        oilKindButton.clipsToBounds=YES;
        [oilKindButton setTitle:oilKind[i] forState:UIControlStateNormal];
        if (i==0) {
             [oilKindButton setBackgroundColor:RGB(192, 192, 192)];
            [oilKindButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else{
            [oilKindButton setBackgroundColor:[UIColor whiteColor]];
            [oilKindButton setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
        }
       
        [topViw addSubview:oilKindButton];
        [oilKindButton addTarget:self action:@selector(chooseOilKindBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    //一键加油
    UIView *oneKeyOil=[[UIView alloc ]initWithFrame:CGRectMake(SCREENWIDTH/2-156, SCREENHEIGHT-64-54, 136, 44)];
    oneKeyOil.backgroundColor=RGB(243, 73, 78);
    oneKeyOil.layer.cornerRadius=22.0f;
    oneKeyOil.clipsToBounds=YES;
    [self.view addSubview:oneKeyOil];
    
    UIImageView *letfImage=[[UIImageView alloc]initWithFrame:CGRectMake(25, 12, 20, 20)];
    letfImage.image=[UIImage imageNamed:@"一件加油icon"];
    letfImage.userInteractionEnabled=YES;
    [oneKeyOil addSubview:letfImage];
    
    UILabel *leftLab=[[UILabel alloc]initWithFrame:CGRectMake(letfImage.right+10, 15, oneKeyOil.width-letfImage.right-10, 14) ];
    leftLab.font=[UIFont systemFontOfSize:14];
    leftLab.text=@"一键加油";
    leftLab.userInteractionEnabled=YES;
    leftLab.textColor=[UIColor whiteColor];
    [oneKeyOil addSubview:leftLab];
    
    UITapGestureRecognizer *tap1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(oneKeyOilBtnClicks:)];
    
    [oneKeyOil addGestureRecognizer:tap1];
    
    
    //购买加油卡
    UIView *buyOilCard=[[UIView alloc ]initWithFrame:CGRectMake(SCREENWIDTH/2+20, SCREENHEIGHT-64-54, 136, 44)];
    buyOilCard.backgroundColor=RGB(243, 73, 78);
    buyOilCard.layer.cornerRadius=22.0f;
    buyOilCard.clipsToBounds=YES;
    [self.view addSubview:buyOilCard];
    
    UIImageView *rightImage=[[UIImageView alloc]initWithFrame:CGRectMake(18, 12, 20, 20)];
    rightImage.image=[UIImage imageNamed:@"购买加油卡icon"];
    rightImage.userInteractionEnabled=YES;
    [buyOilCard addSubview:rightImage];
    
    UILabel *rightLab=[[UILabel alloc]initWithFrame:CGRectMake(rightImage.right+10, 15, buyOilCard.width-rightImage.right-10, 14) ];
    rightLab.userInteractionEnabled=YES;
    rightLab.font=[UIFont systemFontOfSize:14];
    rightLab.text=@"购买加油卡";
    rightLab.textColor=[UIColor whiteColor];
    [buyOilCard addSubview:rightLab];
    
    
    UITapGestureRecognizer *tap2=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(buyOilCardsBtnClick:)];
    [buyOilCard addGestureRecognizer:tap2];
    
    
    NSArray *mapRelationImage=@[@"刷新",@"放大A",@"位置矫正",@"缩小"];
    
    for (int i=0; i<4; i++) {
        UIButton *mapRelationButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [mapRelationButton setImage:[UIImage imageNamed:mapRelationImage[i]] forState:UIControlStateNormal];
        mapRelationButton.frame=CGRectMake(13+i%2*(SCREENWIDTH-82+28),oneKeyOil.top-92+i/2*(28+15), 28, 28);
        mapRelationButton.tag=i;
        [self.view addSubview:mapRelationButton];
        [mapRelationButton addTarget:self action:@selector(mapRelationBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
   
   
}
-(void)creatShopDetailView{
    //屏幕弹出部分
    UIWindow *window =[UIApplication sharedApplication].keyWindow;
    _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    _scrollView.backgroundColor=[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:0.2];
    _scrollView.pagingEnabled=YES;
    _scrollView.showsVerticalScrollIndicator=NO;
    _scrollView.showsHorizontalScrollIndicator=NO;
    _scrollView.contentSize=CGSizeMake(SCREENWIDTH*locationArr.count, SCREENHEIGHT);
    _scrollView.hidden=YES;
    [window addSubview:_scrollView];
    
    UITapGestureRecognizer *scrTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scrTapClick:)];
    [_scrollView addGestureRecognizer:scrTap];
    
    
    for (int i=0; i<locationArr.count; i++) {
        UIView *whiteView=[[UIView alloc]initWithFrame:CGRectMake(25+i*SCREENWIDTH, 106, SCREENWIDTH-50, 422)];
        whiteView.tag=i;
        whiteView.backgroundColor=[UIColor whiteColor];
        whiteView.layer.cornerRadius=12.0f;
        whiteView.clipsToBounds=YES;
        [_scrollView addSubview:whiteView];
        
        UILabel *shopName=[[UILabel alloc]initWithFrame:CGRectMake(16, 0, whiteView.width-16, 44)];
        shopName.text=locationArr[i][@"shop"];
        shopName.font=[UIFont systemFontOfSize:15];
        shopName.textColor=RGB(51, 51, 51);
        [whiteView addSubview:shopName];
        
        UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, shopName.bottom, whiteView.width, 1)];
        line.backgroundColor=RGB(192, 192, 192);
        [whiteView addSubview:line];
        
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, line.bottom, whiteView.width, 270)];
        imageView.image=[UIImage imageNamed:locationArr[i][@"image"]];
        [whiteView addSubview:imageView];
        
        UIView *addressView=[[UIView alloc]initWithFrame:CGRectMake(0, imageView.bottom-44, imageView.width, 44)];
        addressView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.749];
        [whiteView addSubview:addressView];
        
        UIImageView *addtip=[[UIImageView alloc]initWithFrame:CGRectMake(16, 15, 14, 14)];
        addtip.image=[UIImage imageNamed:@"定位icon"];
        [addressView addSubview:addtip];
        
        UILabel *addtressLable=[[UILabel alloc]initWithFrame:CGRectMake(38, 0, addressView.width-38, 44)];
        addtressLable.font=[UIFont systemFontOfSize:13];
        addtressLable.textColor=[UIColor whiteColor];
        addtressLable.text=locationArr[i][@"address"];
        [addressView addSubview:addtressLable];
        
        NSArray *oilKindArr=@[@"95#",@"92#",@"柴油"];
        NSArray *oilPriceArr=@[@"6.24元／升",@"5.90元／升",@"5.50元／升"];
        for (int j=0; j<3; j++) {
            UILabel *oilKind=[[UILabel alloc]initWithFrame:CGRectMake(j*addressView.width/3, addressView.bottom, SCREENWIDTH/3, 32)];
            oilKind.textColor=RGB(51, 51, 51);
            oilKind.textAlignment=NSTextAlignmentCenter;
            oilKind.font=[UIFont systemFontOfSize:14];
            oilKind.text=oilKindArr[j];
            [whiteView addSubview:oilKind];
            
            UILabel *oilPriceLable=[[UILabel alloc]initWithFrame:CGRectMake(j*addressView.width/3, oilKind.bottom, SCREENWIDTH/3, 32)];
            oilPriceLable.font=[UIFont systemFontOfSize:14];
            oilPriceLable.text=oilPriceArr[j];
            oilPriceLable.textAlignment=NSTextAlignmentCenter;
            oilPriceLable.textColor=RGB(51, 51, 51);
            [whiteView addSubview:oilPriceLable];
        }
        UIView *line2=[[UIView alloc]initWithFrame:CGRectMake(0,whiteView.height-45 ,whiteView.width , 1)];
        line2.backgroundColor=RGB(192, 192, 192);
        [whiteView addSubview:line2];
        NSArray *buttonTitle=@[@"更换加油站",@"直接加油"];
        for (int k=0; k<2; k++) {
            UIButton *otherButton=[UIButton buttonWithType:UIButtonTypeCustom];
            otherButton.frame=CGRectMake(1+k*((whiteView.width-3)/2+1), line2.bottom, (whiteView.width-3)/2, 43);
            otherButton.titleLabel.font=[UIFont systemFontOfSize:14];
            [otherButton setTitle:buttonTitle[k] forState:UIControlStateNormal];
            if (k==0) {
                [otherButton setTitleColor:RGB(143, 143, 143) forState:UIControlStateNormal];
                UIView *seperateLine=[[UIView alloc]initWithFrame:CGRectMake(otherButton.right, line2.bottom, 1, 43)];
                seperateLine.backgroundColor=RGB(192, 192, 192);
                [whiteView addSubview:seperateLine];
            }else{
                [otherButton setTitleColor:RGB(243, 73, 78) forState:UIControlStateNormal];
            }
            otherButton.tag=k;
            [otherButton addTarget:self action:@selector(otherBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [whiteView addSubview:otherButton];
        }
    }
    
    //屏幕弹出部分
}
-(void)otherBtnClick:(UIButton *)sender{
    switch (sender.tag) {
        case 0:
        {
            //
            UIView *superView=[sender superview];
            if (superView.tag==locationArr.count-1) {
                [_scrollView setContentOffset:CGPointMake(0, 0)];
            }else{
                [_scrollView setContentOffset:CGPointMake((superView.tag+1)*SCREENWIDTH, 0)];
            }
            
        }
            break;
        case 1:
        {
            //
            _scrollView.hidden=YES;
            OneKeyOilVC *vc=[[OneKeyOilVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}
//_scollview
-(void)scrTapClick:(UITapGestureRecognizer *)tap{
    _scrollView.hidden=YES;
    [_scrollView setContentOffset:CGPointMake(0, 0)];
}
//
-(void)chooseOilKindBtnClick:(UIButton *)sender{
    for (UIButton *button in topViw.subviews) {
        if (button.tag==sender.tag) {
            button.backgroundColor=RGB(192, 192, 192);
            [button setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
        }else{
            button.backgroundColor=RGB(255, 255, 255);
            [button setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
        }
    }
}

- (BMKLocationService *)locService {
    if (_locService == nil) {
        _locService = [[BMKLocationService alloc]init];
        _locService.distanceFilter = 200.f;
        _locService.delegate = self;
        [_locService setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
        [_locService startUserLocationService];
        // 后台也定位 并且屏幕上方有蓝条提示
        //_locService.allowsBackgroundLocationUpdates = YES;
    }else{
        
        BaiduMapManager *manager = [BaiduMapManager shareBaiduMapManager];
        
        [manager startUserLocationService];
        
        manager.userLocationBlock = ^(BMKUserLocation *location) {
          
            [self didUpdateBMKUserLocation:location];
            
            
        };
        
//        [_locService startUserLocationService];
    }
    //启动LocationService
    NSLog(@"_locService==================%@",_locService);
    return _locService;
}
//实现相关delegate 处理位置信息更新
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    
    NSLog(@"userLocation=============%@",userLocation);

    
    CLLocationCoordinate2D locss = {userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude};
    userLoc=locss;
    [self.mapView setCenterCoordinate:locss];
    // 1.显示用户位置
    self.mapView.showsUserLocation = YES;//34.239566//108.873341//34.24356//108.874781//34.243414//108.875266// latitude = "34.239771";
    //longtitude = "108.876793";
    // 2.更新用户最新位置到地图上
    [self.mapView updateLocationData:userLocation];
    
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    appdelegate.userLocation = userLocation;
    // 3.设置中心 为 用户位置
    //CLLocationCoordinate2D loc = {_latitude, _longitude};
    CLLocationCoordinate2D center = locss;
    CLLocationDegrees latitude = 0.0;
    CLLocationDegrees longitude = 0.09;
    // 4.设置跨度 数值越小 越精确
    BMKCoordinateSpan span = BMKCoordinateSpanMake(latitude, longitude);
    // 5.设置区域 中心店 和 范围跨度
    BMKCoordinateRegion region = BMKCoordinateRegionMake(center, span);
    
    // 设置地图显示区域范围
    [self.mapView setRegion:region animated:YES];
    [self.mapView setZoomLevel:15];
}
#pragma mark - 地图功能-------------------------------------------
- (BMKMapView *)mapView {
    if (_mapView == nil) {
        _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64)];
        _mapView.userTrackingMode=BMKUserTrackingModeFollowWithHeading;
    }
    return _mapView;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.mapView viewWillAppear];
    self.mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    self.mapView.userInteractionEnabled=YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    _scrollView.hidden=YES;
    [_scrollView removeFromSuperview];
    [super viewWillAppear:animated];
    onlyOnce=YES;
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil; // 不用时，置nil
}
- (void)viewDidAppear:(BOOL)animated {
    if (onlyOnce==NO) {
        for (int i=0; i<locationArr.count; i++) {
            NSLog(@"latitude = %@,longitude = %@",[NSString stringWithFormat:@"%.2f",_latitude],[NSString stringWithFormat:@"%.2f",_longitude]);
            EricAnnotition* annotation = [[EricAnnotition alloc]init];
            CLLocationCoordinate2D coor; // 定义模型经纬度
            coor.latitude = [locationArr[i][@"latitude"] floatValue];//[NSString stringWithFormat:@"%@",@"34.239566"];
            _latitude=[locationArr[i][@"latitude"] floatValue];
            coor.longitude =[locationArr[i][@"lontitude"] floatValue];
            _longitude=[locationArr[i][@"lontitude"] floatValue];
            annotation.coordinate = coor;
            annotation.identify=i;
            //annotation.title = @"这里是北京";
            [_mapView addAnnotation:annotation];
        }

    }
    
     [self creatShopDetailView];
    
}
//  Override每当添加一个大头针就会调用这个方法(对大头针没有进行封装)
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation {

    // 这里的BMKAnnotationView 就相当于是UITableViewCell一样 其实就是一个View我们也是通过复用的样子一样进行使用。 而传进来的annotation 就是一个模型，它里面装的全都是数据！
    if ([annotation isKindOfClass:[EricAnnotition class]]) {
        // 如果大头针类型 是我们自定义的百度的 而且是后加的大头针模型类 的话 才执行
        static NSString *const ID = @"myAnnotation";
        BMKPinAnnotationView *newAnnotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:ID];
        CLLocationCoordinate2D coor2 = {_latitude, _longitude};
        annotation.coordinate = coor2;
        if (newAnnotationView == nil) {
            newAnnotationView =  [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:ID];
        }
        newAnnotationView.userInteractionEnabled=YES;
        newAnnotationView.enabled=YES;
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        //newAnnotationView.animatesDrop = YES; // 设置该标注点动画显示
        newAnnotationView.image = [UIImage imageNamed:@"油站图标"];
        
        
        EricAnnotition *annotition=annotation;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(0, 0,newAnnotationView.image.size.width, newAnnotationView.image.size.height);
        btn.tag=annotition.identify;
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [newAnnotationView addSubview:btn];
        
        return newAnnotationView;
    }
    // 这里是说定位自己本身的那个大头针模型 返回nil 自动就变成蓝色点点
    return nil;
}
//点击你的location时调用
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
    NSLog(@"123456789");
    if ([view.annotation isKindOfClass:[EricAnnotition class]]) {
        
        EricAnnotition *annotition=view.annotation;
        NSLog(@"%ld",(long)annotition.identify);
        
        
    }
}
//点大头时调用
-(void)btnAction:(UIButton *)sender{
    NSLog(@"%ld",sender.tag);
    [_scrollView setContentOffset:CGPointMake(sender.tag*SCREENWIDTH, 0)];
//    _scrollView.frame=CGRectMake((SCREENWIDTH-50)/2, (SCREENHEIGHT-50)/2, 50, 50);
    _scrollView.hidden=NO;
//    [UIView animateWithDuration:0.5 animations:^{
//        _scrollView.frame=CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
//    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
