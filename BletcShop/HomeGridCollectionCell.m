//
//  HomeGridCollectionCell.m
//  BletcShop
//
//  Created by Bletc on 2017/8/18.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "HomeGridCollectionCell.h"
#import "XHStarRateView.h"
#import "UIImageView+WebCache.h"
@interface HomeGridCollectionCell ()
@property (weak, nonatomic) IBOutlet UIImageView *advertImg;
@property (weak, nonatomic) IBOutlet UIImageView *shopImg;
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UILabel *distancelab;
@property (weak, nonatomic) IBOutlet UILabel *zheLab;
@property (weak, nonatomic) IBOutlet UILabel *quanLab;
@property (weak, nonatomic) IBOutlet UILabel *zenglab;
@property (weak, nonatomic) IBOutlet UILabel *baolab;
@property (weak, nonatomic) IBOutlet UIView *starView;
@property (weak, nonatomic) IBOutlet UILabel *soldCountLab;
@property(weak ,nonatomic) XHStarRateView *star_v;
@property (weak, nonatomic) IBOutlet UILabel *trade_lab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *quan_left;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *zeng_left;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bao_left;


@end
@implementation HomeGridCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];

    XHStarRateView *star_View = [[XHStarRateView alloc]initWithFrame:CGRectMake(0, 0, 65, 13)];
    star_View.userInteractionEnabled = NO;
    star_View.currentScore = 3;
    star_View.rateStyle = IncompleteStar;
    [self.starView addSubview:star_View];
    
    self.star_v = star_View;


}

-(void)setModel:(HomeShopModel *)model{
    
    _model = model;
    
    [self.shopImg sd_setImageWithURL:[NSURL URLWithString:self.model.img_url] placeholderImage:[UIImage imageNamed:@"icon3.png"]];
    self.shopName.text = _model.title_S;
    
    self.soldCountLab.text = [NSString stringWithFormat:@"已售%@笔",_model.soldCount];
    
    self.star_v.currentScore = [_model.stars floatValue];
    
    
    self.trade_lab.text = [NSString stringWithFormat:@"%@   ",_model.trade];
    if ([_model.pri[@"discount"] boolValue]) {
        self.zheLab.text = @"折 ";
        
    }else{
        self.zheLab.text = @"";
        
    }
    
    if ([_model.pri[@"coupon"] boolValue]) {
        self.quanLab.text = @"券 ";
        self.quan_left.constant = 13;
        
    }else{
        self.quanLab.text = @"";
        self.quan_left.constant = 0;
        
    }
    
    if ([_model.pri[@"add"] boolValue]) {
        self.zenglab.text = @"赠 ";
        self.zeng_left.constant = 13;
    }else{
        self.zenglab.text = @"";
        self.zeng_left.constant = 0;
        
    }
    
    if ([_model.pri[@"insure"] boolValue]) {
        self.baolab.text = @"保 ";
        
    }else{
        self.baolab.text = @"";
        
    }
    
    
    
    
    CGFloat meter = [self.model.distance floatValue];
    
    if (meter>1000) {
        self.distancelab.text = [[NSString alloc]initWithFormat:@"距离%.1fkm",meter/1000.0];
    }else
        self.distancelab.text = [[NSString alloc]initWithFormat:@"距离%.1fm",meter];
    if (_model.remark.length>0) {
        [self.advertImg sd_setImageWithURL:[NSURL URLWithString:model.long_img_url] placeholderImage:[UIImage imageNamed:@"icon3"]];
        self.advertImg.hidden = NO;
        
    }else{
        self.advertImg.hidden = YES;
    }
    
    
}



@end
