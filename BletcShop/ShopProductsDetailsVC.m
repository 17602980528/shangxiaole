//
//  ShopProductsDetailsVC.m
//  BletcShop
//
//  Created by apple on 2017/7/4.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "ShopProductsDetailsVC.h"
#import "ShopProductsDetailsVCTableViewCell.h"
#import "XHStarRateView.h"
#import "UIImageView+WebCache.h"
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import "XWScanImage.h"
@interface ShopProductsDetailsVC ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) IBOutlet UIView *headSectionView;
@property (weak, nonatomic) IBOutlet UIImageView *shopImage;
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UIView *aprise;
@property (weak, nonatomic) IBOutlet UILabel *sell;
@property (weak, nonatomic) IBOutlet UILabel *distance;
@property (nonatomic,strong)NSArray *dataSourseArr;
@end

@implementation ShopProductsDetailsVC
- (IBAction)callShop:(id)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"拨打电话" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:[NSString getTheNoNullStr:[_wholeInfoDic objectForKey:@"store_number"] andRepalceStr:[_wholeInfoDic objectForKey:@"phone"]] otherButtonTitles:nil, nil];
    [sheet showInView:self.tableview];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        NSMutableString* telStr = [[NSMutableString alloc]initWithString:@"tel://"];
        [telStr appendString:[NSString getTheNoNullStr:[_wholeInfoDic objectForKey:@"store_number"] andRepalceStr:[_wholeInfoDic objectForKey:@"phone"]]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telStr]];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",self.wholeInfoDic);
    self.navigationItem.title=@"全部商品";
    LEFTBACK
    XHStarRateView *view=[[XHStarRateView alloc] initWithFrame:self.aprise.frame];
    view.userInteractionEnabled=NO;
     view.isAnimation = YES;
     view.rateStyle = IncompleteStar;
    view.currentScore=[self.wholeInfoDic[@"stars"] floatValue];
    [self.headSectionView addSubview:view];
    self.shopName.text = self.wholeInfoDic[@"store"];
    
    self.sell.text=[NSString stringWithFormat:@"已售%@笔",self.wholeInfoDic[@"sold"]];
    
    
    CLLocationCoordinate2D c1 = (CLLocationCoordinate2D){[self.wholeInfoDic[@"latitude"] doubleValue], [self.wholeInfoDic[@"longtitude"] doubleValue]};
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    CLLocationCoordinate2D c2 = appdelegate.userLocation.location.coordinate;
    BMKMapPoint a=BMKMapPointForCoordinate(c1);
    BMKMapPoint b=BMKMapPointForCoordinate(c2);
    CLLocationDistance distance = BMKMetersBetweenMapPoints(a,b);
    
    int meter = (int)distance;
    if (meter>1000) {
        self.distance.text = [[NSString alloc]initWithFormat:@"%.1fkm",meter/1000.0];
    }else
        self.distance.text = [[NSString alloc]initWithFormat:@"%dm",meter];
    
    NSURL * nurl1=[[NSURL alloc] initWithString:[[SHOPIMAGE_ADDIMAGE stringByAppendingString:[self.wholeInfoDic objectForKey:@"image_url"]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    [_shopImage sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"icon3.png"] options:SDWebImageRetryFailed];
    [self postRequest];
   
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSourseArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *resuseIdentify=@"ShopProductsDetailsVCCell";
    ShopProductsDetailsVCTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:resuseIdentify];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"ShopProductsDetailsVCTableViewCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor clearColor];
    }
    cell.productName.text=_dataSourseArr[indexPath.row][@"name"];
    cell.productPrice.text=[NSString stringWithFormat:@"¥%@",_dataSourseArr[indexPath.row][@"price"]];
    
    NSURL * nurl1=[[NSURL alloc] initWithString:[[SOURCE_PRODUCT stringByAppendingString:_dataSourseArr[indexPath.row][@"image_url"]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    [cell.productImage sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"icon3"]];
    cell.productImage.contentMode=UIViewContentModeScaleToFill;
    
    UITapGestureRecognizer *tap1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scanBigImageClick1:)];
    cell.productImage.userInteractionEnabled=YES;
    [ cell.productImage addGestureRecognizer:tap1];
    
    cell.productMoreDes.hidden=YES;
    
    if (self.wholeInfoDic[@"card_list"]) {
        if ([self.wholeInfoDic[@"card_list"][@"count"] count]>0||[self.wholeInfoDic[@"card_list"][@"experience"] count]>0||[self.wholeInfoDic[@"card_list"][@"meal"] count]>0||[self.wholeInfoDic[@"card_list"][@"value"] count]>0) {
            cell.cardCanUse.text=@"会员卡可用";
            cell.cardCanUse.hidden=NO;
            if (self.wholeInfoDic[@"coupon_list"]&&[self.wholeInfoDic[@"coupon_list"] count]>0) {
                cell.couponCanuse.text=@"优惠券可用";
                cell.couponCanuse.hidden=NO;
            }else{
                cell.couponCanuse.text=@"";
                cell.couponCanuse.hidden=YES;
            }
        }else{
            if (self.wholeInfoDic[@"coupon_list"]&&[self.wholeInfoDic[@"coupon_list"] count]>0) {
                cell.cardCanUse.text=@"优惠券可用";
                cell.cardCanUse.hidden=NO;
                cell.couponCanuse.text=@"";
                cell.couponCanuse.hidden=YES;
            }else{
                cell.cardCanUse.text=@"";
                cell.couponCanuse.text=@"";
                cell.cardCanUse.hidden=YES;
                cell.couponCanuse.hidden=YES;
            }
        }
    }

    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.headSectionView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 107;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 89;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)scanBigImageClick1:(UITapGestureRecognizer *)tap{
    NSLog(@"点击图片");
    UIImageView *clickedImageView = (UIImageView *)tap.view;
    [XWScanImage scanBigImageWithImageView:clickedImageView];
}
//商品数据
-(void)postRequest
{
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/commodity/get",BASEURL];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:[self.wholeInfoDic objectForKey:@"muid"] forKey:@"muid"];
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        NSLog(@"%@",result);
         _dataSourseArr=[NSArray arrayWithArray:result];
        [_tableview reloadData];
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
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
