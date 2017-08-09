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
@interface OilMapVC ()
{
    UIView *topViw;
    NSArray *locationArr;
    BOOL onlyOnce;
    CLLocationCoordinate2D userLoc;
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
    
    locationArr=@[@{@"latitude":@"34.239566",@"lontitude":@"108.873341"},@{@"latitude":@"34.250927",@"lontitude":@"108.862463"},@{@"latitude":@"34.251389",@"lontitude":@"108.868668"},@{@"latitude":@"34.239566",@"lontitude":@"108.873341"},@{@"latitude":@"34.21073",@"lontitude":@"108.896078"},@{@"latitude":@"34.265357",@"lontitude":@"108.877525"},@{@"latitude":@"34.243865",@"lontitude":@"108.841901"}];
    
    
    
    
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
    }
    //启动LocationService
    
    return _locService;
}
//实现相关delegate 处理位置信息更新
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
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
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillAppear:animated];
    onlyOnce=YES;
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil; // 不用时，置nil
}
- (void)viewDidAppear:(BOOL)animated {
    if (onlyOnce==NO) {
        for (int i=0; i<locationArr.count; i++) {
            NSLog(@"latitude = %@,longitude = %@",[NSString stringWithFormat:@"%.2f",_latitude],[NSString stringWithFormat:@"%.2f",_longitude]);
            BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
            CLLocationCoordinate2D coor; // 定义模型经纬度
            coor.latitude = [locationArr[i][@"latitude"] floatValue];//[NSString stringWithFormat:@"%@",@"34.239566"];
            _latitude=[locationArr[i][@"latitude"] floatValue];
            coor.longitude =[locationArr[i][@"lontitude"] floatValue];
            _longitude=[locationArr[i][@"lontitude"] floatValue];
            annotation.coordinate = coor;
            //annotation.title = @"这里是北京";
            [_mapView addAnnotation:annotation];
        }

    }
    // 添加一个PointAnnotation模型
    
}
//  Override每当添加一个大头针就会调用这个方法(对大头针没有进行封装)
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation {

    // 这里的BMKAnnotationView 就相当于是UITableViewCell一样 其实就是一个View我们也是通过复用的样子一样进行使用。 而传进来的annotation 就是一个模型，它里面装的全都是数据！
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        // 如果大头针类型 是我们自定义的百度的 而且是后加的大头针模型类 的话 才执行
        static NSString *const ID = @"myAnnotation";
        BMKPinAnnotationView *newAnnotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:ID];
        CLLocationCoordinate2D coor2 = {_latitude, _longitude};
        annotation.coordinate = coor2;
        if (newAnnotationView == nil) {
            newAnnotationView =  [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:ID];
        }
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.animatesDrop = YES; // 设置该标注点动画显示
        newAnnotationView.image = [UIImage imageNamed:@"油站图标"];
        return newAnnotationView;
    }
    // 这里是说定位自己本身的那个大头针模型 返回nil 自动就变成蓝色点点
    return nil;
}
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
    if ([view.annotation isKindOfClass:[BMKPinAnnotationView class]]) {
        
       
        
    }
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
