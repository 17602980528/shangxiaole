//
//  NewShopCardListCell.m
//  BletcShop
//
//  Created by Bletc on 2017/5/12.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "NewShopCardListCell.h"

@implementation NewShopCardListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = RGB(240,240,240);
        [self initSubviews];
    }
    return self;
}
-(void)initSubviews{
   
    UIImageView *back_view = [[UIImageView alloc]initWithFrame:CGRectMake(13, 0, SCREENWIDTH-26, 90)];
    [self addSubview:back_view];
    self.back_view = back_view;
    
    
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(6, 8, 131, 74)];
    imageView.layer.cornerRadius = 6;
    imageView.layer.masksToBounds = YES;
    imageView.layer.borderWidth = 1;
    imageView.layer.borderColor = RGB(49,43,43).CGColor;
    
    self.cardImg = imageView;
    [back_view addSubview:imageView];
    
    UIView *bot_view = [[UIView alloc]initWithFrame:CGRectMake(0, 74-25, imageView.width, 25)];
    bot_view.backgroundColor = [UIColor whiteColor];
    [imageView addSubview:bot_view];
    
    UILabel *vipLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 25, imageView.width, 13)];
    vipLab.textAlignment = NSTextAlignmentCenter;
    vipLab.textColor = [UIColor whiteColor];
    [imageView addSubview:vipLab];
    self.vipLab = vipLab;
    
    UILabel *content_lab = [[UILabel alloc]init];
    self.content_lab = content_lab;

    content_lab.font = [UIFont systemFontOfSize:13];
    content_lab.numberOfLines =1;
    content_lab.textColor = RGB(51,51,51);
    
    content_lab.frame = CGRectMake(imageView.right+8, 19, back_view.width-(imageView.right+8)-87, 14);
    [back_view addSubview:content_lab];
    
    
    UILabel *cardPriceLable=[[UILabel alloc]initWithFrame:CGRectMake(back_view.width-87, content_lab.top, 50, 14)];
    cardPriceLable.textAlignment=NSTextAlignmentLeft;
    cardPriceLable.font=[UIFont systemFontOfSize:14.0f];
    cardPriceLable.textColor=RGB(253,108,110);
    [back_view addSubview:cardPriceLable];
    
    self.cardPriceLable = cardPriceLable;
    
    UILabel *shulabView = [[UILabel alloc]initWithFrame:CGRectMake(back_view.width-43, 13, 2, back_view.height-26)];
    shulabView.textColor = RGB(210,210,210);
    shulabView.text = @"|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n";
    shulabView.numberOfLines = 0;
    shulabView.font = [UIFont systemFontOfSize:5];
    [back_view addSubview:shulabView];
    
    UILabel *discountLable=[[UILabel alloc]initWithFrame:CGRectMake(content_lab.left, content_lab.bottom+22, 35, 14)];
    discountLable.font=[UIFont systemFontOfSize:12.0f];
    discountLable.textColor=[UIColor whiteColor];
    discountLable.backgroundColor = RGB(253,108,110);
    discountLable.layer.cornerRadius = 3;
    discountLable.layer.masksToBounds = YES;
    discountLable.textAlignment=NSTextAlignmentCenter;
    [back_view addSubview:discountLable];
    self.discountLable = discountLable;
    
    
    UILabel *timeLable=[[UILabel alloc]initWithFrame:CGRectMake(discountLable.right-5, discountLable.top, SCREENWIDTH-(imageView.right+10+50), discountLable.height)];
    timeLable.font=[UIFont systemFontOfSize:12.0f];
    timeLable.textColor=RGB(61,61,61);
    timeLable.textAlignment =NSTextAlignmentLeft;
    [back_view addSubview:timeLable];
    
    self.timeLable = timeLable;
    
    
    
    UILabel  *buyLab = [[UILabel alloc]init];
    buyLab.text = @"购买";
    buyLab.layer.borderColor = RGB(243,73,78).CGColor;
    buyLab.layer.borderWidth = 1;
    buyLab.textColor = RGB(243,73,78);
    buyLab.layer.cornerRadius = 6;
    buyLab.layer.masksToBounds = YES;
    buyLab.textAlignment = NSTextAlignmentCenter;
    buyLab.font = [UIFont systemFontOfSize:13];
    [back_view addSubview:buyLab];
    
    [buyLab mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(20);
        make.right.equalTo(back_view).offset(-7);
        make.centerY.mas_equalTo(imageView);

    }];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, back_view.height-0.5, back_view.width, 0.5)];
    line.backgroundColor = RGB(210,210,210);
    [back_view addSubview:line];
    
    self.line = line;
}

//-(void)setDiscountLable:(UILabel *)discountLable{
//    _discountLable = discountLable;
//    
//    
//   CGRect frame = _discountLable.frame ;
//    
//    CGFloat ww = [discountLable.text boundingRectWithSize:CGSizeMake(1000, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_discountLable.font} context:nil].size.width;
//    
//    frame.size.width = ww +5;
//    _discountLable.frame = frame;
//}
@end
