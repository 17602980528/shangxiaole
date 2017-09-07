//
//  CardManagerViewController.m
//  BletcShop
//
//  Created by Bletc on 16/4/13.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "CardManagerViewController.h"
#import "UIImageView+WebCache.h"
#import "RechargeViewController.h"
#import "UpgradeViewController.h"
#import "DelayViewController.h"
#import "OrderViewController.h"
#import "ShareCardViewController.h"
#import "ComplaintVC.h"

#import "NewShopDetailVC.h"

#import "PayMentController.h"
#import "UPgradeVC.h"
//eric
#import "TransferOwnershipViewController.h"
#import "CardEricShareViewController.h"
#import "CheckTransferStateAndEditOrRemoveCardViewController.h"


#import "MoneyPAYViewController.h"
#import "CountPAYViewController.h"
#import "ComplainUnnormalVC.h"
//#import "OtherCardComplainVC.h"
#import "RevokeVicotoryOrFailVC.h"//失败反馈
@interface CardManagerViewController ()
{
    NSDictionary *cardInfo_dic;
    CGFloat heights;
    NSArray *titles_array;
    NSArray *imageNameArray;
}
@property (weak, nonatomic) IBOutlet UILabel *typeAndLevel1;
@property (weak, nonatomic) IBOutlet UILabel *shopeName1;
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UILabel *typeAndLevel;
@property (weak, nonatomic) IBOutlet UILabel *remainLab;
@property (weak, nonatomic) IBOutlet UILabel *startAndEndLab;
@property (weak, nonatomic) IBOutlet UILabel *card_contentLab;
@property (weak, nonatomic) IBOutlet UIButton *shousuoBtn;
@property (strong, nonatomic) IBOutlet UIView *tabheaderView;
@property (weak, nonatomic) IBOutlet UIView *content_back_View;
@property (weak, nonatomic) IBOutlet UIImageView *cardImgview;
@property (weak, nonatomic) IBOutlet UIImageView *redimg;
@end

@implementation CardManagerViewController
/**
 
 "addition_sum" = 0;
 "card_code" = "vipc_3ba8f333e1";
 "card_level" = "\U91d1\U5361";
 "card_remain" = 100;
 "card_temp_color" = "#6A5ACD";
 "card_type" = "\U50a8\U503c\U5361";
 "claim_state" = null;
 "date_end" = "2017-07-26 17:40:05";
 "date_start" = "2017-07-26 17:40:05";
 evaluate = false;
 indate = no;
 merchant = "m_d7c116a9cc";
 price = 100;
 rule = 80;
 state = null;
 store = "\U5546\U6d88\U4e50";
 user = "u_uuid0148";
 
 
 */

-(void)postRequestAllInfo
{
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/card/detailGet",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    
    [params setObject:self.card_dic[@"merchant"] forKey:@"muid"];
    [params setObject:appdelegate.cardInfo_dic[@"card_level"] forKey:@"cardLevel"];
    [params setObject:self.card_dic[@"card_code"] forKey:@"cardCode"];
    
    
    
    NSLog(@"---%@",appdelegate.cardInfo_dic);
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"result===%@", result);
        cardInfo_dic = [NSDictionary dictionaryWithDictionary:result];
        
        AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        
        appdelegate.cardInfo_dic = cardInfo_dic;
        
        cardInfo_dic = result;
        
        
        
        
      self.shopeName1.text =  self.shopName.text = cardInfo_dic[@"store"];
        self.cardImgview.backgroundColor = [UIColor colorWithHexString:cardInfo_dic[@"card_temp_color"]];
        
      self.typeAndLevel1.text =  self.typeAndLevel.text = [NSString stringWithFormat:@"%@(%@)",cardInfo_dic[@"card_type"],cardInfo_dic[@"card_level"]];
        self.startAndEndLab.text = [NSString stringWithFormat:@"%@-%@",[cardInfo_dic[@"date_start"] substringToIndex:10],[cardInfo_dic[@"date_end"] substringToIndex:10]];
        
        if ([cardInfo_dic[@"card_type"] isEqualToString:@"计次卡"]) {
            self.card_contentLab.text = @"计次卡用完为止。";

            int cishu =  [cardInfo_dic[@"card_remain"] floatValue]  /   ([cardInfo_dic[@"price"] floatValue]/[cardInfo_dic[@"rule"] floatValue]);
            
            
            self.remainLab.text = [NSString stringWithFormat:@"剩余:%d次",cishu];
        }else{
            self.card_contentLab.text = @"店内项目可使用会员卡任意消费。";
//            self.card_contentLab.text = @"您应该已经收到系统生成的电子邮件，您可以访问电子邮件中的链接，并在我们的计划中注册您的公司。请注意，在迁移完成之前，您将无法访问“Certificates, Identifiers & Profiles”（证书、标识符和描述文件）门户";

            self.remainLab.text = [NSString stringWithFormat:@"余额:%@元",cardInfo_dic[@"card_remain"]];

        }
        
        [self.CardInfotable reloadData];
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    LEFTBACK
    self.navigationItem.title = @"会员卡";
    
    titles_array = @[@"我要续卡",@"我要升级",@"申请延期",@"我要预约",@"家庭共享",@"卡片转让",@"我要分享",@"投诉理赔"];
    imageNameArray=@[@"会员卡-续卡-2017",@"会员卡-升级-2017",@"会员卡-延期-2017",@"会员卡-预约-2017",@"会员卡-共享-2017",@"会员卡-转让-2017",@"会员卡-分享-2017",@"会员卡-理赔-2017"];
    
    [self postRequestAllInfo];

    self.tabheaderView.frame = CGRectMake(13, 212*LZDScale-21, SCREENWIDTH-26, 99);
    
    [self.view addSubview:self.tabheaderView];

    
    [self _inittable];
    
    
    
}
-(void)_inittable
{
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(13, _tabheaderView.bottom, SCREENWIDTH-26, SCREENHEIGHT-64-(_tabheaderView.bottom)) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.showsVerticalScrollIndicator = NO;
    table.estimatedRowHeight = 100;
    table.backgroundColor = [UIColor whiteColor];
    self.CardInfotable = table;
    [self.view addSubview:table];
    
    
    [self.view bringSubviewToFront:table];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 0;
    }else{
        
        return titles_array.count;
    }
    return 0;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 0.01;
    }
    else
    {
        if (indexPath.row==2 && ![self.card_dic[@"indate"] isEqualToString:@"yes"]) {
            return 0.01;

        }else{
            return 42;

        }
       
    }
    
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    if (section==1) {
//        return 0.01;
//    }else
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIndentifier = @"cellIndentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if(cell==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndentifier];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;

    }
    
    
     if (indexPath.section==1)
    {
        cell.textLabel.text=titles_array[indexPath.row];
        cell.imageView.image=[UIImage imageNamed:imageNameArray[indexPath.row]];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(13, 42-1, SCREENWIDTH-26, 1)];
        line.backgroundColor = RGB(220,220,220);
        [cell.contentView addSubview:line];
        
        if (indexPath.row==2 && ![self.card_dic[@"indate"] isEqualToString:@"yes"]) {
            
            cell.textLabel.hidden = YES;
            cell.imageView.hidden = YES;
            cell.accessoryType=UITableViewCellAccessoryNone;
            line.hidden = YES;
        }
        cell.detailTextLabel.textColor=RGB(243, 73, 78);
        if (indexPath.row==7) {
            
            NSString *claim_state  = [NSString getTheNoNullStr:cardInfo_dic[@"claim_state"] andRepalceStr:@""];

            if (claim_state.length==0) {
                cell.detailTextLabel.text=@"";
            }else if([cardInfo_dic[@"claim_state"] isEqualToString:@"CHECK_FAILED"]){
                cell.detailTextLabel.text=@"核查失败";
            }else if([cardInfo_dic[@"claim_state"] isEqualToString:@"ACCESS"]){
                cell.detailTextLabel.text=@"处理成功";
            }else{
                cell.detailTextLabel.text=@"处理中";
            }
        }else{
            cell.detailTextLabel.text=@"";
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section==1) {
        
        if (indexPath.row==7) {
            
                if ([cardInfo_dic[@"claim_state"] isEqualToString:@"CHECK_FAILED"]) {
                    RevokeVicotoryOrFailVC *vc=[[RevokeVicotoryOrFailVC alloc]init];
                    vc.dic=cardInfo_dic;
                    vc.resultBlock = ^(NSString *result) {
                        [self postRequestAllInfo];
                    };
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    ComplainUnnormalVC *vc=[[ComplainUnnormalVC alloc]init];
                    vc.resultBlock = ^(NSString *result) {
                        [self postRequestAllInfo];
                    };
                    vc.dic=cardInfo_dic;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            
        }else{
            NSString *claim_state  = [NSString getTheNoNullStr:cardInfo_dic[@"claim_state"] andRepalceStr:@""];

            if (claim_state.length==0){
                
                if (indexPath.row==0) {
                    
                    if ([[NSString getTheNoNullStr:cardInfo_dic[@"display_state"] andRepalceStr:@""] isEqualToString:@"off"]) {
                        [self tishi:@"该会员卡已下架，您无法进行该操作!"];
                        
                    }else{
                        [self rechargeAction];
                        
                    }
                }else if (indexPath.row==1){
                    
                    if ([[NSString getTheNoNullStr:cardInfo_dic[@"display_state"] andRepalceStr:@""] isEqualToString:@"off"] ) {
                        
                        [self tishi:@"该会员卡已下架，您无法进行该操作!"];
                        
                    }else{
                        [self postRequestUpgrade];
                        
                    }
                }else if (indexPath.row==2){
                    
                    [self delayAction];
                    
                }else if (indexPath.row==3){
                    [self postRequestOrder];
                }else if (indexPath.row==4){
                    [self shareCard];
                }else if(indexPath.row==5){
                    NSLog(@"%@",cardInfo_dic);
                    if ([cardInfo_dic[@"state"] isEqualToString:@"null"]) {
                        //没转让也没分享
                        TransferOwnershipViewController *transferOwnershipVC=[[TransferOwnershipViewController alloc]init];
                        transferOwnershipVC.dic=self.card_dic;
                        [self.navigationController pushViewController:transferOwnershipVC animated:YES];
                        
                    }else if ([cardInfo_dic[@"state"] isEqualToString:@"transfer"]){
                        //转让没分享,去查看编辑页面
                        //去下个页面
                        CheckTransferStateAndEditOrRemoveCardViewController *vc=[[CheckTransferStateAndEditOrRemoveCardViewController alloc]init];
                        vc.index=0;
                        vc.state=0;
                        //                vc.realMoney=realMoney;
                        //                vc.disCount=disCount;
                        vc.dic = cardInfo_dic;
                        [self.navigationController pushViewController:vc animated:YES];
                        
                    }else if ([cardInfo_dic[@"state"] isEqualToString:@"share"]){
                        //分享没转让
                        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                        hud.mode = MBProgressHUDModeText;
                        hud.label.text = NSLocalizedString(@"该卡已分享，转让需取消分享", @"HUD message title");
                        hud.label.font = [UIFont systemFontOfSize:13];
                        hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
                        [hud hideAnimated:YES afterDelay:2.f];
                    }
                    
                }else if (indexPath.row==6){
                    
                    if ([cardInfo_dic[@"card_type"] isEqualToString:@"储值卡"] && [cardInfo_dic[@"rule"] integerValue] !=100) {
                        
                        if ([cardInfo_dic[@"state"] isEqualToString:@"null"]){
                            CardEricShareViewController *transferOwnershipVC=[[CardEricShareViewController alloc]init];
                            transferOwnershipVC.dic = cardInfo_dic;
                            [self.navigationController pushViewController:transferOwnershipVC animated:YES];
                            
                        }else if ([cardInfo_dic[@"state"] isEqualToString:@"share"]){
                            //分享转让没转让,去查看编辑页面
                            //去下个页面
                            CheckTransferStateAndEditOrRemoveCardViewController *vc=[[CheckTransferStateAndEditOrRemoveCardViewController alloc]init];
                            vc.index=1;
                            vc.state=0;
                            //                vc.realMoney=realMoney;
                            //                vc.disCount=disCount;
                            vc.dic = cardInfo_dic;
                            [self.navigationController pushViewController:vc animated:YES];
                        }else if ([cardInfo_dic[@"state"] isEqualToString:@"transfer"]){
                            //分享没转让
                            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                            hud.mode = MBProgressHUDModeText;
                            hud.label.text = NSLocalizedString(@"该卡已转让，分享需取消转让", @"HUD message title");
                            hud.label.font = [UIFont systemFontOfSize:13];
                            hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
                            [hud hideAnimated:YES afterDelay:2.f];
                        }
                        
                    }else{
                        
                        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                        hud.mode = MBProgressHUDModeText;
                        if ([cardInfo_dic[@"card_type"] isEqualToString:@"计次卡"]){
                            hud.label.text = NSLocalizedString(@"计次卡不能分享!", @"HUD message title");
                        }else if ([cardInfo_dic[@"rule"] integerValue] ==100){
                            hud.label.text = NSLocalizedString(@"没有折扣的储值卡,不能分享!", @"HUD message title");
                        }
                        hud.label.font = [UIFont systemFontOfSize:13];
                        hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
                        [hud hideAnimated:YES afterDelay:2.f];
                        
                    }
                    
                    
                    
                }else{
                    
                }
                
            }else{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"会员卡理赔中，不能进行任何操作！" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [sureAction setValue:RGB(243, 73, 78) forKey:@"titleTextColor"];
                [alert addAction:sureAction];
                [self presentViewController:alert animated:YES completion:nil];
                
            }
        }
       
    }
}
/**
 共享会员卡
 */
-(void)shareCard{
    NSLog(@"共享会员卡");
    
    ShareCardViewController *VC = [[ShareCardViewController alloc]init];
    VC.card_dic = cardInfo_dic;
    [self.navigationController pushViewController:VC animated:YES];
    
}
/**
 预约
 */
-(void)postRequestOrder
{
    //获取商家的商品列表
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/commodity/get",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    

    [params setObject:cardInfo_dic[@"merchant"] forKey:@"muid"];
    
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"result = %@", result);
        
        OrderViewController *orderView = [[OrderViewController alloc]init];
        orderView.allClassArray =[NSMutableArray arrayWithArray:result];
        orderView.card_dic = cardInfo_dic;
        
        
        [self.navigationController pushViewController:orderView animated:YES];
        
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
}

/**
 续卡
 */
-(void)rechargeAction
{
    RechargeViewController *rechargeView = [[RechargeViewController alloc]init];
    rechargeView.card_dic = cardInfo_dic;
    [self.navigationController pushViewController:rechargeView animated:YES];
}

/**
 升级
 */

-(void)postRequestUpgrade
{
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/card/levelGet",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:cardInfo_dic[@"merchant"] forKey:@"muid"];
    [params setObject:cardInfo_dic[@"card_code"] forKey:@"code"];
    
    
    DebugLog(@"url=%@---%@",url,params);
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"%@", result);
        
        UPgradeVC *upgradeView = [[UPgradeVC alloc]init];
        upgradeView.card_dic = cardInfo_dic;
        upgradeView.resultArray = [result copy];
        [self.navigationController pushViewController:upgradeView animated:YES];

        

        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
}

/**
 延期
 */
-(void)delayAction
{
    DelayViewController *delayView = [[DelayViewController alloc]init];
    delayView.card_dic = cardInfo_dic;
    [self.navigationController pushViewController:delayView animated:YES];
}


-(IBAction)shouSuoClick:(UIButton*)sender{
    
    
    if (sender.selected) {

        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = self.CardInfotable.frame;
            
            frame.origin.y = SCREENHEIGHT;
            self.CardInfotable.frame = frame;

            self.redimg.transform = CGAffineTransformMakeRotation(M_PI);
            
            
            CGRect tabheaderFrame =  self.tabheaderView.frame;
        
            tabheaderFrame.origin.y = SCREENHEIGHT-64-99;
            self.tabheaderView.frame = tabheaderFrame;
        
        
        }];
        
    }else{

        [UIView animateWithDuration:0.3 animations:^{
            
            CGRect tabheaderFrame =  self.tabheaderView.frame;
            
            tabheaderFrame.origin.y = self.cardImgview.bottom-21;
            self.tabheaderView.frame = tabheaderFrame;

            
            CGRect frame = self.CardInfotable.frame;
            
            frame.origin.y = self.tabheaderView.bottom;
            self.CardInfotable.frame = frame;
            
        } completion:^(BOOL finished) {
            
            
            self.redimg.transform = CGAffineTransformMakeRotation(0);
        }];
        
        
    }
    sender.selected = !sender.selected;
    
}

- (IBAction)payBtnClick:(UIButton *)sender {
    NSString *claim_state  = [NSString getTheNoNullStr:cardInfo_dic[@"claim_state"] andRepalceStr:@""];

    
    if (claim_state.length==0){
        if ([cardInfo_dic[@"card_type"] isEqualToString:@"储值卡"]) {
            PUSH(MoneyPAYViewController)
            vc.refresheDate = ^{
                self.refresheDate();
                
                [self postRequestAllInfo];
            };
            
            vc.card_dic = cardInfo_dic;
            vc.user = self.card_dic[@"user"];
            
            
        }else if ([cardInfo_dic[@"card_type"] isEqualToString:@"计次卡"]){
            
            PUSH(CountPAYViewController)
            vc.card_dic = cardInfo_dic;
            vc.refresheDate = ^{
                self.refresheDate();
                
                [self postRequestAllInfo];
            };
            vc.user = self.card_dic[@"user"];
            
        }

    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"会员卡理赔中，不能进行任何操作！" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [sureAction setValue:RGB(243, 73, 78) forKey:@"titleTextColor"];
        [alert addAction:sureAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}

- (IBAction)tapShopClick:(UITapGestureRecognizer *)sender {
    
    
    PUSH(NewShopDetailVC)
    
    NSMutableDictionary *muta_dic =[NSMutableDictionary dictionaryWithDictionary:cardInfo_dic];
    [muta_dic setValue:cardInfo_dic[@"merchant"] forKey:@"muid"];
    vc.videoID = @"";
    vc.infoDic =muta_dic;
       
}

-(void)tishi:(NSString*)ts{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //hud.frame = CGRectMake(0, 64, 375, 667);
    // Set the annular determinate mode to show task progress.
    hud.mode = MBProgressHUDModeText;
    
    hud.label.text = NSLocalizedString(ts, @"HUD message title");
    hud.label.font = [UIFont systemFontOfSize:13];
    // Move to bottm center.
    //    hud.offset = CGPointMake(0.f, );
    hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
    [hud hideAnimated:YES afterDelay:2.f];
    
}

@end
