//
//  NewAllCouponsVC.m
//  BletcShop
//
//  Created by apple on 2017/8/14.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "NewAllCouponsVC.h"
#import "ShaperView.h"
#import "CouponIntroduceVC.h"
#import "CouponCell.h"
#import "UIImageView+WebCache.h"
#import "OFFLINEVC.h"
#import "ExpiredCouponsVC.h"
#import "PlatCouponTableViewCell.h"
@interface NewAllCouponsVC ()<UITableViewDelegate,UITableViewDataSource>
{
    CGFloat heights;
     SDRefreshFooterView *_refreshFooter;
     SDRefreshHeaderView *_refreshheader;
    UIImageView *imageView;
    UILabel *noticeLabel;
}
@property (weak, nonatomic) IBOutlet UIView *indicatorView;//红线
@property (nonatomic,strong)NSMutableArray *shopCouponArray;//商家优惠券
@property (nonatomic,strong)NSMutableArray *platCouponArray;//平台优惠券
@property(nonatomic)NSInteger page;//商家优惠券分页
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,copy)NSString *sign;
@end

@implementation NewAllCouponsVC

-(NSMutableArray *)shopCouponArray{
    if (!_shopCouponArray) {
        _shopCouponArray = [NSMutableArray array];
    }
    return _shopCouponArray;
}
-(NSMutableArray *)platCouponArray{
    if (!_platCouponArray) {
        _platCouponArray = [NSMutableArray array];
    }
    return _platCouponArray;
}
-(void)viewWillAppear:(BOOL)animated
{
    _page=1;
    [self.shopCouponArray removeAllObjects];
    [self.tableView reloadData];
    if ([_sign isEqualToString:@"shop"]) {
         [self postRequestCashCoupon];
    }
    self.navigationController.navigationBarHidden = NO;
}

- (IBAction)goOutDateVC:(id)sender {
    ExpiredCouponsVC *vc=[[ExpiredCouponsVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)getShopOrPlatCoupons:(UIButton *)sender {
    if (imageView) {
        [imageView removeFromSuperview];
    }
    if (noticeLabel) {
        [noticeLabel removeFromSuperview];
    }
    _page=1;
    [self.shopCouponArray removeAllObjects];
    [self.platCouponArray removeAllObjects];
    [self.tableView reloadData];
    
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame=self.indicatorView.frame;
        frame.origin.y=sender.bottom;
        frame.origin.x=sender.center.x-45;
        frame.size.height=2;
        self.indicatorView.frame=frame;
    }];
    
    if (sender.tag==0) {
        _sign=@"shop";
        [self postRequestCashCoupon];
    }else if (sender.tag==1){
        _sign=@"plat";
        [self postRequestPlatCashCoupon];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    LEFTBACK
    self.title = @"我的优惠券";
    
    _sign=@"shop";
    heights=0;
    _page=1;
    
    _refreshheader = [SDRefreshHeaderView refreshView];
    [_refreshheader addToScrollView:_tableView];
    _refreshheader.isEffectedByNavigationController = NO;
    
    __block typeof(self)tempSelf =self;
    _refreshheader.beginRefreshingOperation = ^{
        if ([tempSelf.sign isEqualToString:@"shop"]) {
            tempSelf.page=1;
            [tempSelf.shopCouponArray removeAllObjects];
            //[tempSelf.tableView reloadData];
            //请求数据
            [tempSelf postRequestCashCoupon];
        }else{
            [tempSelf postRequestPlatCashCoupon];
        }
    };
    
    
    _refreshFooter = [SDRefreshFooterView refreshView];
    [_refreshFooter addToScrollView:_tableView];
    _refreshFooter.beginRefreshingOperation =^{
        if ([tempSelf.sign isEqualToString:@"shop"]){
            tempSelf.page++;
            //数据请求
            NSLog(@"====>>>>%ld",tempSelf.page);
            [tempSelf postRequestCashCoupon];
        }else{
           
        }
    };
    
    [self showLoadingView];

}
//无活动显示无活动
-(void)initNoneActiveView{
    self.view.backgroundColor=RGB(240, 240, 240);
    
    if (imageView) {
        [imageView removeFromSuperview];
    }
    if (noticeLabel) {
        [noticeLabel removeFromSuperview];
    }
    imageView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-92, 63+60, 184, 117)];
    imageView.image=[UIImage imageNamed:@"CC588055F2B4764AA006CD2B6ACDD25C.jpg"];
    [self.view addSubview:imageView];
    
    noticeLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)+46, SCREENWIDTH, 30)];
    noticeLabel.font=[UIFont systemFontOfSize:15.0f];
    noticeLabel.textColor=RGB(153, 153, 153);
    noticeLabel.textAlignment=NSTextAlignmentCenter;
    noticeLabel.text=@"没有可用的代金券哦";
    [self.view addSubview:noticeLabel];
}
-(void)postRequestCashCoupon
{
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/coupon/validateGet",BASEURL];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    [params setObject:[NSString stringWithFormat:@"%ld",self.page] forKey:@"index"];

    NSLog(@"params---%@",params);
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        [_refreshFooter endRefreshing];
        [_refreshheader endRefreshing];
        
        
        DebugLog(@"result---%@",result);
        
        NSArray *arr = (NSArray*)result;
        
      
            for (NSDictionary *dic in arr) {
                NSMutableDictionary *newDic=[dic mutableCopy];
                [newDic setObject:@"close" forKey:@"turn"];
                [self.shopCouponArray addObject:newDic];
                NSLog(@"couponArray====%@",self.shopCouponArray);
            }
        
        
        
        if ([self.shopCouponArray count]==0) {
            
            [self initNoneActiveView];
            
        }else{
            if (imageView) {
                [imageView removeFromSuperview];
            }
            if (noticeLabel) {
                [noticeLabel removeFromSuperview];
            }
        }
        
        [_tableView reloadData];
        [self hintLoadingView];
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self hintLoadingView];
        
        
        [_refreshFooter endRefreshing];
        [_refreshheader endRefreshing];
        
        NSLog(@"%@", error);
    }];
    
}
//创建TableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([_sign isEqualToString:@"shop"]) {
        return self.shopCouponArray.count;
    }else{
        return self.platCouponArray.count;
    }
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CouponCell *cell1 = [CouponCell couponCellWithTableView:tableView];
    PlatCouponTableViewCell *cell2 = [PlatCouponTableViewCell couponCellWithTableView:tableView];
    //PlatCouponTableViewCell
    if ([_sign isEqualToString:@"shop"]) {
        if (self.shopCouponArray.count!=0) {
            NSDictionary *dic = self.shopCouponArray[indexPath.row];
            
            [cell1.headImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SHOPIMAGE_ADDIMAGE,dic[@"image_url"]]]];
            
            cell1.shopNamelab.text=dic[@"store"];
            
            cell1.couponMoney.text=[NSString stringWithFormat:@"%@元",dic[@"sum"]];
            
            cell1.deadTime.text= [NSString stringWithFormat:@"%@~%@",dic[@"date_start"],dic[@"date_end"]];
            
            cell1.limitLab.text=[NSString stringWithFormat:@"满减券 满%@元可用",dic[@"pri_condition"]];
            
            cell1.expiredView.hidden=YES;
            if ([dic[@"validate"] isEqualToString:@"true"]) {
                cell1.showImg.hidden = YES ;
            }else{
                cell1.showImg.hidden = NO ;
                
            }
            
            if ([dic[@"coupon_type"] isEqualToString:@"ONLINE"]||[dic[@"coupon_type"] isEqualToString:@"null"]) {
                cell1.onlineState.image=[UIImage imageNamed:@"线上shop"];
                cell1.youjian.hidden=YES;
            }else{
                cell1.onlineState.image=[UIImage imageNamed:@"线下shop"];
                cell1.youjian.hidden=NO;
            }
            
            
            cell1.contentLable.text=dic[@"content"];
            //      cell.contentLable.text=@"此优惠活动只针对新顾客体验使用此优惠活动只针对新顾客体验使用此优惠活动只针对新顾客体验使用此优惠活动只针对新顾客体验使用此优惠活动只针对新顾客体验使用此优惠活动只针对新顾客体验使用";
            CGFloat hh = [cell1.contentLable.text boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: cell1.contentLable.font} context:nil].size.height;
            
            cell1.turnButton.tag=indexPath.row;
            [cell1.turnButton addTarget:self action:@selector(openOrClose:) forControlEvents:UIControlEventTouchUpInside];
            if([self.shopCouponArray[indexPath.row][@"turn"] isEqualToString:@"open"]){
                cell1.bgView.frame=CGRectMake(12, 10, SCREENWIDTH-24, 150+hh+10-34);
                cell1.contentLable.frame=CGRectMake(12, cell1.turnButton.bottom+10+1, cell1.bgView.width-24, hh);
                heights=160+hh+10-34;
                cell1.jian.image=[UIImage imageNamed:@"上A"];
            }else{
                cell1.bgView.frame=CGRectMake(12, 10, SCREENWIDTH-24, 150-34);
                cell1.contentLable.frame=CGRectMake(12, cell1.turnButton.bottom+10+1, cell1.bgView.width-24, 10);
                heights=160-34;
                cell1.jian.image=[UIImage imageNamed:@"下A"];
            }
            
        }
        return cell1;
    }else if([_sign isEqualToString:@"plat"]){
        if (self.platCouponArray.count!=0) {
            
            NSLog(@"colors===%@",cell2.gradientLayer.colors);
            NSDictionary *dic = self.platCouponArray[indexPath.row];
            
            [cell2.headImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SHOPIMAGE_ADDIMAGE,dic[@"image_url"]]] placeholderImage:[UIImage imageNamed:@"商消乐——优惠券用 2"]];
            
            //        cell.headImg.hidden= YES;
            cell2.shopNamelab.text=[NSString stringWithFormat:@"%@券",dic[@"coupon_type"]];
            CGRect frame = cell2.shopNamelab.frame;
            frame.origin.y = 22;
            cell2.shopNamelab.frame = frame;
            //        cell.shopNamelab.font = [UIFont systemFontOfSize:27];
            cell2.couponMoney.text=[[NSString getTheNoNullStr:dic[@"sum"] andRepalceStr:@"0"] stringByAppendingString:@"元"];
            cell2.couponMoney.font = [UIFont systemFontOfSize:22];
            
            NSMutableAttributedString *muta_att = [[NSMutableAttributedString  alloc]initWithString:cell2.couponMoney.text];
            
            [muta_att setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} range:NSMakeRange(cell2.couponMoney.text.length-1, 1)];
            cell2.couponMoney.attributedText = muta_att;
            
            
            cell2.deadTime.text= [NSString stringWithFormat:@"有效期:%@~%@",dic[@"date_start"],dic[@"date_end"]];
            cell2.detail.text=[NSString stringWithFormat:@"满%@元%@",dic[@"pri_condition"],dic[@"content"]];
            if ([dic[@"validate"] isEqualToString:@"true"]) {
                cell2.showImg.hidden = YES ;
            }else{
                cell2.showImg.hidden = NO ;
                
            }
            
            cell2.onlineState.image=[UIImage imageNamed:@"线上shop"];
            cell2.youjian.hidden=YES;
            
        }
        return cell2;
    }
    
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_sign isEqualToString:@"shop"]) {
        return heights;
    }else{
        return 126;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_sign isEqualToString:@"shop"]) {
        if (_shopCouponArray.count>0) {
            if ([_shopCouponArray[indexPath.row][@"coupon_type"] isEqualToString:@"ONLINE"]||[_shopCouponArray[indexPath.row][@"coupon_type"] isEqualToString:@"null"]) {
                
                CouponIntroduceVC *vc=[[CouponIntroduceVC alloc]init];
                vc.infoDic=_shopCouponArray[indexPath.row];
                vc.index=0;
                [self.navigationController pushViewController:vc animated:YES];
                
            }else{
                //OFFLINEVC
                OFFLINEVC *vc=[[OFFLINEVC alloc]init];
                vc.dic=_shopCouponArray[indexPath.row];
                [self.navigationController pushViewController:vc animated:YES];
            }

        }
    }
   
}

-(void)openOrClose:(UIButton *)sender{
    NSMutableDictionary *dic=self.shopCouponArray[sender.tag];
    if ([dic[@"turn"] isEqualToString:@"close"]) {
        [dic setObject:@"open" forKey:@"turn"];
    }else{
        [dic setObject:@"close" forKey:@"turn"];
    }
    [self.shopCouponArray replaceObjectAtIndex:sender.tag withObject:dic];
    
    [_tableView reloadData];
}
-(void)postRequestPlatCashCoupon
{

    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/user/getSxlCoupon",BASEURL];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    NSLog(@"params---%@",params);
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        [self.platCouponArray removeAllObjects];
        
        DebugLog(@"result---%@",result);
        
        NSArray *arr = (NSArray*)result;
        
        for (NSDictionary *dic in arr) {
                
                [self.platCouponArray addObject:dic];
            }
        
        if ([_platCouponArray count]==0) {
            
            [self initNoneActiveView];
            
        }else{
            if (imageView) {
                [imageView removeFromSuperview];
            }
            if (noticeLabel) {
                [noticeLabel removeFromSuperview];
            }
        }
        [self.tableView reloadData];
        [_refreshFooter endRefreshing];
        [_refreshheader endRefreshing];
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [_refreshFooter endRefreshing];
        [_refreshheader endRefreshing];
    }];
    
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
