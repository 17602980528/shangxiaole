//
//  ShopListTableViewself.m
//  BletcShop
//
//  Created by Bletc on 16/8/4.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "ShopListTableViewCell.h"

#import "ShaperView.h"
@implementation ShopListTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self crectSubviews];
    }
    return self;
}

-(void)crectSubviews{
    
    
    UIImageView *shopImageView = [[UIImageView alloc]initWithFrame:CGRectMake(13, 10, 65, 65)];
    shopImageView.layer.cornerRadius = 5;
    shopImageView.layer.masksToBounds = YES;
    [self addSubview:shopImageView];
    //店名
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(shopImageView.right+15, 14, SCREENWIDTH-(shopImageView.right+15), 14)];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.font = [UIFont systemFontOfSize:15];
    nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    nameLabel.numberOfLines = 0;
    nameLabel.text = @"";
    [self addSubview:nameLabel];
    
    //距离
    UILabel *distanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 44, SCREENWIDTH-90-13, 12)];
    distanceLabel.backgroundColor = [UIColor clearColor];
    distanceLabel.textAlignment = NSTextAlignmentRight;
    distanceLabel.font = [UIFont systemFontOfSize:12];
    distanceLabel.text = @"1000米";
    distanceLabel.textColor = RGB(102,102,102);
    
    [self addSubview:distanceLabel];
  //
//    ShaperView *viewr=[[ShaperView alloc]initWithFrame:CGRectMake(90, 85, SCREENWIDTH-90, 1)];
//    ShaperView *viewt= [viewr drawDashLine:viewr lineLength:3 lineSpacing:3 lineColor:[UIColor colorWithRed:234/255.0f green:234/255.0f blue:234/255.0f alpha:1.0f]];
//    [self addSubview:viewt];
    
   
    
//    UILabel *sheContent=[[UILabel alloc]initWithFrame:CGRectMake(114, 97, SCREENWIDTH-114, 15)];
//    sheContent.textAlignment=NSTextAlignmentLeft;
//    sheContent.font=[UIFont systemFontOfSize:12.0f];
//    
//    [self addSubview:sheContent];
    
    
       
    
    XHStarRateView *starView = [[XHStarRateView alloc]initWithFrame:CGRectMake(nameLabel.left, 67+5, 77, 15)];
    starView.userInteractionEnabled = NO;
    starView.currentScore = 3;
    starView.rateStyle = IncompleteStar;
    [self addSubview:starView];
    
    
    
    //销售额
    UILabel *sellerLabel=[[UILabel alloc]initWithFrame:CGRectMake(starView.right + 5, starView.top+1.5, SCREENWIDTH-(starView.right + 5), 12)];
    sellerLabel.font=[UIFont systemFontOfSize:12.0f];
    sellerLabel.textAlignment=NSTextAlignmentLeft;
    sellerLabel.textColor = RGB(102,102,102);
    [self addSubview:sellerLabel];

    
    
    UILabel *brandLabel=[[UILabel alloc]initWithFrame:CGRectMake(shopImageView.left, shopImageView.bottom-15, 44, 12)];
    brandLabel.text=@"品牌";
    brandLabel.font=[UIFont systemFontOfSize:9.0f];
    [self addSubview:brandLabel];
    brandLabel.backgroundColor=RGB(226,102,102);
    

    LZDButton *delete_btn = [LZDButton creatLZDButton];
    delete_btn.hidden = YES;
    delete_btn.frame = CGRectMake(SCREENWIDTH-36, 60, 36, 36);
    
    [delete_btn setImage:[UIImage imageNamed:@"删除按钮 2"] forState:0];

    delete_btn.contentEdgeInsets = UIEdgeInsetsMake(10.5, 10.5, 10.5, 10.5);
    [self addSubview:delete_btn];
    self.delete_btn = delete_btn;
    
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, sellerLabel.bottom+10, SCREENWIDTH, 5)];
    
    lineView.backgroundColor=RGB(240,240,240);
    [self addSubview:lineView];
    
//    NSLog(@"------%lf",lineView.bottom);
    self.starView = starView;
    self.shopImageView = shopImageView;
    self.nameLabel = nameLabel;
    self.distanceLabel =distanceLabel;
    self.sellerLabel =sellerLabel;
    self.tradeLable=brandLabel;
}

@end
