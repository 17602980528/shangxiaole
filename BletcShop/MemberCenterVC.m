//
//  MemberCenterVC.m
//  BletcShop
//
//  Created by Bletc on 2017/7/20.
//  Copyright © 2017年 bletc. All rights reserved.
//
#define NUMM 100000

#import "MemberCenterVC.h"
#import <BaiduMapAPI_Utils/BMKGeometry.h>
#import "UIImageView+WebCache.h"
#import "LandingController.h"
#import "SDCycleScrollView.h"
#import "THProgressView.h"
#import "IntegralKnowledgeVC.h"

#import "ConvertRecordCell.h"
#import "ConvertCostVC.h"

#import "OFFLINEVC.h"
#import "CouponIntroduceVC.h"

#import "CheckLogisticsVC.h"

@interface MemberCenterVC ()<UITableViewDelegate,UITableViewDataSource>

{
    
    UIView *lineView;
    UIView *topView;
    UIView *topBackView;
    
    UIView *slipBackView;
    NSMutableArray* _adverImages;
    SDCycleScrollView *cycleScrollView2;
    
    UIImageView *headImageView;
    UILabel *convertLabel;
    NSDictionary *pointAndSign_dic;
    
    UIButton *signBtn;
    
    
}

@property(nonatomic,strong)SDRefreshFooterView *refreshFooter;
@property(nonatomic,strong)SDRefreshHeaderView *refreshheader;
@property(nonatomic,strong)UIButton *oldBtn;

@property (nonatomic, strong) NSArray *headArray;
@property(nonatomic,strong)UITableView *mainTableView;
@property (nonatomic , strong) NSArray  *data_A;// <#Description#>
@property(nonatomic,strong)NSMutableArray *coupons_muta;//优惠券
@property(nonatomic)NSInteger page_coupon;

@property(nonatomic,strong)NSMutableArray *integral_muta;//积分兑换
@property(nonatomic)NSInteger page_integral;

@property(nonatomic,strong)NSMutableArray *pointList_muta;//积分明细
@property(nonatomic)NSInteger page_pointList;

@property(nonatomic,strong)NSMutableArray *my_exchange_muta;//我的兑换
@property(nonatomic)NSInteger page_exchange;

@end

@implementation MemberCenterVC


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=RGB(234, 234, 234);
    self.navigationItem.title=@"积分商城";
    
    LEFTBACK
    
    LZDButton *rightBtn = [LZDButton creatLZDButton];
    rightBtn.bounds = CGRectMake(0, 0, 80, 44);
    [rightBtn setTitle:@"积分知识" forState:0];
    [rightBtn setTitleColor:RGB(51,51,51) forState:0];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];

    rightBtn.block = ^(LZDButton *btn) {
        PUSH(IntegralKnowledgeVC)

    };
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    [self showLoadingView];
    
   
    
    self.page_integral = self.page_coupon = self.page_exchange = self.page_pointList = 1;
    
    
    [self creatTableView];

    [self creatTopbackView];

    [self   getShopList];

    [self getLunBoAdvert];

    
}
-(void)creatTopbackView{
    topBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 180+45)];
    [self.view addSubview:topBackView];
    
    slipBackView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 95)];
    slipBackView.backgroundColor=RGB(240, 240, 240);
    [topBackView addSubview:slipBackView];
    
    cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:slipBackView.frame delegate:nil placeholderImage:[UIImage imageNamed:@""]];
    cycleScrollView2.imageURLStringsGroup = _adverImages;
    cycleScrollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    //    cycleScrollView2.titlesGroup = titles;
    cycleScrollView2.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    
    cycleScrollView2.clickItemOperationBlock = ^(NSInteger currentIndex) {
        
        
        
    };
    
    
    
    [slipBackView addSubview:cycleScrollView2];
    
    
    
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, slipBackView.bottom+10, SCREENWIDTH, 65)];
    headView.backgroundColor = [UIColor whiteColor];
    [topBackView addSubview:headView];
    
    headImageView=[[UIImageView alloc]initWithFrame:CGRectMake(13, 13, 40, 40)];
    headImageView.image=[UIImage imageNamed:@"userHeader"];
    headImageView.layer.cornerRadius=headImageView.height/2;
    headImageView.clipsToBounds=YES;
    headImageView.userInteractionEnabled=YES;
    [headView addSubview:headImageView];
    headImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    
    
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goLandingOrNot)];
    [headImageView addGestureRecognizer:tapGesture];
    
    //积分
    convertLabel=[[UILabel alloc]initWithFrame:CGRectMake(headImageView.right +16, 26, 120, 13)];
    
    convertLabel.textAlignment=NSTextAlignmentLeft;
    convertLabel.font=[UIFont systemFontOfSize:14.0f];
    convertLabel.textColor=RGB(243,73,78);
    
    convertLabel.text= [NSString stringWithFormat:@"积分:%ld",[pointAndSign_dic[@"integral"] integerValue] ];
    [headView addSubview:convertLabel];
    
    signBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    signBtn.frame=CGRectMake(SCREENWIDTH-19-13-51, 23, 51, 19);
    
  
        signBtn.enabled = YES;
        
        [signBtn setTitle:@"签到" forState:UIControlStateNormal];
        signBtn.backgroundColor=NavBackGroundColor;

    [signBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    signBtn.titleLabel.font=[UIFont systemFontOfSize:13.0f];
    signBtn.layer.cornerRadius=8;
    signBtn.clipsToBounds=YES;
    [headView addSubview:signBtn];
    
    
    AppDelegate *delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    if (delegate.IsLogin)
    {
        //请求积分等
        NSLog(@"%@",delegate.userInfoDic);
        NSURL * nurl1=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HEADIMAGE,[delegate.userInfoDic objectForKey:@"headimage"]]];
        
        [headImageView sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"icon3.png"] options:SDWebImageRetryFailed];
        [signBtn addTarget:self action:@selector(signBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        
    }else{
        
        [signBtn addTarget:self action:@selector(goLandingOrNot) forControlEvents:UIControlEventTouchUpInside];
        
        signBtn.backgroundColor=[UIColor lightGrayColor];//RGB(66, 170, 250);
        
    }

    
    self.headArray = @[@"积分兑换区",@"优惠券",@"积分明细",@"我的兑换"];
    
    
    topView = [[UIView alloc]initWithFrame:CGRectMake(0, headView.bottom+10, SCREENWIDTH, 44)];
    topView.backgroundColor = [UIColor whiteColor];
    [topBackView addSubview:topView];
    
    
    for (int i = 0; i <self.headArray.count; i ++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(i*(SCREENWIDTH)/_headArray.count, 0, (SCREENWIDTH)/_headArray.count, topView.height-2)];
        
        [btn setTitle:self.headArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
        [btn setTitleColor:NavBackGroundColor forState:UIControlStateSelected];
        btn.tag = i+NUMM;
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [topView addSubview:btn];
        if (i==0) {
            btn.selected = YES;
            self.oldBtn = btn;
            
            lineView = [[UIView alloc]init];
            lineView.bounds = CGRectMake(0, 0, 62, 2);
            lineView.center = CGPointMake(btn.center.x, CGRectGetMaxY(btn.frame)+1);
            lineView.backgroundColor = NavBackGroundColor;
            [topView addSubview:lineView];
        }
    }

}



-(void)creatTableView{
    
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 180+45, SCREENWIDTH, SCREENHEIGHT-(180+45)-64) style:UITableViewStylePlain];
    tableView.delegate =self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    tableView.backgroundColor = RGB(240, 240, 240);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTableView = tableView;
    
    
    self.refreshheader = [SDRefreshHeaderView refreshView];
    [_refreshheader addToScrollView:tableView];
    _refreshheader.isEffectedByNavigationController = NO;
    
    __block typeof(self)tempSelf =self;
    _refreshheader.beginRefreshingOperation = ^{
        
        if (tempSelf.oldBtn.tag ==NUMM) {
            [tempSelf.refreshheader endRefreshing];


            
        }else if (tempSelf.oldBtn.tag== NUMM +1){
            
        tempSelf.page_coupon=1;
        [tempSelf.coupons_muta removeAllObjects];
        //请求数据
        [tempSelf postGetCouponRequest];
            
        }else if (tempSelf.oldBtn.tag== NUMM +2){
            [tempSelf.refreshheader endRefreshing];
 
        }else if (tempSelf.oldBtn.tag== NUMM +3){
            [tempSelf.refreshheader endRefreshing];
 
        }

    };
    
    
    self.refreshFooter = [SDRefreshFooterView refreshView];
    [_refreshFooter addToScrollView:tableView];
    _refreshFooter.beginRefreshingOperation =^{

        if (tempSelf.oldBtn.tag ==NUMM) {
            [tempSelf.refreshFooter endRefreshing];

            
            
        }else if (tempSelf.oldBtn.tag== NUMM +1){
            tempSelf.page_coupon++;
            //请求数据
            [tempSelf postGetCouponRequest];
        }else if (tempSelf.oldBtn.tag== NUMM +2){
            [tempSelf.refreshFooter endRefreshing];

        }else if (tempSelf.oldBtn.tag== NUMM +3){
            [tempSelf.refreshFooter endRefreshing];
 
        }

        
    };

    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_oldBtn.tag==NUMM) {
        return (SCREENWIDTH-1)/2+1;
    }else if(_oldBtn.tag ==NUMM+1){
        return 120;
    }else if(_oldBtn.tag ==NUMM+2){
        return  64;

    }else
    
        return 100;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_oldBtn.tag==NUMM) {
        
       return  self.data_A.count%2 ==0 ? self.data_A.count/2 :self.data_A.count/2+1;
    }else{
        
        return self.data_A.count;

    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_oldBtn.tag==NUMM) {
        
        return [self creatIntegralGoodsCell:indexPath];
        
        
        
    }else if(_oldBtn.tag==NUMM +1){
    
        return  [self creatCoupnsCell:indexPath];
        
    }else if(_oldBtn.tag==NUMM +2){
        
        return  [self creatPointDetailCell:indexPath];
    }else
    {
        
        return [self creatMyExchangeCell:indexPath];
//    
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
//        
//        if (!cell) {
//            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"cellID"];
//            cell.backgroundColor = RGB(arc4random()%255, arc4random()%255, arc4random()%255);
//        }
//        
//        return cell;
    
    
    }
    
   
}

-(UITableViewCell*)creatMyExchangeCell:(NSIndexPath*)indexPath{
    
    
    ConvertRecordCell  *cell=[_mainTableView dequeueReusableCellWithIdentifier:@"ConvertRecordCellID"];
    if (!cell) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"ConvertRecordCell" owner:self options:nil] firstObject];
        
    }
    
    NSLog(@"-data_A-----%@",self.data_A);
    
    if (self.data_A.count != 0) {
        NSDictionary *dic = self.data_A[indexPath.row];
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",POINT_GOODS,dic[@"image_url"]]]];
        
        cell.titleLab.text=dic[@"name"];
        cell.timeLab.text=dic[@"datetime"];
        cell.state_lab.text=dic[@"tip"];
        
        if ([dic[@"track_state"] isEqualToString:@"wait"]) {
            cell.state_lab.backgroundColor = [UIColor colorWithHexString:@"#e26666"];
            cell.state_m.hidden = YES;
        }else{
            if ([dic[@"track_state"] isEqualToString:@"sending"]) {
                cell.state_lab.backgroundColor = [UIColor colorWithHexString:@"#45ae26"];
                
            }else if([dic[@"track_state"] isEqualToString:@"received"]){
                cell.state_lab.backgroundColor = [UIColor colorWithHexString:@"#808080"];
                
            }
            cell.state_m.hidden = NO;
            
        }
        
    }
    
    return cell;
}

-(UITableViewCell*)creatPointDetailCell:(NSIndexPath*)indexPath{
    UITableViewCell *cell=[_mainTableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        UILabel *shopNameLable=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, SCREENWIDTH-20, 20)];
        shopNameLable.tag=100;
        shopNameLable.text=@"推荐新用户奖励";
        shopNameLable.font=[UIFont systemFontOfSize:15.0f];
        [cell addSubview:shopNameLable];
        
        UILabel *exChangeTime=[[UILabel alloc]initWithFrame:CGRectMake(20, 30, SCREENWIDTH-20, 20)];
        exChangeTime.text=@"2017-2-23 06:07:51";
        exChangeTime.font=[UIFont systemFontOfSize:13.0f];
        exChangeTime.tag=200;
        exChangeTime.textColor=[UIColor grayColor];
        [cell addSubview:exChangeTime];
        
        UILabel *costPoint=[[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH-100, 17, 100, 30)];
        costPoint.textColor=[UIColor redColor];
        costPoint.text=@"+10";
        costPoint.textAlignment=1;
        costPoint.font=[UIFont systemFontOfSize:13.0f];
        costPoint.tag=300;
        [cell addSubview:costPoint];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 64-1, SCREENWIDTH, 1)];
        view.backgroundColor = RGB(240, 240, 240);
        [cell addSubview:view];
        
    }
    UILabel *lab1=[cell viewWithTag:100];
    UILabel *lab2=[cell viewWithTag:200];
    UILabel *lab3=[cell viewWithTag:300];
    lab1.text=_data_A[indexPath.row][@"type"];
    lab2.text=_data_A[indexPath.row][@"datetime"];
    lab3.text=[NSString stringWithFormat:@"%@",_data_A[indexPath.row][@"integral"]];
    return cell;
}


-(UITableViewCell*)creatCoupnsCell:(NSIndexPath*)indexPath{
    
    UITableViewCell *cell=[_mainTableView dequeueReusableCellWithIdentifier:@"CoupnsCellID"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CoupnsCellID"];
        UIImageView *shopHead=[[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 95, 95)];
        shopHead.tag=100;
        [cell addSubview:shopHead];
        
        UIImageView *tipImageView=[[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 30, 30)];
        tipImageView.tag=1213;
        [cell addSubview:tipImageView];
        
        UILabel *couponNameLable=[[UILabel alloc]initWithFrame:CGRectMake(125, 10, SCREENWIDTH-125-15-78-10, 50)];
        couponNameLable.text=@"美式黑椒牛排立减15元代金券";
        couponNameLable.tag=200;
        couponNameLable.font=[UIFont systemFontOfSize:15.0f];
        couponNameLable.numberOfLines=0;
        [cell addSubview:couponNameLable];
        
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(SCREENWIDTH-78-10, 15, 78, 35);
        button.backgroundColor=[UIColor colorWithRed:237/255.0f green:71/255.0f blue:59/255.0f alpha:1.0f];
        button.layer.cornerRadius=3.0f;
        button.titleLabel.font=[UIFont systemFontOfSize:13.0f];
        [button setTitle:@"立即领取" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cell addSubview:button];
        button.tag=666;
        [button addTarget:self action:@selector(getCoupon:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *couponMoney=[[UILabel alloc]init];
        couponMoney.tag=300;
        couponMoney.textColor=NavBackGroundColor;
        [cell addSubview:couponMoney];
        
        UILabel *baseCouponMoney=[[UILabel alloc]init];
        baseCouponMoney.tag=400;
        baseCouponMoney.textColor=[UIColor lightGrayColor];
        baseCouponMoney.font=[UIFont systemFontOfSize:13.0f];
        [cell addSubview:baseCouponMoney];
        
        UILabel *shopNameAndDistant=[[UILabel alloc]initWithFrame:CGRectMake(125, couponMoney.bottom+5, SCREENWIDTH-125, 15)];
        shopNameAndDistant.tag=500;
        shopNameAndDistant.text=@"三人行麻辣香锅 3.0km";
        shopNameAndDistant.font=[UIFont systemFontOfSize:13.0f];
        shopNameAndDistant.textColor=[UIColor lightGrayColor];
        [cell addSubview:shopNameAndDistant];
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 120-1, SCREENWIDTH, 1)];
        view.backgroundColor = RGB(240, 240, 240);
        [cell addSubview:view];
        
    }
    UIImageView *headImgView=[cell viewWithTag:100];
    NSURL * nurl1=[[NSURL alloc] initWithString:[[SHOPIMAGE_ADDIMAGE stringByAppendingString:[NSString getTheNoNullStr:[_data_A[indexPath.row]  objectForKey:@"image_url"] andRepalceStr:@""]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    [headImgView sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"icon3.png"] options:SDWebImageRetryFailed];
    
    UILabel *couponMoneyLable=[cell viewWithTag:200];
    couponMoneyLable.text=[NSString stringWithFormat:@"%@减%@元代金券",_data_A[indexPath.row][@"store"],_data_A[indexPath.row][@"sum"]];
    couponMoneyLable.frame=CGRectMake(125, 10, SCREENWIDTH-125-15-78-10, 50);
    
    UILabel *couponMoney=[cell viewWithTag:300];
    UIFont *fnt = [UIFont fontWithName:@"HelveticaNeue" size:24.0f];
    NSString *money=[NSString stringWithFormat:@"%@元",_data_A[indexPath.row][@"sum"]];
    CGSize size=[money sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt, NSFontAttributeName,nil]];
    CGFloat nameH = size.height;
    CGFloat nameW = size.width;
    couponMoney.frame=CGRectMake(125, couponMoneyLable.bottom+5, nameW, 30);
    couponMoney.text=money;
    //
    UILabel *baseCouponMoney=[cell viewWithTag:400];
    baseCouponMoney.text=[NSString stringWithFormat:@"满%@元可用",_data_A[indexPath.row][@"pri_condition"]];
    baseCouponMoney.frame=CGRectMake(couponMoney.right,couponMoneyLable.bottom+(nameH-15) , SCREENWIDTH-couponMoney.frame.origin.x-couponMoney.width-5, 15);
    //
    UILabel *shopNameAndDistant=[cell viewWithTag:500];
    shopNameAndDistant.text=_data_A[indexPath.row][@"store"];
    shopNameAndDistant.frame=CGRectMake(125, couponMoney.bottom+5, SCREENWIDTH-125, 15);
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    //
    UIButton *sender=[cell viewWithTag:666];
    UIImageView *tip=[cell viewWithTag:1213];
    if([_data_A[indexPath.row][@"coupon_type"] isEqualToString:@"OFFLINE"]){
        tip.image=[UIImage imageNamed:@"下角标ss"];
    }else{
        tip.image=[UIImage imageNamed:@"上角标"];
    }
    
    if ([_data_A[indexPath.row][@"received"] isEqualToString:@"true"]) {
        [sender setTitle:@"立即使用" forState:UIControlStateNormal];
        [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        sender.backgroundColor=[UIColor whiteColor];
        sender.layer.borderWidth=1.0f;
        sender.layer.borderColor=[[UIColor redColor]CGColor];
    }else{
        sender.backgroundColor=[UIColor colorWithRed:237/255.0f green:71/255.0f blue:59/255.0f alpha:1.0f];
        [sender setTitle:@"立即领取" forState:UIControlStateNormal];
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    //距离
    CLLocationCoordinate2D c1 = CLLocationCoordinate2DMake([[[_data_A objectAtIndex:indexPath.row] objectForKey:@"latitude"] doubleValue], [[[_data_A objectAtIndex:indexPath.row] objectForKey:@"longtitude"] doubleValue]);
    
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    BMKMapPoint a=BMKMapPointForCoordinate(c1);
    BMKMapPoint b=BMKMapPointForCoordinate(appdelegate.userLocation.location.coordinate);
    CLLocationDistance distance = BMKMetersBetweenMapPoints(a,b);
    
    int meter = (int)distance;
    if (meter>1000) {
        shopNameAndDistant.text = [[NSString alloc]initWithFormat:@"%@ %.1fkm",_data_A[indexPath.row][@"store"],meter/1000.0];
    }else{
        shopNameAndDistant.text = [[NSString alloc]initWithFormat:@"%@ %dm",_data_A[indexPath.row][@"store"],meter];
    }
    return cell;
}

-(UITableViewCell*)creatIntegralGoodsCell:(NSIndexPath*)indexpath{
{
    UITableViewCell *cell = [_mainTableView dequeueReusableCellWithIdentifier:@"integralCellID"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"integralCellID"];
        cell.backgroundColor =RGB(240, 240, 240);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
        if (_data_A.count!=0) {
            
            for (UIView *view in cell.contentView.subviews) {
                [view removeFromSuperview];
            }
            
            for (int i = 0; i <2; i++) {
                UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(i*((SCREENWIDTH-1)/2+1), 0, (SCREENWIDTH-1)/2, (SCREENWIDTH-1)/2)];
                backView.backgroundColor = [UIColor whiteColor];
                backView.tag = indexpath.row *2+i;
                
                [cell.contentView addSubview:backView];
                
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(integralClick:)];
                [backView addGestureRecognizer:tap];
                
                UIImageView *rewardImageView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH/4-40, 10, 80, 80)];
                rewardImageView.contentMode = UIViewContentModeScaleAspectFit;
                rewardImageView.userInteractionEnabled=YES;
                [backView addSubview:rewardImageView];
                
               
                
                
                UILabel *rewardNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 99, SCREENWIDTH/2, 13)];
                rewardNameLabel.textAlignment=NSTextAlignmentCenter;
                rewardNameLabel.font=[UIFont systemFontOfSize:13.0f];
                [backView addSubview:rewardNameLabel];
                
                UIView *progressBackView=[[UIView alloc]initWithFrame:CGRectMake(0, 120, SCREENWIDTH/2, 10)];
                [backView addSubview:progressBackView];
                
                THProgressView *ProgressView = [[THProgressView alloc] initWithFrame:CGRectMake(42,122,70,5)];
                ProgressView.borderTintColor =[UIColor grayColor];
                ProgressView.progressTintColor = [UIColor redColor];
                [backView addSubview:ProgressView];
                
                UILabel *overLabel=[[UILabel alloc]initWithFrame:CGRectMake(118, 120, SCREENWIDTH/2-118, 10)];
                overLabel.textAlignment=NSTextAlignmentLeft;
                overLabel.font=[UIFont systemFontOfSize:10.0f];
                overLabel.textColor=[UIColor grayColor];
                [backView addSubview:overLabel];
                
                UIImageView *moneyImage=[[UIImageView alloc]initWithFrame:CGRectMake(44, 135, 15, 15)];
                moneyImage.image=[UIImage imageNamed:@"s_money_n"];
                [backView addSubview:moneyImage];
                
                UILabel *priceLabel=[[UILabel alloc]initWithFrame:CGRectMake(65, 135, SCREENWIDTH/2-65, 15)];
                priceLabel.textAlignment=NSTextAlignmentLeft;
                priceLabel.font=[UIFont systemFontOfSize:13.0f];
                [backView addSubview:priceLabel];
                priceLabel.textColor=RGB(226, 47, 50);

                
                if (indexpath.row*2+1==_data_A.count) {
                    
                    backView.hidden = YES;
                }else{
                    backView.hidden = NO;
                }
                
                if (indexpath.row *2+i <_data_A.count) {
                    
                    
                    NSDictionary *dic = self.data_A[indexpath.row*2+i];
                    
                    NSURL * nurl1=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",POINT_GOODS,dic[@"image_url"]]];
                    [rewardImageView sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"icon3.png"] options:SDWebImageRetryFailed];
                    
                    rewardNameLabel.text=dic[@"name"];
                    
                    priceLabel.text=dic[@"price"];
                    
                    ProgressView.progress= [dic[@"remain"]floatValue]/[dic[@"sum"]floatValue];
                    
                    overLabel.text=[NSString stringWithFormat:@"剩余%.1f%%",ProgressView.progress*100];
                    
                }
               
                
           
                
                
               

            }
            
            
        }
        
        
        
        
        return cell;
        
    }
}

#pragma mark 点击事件


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_oldBtn.tag == NUMM +3) {
        
        NSDictionary *dic = self.data_A[indexPath.row];
        if (![dic[@"track_state"] isEqualToString:@"wait"]) {
            PUSH(CheckLogisticsVC)
            vc.order_dic = self.data_A[indexPath.row];
            
        }
    }
    
    

}
//领取优惠券
-(void)getCoupon:(UIButton *)sender{
    
    UITableViewCell *cell=(UITableViewCell *)[sender superview];
    NSIndexPath *indexPath=[_mainTableView indexPathForCell:cell];
    
    NSDictionary *dic=_data_A[indexPath.row];
    AppDelegate *delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    if (delegate.IsLogin) {
        //掉用领取接口
        if ([sender.titleLabel.text isEqualToString:@"立即使用"]) {
            if ([dic[@"coupon_type"] isEqualToString:@"OFFLINE"]) {
                OFFLINEVC *vc=[[OFFLINEVC alloc]init];
                vc.dic=dic;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                CouponIntroduceVC *couponVC=[[CouponIntroduceVC alloc]init];
                couponVC.index=1;
                couponVC.infoDic=_data_A[indexPath.row];
                [self.navigationController pushViewController:couponVC animated:YES];
                
            }
            
            
            
        }else{
            [self postReceiveConponRequest:indexPath.row];
        }
    }else{
        LandingController *landVc = [[LandingController alloc]init];
        [self.navigationController pushViewController:landVc animated:YES];
    }
    
}


//积分商品
-(void)integralClick:(UITapGestureRecognizer*)tap{
    
    
    PUSH(ConvertCostVC)
    vc.infoDic=_data_A[tap.view.tag];
    
    vc.imageNameString=_data_A[tap.view.tag][@"image_url"];//图片名
    vc.shopNameString=_data_A[tap.view.tag][@"name"];
    vc.shopNeedPoint=_data_A[tap.view.tag][@"price"];
    NSInteger sum=[_data_A[tap.view.tag][@"sum"] integerValue];
    NSInteger remain=[_data_A[tap.view.tag][@"remain"] integerValue];
    vc.converRecordCount=[NSString stringWithFormat:@"%ld",(sum-remain)];
    vc.totalPoint=pointAndSign_dic[@"integral"];
    
    
}

//顶部三个分类对应的点击事件
-(void)btnClick:(UIButton*)sender{
    if (sender !=_oldBtn) {
        sender.selected = YES;
        _oldBtn.selected = NO;
        _oldBtn = sender;
        [UIView animateWithDuration:0.5 animations:^{
            lineView.center = CGPointMake(sender.center.x, CGRectGetMaxY(sender.frame)+1);
        }];

        if (_oldBtn.tag==NUMM) {
            if (_integral_muta.count==0) {
                
                [self postGetCouponRequest];
            }else{
                _data_A = [_integral_muta mutableCopy];
                [_mainTableView reloadData];

            }
        }
        
        if (_oldBtn.tag==NUMM+1) {
            if (_coupons_muta.count==0) {
                [self postGetCouponRequest];
            }else{
                _data_A = [_coupons_muta mutableCopy];
                [_mainTableView reloadData];

            }
        }
        
        if (_oldBtn.tag==NUMM+2) {
            if (_pointList_muta.count==0) {
                [self postRequestPonitDetails];
            }else{
                _data_A = [_pointList_muta mutableCopy];
                [_mainTableView reloadData];

            }
        }
        
        if (_oldBtn.tag==NUMM+3) {
            if (_my_exchange_muta.count==0) {
                [self getMyExchangeData];
            }else{
                _data_A = [_my_exchange_muta mutableCopy];
                [_mainTableView reloadData];
                
            }
        }

        

        
    }
    
    
    
}


//签到
-(void)signBtnClick{
    
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@Extra/mall/sign",BASEURL ];
    AppDelegate *delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:delegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"result==%@", result);
        if ([result[@"result_code"] intValue]==1) {
            
            [self postRequestPointWithSign:delegate.userInfoDic[@"uuid"]];
            
            
        }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
    
}


-(void)goLandingOrNot{
    AppDelegate *delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    if (!delegate.IsLogin)
    {
        LandingController *landVc = [[LandingController alloc]init];
        [self.navigationController pushViewController:landVc animated:YES];
    }else{
        [self signBtnClick];
    }
    
}
#pragma mark 数据请求

//领取优惠券;

-(void)postReceiveConponRequest:(NSInteger)index{
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/coupon/receive",BASEURL];
    NSDictionary *dic = _data_A[index];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    [params setObject:dic[@"muid"] forKey:@"muid"];
    [params setObject:dic[@"coupon_id"] forKey:@"coupon_id"];
    
    NSLog(@"------%@",params);
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        NSLog(@"%@",result);
        if ([result[@"result_code"] integerValue]==1) {
            
            [self showHint:@"领取成功"];

            NSMutableDictionary *muta_dic = [NSMutableDictionary dictionaryWithDictionary:dic];
            [muta_dic setValue:@"true" forKey:@"received"];
            
            [self.coupons_muta replaceObjectAtIndex:index withObject:muta_dic];
            
            self.data_A = [_coupons_muta mutableCopy];
            
            [_mainTableView reloadData];
            
        }else if([result[@"result_code"] integerValue]==1062){
            [self showHint:@"限领1份"];

           
            
        }else if([result[@"result_code"] integerValue]==0){
            [self showHint:@"已被领取完了!"];

           
            
        }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
}


-(void)getMyExchangeData{
    
    

    //    [self showHudInView:self.view hint:@"加载中..."];;
    
    NSString *url = [NSString stringWithFormat:@"%@Extra/mall/getExchange",BASEURL];
    NSMutableDictionary *paramer = [NSMutableDictionary dictionary];
    
    AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    if (appdelegate.IsLogin) {
        [paramer setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
        
    }else{
        [paramer setObject:@"" forKey:@"uuid"];
        
    }
    
    
    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        [self hideHud];
        NSLog(@"result----%@",result);
        if (result) {
            [self.my_exchange_muta addObjectsFromArray:result];
            
            self.data_A = [self.my_exchange_muta mutableCopy];
            [_mainTableView reloadData];
        }
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"getExchange,error----%@",error);
        
        [self hideHud];
    }];
    
}

//积分明细
-(void)postRequestPonitDetails{
    NSString *url =[[NSString alloc]initWithFormat:@"%@Extra/mall/getConsume",BASEURL ];
    AppDelegate *del=(AppDelegate *)[UIApplication sharedApplication].delegate;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if (del.IsLogin) {
        [params setObject:del.userInfoDic[@"uuid"] forKey:@"uuid"];

    }else{
        [params setObject:@"" forKey:@"uuid"];

    }
    NSLog(@"params==%@", params);

    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"result==%@", result);
        if (result) {
                NSArray *arr = result;
                
                [self.pointList_muta addObjectsFromArray:arr];
                
                self.data_A = [self.pointList_muta mutableCopy];
                
            [_mainTableView reloadData];
            
        }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
}


//获取发布优惠券商家列表
-(void)postGetCouponRequest{
    
    
    //    [self showHudInView:self.view hint:@"加载中..."];;

    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/coupon/marketGet",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    if (appdelegate.IsLogin) {
        [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
        [params setValue:[NSString stringWithFormat:@"%ld",self.page_coupon] forKey:@"index"];
        
    }else{
        [params setValue:[NSString stringWithFormat:@"%ld",self.page_coupon] forKey:@"index"];
    }
    NSLog(@"------%@",params);
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        NSLog(@"%@",result);
        
        [self hideHud];
        [_refreshheader endRefreshing];
        [_refreshFooter endRefreshing];
        if ([result count]>0) {
            NSArray *arr = result;
            
            [self.coupons_muta addObjectsFromArray:arr];
            
            self.data_A = [self.coupons_muta mutableCopy];
            
            [_mainTableView reloadData];
            
        }else{
            
            
            
        }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_refreshheader endRefreshing];
        [_refreshFooter endRefreshing];
        [self hideHud];
        NSLog(@"%@", error);
        
    }];
    
    
}


//获取轮播广告接口
-(void)getLunBoAdvert{
    
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@Extra/mall/getAdverts",BASEURL ];
    
    [KKRequestDataService requestWithURL:url params:nil httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"result==%@", result);//POINT_LUNBO
        
        if (result) {
            
            _adverImages = [NSMutableArray array];
            for (int i=0; i<[result count]; i++) {
                [_adverImages addObject:[NSString stringWithFormat:@"%@%@",POINT_LUNBO,result[i][@"image_url"]]];
            }
            
            
            // 网络加载 --- 创建带标题的图片轮播器
            
            //         --- 模拟加载延迟
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                cycleScrollView2.imageURLStringsGroup = _adverImages;
            });
            
            
        }
        
        
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
}

-(void)getShopList{
    //    [self showHudInView:self.view hint:@"加载中..."];;
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@Extra/mall/getGoods",BASEURL ];
    
    [KKRequestDataService requestWithURL:url params:nil httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        [self hintLoadingView];
        NSLog(@"result==%@", result);//POINT_LUNBO
        if (result) {
            
            [self.integral_muta addObjectsFromArray:(NSArray*)result];
            
            self.data_A = self.integral_muta;
            
            [_mainTableView reloadData];
        }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {

        [self hintLoadingView];

        NSLog(@"%@", error);
        
    }];
    
}


-(void)postRequestPointWithSign:(NSString *)uuid {
    
    //请求乐点数
    NSString *url =[[NSString alloc]initWithFormat:@"%@Extra/mall/getIntegral",BASEURL ];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:uuid forKey:@"uuid"];
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"result==%@", result);
        if (result) {
            
            pointAndSign_dic = [NSDictionary dictionaryWithDictionary:result];
            
            convertLabel.text= [NSString stringWithFormat:@"积分:%ld",[pointAndSign_dic[@"integral"] integerValue] ];
            
            if ([pointAndSign_dic[@"signed"]isEqualToString:@"yes"]) {
                [signBtn setTitle:@"已签到" forState:UIControlStateNormal];
                signBtn.backgroundColor=[UIColor whiteColor];
                signBtn.layer.borderWidth = 1;
                signBtn.layer.borderColor =RGB(243,73,78).CGColor;
                [signBtn setTitleColor:RGB(243,73,78) forState:UIControlStateNormal];

                
                
                signBtn.enabled = NO;
            }else{
                signBtn.enabled = YES;
                
                [signBtn setTitle:@"签到" forState:UIControlStateNormal];
                signBtn.backgroundColor=RGB(243,73,78);
                [signBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }


        }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
}





-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"contentOffset"]) {
        
        
        CGPoint offset = [change[NSKeyValueChangeNewKey] CGPointValue];
        
        if (offset.y>=0 && offset.y <=180) {
            
        CGRect newFrame = CGRectMake(0, -offset.y, SCREENWIDTH, 180+45);

        topBackView.frame = newFrame;
            
            _mainTableView.frame = CGRectMake(0, topBackView.bottom, SCREENWIDTH, SCREENHEIGHT-(64+topBackView.bottom));
            
        }else if (offset.y >180){
            topBackView.frame = CGRectMake(0, -180, SCREENWIDTH, 180+45);
            _mainTableView.frame = CGRectMake(0, topBackView.bottom, SCREENWIDTH, SCREENHEIGHT-(64+topBackView.bottom));


        }else if (offset.y <0){
            
            topBackView.frame = CGRectMake(0, 0, SCREENWIDTH, 180+45);
            _mainTableView.frame = CGRectMake(0, topBackView.bottom, SCREENWIDTH, SCREENHEIGHT-(64+topBackView.bottom));

        }
        
 
    }
   
    
}



#pragma mark 懒加载

-(NSMutableArray *)coupons_muta{
    if (!_coupons_muta) {
        _coupons_muta = [NSMutableArray array];
    }
    return _coupons_muta;
}

-(NSMutableArray *)integral_muta{
    if (!_integral_muta) {
        _integral_muta = [NSMutableArray array];
    }
    return _integral_muta;
}
-(NSMutableArray *)pointList_muta{
    if (!_pointList_muta) {
        _pointList_muta = [NSMutableArray array];
    }
    return _pointList_muta;
}
-(NSMutableArray *)my_exchange_muta{
    if (!_my_exchange_muta) {
        _my_exchange_muta = [NSMutableArray array];
    }
    return _my_exchange_muta;
    
}
-(NSArray *)data_A{
    if (!_data_A) {
        _data_A = [NSArray array];
    }
    return _data_A;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [_mainTableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];

    //根据是否登录去请求积分等数据
    AppDelegate *delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    if (delegate.IsLogin)
    {
        //请求积分等
        NSLog(@"%@",delegate.userInfoDic);
        [self postRequestPointWithSign:delegate.userInfoDic[@"uuid"]];
        
        
        NSURL * nurl1=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HEADIMAGE,[delegate.userInfoDic objectForKey:@"headimage"]]];
        
        [headImageView sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"icon3.png"] options:SDWebImageRetryFailed];
        
    }
    
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [_mainTableView removeObserver:self forKeyPath:@"contentOffset"];
    
}
@end
