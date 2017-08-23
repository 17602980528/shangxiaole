//
//  MineViewController.m
//  BletcShop
//
//  Created by wuzhengdong on 16/1/25.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "MineViewController.h"
#import "Mygroup.h"
#import "Myitem.h"
#import "Mycell.h"
#import "CardVipController.h"
#import "MyOderController.h"
#import "MyMoneybagController.h"
#import "FriendController.h"
#import "LookAgoController.h"
#import "LandingController.h"
#import "UserInfoViewController.h"
#import "MyMoneybagController.h"
#import "FavorateViewController.h"
#import "NoEvaluateController.h"
#import "RegisterController.h"//测试
#import "MyOderController.h"
#import "UIImageView+WebCache.h"
#import "MyCashCouponViewController.h"
#import "PointRuleViewController.h"
#import "EndOrBeginningViewController.h"
#import "WXApi.h"

#import "UIButton+WebCache.h"

#import "ShareViewController.h"
#import "LZDBASEViewController.h"

//#import "LZDUserInfoVC.h"
#import "PersonalEricCell.h"
#import "MemberCenterVC.h"
//#import "UMSocial.h"
#import <UMSocialCore/UMSocialCore.h>
#import "QRcodeUIViewController.h"
#import "MineInfoVCSecond.h"
#import "MoreViewController.h"
#import "NewMyPayMentsVC.h"
#import "NewAllCouponsVC.h"
@interface MineViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIView *shareView;
    NSArray *array_p;
    UIImageView *mom;
    UIImageView *headImageView;
    UILabel * signLabel;
    UIButton *setButton;
    UIImageView *setImageView;
    AppDelegate *appdelegate;
    UIButton *signBtn;
    NSDictionary *pointAndSign_dic;
}
@property(nonatomic,weak)UITableView *Mytable;
@property(nonatomic,strong)NSMutableArray *data;
@property (nonatomic , strong) NSDictionary *data_D;//分享的数据

@end

@implementation MineViewController
-(NSDictionary *)data_A{
    if (!_data_D) {
        _data_D = [[NSDictionary alloc]init];
    }
    return _data_D;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor= RGB(240, 240, 240);
    appdelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    [self _initTable];
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(notice:) name:@"signNotice" object:nil];
    
    [self getData];
    
    
    
}
-(void)getData{
    
    NSString *url = [NSString stringWithFormat:@"%@Extra/source/share",BASEURL];
    NSLog(@"---%@",url);
    
    
    [KKRequestDataService requestWithURL:url params:nil httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"------%@",result);
        self.data_D = (NSDictionary*)result;
        
        [self creatShareView];
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    
}

-(void)postRequestPoints
{
    //请求乐点数
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/user/accountGet",BASEURL];
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    [params setObject:@"integral" forKey:@"type"];
    
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"result==%@", result);
        self.allPoint = [NSString getTheNoNullStr:result[@"integral"] andRepalceStr:@"0"];
        NSLog(@"%@", self.allPoint);
        [self.Mytable reloadData];
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.allPoint = @"0";
    [self _loading];
    if (mom) {
        mom.frame=CGRectMake(0, 0, SCREENWIDTH, 166);
        headImageView.center=mom.center;
        headImageView.bounds=CGRectMake(0, 0, 70, 70);
        headImageView.layer.cornerRadius=headImageView.width/2;
        headImageView.clipsToBounds=YES;
        signLabel.frame=CGRectMake((SCREENWIDTH-200)/2, headImageView.bottom+10, 200, 20);
        signLabel.alpha=1.0f;
    }
    
    appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    if (appdelegate.IsLogin) {
        
        [self postRequestPointWithSign:appdelegate.userInfoDic[@"uuid"]];
        
        NSString *string=[NSString stringWithFormat:@"%@%@",HEADIMAGE,[appdelegate.userInfoDic objectForKey:@"headimage"]];
        NSURL * nurl1=[NSURL URLWithString:[string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
        [headImageView sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"icon3.png"] options:SDWebImageRetryFailed];
        signLabel.text = [NSString getTheNoNullStr:appdelegate.userInfoDic[@"nickname"] andRepalceStr:@"未设置"];
        
    }else{
        headImageView.image=[UIImage imageNamed:@"头像"];
        signLabel.text=@"未登录";
    }
    
}
-(void)_loading
{
    
    appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    
    if (appdelegate.IsLogin) {
        [self postRequestPoints];
    }else{
        NSIndexSet *indexset = [NSIndexSet indexSetWithIndex:0];
        
        [self.Mytable reloadSections:indexset withRowAnimation:UITableViewRowAnimationNone];
    }
    
    
}
//添加下部的TableView
//添加下部的TableView
-(void)_initTable
{
    //self.automaticallyAdjustsScrollViewInsets=NO;
    UITableView *mytable = [[UITableView alloc]initWithFrame:CGRectMake(0, -20, SCREENWIDTH, SCREENHEIGHT - 49+20) style:UITableViewStyleGrouped];
    mytable.backgroundColor=[UIColor clearColor];
    mytable.dataSource = self;
    mytable.delegate = self;
    mytable.contentInset = UIEdgeInsetsMake(166, 0, 0, 0);
    mytable.showsVerticalScrollIndicator = NO;
    mytable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.Mytable = mytable;
    [self.view addSubview:mytable];
    
    mom=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 166)];
    mom.userInteractionEnabled=YES;
    mom.image=[UIImage imageNamed:@"bg(1)"];
    mom.contentMode=UIViewContentModeScaleAspectFill;
    [self.view addSubview:mom];
    
    headImageView=[[UIImageView alloc]init];
    headImageView.contentMode=UIViewContentModeScaleAspectFill;
    headImageView.bounds=CGRectMake(0, 0, 70, 70);
    headImageView.center=mom.center;
    headImageView.layer.cornerRadius=headImageView.width/2;
    headImageView.clipsToBounds=YES;
    headImageView.userInteractionEnabled=YES;
    headImageView.image=[UIImage imageNamed:@"头像"];
    [mom addSubview:headImageView];
    
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(HeadImageAction)];
    [headImageView addGestureRecognizer:tap];
    
    
    signLabel = [[UILabel alloc]initWithFrame:CGRectMake((mom.width-200)/2, headImageView.bottom+10, 200, 20)];
    signLabel.text =@"未登录";
    signLabel.textAlignment = NSTextAlignmentCenter;
    signLabel.textColor = [UIColor whiteColor];
    [mom addSubview:signLabel];
    
    setImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"设置"]];
    setImageView.frame=CGRectMake(13, headImageView.center.y-10, 20, 20);
    [mom addSubview:setImageView];
    
    setButton=[UIButton buttonWithType:UIButtonTypeCustom];
    setButton.frame=CGRectMake(0, headImageView.center.y-25, 50, 50);
    [mom addSubview:setButton];
    [setButton addTarget:self action:@selector(goSettingVC) forControlEvents:UIControlEventTouchUpInside];
    
    signBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    signBtn.frame=CGRectMake(SCREENWIDTH-63, headImageView.center.y-10, 50, 20);
    signBtn.layer.borderWidth=1.0f;
    signBtn.layer.borderColor=[[UIColor whiteColor]CGColor];
    signBtn.layer.cornerRadius=5.0f;
    signBtn.clipsToBounds=YES;
    [signBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [signBtn setTitle:@"签到" forState:UIControlStateNormal];
    signBtn.titleLabel.font=[UIFont systemFontOfSize:13.0f];
    [mom addSubview:signBtn];
    
    
    
    if (appdelegate.IsLogin) {
        NSString *string=[NSString stringWithFormat:@"%@%@",HEADIMAGE,[appdelegate.userInfoDic objectForKey:@"headimage"]];
        
        NSURL * nurl1=[NSURL URLWithString:[string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
        [headImageView sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"icon3.png"] options:SDWebImageRetryFailed];
        signLabel.text = [NSString getTheNoNullStr:appdelegate.userInfoDic[@"nickname"] andRepalceStr:@"未设置"];
        setImageView.hidden=NO;
        setButton.hidden=NO;
        signBtn.hidden=NO;
    }else{
        headImageView.image=[UIImage imageNamed:@"头像"];
        signLabel.text=@"未登录";
        setImageView.hidden=YES;
        setButton.hidden=YES;
        signBtn.hidden=YES;
    }
    
    
}

-(NSMutableArray *)data{
    _data=nil;
    if (_data==nil) {
        _data = [NSMutableArray array];
        
        //创建cell模型
        
        //一区
        Myitem *item10 = [Myitem itemsWithImg:@"会员卡ss" title:@"我的会员卡" vcClass:[CardVipController class]];
        Myitem *item11 = [Myitem itemsWithImg:@"钱包" title:@"我的钱包" vcClass:[MyMoneybagController class]];
        Myitem *item13 = [Myitem itemsWithImg:@"优惠券ss" title:@"我的优惠券" vcClass:[NewAllCouponsVC class]];//MyCashCouponViewController
        Myitem *item14 = [Myitem itemsWithImg:@"消费" title:@"我的消费" vcClass:[NewMyPayMentsVC class]];//
        
        Myitem *item12=[Myitem itemsWithImg:@"积分商城" title:@"积分商城" vcClass:[MemberCenterVC class]];
        Mygroup *group1 = [[Mygroup alloc] init];
        group1.items = @[item10,item13,item11,item14,item12];
        [_data addObject:group1];
        
        
        //二区
        
        Myitem *item20 = [Myitem itemsWithImg:@"收藏" title:@"我的收藏" vcClass:[FavorateViewController class]];
        Myitem *item21 = [Myitem itemsWithImg:@"评价" title:@"我的评价" vcClass:[NoEvaluateController class]];
        Myitem *item30 = [Myitem itemsWithImg:@"推荐" title:@"我的推荐" vcClass:[FriendController class]];
        Myitem *item31 = [Myitem itemsWithImg:@"我的好友" title:@"我的好友" vcClass:[LZDBASEViewController class]];
        Myitem *item32 = [Myitem itemsWithImg:@"邀请好友" title:@"邀请好友使用" vcClass:[ShareViewController class]];
        
        Mygroup *group2 = [[Mygroup alloc] init];
        group2.items = @[item31,item20,item21,item30,item32];
        [_data addObject:group2];
        
    }
    
    return _data;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.data.count;
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    Mygroup *group = self.data[section];
    return group.items.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    PersonalEricCell *cell = [PersonalEricCell cellForTableView:tableView];
    Mygroup *group = self.data[indexPath.section];
    Myitem *myItem = group.items[indexPath.row];
    cell.cellItem = myItem;
    cell.bgImageView.backgroundColor=[UIColor clearColor];
    if (indexPath.row==0) {
        cell.bgImageView.image=[UIImage imageNamed:@"导角矩形上"];
    }else if (indexPath.row==4){
        cell.bgImageView.image=[UIImage imageNamed:@"导角矩形下"];
    }else{
        cell.bgImageView.image=[UIImage imageNamed:@""];
        cell.bgImageView.backgroundColor=[UIColor whiteColor];
    }
    if (indexPath.section==1&&indexPath.row==0) {
        cell.desLale.hidden=NO;
    }else{
        cell.desLale.hidden=YES;
    }
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    Mygroup *group = self.data[indexPath.section];
    Myitem *item = group.items[indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (!appdelegate.IsLogin) {
        LandingController *landVc = [[LandingController alloc]init];
        [self.navigationController pushViewController:landVc animated:YES];
    }else
    {
        
        if ([item.vcClass isSubclassOfClass:[UIViewController class]]) {
            UIViewController *vc = [[item.vcClass alloc]init];
            vc.title = item.title;
            
            if ([vc isKindOfClass:[PointRuleViewController class]]) {
                
                PointRuleViewController *PointRuleView = [[PointRuleViewController alloc]init];
                PointRuleView.type = 99;
                [self.navigationController pushViewController:PointRuleView animated:YES];
                
            }else if([vc isKindOfClass:[ShareViewController class]]){
                
                shareView.hidden = NO;
                
            }else{
                [self.navigationController pushViewController:vc animated:YES];
                
            }
            
        }
    }
    
}

//头像的点击事件
-(void)HeadImageAction
{
    NSLog(@"头像");
    
    if (appdelegate.IsLogin) {
        
        //        LZDUserInfoVC *VC = [[LZDUserInfoVC alloc]init];
        //
        //        [self.navigationController pushViewController:VC animated:YES];
        MineInfoVCSecond *vc=[[MineInfoVCSecond alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        LandingController *LandVC = [[LandingController alloc]init];
        
        [self.navigationController pushViewController:LandVC animated:YES];
    }
}

-(void)postRequestEvaluate
{
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/evaluate/listGet",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         NSLog(@"result==%@", result);
         
         NSMutableArray *evaluateArray = [result copy];
         if (evaluateArray.count>0) {
             [self startEvaluateView];
         }else{
             MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
             //            hud.frame = CGRectMake(0, 64, 375, 667);
             // Set the annular determinate mode to show task progress.
             hud.mode = MBProgressHUDModeText;
             
             hud.label.text = NSLocalizedString(@"无未评价订单", @"HUD message title");
             hud.label.font = [UIFont systemFontOfSize:13];
             // Move to bottm center.
             //    hud.offset = CGPointMake(0.f, );
             hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
             [hud hideAnimated:YES afterDelay:3.f];
         }
         
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         //         [self noIntenet];
         NSLog(@"%@", error);
     }];
    
}
-(void)startEvaluateView{
    NoEvaluateController *controller = [[NoEvaluateController alloc]init];
    
    
    controller.title = @"未评价";
    [self.navigationController pushViewController:controller animated:YES];
}
-(void)creatShareView{
    
    
    //    array_p = [NSArray arrayWithObjects:UMShareToQQ,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina, nil];
    
    
    
    shareView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    shareView.hidden= YES;
    shareView.backgroundColor = [UIColor colorWithRed:51/255.f green:51/255.f blue:51/255.f alpha:0.7];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancleClick)];
    [shareView addGestureRecognizer:tap];
    
    NSArray* windows = [UIApplication sharedApplication].windows;
    UIWindow *curent_window = [windows lastObject];
    
    [curent_window addSubview: shareView];
    
    UIView *backview = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT-201, SCREENWIDTH, 201)];
    backview.backgroundColor = RGB(240,240,240);
    [shareView addSubview:backview];
    
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 13, SCREENWIDTH, 14)];
    lable.text =@"分享到";
    lable.font = [UIFont systemFontOfSize:15];
    lable.textColor = RGB(51,51,51);
    lable.textAlignment = NSTextAlignmentCenter;
    [backview addSubview:lable];
    NSArray *arr = @[@"扫一扫",@"微信好友",@"朋友圈",@"微博"];
    for (int i = 0; i < arr.count; i ++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat width = 0;
        if (SCREENWIDTH <= 320) {
            width = 50;
        }else{
            width = 63;
            
        }
        CGFloat bod = (SCREENWIDTH-18*2-width*4)/3;
        
        btn.tag = i;
        [btn addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(18+(width+bod)*i, 50, width, width);
        [btn setImage:[UIImage imageNamed:arr[i]] forState:0];
        [backview addSubview:btn];
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(btn.left, btn.bottom+13, btn.width, 12)];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = RGB(51,51,51);
        lab.font = [UIFont systemFontOfSize:12];
        lab.text  = arr[i];
        [backview addSubview:lab];
        
        
    }
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, SCREENHEIGHT-49, SCREENWIDTH, 49);
    [button setTitle:@"取消" forState:0];
    [button setTitleColor:RGB(51,51,51) forState:0];
    button.titleLabel.font = [UIFont systemFontOfSize:17];
    
    button.backgroundColor = [UIColor whiteColor];
    [button addTarget:self action:@selector(cancleClick) forControlEvents:UIControlEventTouchUpInside];
    [shareView addSubview:button];
    
    
}
-(void)shareClick:(UIButton*)sender{
    
    shareView.hidden =YES;
    NSLog(@"---%@===",_data_D);
    
    UMSocialMessageObject *messageObj = [UMSocialMessageObject messageObject];
    NSString *share_title = [NSString getTheNoNullStr:_data_D[@"title"] andRepalceStr:@"分享的title"];
    
    NSString *share_text =[NSString getTheNoNullStr:_data_D[@"content"] andRepalceStr:@"分享的text"];
    
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_data_D[@"image"]]]];
    
    
    UMShareWebpageObject *shareObj = [UMShareWebpageObject shareObjectWithTitle:share_title descr:share_text thumImage:image];
    
    NSString *codeString = [NSString stringWithFormat:@"%@?phone=%@",_data_D[@"link_add"],appdelegate.userInfoDic[@"phone"]];
    
    shareObj.webpageUrl = codeString;
    messageObj.shareObject = shareObj;
    
    //    array_p = [[NSArray alloc]initWithObjects:@[[UMSocialPlatformType_QQ n]] count:4];
    
    
    //   NSString *codeString = _data_D[0][0];
    NSLog(@"-----%@",codeString);
    
    if (sender.tag == 0) {
        QRcodeUIViewController *VC= [[QRcodeUIViewController alloc]init];
        VC.codeString = codeString;
        [self.navigationController pushViewController:VC animated:YES];
        
        
    }else  if (sender.tag == 1) {
        
        [self shareTo:UMSocialPlatformType_WechatSession withMessageObj:messageObj];
        
        
        
    }else if (sender.tag == 2) {
        
        
        
        [self shareTo:UMSocialPlatformType_WechatTimeLine withMessageObj:messageObj];
        
        
    }else if (sender.tag == 3) {
        
        
        messageObj.text = [NSString stringWithFormat:@"%@\n%@\n%@",share_title,share_text,codeString];
        
        UMShareImageObject *shareImgObj = [[UMShareImageObject alloc]init];
        [shareImgObj setShareImage:image];
        
        messageObj.shareObject = shareImgObj;
        
        
        [self shareTo:UMSocialPlatformType_Sina withMessageObj:messageObj];
        
        
        
    }
    
    
    NSLog(@"===%ld",sender.tag);
    
    
    
}

-(void)shareTo:(UMSocialPlatformType)platforeType withMessageObj:(UMSocialMessageObject*)messageObj{
    
    [[UMSocialManager defaultManager]shareToPlatform:platforeType messageObject:messageObj currentViewController:self completion:^(id result, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",result);
            
            if ([result isKindOfClass:[UMSocialShareResponse class]]) {
                if (platforeType == UMSocialPlatformType_WechatTimeLine || platforeType == UMSocialPlatformType_Sina) {
                    
                    
                    NSString *url = [NSString stringWithFormat:@"%@UserType/share/resolve",BASEURL];
                    NSMutableDictionary *paramer = [NSMutableDictionary dictionary];
                    
                    [paramer setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
                    if (platforeType == UMSocialPlatformType_WechatTimeLine) {
                        [paramer setObject:@"微信分享" forKey:@"tip"];
                        
                    }else{
                        [paramer setObject:@"微博分享" forKey:@"tip"];
                        
                    }
                    
                    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
                        
                        
                        if ([result[@"result_code"] integerValue]==1) {
                            //NSString *reward =result[@"reward"];
                        }
                        
                        
                    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
                        
                    }];
                    
                }
                
                
                
            }else{
                NSLog(@"response data is %@",result);
                
            }
        }
    }];
    
}
-(void)cancleClick{
    shareView.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
}
-(void)notice:(id)sender{
    NSDictionary *dic=[sender userInfo];
    NSLog(@"%@",dic[@"1"]);
    [self.Mytable reloadData];
}
-(void)dealloc{
    [shareView removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat offset_Y = scrollView.contentOffset.y+186;
//    NSLog(@"======%f",offset_Y);
    if  (offset_Y < 0) {
        CGRect frame =mom.frame;
        
        CGFloat height=166 +ABS(offset_Y);
        frame.size.height=height;
        mom.frame=frame;
        
        headImageView.center=mom.center;
        headImageView.bounds=CGRectMake(0, 0, 70+ABS(offset_Y), 70+ABS(offset_Y));
        
        headImageView.layer.cornerRadius=headImageView.width/2.0;
        headImageView.clipsToBounds=YES;
        CGRect frame2 = signLabel.frame;
        frame2.origin.y=headImageView.bottom+10;
        signLabel.frame=frame2;
        setButton.hidden=YES;
        setImageView.hidden=YES;
        signBtn.hidden=YES;
    }else if(offset_Y > 0){
        CGRect frame =mom.frame;
        CGFloat height=166 -ABS(offset_Y);
        signLabel.alpha=1*(66-ABS(offset_Y))/66.0;
        headImageView.bounds=CGRectMake(0, 0, 70-ABS(offset_Y), 70-ABS(offset_Y));
        
        headImageView.layer.cornerRadius=headImageView.width/2.0;
        headImageView.clipsToBounds=YES;
        
        if (ABS(offset_Y)>=26) {
            headImageView.bounds=CGRectMake(0, 0, 40, 40);
            headImageView.layer.cornerRadius=20;
        }
        if (height<=80) {
            height=80;
            signLabel.alpha=0;
            
        }
        frame.size.height=height;
        
        mom.frame=frame;
        headImageView.center=mom.center;
        
        CGRect frame2 = signLabel.frame;
        frame2.origin.y=headImageView.bottom+10;
        signLabel.frame=frame2;
         setButton.hidden=YES;
        setImageView.hidden=YES;
        signBtn.hidden=YES;
    }else{
         signLabel.alpha=1;
        if (appdelegate.IsLogin) {
            setButton.hidden=NO;
            setImageView.hidden=NO;
            signBtn.hidden=NO;
        }else{
            setButton.hidden=YES;
            setImageView.hidden=YES;
            signBtn.hidden=YES;
        }

    }
}
//
-(void)goSettingVC{
    MoreViewController *vc=[[MoreViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
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
            
            if ([pointAndSign_dic[@"signed"]isEqualToString:@"yes"]) {
                [signBtn setTitle:@"已签到" forState:UIControlStateNormal];
                signBtn.enabled = NO;
            }else{
                signBtn.enabled = YES;
                [signBtn setTitle:@"签到" forState:UIControlStateNormal];
                [signBtn addTarget:self action:@selector(signBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            }
            
        }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
}
-(void)signBtnClick:(UIButton*)sender{
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@Extra/mall/sign",BASEURL ];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"result==%@", result);
        if ([result[@"result_code"] integerValue]==1) {
            [signBtn setTitle:@"已签到" forState:UIControlStateNormal];
            signBtn.enabled = NO;
            [self tishiSting:@"签到成功，积分+20！"];
        }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
}
-(void)tishiSting:(NSString*)tishi{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    
    hud.label.text = NSLocalizedString(tishi, @"HUD message title");
    hud.label.font = [UIFont systemFontOfSize:13];
    hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
    [hud hideAnimated:YES afterDelay:3.f];
    
}

@end
