//
//  BaiduMapManager.h
//  BletcShop
//
//  Created by Bletc on 2017/7/31.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Search/BMKGeocodeSearch.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>

@interface BaiduMapManager : NSObject


@property (nonatomic,copy) void(^userLocationBlock)(BMKUserLocation*location);// 用户位置信息,经纬度

@property (nonatomic,copy)void (^userAddressBlock)(BMKReverseGeoCodeResult*result);// 反地理编码位置信息


+(BaiduMapManager*)shareBaiduMapManager;


-(void)startUserLocationService;

@end
