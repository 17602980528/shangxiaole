//
//  HomeShopModel.m
//  BletcShop
//
//  Created by Bletc on 2016/11/4.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "HomeShopModel.h"
#import "HomeViewCell.h"
@implementation HomeShopModel


-(CGFloat)cellHight{
    
    
    HomeViewCell *cell = [[HomeViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    _cellHight = [cell cellHeightWithModel:self];
    
    return _cellHight;
}

-(HomeShopModel*)initWithDictionary:(NSDictionary*)dic;
{
    //长条广告
    self.long_img_url = [NSString stringWithFormat:@"%@%@",LONGADVERTIMAGE,[NSString getTheNoNullStr:dic[@"image_url"] andRepalceStr:@""]];
    
    self.muid =[NSString getTheNoNullStr:dic[@"muid"] andRepalceStr:@""];
    
    self.img_url = [NSString stringWithFormat:@"%@%@",SHOPIMAGE_ADDIMAGE,dic[@"image_url"]];
    
    self.title_S =[NSString getTheNoNullStr:dic[@"store"] andRepalceStr:@""];
    self.subTitl = [NSString getTheNoNullStr:dic[@"discount"] andRepalceStr:@""];
    self.addTitl = [NSString getTheNoNullStr:dic[@"add"] andRepalceStr:@""];
    
    self.video = [NSString getTheNoNullStr:dic[@"video"] andRepalceStr:@""];
    self.soldCount = [NSString getTheNoNullStr:dic[@"sold"] andRepalceStr:@"0"];
    
    self.longtitude =[NSString getTheNoNullStr:dic[@"longtitude"] andRepalceStr:@""];
    
    self.latitude =[NSString getTheNoNullStr:dic[@"latitude"] andRepalceStr:@""];
    self.stars =[NSString getTheNoNullStr:dic[@"stars"] andRepalceStr:@"0"];
    self.coupon_exists= [NSString getTheNoNullStr:dic[@"coupon"] andRepalceStr:@""];
    self.trade=[NSString getTheNoNullStr:dic[@"trade"] andRepalceStr:@""];
    
    self.distance =[NSString getTheNoNullStr:dic[@"distance"] andRepalceStr:@""];
    
    self.pri = dic[@"pri"];
    return self;
}

@end
