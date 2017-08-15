//
//  PlatCouponsVC.m
//  BletcShop
//
//  Created by Bletc on 2017/5/26.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "PlatCouponsVC.h"
#import "CouponCell.h"
#import "UIImageView+WebCache.h"
@interface PlatCouponsVC ()
{
    __block MBProgressHUD *hud;

}
@property (nonatomic,strong)NSMutableArray *couponArray;

@end

@implementation PlatCouponsVC
-(NSMutableArray *)couponArray{
    if (!_couponArray) {
        _couponArray = [NSMutableArray array];
    }
    return _couponArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"商消乐优惠券";
    self.tableView.rowHeight = 126;
LEFTBACK
    
    [self postRequestCashCoupon];
    
    
}



#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.couponArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CouponCell *cell = [CouponCell couponCellWithTableView:tableView];
    
    if (self.couponArray.count!=0) {

        NSLog(@"colors===%@",cell.gradientLayer.colors);
        NSDictionary *dic = self.couponArray[indexPath.row];
        

        [cell.headImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SHOPIMAGE_ADDIMAGE,dic[@"image_url"]]] placeholderImage:[UIImage imageNamed:@"商消乐——优惠券用 2"]];

        //        cell.headImg.hidden= YES;
        cell.shopNamelab.text=[NSString stringWithFormat:@"%@券",dic[@"coupon_type"]];
        CGRect frame = cell.shopNamelab.frame;
        frame.origin.y = 22;
        cell.shopNamelab.frame = frame;
//        cell.shopNamelab.font = [UIFont systemFontOfSize:27];
        cell.couponMoney.text=[[NSString getTheNoNullStr:dic[@"sum"] andRepalceStr:@"0"] stringByAppendingString:@"元"];
        cell.couponMoney.font = [UIFont systemFontOfSize:22];
        
        NSMutableAttributedString *muta_att = [[NSMutableAttributedString  alloc]initWithString:cell.couponMoney.text];
        
        [muta_att setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} range:NSMakeRange(cell.couponMoney.text.length-1, 1)];
        cell.couponMoney.attributedText = muta_att;
        
        
        cell.deadTime.text= [NSString stringWithFormat:@"有效期:%@~%@",dic[@"date_start"],dic[@"date_end"]];
        cell.detail.text=[NSString stringWithFormat:@"满%@元%@",dic[@"pri_condition"],dic[@"content"]];
        if ([dic[@"validate"] isEqualToString:@"true"]) {
            cell.showImg.hidden = YES ;
        }else{
            cell.showImg.hidden = NO ;
            
        }
//        cell.onlineState.hidden = YES;
        
//        if ([dic[@"coupon_type"] isEqualToString:@"ONLINE"]||[dic[@"coupon_type"] isEqualToString:@"null"]) {
            cell.onlineState.image=[UIImage imageNamed:@"线上shop"];
            cell.youjian.hidden=YES;
//        }else{
//            cell.onlineState.image=[UIImage imageNamed:@"线下shop"];
//            cell.youjian.hidden=NO;
//        }
        
    }
    
    return cell;
}

-(void)postRequestCashCoupon
{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/user/getSxlCoupon",BASEURL];
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    
    
    if (_useCoupon ==100) {
        
        [params setObject:self.muid forKey:@"muid"];
        
    }
    NSLog(@"params---%@",params);
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        [hud hideAnimated:YES];
        [self.couponArray removeAllObjects];
        
        DebugLog(@"result---%@",result);
      
            NSArray *arr = (NSArray*)result;
            
            if (self.useCoupon ==100) {
                for (NSDictionary *dic in arr) {
                    
                    if ([dic[@"pri_condition"] floatValue] <= [self.moneyString floatValue]) {
                        [self.couponArray addObject:dic];
                        
                    }
                    
                }
                
                
            }else{
                for (NSDictionary *dic in arr) {
                    
                    [self.couponArray addObject:dic];
                }
                
            }
            
      
        
        if ([_couponArray count]==0) {
            
            [self initNoneActiveView];
            
        }
        
        [self.tableView reloadData];
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud hideAnimated:YES afterDelay:3.f];
        NSLog(@"%@", error);
    }];
    
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





#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if(_useCoupon==100){
       
        self.block(_couponArray[indexPath.row]);
        
        [self.navigationController popViewControllerAnimated:YES];

    }
    
    
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
