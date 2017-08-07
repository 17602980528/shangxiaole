//
//  OilMapVC.m
//  BletcShop
//
//  Created by apple on 2017/8/7.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "OilMapVC.h"

@interface OilMapVC ()
{
    UIView *topViw;
}
@end

@implementation OilMapVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self locService];
    CLLocationCoordinate2D loc = {_latitude, _longitude};
   // [self.mapView showsUserLocation];
    // 显示地图
    [self.view addSubview:self.mapView];
    [self.mapView setCenterCoordinate:loc];//地图拉回到坐标所在位置
    
    
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
        _locService.delegate = self;
        _locService.distanceFilter = 200.f;
        [_locService setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
        // 后台也定位 并且屏幕上方有蓝条提示
        //_locService.allowsBackgroundLocationUpdates = YES;
        //启动LocationService
        [_locService startUserLocationService];
    }
    return _locService;
}
//实现相关delegate 处理位置信息更新
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    // 1.显示用户位置
    self.mapView.showsUserLocation = YES;
    // 2.更新用户最新位置到地图上
    [self.mapView updateLocationData:userLocation];
    
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    appdelegate.userLocation = userLocation;
    // 3.设置中心 为 用户位置
    CLLocationCoordinate2D loc = {_latitude, _longitude};
    CLLocationCoordinate2D center = loc;
    CLLocationDegrees latitude = 0.0;
    CLLocationDegrees longitude = 0.09;
    // 4.设置跨度 数值越小 越精确
    BMKCoordinateSpan span = BMKCoordinateSpanMake(latitude, longitude);
    // 5.设置区域 中心店 和 范围跨度
    BMKCoordinateRegion region = BMKCoordinateRegionMake(center, span);
    
    // 设置地图显示区域范围
    [self.mapView setRegion:region animated:YES];
    [self.mapView setZoomLevel:17];
}
#pragma mark - 地图功能-------------------------------------------
- (BMKMapView *)mapView {
    if (_mapView == nil) {
        _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64)];
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
    
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil; // 不用时，置nil
}
- (void)viewDidAppear:(BOOL)animated {
    // 添加一个PointAnnotation模型
    NSLog(@"latitude = %@,longitude = %@",[NSString stringWithFormat:@"%.2f",_latitude],[NSString stringWithFormat:@"%.2f",_longitude]);
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    CLLocationCoordinate2D coor; // 定义模型经纬度
    coor.latitude = self.latitude;
    coor.longitude = self.longitude;
    annotation.coordinate = coor;
    //annotation.title = @"这里是北京";
    [_mapView addAnnotation:annotation];
    
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
        newAnnotationView.image = [UIImage imageNamed:@"location"];
        return newAnnotationView;
    }
    // 这里是说定位自己本身的那个大头针模型 返回nil 自动就变成蓝色点点
    return nil;
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
