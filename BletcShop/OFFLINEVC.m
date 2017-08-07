//
//  OFFLINEVC.m
//  BletcShop
//
//  Created by apple on 2017/5/22.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "OFFLINEVC.h"
#import "HGDQQRCodeView.h"
#import "UIImageView+WebCache.h"
#import "ShaperView.h"
#import "NewShopDetailVC.h"
@interface OFFLINEVC ()
{
    UIView *bgView;
    BOOL openState;
    UIImageView *jianImageView;
    UILabel *label;
    UIView *shopView;
}
@property (nonatomic,strong)  UIView *QRView;
@end

@implementation OFFLINEVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(240, 240, 240);
    openState=NO;
    LEFTBACK
    self.navigationItem.title = @"优惠券二维码";
    NSLog(@"self.dic======%@",self.dic);
    
    bgView=[[UIView alloc]initWithFrame:CGRectMake(13, 38, SCREENWIDTH-26, 580)];
    bgView.backgroundColor=[UIColor whiteColor];
    bgView.layer.cornerRadius=12.0f;
    bgView.clipsToBounds=YES;
    [self.view addSubview:bgView];
    
    UIImageView *headImageView=[[UIImageView alloc]initWithFrame:CGRectMake((SCREENWIDTH-51)/2, 10, 51, 51)];
    headImageView.layer.cornerRadius=headImageView.width*0.5;
    headImageView.clipsToBounds=YES;
    [self.view addSubview:headImageView];
    [headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SHOPIMAGE_ADDIMAGE,self.dic[@"image_url"]]]];
    
    
    self.QRView = [[UIView alloc]initWithFrame:CGRectMake(41, 45, bgView.width-82, bgView.width-82)];
    [bgView addSubview:_QRView];
    
    NSDictionary *infoDic = [NSDictionary dictionaryWithObjectsAndKeys:self.dic[@"uuid"],@"uuid",self.dic[@"coupon_id"],@"coupon_id", nil];
    NSString *codeString = [NSString dictionaryToJson:infoDic];

    [HGDQQRCodeView creatQRCodeWithURLString:codeString superView:self.QRView logoImage:[UIImage imageNamed:@"app_icon3"] logoImageSize:CGSizeMake(SCREENWIDTH*0.1, SCREENWIDTH*0.1) logoImageWithCornerRadius:0];
    
    UILabel *notice=[[UILabel alloc]initWithFrame:CGRectMake((bgView.width-150)/2, self.QRView.bottom+20, 150, 30)];
    notice.textAlignment=NSTextAlignmentCenter;
    notice.text=@"商户扫描此码";
    notice.font=[UIFont systemFontOfSize:16.0f];
    notice.textColor=RGB(243, 73, 78);
    notice.layer.cornerRadius=12.0f;
    notice.clipsToBounds=YES;
    notice.layer.borderColor=RGB(243, 73, 78).CGColor;
    notice.layer.borderWidth=1.0f;
    [bgView addSubview:notice];
    
    
    ShaperView *viewr=[[ShaperView alloc]initWithFrame:CGRectMake(16, notice.bottom+20, bgView.width-32, 1)];
    ShaperView *viewt= [viewr drawDashLine:viewr lineLength:3 lineSpacing:3 lineColor:[UIColor colorWithRed:234/255.0f green:234/255.0f blue:234/255.0f alpha:1.0f]];
    [bgView addSubview:viewt];
    
    UIView *leftCircle=[[UIView alloc]initWithFrame:CGRectMake(-8, viewr.top-8, 16, 16)];
    leftCircle.layer.cornerRadius=8.0f;
    leftCircle.clipsToBounds=YES;
    leftCircle.backgroundColor=RGB(240, 240, 240);
    [bgView addSubview:leftCircle];
    
    
    UIView *rightCircle=[[UIView alloc]initWithFrame:CGRectMake(bgView.width-8, viewr.top-8, 16, 16)];
    rightCircle.layer.cornerRadius=8.0f;
    rightCircle.clipsToBounds=YES;
    rightCircle.backgroundColor=RGB(240, 240, 240);
    [bgView addSubview:rightCircle];
    
    
    UILabel *instruments=[[UILabel alloc]initWithFrame:CGRectMake(15, viewr.bottom+15, 60, 13)];
    instruments.text=@"使用说明";
    instruments.font=[UIFont systemFontOfSize:13.0f];
    [bgView addSubview:instruments];
    
    jianImageView=[[UIImageView alloc]initWithFrame:CGRectMake(instruments.right+3, instruments.top, 13, 13)];
    jianImageView.image=[UIImage imageNamed:@"下A"];
    [bgView addSubview:jianImageView];
    
    UIButton *turn=[UIButton buttonWithType:UIButtonTypeCustom];
    turn.frame=CGRectMake(0, viewr.bottom, 100, 40);
    [bgView addSubview:turn];
    
    [turn addTarget:self action:@selector(turnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    label=[[UILabel alloc]initWithFrame:CGRectMake(15, instruments.bottom+10, bgView.width-30, 0.0)];
    label.text=@"";
    label.numberOfLines=0;
    label.font=[UIFont systemFontOfSize:13.0f];
    label.textColor=RGB(51, 51, 51);
    [bgView addSubview:label];
    //进入店铺入口
    shopView=[[UIView alloc]initWithFrame:CGRectMake((bgView.width-215)/2, label.bottom+20, 215, 25)];
    shopView.layer.borderColor=RGB(229, 229, 229).CGColor;
    shopView.layer.borderWidth=1.0f;
    shopView.layer.cornerRadius=6.0f;
    shopView.clipsToBounds=YES;
    [bgView addSubview:shopView];
    
    UIImageView *homeView=[[UIImageView alloc]initWithFrame:CGRectMake(15, 5, 15, 15)];
    homeView.image=[UIImage imageNamed:@"店铺icon"];
    [shopView addSubview:homeView];
    
    UILabel *shopName=[[UILabel alloc]initWithFrame:CGRectMake(homeView.right+12, 0, shopView.width-55, 25)];
    shopName.font=[UIFont systemFontOfSize:14.0f];
    shopName.text=self.dic[@"store"];
    [shopView addSubview:shopName];
    
    UIImageView *youjian=[[UIImageView alloc]initWithFrame:CGRectMake(shopName.right , 6, 6, 13)];
    youjian.image=[UIImage imageNamed:@"youjiantou"];
    [shopView addSubview:youjian];
    
    UIButton *nextVC=[UIButton buttonWithType:UIButtonTypeCustom];
    nextVC.frame=shopView.frame;
    [bgView addSubview:nextVC];
    [nextVC addTarget:self action:@selector(goNextBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    CGRect frame=bgView.frame;
    frame.size.height=CGRectGetMaxY(shopView.frame)+20;
    bgView.frame=frame;
    
}
-(void)turnClick{
    if (openState==NO) {
        jianImageView.image=[UIImage imageNamed:@"上A"];
        CGRect frame =label.frame;
        frame.size.height=32;
        label.frame=frame;
        label.text=@"该二维码仅供用户进店消费时，提供给商户扫描，商户扫描成功后，可抵扣对应面额的现金优惠。";
    }else{
         jianImageView.image=[UIImage imageNamed:@"下A"];
        CGRect frame =label.frame;
        frame.size.height=0.0;
        label.frame=frame;
        label.text=@"";
        
    }
    shopView.frame=CGRectMake((bgView.width-215)/2, label.bottom+20, 215, 25);
    CGRect framess=bgView.frame;
    framess.size.height=CGRectGetMaxY(shopView.frame)+20;
    bgView.frame=framess;
    openState=!openState;
}
-(void)goNextBtnClick{
    NSLog(@"goNextBtnClick-----");
    NewShopDetailVC *controller = [[NewShopDetailVC alloc]init];
    controller.videoID=@"";
    controller.infoDic=[self.dic mutableCopy];
    controller.title = @"商铺信息";
    [self.navigationController pushViewController:controller animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
