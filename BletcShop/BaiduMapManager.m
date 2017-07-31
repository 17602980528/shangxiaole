//
//  BaiduMapManager.m
//  BletcShop
//
//  Created by Bletc on 2017/7/31.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "BaiduMapManager.h"


@interface BaiduMapManager ()<BMKGeoCodeSearchDelegate,BMKLocationServiceDelegate>
@property(nonatomic,strong)BMKGeoCodeSearch *geocodesearch;
@property(nonatomic,strong)BMKLocationService *locService;


@end



@implementation BaiduMapManager



-(instancetype)init{
    
    self.geocodesearch = [[BMKGeoCodeSearch alloc]init];
    _geocodesearch.delegate = self;
    self.locService  = [[BMKLocationService alloc]init];
    _locService.delegate = self;


    return self;
}
+(BaiduMapManager*)shareBaiduMapManager
{

    static BaiduMapManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[BaiduMapManager alloc]init];
        
        
    });
    
    return manager;
}

-(void)startUserLocationService;
{
    self.locService.delegate = self;
    self.geocodesearch.delegate = self;
    [self.locService startUserLocationService];
    
}



-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    
    
    self.userLocationBlock(userLocation);
    
    
    BMKReverseGeoCodeOption *option = [[BMKReverseGeoCodeOption alloc] init];

    option.reverseGeoPoint = CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
    NSLog(@"didUpdateBMKUserLocation=%f - %f", option.reverseGeoPoint.latitude, option.reverseGeoPoint.longitude);

    
    
    [self.geocodesearch reverseGeoCode:option];
    
    
    
    NSLog(@"reverseGeoCode=====%d",[self.geocodesearch reverseGeoCode:option]);
    
    
   
   [self.locService stopUserLocationService];

    
    
    
    
}




- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    
    NSLog(@"onGetReverseGeoCodeResult=====%@=%d",result,error);
    
    if (result) {
        
        self.userAddressBlock(result);
        

    }else{

    
        
    }
}


@end
