//
//  ExpiredCouponsVC.m
//  BletcShop
//
//  Created by apple on 2017/7/20.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "ExpiredCouponsVC.h"
#import "CouponCell.h"
#import "UIImageView+WebCache.h"
@interface ExpiredCouponsVC ()
{
    CGFloat heights;
    SDRefreshFooterView *_refreshFooter;
    SDRefreshHeaderView *_refreshheader;
    UIImageView *imageView;
    UILabel *noticeLabel;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic)NSInteger page;
@end

@implementation ExpiredCouponsVC
{

}
-(NSMutableArray *)couponArray{
    if (!_couponArray) {
        _couponArray = [NSMutableArray array];
    }
    return _couponArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"不可用优惠券";
    LEFTBACK
    heights=0;
    _page=1;
    
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
    [self postRequestCashCoupon];
}
-(void)postRequestCashCoupon
{
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/coupon/invalidateGet",BASEURL];
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    [params setValue:[NSString stringWithFormat:@"%ld",_page] forKey:@"index"];
    
    NSLog(@"params---%@",params);
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        
        [_refreshFooter endRefreshing];
        [_refreshheader endRefreshing];
        
        DebugLog(@"result---%@",result);
        
        NSArray *arr = (NSArray*)result;
        
        for (NSDictionary *dic in arr) {
                NSMutableDictionary *newDic=[dic mutableCopy];
                [newDic setObject:@"close" forKey:@"turn"];
                [self.couponArray addObject:newDic];
                NSLog(@"couponArray====%@",self.couponArray);
            }
        [_tableView reloadData];
        [self hintLoadingView];
        if (self.couponArray.count==0) {
            [self initNoneActiveView];
        }else{
            if (imageView) {
                [imageView removeFromSuperview];
            }
            if (noticeLabel) {
                [noticeLabel removeFromSuperview];
            }
        }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self hintLoadingView];

        [_refreshFooter endRefreshing];
        [_refreshheader endRefreshing];
        NSLog(@"%@", error);
    }];
    
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
        
        cell.expiredView.image=[UIImage imageNamed:@"已过期——印章"];
        
        cell.topView.backgroundColor=RGB(130, 130, 130);
        cell.youjian.hidden=YES;
        if ([dic[@"coupon_type"] isEqualToString:@"ONLINE"]||[dic[@"coupon_type"] isEqualToString:@"null"]) {
            cell.onlineState.image=[UIImage imageNamed:@"已过期-线上"];
           // cell.youjian.hidden=YES;
        }else{
            cell.onlineState.image=[UIImage imageNamed:@"已过期-线下"];
            //cell.youjian.hidden=YES;
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

-(void)openOrClose:(UIButton *)sender{
    NSMutableDictionary *dic=self.couponArray[sender.tag];
    if ([dic[@"turn"] isEqualToString:@"close"]) {
        [dic setObject:@"open" forKey:@"turn"];
    }else{
        [dic setObject:@"close" forKey:@"turn"];
    }
    [self.couponArray replaceObjectAtIndex:sender.tag withObject:dic];
    
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
