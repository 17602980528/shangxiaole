//
//  MyCashCouponViewController.m
//  BletcShop
//
//  Created by Bletc on 16/7/26.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "MyCashCouponViewController.h"
#import "ShaperView.h"
#import "CouponIntroduceVC.h"
#import "CouponCell.h"
#import "UIImageView+WebCache.h"
#import "OFFLINEVC.h"
#import "ExpiredCouponsVC.h"
@interface MyCashCouponViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    CGFloat heights;
    SDRefreshFooterView *_refreshFooter;
    SDRefreshHeaderView *_refreshheader;
    UITableView *_tableView;

}
@property(nonatomic)NSInteger page;
@end

@implementation MyCashCouponViewController

-(NSMutableArray *)couponArray{
    if (!_couponArray) {
        _couponArray = [NSMutableArray array];
    }
    return _couponArray;
}
-(void)viewWillAppear:(BOOL)animated
{
    _page=1;
    [self.couponArray removeAllObjects];
    [self postRequestCashCoupon];
    
    self.navigationController.navigationBarHidden = NO;
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    LEFTBACK
    self.title = @"我的优惠券";
    
    self.view.backgroundColor = RGB(240, 240, 240);
    NSLog(@"#######%@",self.couponArray);
    heights=0;
    _page=1;
    [self _inittable];
    
    _refreshheader = [SDRefreshHeaderView refreshView];
    [_refreshheader addToScrollView:_tableView];
    _refreshheader.isEffectedByNavigationController = NO;
    
    __block typeof(self)tempSelf =self;
    _refreshheader.beginRefreshingOperation = ^{
        tempSelf.page=1;
        [tempSelf.couponArray removeAllObjects];
        //请求数据
        [tempSelf postRequestCashCoupon];
    };
    
    
    _refreshFooter = [SDRefreshFooterView refreshView];
    [_refreshFooter addToScrollView:_tableView];
    _refreshFooter.beginRefreshingOperation =^{
        tempSelf.page++;
        //数据请求
        NSLog(@"====>>>>%ld",tempSelf.page);
        [tempSelf postRequestCashCoupon];
        
    };

    [self showLoadingView];
    
}
//无活动显示无活动
-(void)initNoneActiveView{
    self.view.backgroundColor=RGB(240, 240, 240);
    
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-92, 63, 184, 117)];
    imageView.image=[UIImage imageNamed:@"CC588055F2B4764AA006CD2B6ACDD25C.jpg"];
    [self.view addSubview:imageView];
    
    UILabel *noticeLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)+46, SCREENWIDTH, 30)];
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
    
    if (_useCoupon ==100) {
        
        [params setObject:self.muid forKey:@"muid"];
        
    }
    NSLog(@"params---%@",params);
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        [_refreshFooter endRefreshing];
        [_refreshheader endRefreshing];

        
        DebugLog(@"result---%@",result);
        
        NSArray *arr = (NSArray*)result;
        
        if (self.useCoupon ==100) {
            for (NSDictionary *dic in arr) {
                
                if ([dic[@"pri_condition"] floatValue] <= [self.moneyString floatValue]&&![dic[@"coupon_type"] isEqualToString:@"OFFLINE"] && [self.muid isEqualToString:dic[@"muid"]]) {
                    
                    NSMutableDictionary *newDic=[dic mutableCopy];
                    [newDic setObject:@"close" forKey:@"turn"];
                    [self.couponArray addObject:newDic];
                    
                }
                
            }
            
            
        }else{
            for (NSDictionary *dic in arr) {
                NSMutableDictionary *newDic=[dic mutableCopy];
                [newDic setObject:@"close" forKey:@"turn"];
                [self.couponArray addObject:newDic];
                NSLog(@"couponArray====%@",self.couponArray);
            }
            
        }
        
        
        
        if ([self.couponArray count]==0) {
            
            [self initNoneActiveView];
            
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
-(void)_inittable
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64-49) style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    UIButton *checkExpiredCouponsButton=[UIButton buttonWithType:UIButtonTypeCustom];
    checkExpiredCouponsButton.frame=CGRectMake(0, SCREENHEIGHT-49-64, SCREENWIDTH, 49);
    checkExpiredCouponsButton.backgroundColor=RGB(235, 235, 235);
    [checkExpiredCouponsButton setTitleColor:RGB(94, 94, 94) forState:UIControlStateNormal];
    [checkExpiredCouponsButton setTitle:@"查看不可用优惠券  >>" forState:UIControlStateNormal];
    checkExpiredCouponsButton.titleLabel.font=[UIFont systemFontOfSize:12.0f];
    [self.view addSubview:checkExpiredCouponsButton];
    
    [checkExpiredCouponsButton addTarget:self action:@selector(checkExpiredCouponsButtonClick) forControlEvents:UIControlEventTouchUpInside];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.couponArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CouponCell *cell = [CouponCell couponCellWithTableView:tableView];
    
    if (self.couponArray.count!=0) {
        NSDictionary *dic = self.couponArray[indexPath.row];
        
        [cell.headImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SHOPIMAGE_ADDIMAGE,dic[@"image_url"]]]];
        
        cell.shopNamelab.text=dic[@"store"];
        
        cell.couponMoney.text=[NSString stringWithFormat:@"%@元",dic[@"sum"]];
        
        cell.deadTime.text= [NSString stringWithFormat:@"%@~%@",dic[@"date_start"],dic[@"date_end"]];
        
        cell.limitLab.text=[NSString stringWithFormat:@"满减券 满%@元可用",dic[@"pri_condition"]];
        
        cell.expiredView.hidden=YES;
        if ([dic[@"validate"] isEqualToString:@"true"]) {
            cell.showImg.hidden = YES ;
        }else{
            cell.showImg.hidden = NO ;
            
        }
        
        if ([dic[@"coupon_type"] isEqualToString:@"ONLINE"]||[dic[@"coupon_type"] isEqualToString:@"null"]) {
            cell.onlineState.image=[UIImage imageNamed:@"线上shop"];
            cell.youjian.hidden=YES;
        }else{
            cell.onlineState.image=[UIImage imageNamed:@"线下shop"];
            cell.youjian.hidden=NO;
        }
        
        
        cell.contentLable.text=dic[@"content"];
        //      cell.contentLable.text=@"此优惠活动只针对新顾客体验使用此优惠活动只针对新顾客体验使用此优惠活动只针对新顾客体验使用此优惠活动只针对新顾客体验使用此优惠活动只针对新顾客体验使用此优惠活动只针对新顾客体验使用";
        CGFloat hh = [cell.contentLable.text boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: cell.contentLable.font} context:nil].size.height;
        
        cell.turnButton.tag=indexPath.row;
        [cell.turnButton addTarget:self action:@selector(openOrClose:) forControlEvents:UIControlEventTouchUpInside];
        if([self.couponArray[indexPath.row][@"turn"] isEqualToString:@"open"]){
            cell.bgView.frame=CGRectMake(12, 10, SCREENWIDTH-24, 150+hh+10-34);
            cell.contentLable.frame=CGRectMake(12, cell.turnButton.bottom+10+1, cell.bgView.width-24, hh);
            heights=160+hh+10-34;
            cell.jian.image=[UIImage imageNamed:@"上A"];
        }else{
            cell.bgView.frame=CGRectMake(12, 10, SCREENWIDTH-24, 150-34);
            cell.contentLable.frame=CGRectMake(12, cell.turnButton.bottom+10+1, cell.bgView.width-24, 10);
            heights=160-34;
            cell.jian.image=[UIImage imageNamed:@"下A"];
        }
        
    }
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return heights;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        if ([_couponArray[indexPath.row][@"coupon_type"] isEqualToString:@"ONLINE"]||[_couponArray[indexPath.row][@"coupon_type"] isEqualToString:@"null"]) {
            
            if (self.useCoupon ==100) {
                
                if (self.delegate && [_delegate respondsToSelector:@selector(sendValue:)]) {
                    [_delegate sendValue:_couponArray[indexPath.row]];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }else{
                CouponIntroduceVC *vc=[[CouponIntroduceVC alloc]init];
                vc.infoDic=_couponArray[indexPath.row];
                vc.index=0;
                [self.navigationController pushViewController:vc animated:YES];
                
            }
            
        }else{
            //OFFLINEVC
            OFFLINEVC *vc=[[OFFLINEVC alloc]init];
            vc.dic=_couponArray[indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
        }
}


-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"===删除==");
        
    }];
    action.backgroundColor = [UIColor redColor];
    return @[];
    //    return @[action];
    
}

-(void)deleteCouponWithDic:(NSDictionary*)dic{
    NSString *url = [NSString stringWithFormat:@"%@",BASEURL];
    NSMutableDictionary *paramer = [NSMutableDictionary dictionary];
    
    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}
-(void)openOrClose:(UIButton *)sender{
    NSMutableDictionary *dic=self.couponArray[sender.tag] ;
    if ([dic[@"turn"] isEqualToString:@"close"]) {
        [dic setObject:@"open" forKey:@"turn"];
    }else{
        [dic setObject:@"close" forKey:@"turn"];
    }
    [self.couponArray replaceObjectAtIndex:sender.tag withObject:dic];
    
    [_tableView reloadData];
}
//去过期优惠券页面
-(void)checkExpiredCouponsButtonClick{
    ExpiredCouponsVC *vc=[[ExpiredCouponsVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
