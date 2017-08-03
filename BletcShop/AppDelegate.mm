//
//  AppDelegate.m
//  BletcShop
//
//  Created by wuzhengdong on 16/1/25.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "AppDelegate.h"
#import "MyPch.pch"
#import "MainTabBarController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "MBProgressHUD.h"
#import "Singleton.h"
#import "CanPayCardViewController.h"
#import "BaseNavigationController.h"
#import "WelcomViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"
#import "CardInfoViewController.h"
#import "RechargeViewController.h"
#import "MyMoneybagController.h"
#import "UpgradeViewController.h"
#import "UPPaymentControl.h"
#import "CardManagerViewController.h"
#import "LandingController.h"
#import "BaiduMapManager.h"
#import "BaseNavigationController.h"

#import <UMSocialCore/UMSocialCore.h>

#import "LZDBASEViewController.h"

#import "UIViewController+HUD.h"

#import "EMSDK.h"

#import "Base64.h"
#import "LZDRootViewController.h"
#import "XLAlertView.h"


#import "Database.h"
@interface AppDelegate ()<EMClientDelegate,EMContactManagerDelegate,EMGroupManagerDelegate>
{
    BMKGeoCodeSearch *_geocodesearch;
    BMKMapManager* _mapManager;
    CustomIOSAlertView *LZDAleterView;
    UIView *advise_back;
    
    UILabel *shopName_lab;//商户名
    
    UIImageView *upImg;//用户
    UIImageView *downImg;//商户
    
    NSInteger whichInter;
    
    MBProgressHUD *shophud;
    
    
}

@property (nonatomic,strong) UIImageView *imageView;

@property(nonatomic,strong)UIButton *jump_btn;//跳过
//
@property(nonatomic,strong)dispatch_source_t timer;


@end

@implementation AppDelegate
{
    UIBackgroundTaskIdentifier backgroundTask;
}


-(NSMutableDictionary *)userInfoDic{
    if (!_userInfoDic) {
        _userInfoDic = [NSMutableDictionary dictionary];
    }
    return  _userInfoDic;
}

-(NSMutableDictionary *)shopInfoDic{
    if (!_shopInfoDic) {
        _shopInfoDic = [NSMutableDictionary dictionary];
    }
    return _shopInfoDic;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
      
    if ([self exist]) {
        NSLog(@"数据库存在");
    }
    
    NSString *sss= @"123456789";

    NSLog(@"倒序:%@",[sss stringByReversed]);
    
    
    char a[]="MyPassword";        /*要加密的密码*/
    char b[]="cryptographic";     /*密钥*/
    int k;
    
    sss = [NSString stringWithCString:a encoding:NSUTF8StringEncoding];
    NSString *data_ =[sss base64EncodedString];
    
    NSLog(@"-----%@$$$$$$%@",data_,[data_ base64DecodedString]);
    NSLog(@"-----%@",sss);

    
    /*加密代码*/
    for(k=0;a[k]!='\0';k++)
        a[k]=a[k]^b[k];
    
    printf("You Password encrypted: %s\n",a);

    /*解密代码*/
    for(k=0;a[k]!='\0';k++)
        a[k]=a[k]^b[k];
    printf("You Password: %s\n",a);
    
    NSString *phon = @"17629002328";
    
    
    NSMutableString *muta_s = [NSMutableString stringWithString:@"abcdefghijklmnopqrst"];
    
    for (int i =0; i <phon.length; i ++) {
        
        char rr = [phon characterAtIndex:i];

       NSString *str =  [NSString stringWithFormat:@"%c",rr];
        
        [muta_s insertString:str atIndex:i*2+1];

    }
    
    NSLog(@"解密代码===%@",muta_s);
    
    

    
    
    
    //    [NSThread sleepForTimeInterval:5];
    _superAccoutArray=[NSArray array];
    [self superAccountTextListGet];
    self.whoPay = 0;
    self.payMoney = 0.0;
    self.paymentType = 0;
    self.socketPort = 30002;
    self.socketHost = @"101.201.100.191";
    
    self.cityChoice = @"西安市";
    self.districtString = @"雁塔区";
    self.shopArray = [[NSMutableArray alloc]init];
    self.areaListArray = [[NSArray alloc]init];
    self.shopPersonInfo = [[NSMutableArray alloc]init];
    
    self.menuString = [[NSString alloc]init];
    //self.menuString = @"all";
    self.userPassWordString = [[NSString alloc]init];
    self.userIDString = [[NSString alloc]init];
    self.addressInfo = [[NSString alloc]init];
    self.addressDistrite = [[NSString alloc]init];
    self.addressDistrite =@"全城";
    self.addressInfo = @"暂时定位不到当前位置";
    self.classify = [[NSString alloc]init];
    self.messagePay =[[NSString alloc]init];
    self.messagePayAll =[[NSString alloc]init];
    self.userPassWordString = @"";
    self.userIDString = @"";
    self.IsLogin = NO;
    self.shopIsLogin = NO;
    self.userInfoArray = [[NSMutableArray alloc]init];//用户登陆后信息数组
    self.shopUserInfoArray = [[NSMutableArray alloc]init];//商户信息数组
    self.payShopName =[[NSString alloc]init];//支付的店铺名
    self.payCardArray = [[NSMutableArray alloc]init];//可支付的卡
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
#pragma mark 环信
    [self initHuanXin];
    
    //设置根控制器
    NSDictionary *infoDic = [[NSBundle mainBundle]infoDictionary];
    // app版本
    NSString *app_Version = [infoDic objectForKey:@"CFBundleShortVersionString"];
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:app_Version]) {
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:app_Version];
        //        DebugLog("app_Version===%@",app_Version);
        WelcomViewController *WelcomVC = [[WelcomViewController alloc]init];
        self.window.rootViewController = WelcomVC;
    }else {
        
        MainTabBarController *mainTB = [[MainTabBarController alloc]init];
        self.window.rootViewController = mainTB;
        
        
        //加载广页

        [self initAdvertisePage];

      
        
        
        
        
        {
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
            if ([[defaults objectForKey:@"remeber"] isEqualToString:@"yes"]) {
                
                
                
                if ([defaults objectForKey:@"userID"]&&[defaults objectForKey:@"userpwd"])
                {
                    NSString *userID = [defaults valueForKey:@"userID"];
                    NSString *userPassWordString = [defaults valueForKey:@"userpwd"];
                    NSLog(@"remeber--user = %@-%@",userID,userPassWordString);
                    if (![userID isEqualToString:@""]&&![userPassWordString isEqualToString:@""]) {
                        [self postRequestLogin:userID andPassWord:userPassWordString];
                    }
                }
                
            }

            
            
        }
        
        
        
    }
    
    
    
    /***************************************************************/
    
    
    //验证码
    [CIA initWithAppId:@"f27c526d9cff4775a922a9d22ad7ee3b" authKey:@"a783e81e94fb4a6aab191a1d1209ab91"];
    
    //这里主要是针对iOS 8.0,相应的8.1,8.2等版本各程序员可自行发挥，如果苹果以后推出更高版本还不会使用这个注册方式就不得而知了……
    
    //    #ifdef __IPHONE_8_0
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        [application registerForRemoteNotifications];
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        //        DebugLog("--[application respondsToSelector:@selector(registerForRemoteNotifications)]---");
        
    }  else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
        //        DebugLog(@"--registerForRemoteNotificationTypes---");
        
    }
    
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    
    BOOL ret = [_mapManager start:@"9EyRNg7GH4lQoObVHOYEA7Mwn8F922SG" generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    BaiduMapManager *baiduMapManager = [BaiduMapManager shareBaiduMapManager];
    [baiduMapManager startUserLocationService];

    
    baiduMapManager.userAddressBlock = ^(BMKReverseGeoCodeResult *result) {
        self.addressInfo = result.address;
        self.addressDistrite = result.addressDetail.district;
        self.province =result.addressDetail.province;
        self.city =result.addressDetail.city;
        self.districtString =result.addressDetail.district;

        
    };
    baiduMapManager.userLocationBlock = ^(BMKUserLocation *location) {
        self.userLocation = location;
        
    };
    
    
//
    //按比例适配屏幕
    AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    if(SCREENHEIGHT == 667){
        
        myDelegate.autoSizeScaleX = 1.0;
        
        myDelegate.autoSizeScaleY = 1.0;
        
    }
    else{
        
        myDelegate.autoSizeScaleX = SCREENWIDTH/375;
        
        myDelegate.autoSizeScaleY = SCREENHEIGHT/667;
        
        
    }
    
    
    // 1.获得网络监控的管理者
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    
    // 2.设置网络状态改变后的处理
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变了, 就会调用这个block
        switch (status) {
            case AFNetworkReachabilityStatusUnknown: // 未知网络
                NSLog(@"未知网络");
                break;
                
            case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
                NSLog(@"没有网络(断网)");
                [self textExample];
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
                NSLog(@"手机自带网络");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
                NSLog(@"WIFI");
                break;
        }
    }];
    
    // 3.开始监控
    [mgr startMonitoring];
    
    
#pragma mark友盟配置
    
    [[UMSocialManager defaultManager] openLog:YES];
    
    [[UMSocialManager defaultManager]setUmSocialAppkey:@"57b151fe67e58ec90a000bca"];
    
    [[UMSocialManager defaultManager]setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx9ff00c1974e22928" appSecret:@"aaf33e2246f133e4d30ebc1ab6db2dfa" redirectURL:@"http://mobile.umeng.com/social"];
    
    
    
    [[UMSocialManager defaultManager]setPlaform:UMSocialPlatformType_Sina appKey:@"3250560160" appSecret:@"25ee0d2e21e73af9162c801381171e14" redirectURL:@"www.cnconsum.com"];
    
    
    [[UMSocialManager defaultManager]setPlaform:UMSocialPlatformType_QQ appKey:@"1105439953" appSecret:@"XmlGFpPTvzYfOjOe" redirectURL:@"http://mobile.umeng.com/social"];
    
    
   
    return YES;
}

-(void)initHuanXin{
    
#if DEBUG
    EMOptions *options = [EMOptions optionsWithAppkey:@"kb0824#vipcard"];
    
    
    //    options.apnsCertName = @"push_d";
#else
    EMOptions *options = [EMOptions optionsWithAppkey:@"kb0824#vipcard"];
    
    //    options.apnsCertName = @"release";
    
#endif
    
    [[EMClient sharedClient] initializeSDKWithOptions:options];
    
    //添加代理
    [[EMClient sharedClient]removeDelegate:self];
    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
    
    [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:nil];
    
    [[EMClient sharedClient].groupManager addDelegate:self delegateQueue:nil];
    // 自动登录
    if ([[EMClient sharedClient].options isAutoLogin]) {
        NSLog(@"正在自动登录");
    }
    
    
    [[EMClient sharedClient]getPushNotificationOptionsFromServerWithCompletion:^(EMPushOptions *aOptions, EMError *aError) {
        
        //        aOptions.displayStyle=EMPushDisplayStyleMessageSummary;
        //        DebugLog("aOptions----%@",aOptions);
    }];
    
}


/**
 在别的设备登录环信
 */
-(void)didLoginFromOtherDevice{
    DebugLog(@"didLoginFromOtherDevice");
    
    
    
#ifdef DEBUG
    
#else
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *sellerID = [defaults objectForKey:@"phone"];
    
    NSString *userID = [defaults objectForKey:@"userID"];
    DebugLog(@"sellerID==%@\nuserID=%@",sellerID,userID);
    
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    appdelegate.socketCutBy=1;
    [appdelegate cutOffSocket];
    
    
    if (userID) {
        
        
        
        [defaults removeObjectForKey:@"userID"];
        [defaults removeObjectForKey:@"userpwd"];
        [defaults removeObjectForKey:@"remeber"];
        [defaults synchronize];
        
        
        appdelegate.userInfoDic = nil;
        
        
        
        
        UIViewController *view =[self topViewController];
        
        
        
        if (view.tabBarController.selectedIndex==2) {
            
            UINavigationController *select_nav = view.tabBarController.selectedViewController;
            
            
            [view.tabBarController.selectedViewController popToRootViewControllerAnimated:YES];
            
            //            LandingController *LandVC = [[LandingController alloc]init];
            
            DebugLog(@"====%@",select_nav.topViewController);
            
            [select_nav.topViewController viewWillAppear:YES];
            
            [select_nav.topViewController showHint:@"您的账户已在别处登录"];
            
            
            
            
        }else{
            UINavigationController *select_nav = view.tabBarController.selectedViewController;
            
            
            view.tabBarController.selectedIndex = 2;
            
            
            
            UINavigationController *nav =   view.tabBarController.childViewControllers[2];
            [select_nav popToRootViewControllerAnimated:NO];
            
            [nav.topViewController showHint:@"您的账户已在别处登录"];
            
            
            
        }
        
        
        
    }else{
        
        [defaults removeObjectForKey:@"phone"];
        [defaults removeObjectForKey:@"passwd"];
        [defaults removeObjectForKey:@"log_type"];
        [defaults removeObjectForKey:@"remeberShop"];
        
        [defaults synchronize];
        
        
        
//        ShopLandController *shopvc = [[ShopLandController alloc]init];
//        
//        self.window.rootViewController = shopvc;
//        [shopvc showHint:@"您的账户已在别处登录"];
        
    }
    
    
    
#endif
    
    
    
}
-(void)didReceiveFriendInvitationFromUsername:(NSString *)aUsername message:(NSString *)aMessage{
    
    
    NSDictionary *dic =[[NSUserDefaults standardUserDefaults]objectForKey:@"FriendRequest"];
    
    NSMutableDictionary *dic2 = [NSMutableDictionary dictionaryWithDictionary:dic];
    if (!dic2) {
        dic2= [NSMutableDictionary dictionary];
    }
    
    
    
    [dic2 setObject:@{@"userName":aUsername,@"message":aMessage} forKey:aUsername];
    
    
    [[NSUserDefaults standardUserDefaults]setObject:dic2 forKey:@"FriendRequest"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    
    
    
    
    NSLog(@"- appdelegate-aUsername-%@===aMessage==%@",aUsername,aMessage);
    
    
}



- (void)didAutoLoginWithError:(EMError *)aError{
    
    if (!aError) {
        
        //        DebugLog("自动登录成功==%@",[[EMClient sharedClient] currentUsername]);
    }else{
        //        DebugLog("自动登录失败");
    }
    
}

- (void)groupInvitationDidReceive:(NSString *)aGroupId
                          inviter:(NSString *)aInviter
                          message:(NSString *)aMessage;{
    NSLog(@"====aGroupId=%@==aInviter=%@=aMessage=%@",aGroupId,aInviter,aMessage);
    
}
// 自动重连，只需要监听重连相关的回调，无需进行任何操作
- (void)didConnectionStateChanged:(EMConnectionState)connectionState
{
    NSLog(@"类型为 = %zd",connectionState);
    switch (connectionState) {
        case EMConnectionConnected:
        {
            NSLog(@"EMConnectionState连接成功");
        }
            break;
        case EMConnectionDisconnected:
        {
            NSLog(@"EMConnectionState未连接");
            
        }
            break;
            
        default:
            break;
    }
}

- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    self.userLocation = userLocation;
}
- (void)didFailToLocateUserWithError:(NSError *)error
{
    
    NSLog(@"userLocation = error");
}
-(void)cutOffSocket{
    if (self.socketCutBy==1) {
        
        
        if (self.shopIsLogin==YES)
        {
            NSString
            *str = [[NSString alloc]init];
            
            str = [[NSString alloc]initWithFormat:@"%@%@%@\r\n",LOGIN_SUCCESS,self.shopInfoDic[@"muid"],LOGIN_SUCCESS];
            NSData
            *dataStream  = [str
                            dataUsingEncoding:NSUTF8StringEncoding];
            [self.asyncSocketShop
             writeData:dataStream withTimeout:1
             
             tag:1];
            self.shopIsLogin=NO;
            [self.asyncSocketShop disconnect];
            NSLog(@"bbbbbbbbbbbbbbbbbb");
            
            
            
        }
        else if (self.IsLogin==YES) {
            NSString
            *str = [[NSString alloc]init];
            str = [[NSString alloc]initWithFormat:@"%@%@%@\r\n",LOGIN_SUCCESS,self.userInfoDic[@"uuid"],LOGIN_SUCCESS];
            NSData
            *dataStream  = [str
                            dataUsingEncoding:NSUTF8StringEncoding];
            
            [self._asyncSocket
             writeData:dataStream withTimeout:1
             
             tag:1];
            
            
            [__asyncSocket disconnect];
            
            
            self.IsLogin = NO;
            NSLog(@"eeeeeeeeeeeeeeeeeeeeeeeeeeee");
        }
        
    }
    
    
    
    
}


//断网提示遮罩
- (void)textExample {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
    
    // Set the annular determinate mode to show task progress.
    hud.mode = MBProgressHUDModeText;
    hud.label.text = NSLocalizedString(@"网络异常 请检查网络连接", @"HUD message title");
    hud.label.font = [UIFont systemFontOfSize:13];
    // Move to bottm center.
    //    hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
    //    hud.backgroundColor = [UIColor redColor];
    hud.frame = CGRectMake(0, 550, 375, 100);
    hud.userInteractionEnabled = YES;
    
    [hud hideAnimated:YES afterDelay:4.f];
}







#pragma mark 加载广告页面
-(void)initAdvertisePage{
    
    
    advise_back = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    advise_back.backgroundColor =[UIColor whiteColor];
    [self.window addSubview:advise_back];
    
    
    UIImageView *imageV =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    imageV.userInteractionEnabled = YES;
    imageV.contentMode =  UIViewContentModeScaleAspectFill;
    
    [advise_back addSubview:imageV];
    
    
    UIButton *jump_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    jump_btn.frame = CGRectMake(SCREENWIDTH*0.8-16, 16, SCREENWIDTH*0.2, SCREENWIDTH*0.098);
    [jump_btn setTitle:@"3跳过" forState:UIControlStateNormal];
    [jump_btn setTitleColor:[UIColor whiteColor] forState:0];
    jump_btn.titleLabel.font =[UIFont systemFontOfSize:14];
    jump_btn.backgroundColor=RGBA_COLOR(197, 197, 197, 0.7);
    
    jump_btn.alpha = 0.7;
    jump_btn.layer.cornerRadius= SCREENWIDTH*0.0098;
    jump_btn.clipsToBounds = YES;
    [jump_btn addTarget:self action:@selector(jumpClick) forControlEvents:UIControlEventTouchUpInside];
    [advise_back addSubview:jump_btn];
    
    self.jump_btn = jump_btn;
    [self TimeNumAction];
    
    
    NSString *url = [NSString stringWithFormat:@"%@MerchantType/advert/leadGet",BASEURL];
    NSMutableDictionary *paramer = [NSMutableDictionary dictionary];
    
    [paramer setValue:@"西安市雁塔区" forKey:@"eare"];
    
    
    
    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        NSLog(@"leadGet-----%@",result);
        [imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",STAR_ADVERTIMAGE,result[@"image_url"]]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (!image) {
                
                [UIImage imageNamed:@"ad_image"];
                
            }
            
        }];
        
        
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"leadGet--error---%@",error);
        imageV.image = [UIImage imageNamed:@"ad_image"];
        
    }];
    
}
-(void)jumpClick{
    [advise_back removeFromSuperview];
  
    
    //获得版本号
    //倒计时结束，关闭
    if (self.timer) {
        dispatch_source_cancel(self.timer);
        
    }
    self.timer = nil;
    
    
    [self getVersion_code];
    
}



//判断是否textField输入数字
- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string]; //定义一个NSScanner，扫描string
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}



-(void)socketConnectHostShop
{
    if (!_asyncSocketShop)
    {
        _asyncSocketShop=nil;
    }
    
    _asyncSocketShop = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    NSError *error = nil;
    [_asyncSocketShop connectToHost:self.socketHost onPort:self.socketPort withTimeout:-1 error:&error];
    if (error!=nil) {
        NSLog(@"_asyncSocketShop连接失败：%@",error);
    }else{
        NSLog(@"_asyncSocketShop连接成功");
    }
    
}
-(void)socketConnectHost
{
    if (!__asyncSocket)
    {
        __asyncSocket=nil;
    }
    
    __asyncSocket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    NSError *error = nil;
    [__asyncSocket connectToHost:self.socketHost onPort:self.socketPort withTimeout:-1 error:&error];
    if (error!=nil) {
        NSLog(@"__asyncSocket连接失败：%@",error);
    }else{
        NSLog(@"__asyncSocket连接成功");
    }
    
}

- (void)socket:(GCDAsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
    NSLog(@"willDisconnectWithError");
    //[self logInfo:FORMAT(@"Client Disconnected: %@:%hu", [sock connectedHost], [sock connectedPort])];
    if (err) {
        NSLog(@"错误报告：%@",err);
    }else{
        NSLog(@"连接工作正常");
    }
    __asyncSocket = nil;
}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"didConnectToHost");
    
    NSString *str = [[NSString alloc]init];
    if (self.IsLogin) {
        str = [[NSString alloc]initWithFormat:@"%@%@%@\r\n",USER_ROUND,self.userInfoDic[@"uuid"],USER_ROUND];
    }
    else if(self.shopIsLogin)
    {
        str = [[NSString alloc]initWithFormat:@"%@%@%@\r\n",USER_ROUND,self.shopInfoDic[@"muid"],USER_ROUND];
    }
    DebugLog(@"str==%@",str);
    NSData *writeData = [str dataUsingEncoding:NSUTF8StringEncoding];
    [sock writeData:writeData withTimeout:-1 tag:0];
    
    self.connectTimer
    = [NSTimer scheduledTimerWithTimeInterval:30
       
                                       target:self selector:@selector(longConnectToSocket)
                                     userInfo:nil repeats:YES];//
    //在longConnectToSocket方法中进行长连接需要向服务器发送的讯息
    [self.connectTimer fire];
    
    
    //[sock readDataToData:[AsyncSocket CRLFData] withTimeout:-1 tag:0];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    
    NSLog(@"didReadData");
    NSData *strData = [data subdataWithRange:NSMakeRange(0, [data length])];
    NSString *msg = [[NSString alloc] initWithData:strData encoding:NSUTF8StringEncoding];
    
    NSLog(@"messagePay%@",msg);
    if(sock==self._asyncSocket)
    {
        self.messagePay =[[NSString alloc] initWithData:strData encoding:NSUTF8StringEncoding];
        if([self.messagePay isEqualToString:@"*#heart#*"])
        {
            //            NSLog(@"self.messagePayheart%@",self.messagePay);
            return;
        }
        if (self.messagePay.length>4) {
            self.messagePayAll = [[NSString alloc]initWithString:self.messagePay];
        }
        //        NSLog(@"self.messagePay%@",self.messagePay);
        if([self.messagePay rangeOfString:PAY_NP].location ==NSNotFound)
        {
            //            NSLog(@"%@",msg);
        }
        else{
            //返回数据解析
            //            NSArray * infoArray= [msg componentsSeparatedByString:PAY_UORC];//根据su拆分成多个字符串
            //            if (infoArray.count>0) {
            //                for (int i=0; i<infoArray.count; i++) {
            //                    //获取每个数组里的项目和价格-(项目sm价格)
            //
            //                }
            //            }
            UIViewController *view = [self getCurrentRootViewController];
            NSLog(@"view%@",view);
            
            [self getShopName];//获取商户名
            [self NewAlertView];
            
        }
        
    }
    
    else
    {
        
        NSLog(@"self.asyncSocketShop");
    }
    
    [sock readDataWithTimeout:-1 tag:0]; //一直监听网络
    
}
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    
    NSLog(@"didDisconnect===%@",err);
    //    if (self.shopIsLogin) {
    //        [self socketConnectHostShop];
    //
    //    }
    
    
    //    [self socketConnectHost];
}


-(void)longConnectToSocket
{
    NSString
    *longConnect = @"*#heart#*\r\n";
    
    
    
    
    NSData
    *dataStream  = [longConnect
                    dataUsingEncoding:NSUTF8StringEncoding];
    
    
    
    if(self.IsLogin){
        [self._asyncSocket
         writeData:dataStream withTimeout:1
         
         tag:1];
    }else if (self.shopIsLogin)
    {
        [self.asyncSocketShop
         writeData:dataStream withTimeout:1
         
         tag:1];
        
    }
    
}
- (void)socket:(GCDAsyncSocket *)sock didReadPartialDataOfLength:(NSUInteger)partialLength tag:(long)tag{
    
    NSLog(@"didReadData`111");
}
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tagg {
    [sock readDataWithTimeout:-1 tag:0];
}


/**
 获取商户名
 */
-(void)getShopName{
    NSString *String_1 =  [[self.messagePay componentsSeparatedByString:PAY_TYPE] lastObject];
    NSArray *array_1 = [String_1 componentsSeparatedByString:PAY_USCS];
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/merchant/accountGet",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:array_1[0] forKey:@"muid"];
    [params setValue:@"store" forKey:@"type"];
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"result----%@",result);
        shopName_lab.text = result[@"store"];
        
        
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    
}

//弹出支付框
-(void)NewAlertView
{
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
    self.alertView = alertView;
    
    
    [alertView setContainerView:[self createDemoView]];
    
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"去支付", @"取消", nil]];
    [alertView setDelegate:self];
    
    [alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
        [alertView close];
    }];
    
    [alertView setUseMotionEffects:true];
    
    [alertView show];
}


- (UIView *)createDemoView
{
    NSArray * infoArray=[[NSArray alloc]init];
    UIView *demoView = [[UIView alloc] init];
    _type = [self.messagePay substringToIndex:1];
    
    NSLog(@"self.messagePay---%@",self.messagePay);
    NSLog(@"type====%@",_type);
    if ([_type isEqualToString:@"t"]) {
        
        
        
        if([self.messagePay rangeOfString:PAY_NP].location !=NSNotFound)
        {
            demoView.frame =CGRectMake(0, 0, 290, 80);
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 290, 40)];
            NSString *String_1 =  [[self.messagePay componentsSeparatedByString:PAY_TYPE] lastObject];
            NSArray *array_1 = [String_1 componentsSeparatedByString:PAY_USCS];
            
            self.payShopName = array_1[0];
            
            
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont boldSystemFontOfSize:13];
            [demoView addSubview:label];
            
            shopName_lab = label;
            
            NSString *detail = [array_1 lastObject];
            
            UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, 110, 40)];
            label1.textAlignment = NSTextAlignmentCenter;
            label1.font = [UIFont boldSystemFontOfSize:13];
            [demoView addSubview:label1];
            label1.text = @"消费次数";
            UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(170, 40, 110, 40)];
            priceLabel.textAlignment = NSTextAlignmentCenter;
            priceLabel.font = [UIFont boldSystemFontOfSize:13];
            [demoView addSubview:priceLabel];
            
            
            
            priceLabel.text = [[detail componentsSeparatedByString:PAY_NP] lastObject];
            self.payMoney = [priceLabel.text floatValue];;
            
            UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 40, 290, 0.3)];
            line1.backgroundColor = [UIColor grayColor];
            line1.alpha = 0.3;
            [demoView addSubview:line1];
        }
        
    }else{
        NSString *String_1 =  [[self.messagePay componentsSeparatedByString:PAY_TYPE] lastObject];//商户与消费信息
        NSArray *array_1 = [String_1 componentsSeparatedByString:PAY_USCS];
        
        if([self.messagePay rangeOfString:PAY_UORC].location !=NSNotFound)//_roaldSearchText
        {
            
            infoArray=[[array_1 lastObject] componentsSeparatedByString:PAY_UORC];//根据su拆分成多个字符串
            NSLog(@"yes");
        }
        else
        {
            if([self.messagePay rangeOfString:PAY_NP].location !=NSNotFound)
            {
                self.payMoney = 0.0;
                demoView.frame =CGRectMake(0, 0, 290, 80);
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 290, 40)];
                
                self.payShopName = [array_1 firstObject];
                
                NSLog(@"self.payShopName----%@",self.payShopName);
                //                label.text = @"修改昵称";
                label.textAlignment = NSTextAlignmentCenter;
                label.font = [UIFont boldSystemFontOfSize:13];
                [demoView addSubview:label];
                
                shopName_lab = label;
                
                UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, 110, 40)];
                label1.textAlignment = NSTextAlignmentCenter;
                label1.font = [UIFont boldSystemFontOfSize:13];
                [demoView addSubview:label1];
                
                label1.text = [[[array_1 lastObject]componentsSeparatedByString:PAY_NP] firstObject];
                
                UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(170, 40, 110, 40)];
                priceLabel.textAlignment = NSTextAlignmentCenter;
                priceLabel.font = [UIFont boldSystemFontOfSize:13];
                [demoView addSubview:priceLabel];
                priceLabel.text = [[[array_1 lastObject]componentsSeparatedByString:PAY_NP] lastObject];
                if ([priceLabel.text containsString:@"元"]) {
                    NSString *priceAll =[[priceLabel.text componentsSeparatedByString:@"元"]firstObject];
                    self.payMoney = [priceAll floatValue];
                    NSLog(@"===self.messagePay===%@",self.messagePay);
                    NSLog(@"WWWWWWWWWW%@",priceAll);
                    
                }else{
                    NSString *priceAll =priceLabel.text;
                    self.payMoney = [priceAll floatValue];
                    
                }
                
                UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 40, 290, 0.3)];
                line1.backgroundColor = [UIColor grayColor];
                line1.alpha = 0.3;
                [demoView addSubview:line1];
            }
        }
        if (infoArray.count>0) {
            self.payMoney = 0.0;
            demoView.frame =CGRectMake(0, 0, 290, 40*(infoArray.count+1));
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 290, 40)];
            
            shopName_lab = label;
            
            
            self.payShopName = [array_1 firstObject];
            //label.text = @"修改昵称";
            NSLog(@"self.payShopName--%@",self.payShopName);
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont boldSystemFontOfSize:13];
            [demoView addSubview:label];
            NSString *allPrice = [[NSString alloc]init];
            
            for(int i=0; i<infoArray.count; i++) {
                //获取每个数组里的项目和价格-(项目sm价格)
                if(i==0)
                {
                    NSString *tt_sm = infoArray[i];
                    
                    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 40*(i+1), 110, 40)];
                    label.textAlignment = NSTextAlignmentCenter;
                    label.font = [UIFont boldSystemFontOfSize:13];
                    [demoView addSubview:label];
                    
                    label.text = [[tt_sm componentsSeparatedByString:PAY_NP] firstObject];
                    UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(170, 40*(i+1), 110, 40)];
                    priceLabel.textAlignment = NSTextAlignmentCenter;
                    priceLabel.font = [UIFont boldSystemFontOfSize:13];
                    [demoView addSubview:priceLabel];
                    
                    priceLabel.text = [[tt_sm componentsSeparatedByString:PAY_NP] lastObject];
                    
                    allPrice =[[priceLabel.text componentsSeparatedByString:@"元"] firstObject];
                    
                    if ([priceLabel.text containsString:@"元"]) {
                        allPrice =[[priceLabel.text componentsSeparatedByString:@"元"]firstObject];
                        
                        
                    }else{
                        allPrice =priceLabel.text;
                        
                    }
                    
                    
                    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 40*(i+1), 290, 0.3)];
                    line1.backgroundColor = [UIColor grayColor];
                    line1.alpha = 0.3;
                    [demoView addSubview:line1];
                }
                else{
                    NSString *tt_sm = infoArray[i];
                    
                    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 40*(i+1), 110, 40)];
                    label.text = [[tt_sm componentsSeparatedByString:PAY_NP] firstObject];
                    label.textAlignment = NSTextAlignmentCenter;
                    label.font = [UIFont boldSystemFontOfSize:13];
                    [demoView addSubview:label];
                    
                    UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(170, 40*(i+1), 110, 40)];
                    priceLabel.textAlignment = NSTextAlignmentCenter;
                    priceLabel.font = [UIFont boldSystemFontOfSize:13];
                    [demoView addSubview:priceLabel];
                    
                    priceLabel.text = [[tt_sm componentsSeparatedByString:PAY_NP] lastObject];
                    
                    if ([priceLabel.text containsString:@"元"]) {
                        allPrice =[[priceLabel.text componentsSeparatedByString:@"元"]firstObject];
                        
                        
                    }else{
                        allPrice =priceLabel.text;
                        
                    }
                    
                    
                    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 40*(i+1), 290, 0.3)];
                    line1.backgroundColor = [UIColor grayColor];
                    line1.alpha = 0.3;
                    [demoView addSubview:line1];
                }
                self.payMoney = self.payMoney+=[allPrice floatValue];
                
            }
        }
    }
    NSLog(@"zzzzzzzzzzzzzzzzz%f",self.payMoney);
    return demoView;
}
- (void)customIOS7dialogButtonTouchUpInside: (CustomIOSAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    [alertView close];
    
    if (alertView.tag==0&&buttonIndex==1) {
        
    }
    else if (alertView.tag==0&&buttonIndex==0)
    {
        
        
//        [self postSocketPayAction];
        
    }
}



- (UIViewController*)topViewController
{
    return [self topViewControllerWithRootViewController:self.window.rootViewController];
}

- (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController
{
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}
//获取当前界面
-(UIViewController *)getCurrentRootViewController {
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    //    if([topVC isKindOfClass:[MainTabBarController class]])
    //    {
    //        return topVC;
    //        //return [(MainTabBarController *)topVC selectedViewController];
    //    }
    return topVC;
}




/**
 用户登录
 
 @param user     账户
 @param passWord 密码
 */
-(void)postRequestLogin:(NSString *)user andPassWord:(NSString*)passWord
{
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/user/login",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:user forKey:@"phone"];
    [params setObject:passWord forKey:@"passwd"];
    NSLog(@"postRequestLogin user = %@-%@",user,passWord);
    
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"%@", result);
        if ([[result objectForKey:@"result_code"]  isEqualToString: @"login_access"]) {
            NSLog(@"成功");
            NSArray *arr = result[@"info"];
            
            NSDictionary *user_dic = arr[0];
            
            
            self.userInfoDic = [NSMutableDictionary dictionaryWithDictionary:user_dic];
            
            self.IsLogin = YES;
            //            [self socketConnectHost];
            
            
            
        }
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        NSLog(@"%@", error);
    }];
    
}


-(BOOL) verify:(NSString *) resultStr {
    
    //验签证书同后台验签证书
    //此处的verify，商户需送去商户后台做验签
    return NO;
}


-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    NSLog(@"=====%@",url);
    [[UPPaymentControl defaultControl] handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data) {
        
        DebugLog(@"handlePaymentResult----%@",code);
        
        
        [[NSNotificationCenter defaultCenter]postNotificationName:ORDER_PAY_NOTIFICATION object:code];
        
        //结果code为成功时，先校验签名，校验成功后做后续处理
        if([code isEqualToString:@"success"]) {
            
            //判断签名数据是否存在
            if(data == nil){
                //如果没有签名数据，建议商户app后台查询交易结果
                return;
            }
            
            //数据从NSDictionary转换为NSString
            NSData *signData = [NSJSONSerialization dataWithJSONObject:data
                                                               options:0
                                                                 error:nil];
            NSString *sign = [[NSString alloc] initWithData:signData encoding:NSUTF8StringEncoding];
            
            
            
            //验签证书同后台验签证书
            //此处的verify，商户需送去商户后台做验签
            if([self verify:sign]) {
                //支付成功且验签成功，展示支付成功提示
            }
            else {
                //验签失败，交易结果数据被篡改，商户app后台查询交易结果
            }
            
            //            if (self.paymentType==4) {
            //                NSMutableDictionary  *card_dic = [NSMutableDictionary dictionaryWithDictionary:self.cardInfo_dic];
            //
            //                [card_dic setValue:self.payCardType forKey:@"card_level"];
            //                self.cardInfo_dic =  card_dic;
            //
            //            }
            
            //            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"支付成功" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"返回", nil];
            //            [alertView show];
        }
        else if([code isEqualToString:@"fail"]) {
            //交易失败
        }
        else if([code isEqualToString:@"cancel"]) {
            //交易取消
        }
    }];
    if ([url.host isEqualToString:@"safepay"])
    {
        //这个是进程KILL掉之后也会调用，这个只是第一次授权回调，同时也会返回支付信息
        [[AlipaySDK defaultService]processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSString * str = resultDic[@"result"];
            NSInteger orderState=[resultDic[@"resultStatus"] integerValue];
            
            NSLog(@"[[AlipaySDK defaultService]processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic)----%@",resultDic);
            if (orderState==9000) {
                if (self.whoPay==4) {
                    NSMutableDictionary  *card_dic = [NSMutableDictionary dictionaryWithDictionary:self.cardInfo_dic];
                    
                    [card_dic setValue:self.payCardType forKey:@"card_level"];
                    self.cardInfo_dic =  card_dic;
                    
                    
                }
                
            }
            NSLog(@"processAuth_V2Result==result = %@",str);
        }];
        //跳转支付宝钱包进行支付，处理支付结果，这个只是辅佐订单支付结果回调
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSString * query = [[url query] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            NSLog(@"processOrderWithPaymentResult=result = %@",resultDic);
            NSString * str = resultDic[@"memo"];
            NSInteger orderState=[resultDic[@"resultStatus"] integerValue];
            
            
            [[NSNotificationCenter defaultCenter]postNotificationName:ORDER_PAY_NOTIFICATION object:resultDic];
            
            if (orderState==9000)
            {
                
                //                if (self.whoPay==4) {
                //                    NSMutableDictionary  *card_dic = [NSMutableDictionary dictionaryWithDictionary:self.cardInfo_dic];
                //
                //                    [card_dic setValue:self.payCardType forKey:@"card_level"];
                //                    self.cardInfo_dic =  card_dic;
                //
                //                }
                
                
            }
            NSLog(@"memo = %@",str);
            
        }];
        
    }else if ([url.host isEqualToString:@"platformapi"]){
        //授权返回码
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"platformapi==result = %@",resultDic);
            NSInteger orderState=[resultDic[@"resultStatus"] integerValue];
            if (orderState==9000) {
                
                //                if (self.whoPay==4) {
                //                    NSMutableDictionary  *card_dic = [NSMutableDictionary dictionaryWithDictionary:self.cardInfo_dic];
                //
                //                    [card_dic setValue:self.payCardType forKey:@"card_level"];
                //                    self.cardInfo_dic =  card_dic;
                //
                //                }
                
                
            }
            
        }];
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSInteger orderState=[resultDic[@"resultStatus"] integerValue];
            
            
            NSLog(@"[[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic)---%@",resultDic);
            if (orderState==9000) {
                //                if (self.whoPay==4) {
                //                    NSMutableDictionary  *card_dic = [NSMutableDictionary dictionaryWithDictionary:self.cardInfo_dic];
                //
                //                    [card_dic setValue:self.payCardType forKey:@"card_level"];
                //                    self.cardInfo_dic =  card_dic;
                //
                //                }
                
                
            }
        }];
        
    }
    
    NSLog(@"UMSocialSnsService----%@",url);
    
    
    if ([[UMSocialManager defaultManager]handleOpenURL:url]) {
        return  [[UMSocialManager defaultManager]handleOpenURL:url];
    }
    //        if ([UMSocialSnsService handleOpenURL:url]) {
    //
    //            return  [UMSocialSnsService handleOpenURL:url];
    //
    //        }
    
    
    
    return YES;
}

// NOTE: 9.0以后使用新API接口

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    
    NSLog(@"=9.0====%@",url);
    
    [[UPPaymentControl defaultControl] handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data) {
        
        DebugLog(@"handlePaymentResult----%@",code);
        
        [[NSNotificationCenter defaultCenter]postNotificationName:ORDER_PAY_NOTIFICATION object:code];
        
        //结果code为成功时，先校验签名，校验成功后做后续处理
        if([code isEqualToString:@"success"]) {
            
            //判断签名数据是否存在
            if(data == nil){
                //如果没有签名数据，建议商户app后台查询交易结果
                return;
            }
            
            //数据从NSDictionary转换为NSString
            NSData *signData = [NSJSONSerialization dataWithJSONObject:data
                                                               options:0
                                                                 error:nil];
            NSString *sign = [[NSString alloc] initWithData:signData encoding:NSUTF8StringEncoding];
            
            
            
            //验签证书同后台验签证书
            //此处的verify，商户需送去商户后台做验签
            if([self verify:sign]) {
                //支付成功且验签成功，展示支付成功提示
            }
            else {
                //验签失败，交易结果数据被篡改，商户app后台查询交易结果
            }
            //            if (self.paymentType==4) {
            //                NSMutableDictionary *cardMutab_dic = [[NSMutableDictionary alloc]initWithDictionary:self.cardInfo_dic];
            //                [cardMutab_dic setValue:self.payCardType forKey:@"card_level"];
            //
            //
            //
            //                self.cardInfo_dic = cardMutab_dic;
            //
            //            }
            //            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"支付成功" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"返回", nil];
            //            [alertView show];
        }
        else if([code isEqualToString:@"fail"]) {
            //交易失败
        }
        else if([code isEqualToString:@"cancel"]) {
            //交易取消
        }
    }];
    if ([url.host isEqualToString:@"safepay"])
    {
        //这个是进程KILL掉之后也会调用，这个只是第一次授权回调，同时也会返回支付信息
        [[AlipaySDK defaultService]processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSString * str = resultDic[@"result"];
            NSInteger orderState=[resultDic[@"resultStatus"] integerValue];
            NSLog(@"[[AlipaySDK defaultService]processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic)----%@",resultDic);
            if (orderState==9000) {
                //                if (self.whoPay==4) {
                //                    NSMutableDictionary  *card_dic = [NSMutableDictionary dictionaryWithDictionary:self.cardInfo_dic];
                //
                //                    [card_dic setValue:self.payCardType forKey:@"card_level"];
                //                    self.cardInfo_dic =  card_dic;
                //
                //                }
                
            }
            NSLog(@"processAuth_V2Result==result = %@",str);
        }];
        //跳转支付宝钱包进行支付，处理支付结果，这个只是辅佐订单支付结果回调
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            
            
            NSLog(@"processOrderWithPaymentResult=result = %@",resultDic);
            NSString * str = resultDic[@"memo"];
            NSInteger orderState=[resultDic[@"resultStatus"] integerValue];
            
            
            [[NSNotificationCenter defaultCenter]postNotificationName:ORDER_PAY_NOTIFICATION object:resultDic];
            
            if (orderState==9000)
            {
                //                if (self.whoPay==4) {
                //                    NSMutableDictionary  *card_dic = [NSMutableDictionary dictionaryWithDictionary:self.cardInfo_dic];
                //
                //                    [card_dic setValue:self.payCardType forKey:@"card_level"];
                //                    self.cardInfo_dic =  card_dic;
                //
                //                }
                
            }
            NSLog(@"memo = %@",str);
            
        }];
        
    }else if ([url.host isEqualToString:@"platformapi"]){
        //授权返回码
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"platformapi==result = %@",resultDic);
            NSInteger orderState=[resultDic[@"resultStatus"] integerValue];
            if (orderState==9000) {
                //                if (self.whoPay==4) {
                //
                //                    NSMutableDictionary  *card_dic = [NSMutableDictionary dictionaryWithDictionary:self.cardInfo_dic];
                //
                //                    [card_dic setValue:self.payCardType forKey:@"card_level"];
                //                    self.cardInfo_dic =  card_dic;
                //                }
                
            }
            
        }];
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSInteger orderState=[resultDic[@"resultStatus"] integerValue];
            
            NSLog(@"[[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic)---%@",resultDic);
            if (orderState==9000) {
                //                if (self.whoPay==4) {
                //                    NSMutableDictionary  *card_dic = [NSMutableDictionary dictionaryWithDictionary:self.cardInfo_dic];
                //
                //                    [card_dic setValue:self.payCardType forKey:@"card_level"];
                //                    self.cardInfo_dic =  card_dic;
                //
                //                }
                
            }
        }];
        
    }
    
    NSLog(@"UMSocialSnsService----%@",url);
    
    if ([[UMSocialManager defaultManager]handleOpenURL:url]) {
        return  [[UMSocialManager defaultManager]handleOpenURL:url];
    }
    
    //    if ([UMSocialSnsService handleOpenURL:url]) {
    //
    //        return  [UMSocialSnsService handleOpenURL:url];
    //
    //    }
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    [[EMClient sharedClient] applicationDidEnterBackground:application];
    
    if (backgroundTask == UIBackgroundTaskInvalid)
    {
        backgroundTask = [[UIApplication sharedApplication]
                          beginBackgroundTaskWithExpirationHandler:^{
                              // local nitification
                   
                                      //                                      DebugLog("msg :
                                  
                                  //                                  [Tools scheduleLocalNotification:msg withAction:@"继续上传" userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:3],@"tag",[NSNumber numberWithInt:-1],@"index", nil]];
                          
                              [[UIApplication sharedApplication] endBackgroundTask:backgroundTask];
                              backgroundTask = UIBackgroundTaskInvalid;
                          }];
    }
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    [[EMClient sharedClient] applicationWillEnterForeground:application];
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    //    DebugLog("applicationWillTerminate");
    [[SDImageCache sharedImageCache]clearDisk];
    [[SDImageCache sharedImageCache]clearMemory];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"百度地图授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}





/**
 *  获得版本号
 */
-(void)getVersion_code{
    NSDictionary *infoDic = [[NSBundle mainBundle]infoDictionary];
    // app版本
    NSString *app_Version = [infoDic objectForKey:@"CFBundleShortVersionString"];
    
    
    NSString *url = [NSString stringWithFormat:@"%@Extra/source/version",BASEURL];
    
    NSMutableDictionary *paramer = [NSMutableDictionary dictionary];
    [paramer setValue:@"ios" forKey:@"type"];
    
    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        NSLog(@"===--%@",result);
        NSLog(@" app版本  %ld",(long)[app_Version compare:result[@"version"] options:NSNumericSearch]);
        
        if ([app_Version compare:result[@"version"] options:NSNumericSearch] < 0) {
            
            
//            LZDAleterView = [[CustomIOSAlertView alloc]init];
//            UIView *backView = [[UIView alloc]init];
//            backView.layer.cornerRadius =7;
//            backView.clipsToBounds = YES;
//            
//            [LZDAleterView setContainerView:backView];
//            
//            UIButton *titlebtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kWeChatScreenWidth*0.8, 40)];
//            [titlebtn setTitle:@"下载更新" forState:0];
//            
//            [titlebtn setTitleColor:[UIColor colorWithRed:0.0f green:0.5f blue:1.0f alpha:1.0f] forState:UIControlStateNormal];
//            [backView addSubview:titlebtn];
//            NSArray *update_content = result[@"update_content"];
//            NSString *content_S = @"";
//            for (NSString *str in update_content) {
//                content_S = [NSString stringWithFormat:@"%@\n%@",content_S,str];
//            }
//            
//            UILabel *contentLab = [[UILabel alloc]init];
//            contentLab.text =content_S;
//            contentLab.textColor =[UIColor blackColor];
//            contentLab.numberOfLines= 0;
//            contentLab.font = [UIFont systemFontOfSize:14];
//            CGFloat hh = [contentLab.text boundingRectWithSize:CGSizeMake(kWeChatScreenWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:contentLab.font} context:nil].size.height;
//            
//            contentLab.frame = CGRectMake(kWeChatScreenWidth*0.1, 40, kWeChatScreenWidth*0.7, hh+50);
//            [backView addSubview:contentLab];
//            
//            backView.frame= CGRectMake(0, 0, titlebtn.width, contentLab.bottom);
//            [LZDAleterView setParentView:self.window];
//            
//            [LZDAleterView setButtonTitles:[NSMutableArray arrayWithObjects:@"取消",@"去更新",  nil]];
//            
//            
//            [LZDAleterView setUseMotionEffects:YES];
//            
//            [LZDAleterView show];
//            
//            [LZDAleterView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
//                
//                [alertView close];
//                if (buttonIndex==1) {
//                    
//                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/shang-xiao-le/id1130860710?mt=8"]];
//                }
//                
//            }];
//        }
            NSArray *update_content = result[@"update_content"];
            NSString *content_S = @"";
            for (NSString *str in update_content) {
                if (content_S.length ==0) {
                    content_S = str;
                }else
                content_S = [NSString stringWithFormat:@"%@\n%@",content_S,str];
            }
            XLAlertView *xlAlertView = [[XLAlertView alloc]initWithTitle:@"版本更新" message:content_S sureBtn:@"立即更新" cancleBtn:@"下次提醒" logo:@"圆形logo" bgImageView:@"主题背景"];
            xlAlertView.resultIndex = ^(NSInteger index){
                //回调---处理一系列动作
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/shang-xiao-le/id1130860710?mt=8"]];
            };
            [xlAlertView showXLAlertView];
        }
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}


-(BOOL)exist{
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *filename = [path stringByAppendingPathComponent:@"database.sqlite"];
    NSLog(@"======%@",path);
    [Database sharedatabase];
    
    NSFileManager *FM = [NSFileManager defaultManager];
    if ([FM fileExistsAtPath:filename]) {
        return YES;
    }else{
        FMDatabase *db = [FMDatabase databaseWithPath:filename];
        if ([db open]) {
            BOOL result = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_person (id integer PRIMARY KEY AUTOINCREMENT, name text NOT NULL, imgstr text NOT NULL,idstring text NOT NULL);"];
            
            if (result){
                NSLog(@"创表成功");
            }else{
                NSLog(@"创表失败");
            }
            
        }else{
            
        }
        
    }
    return NO;
    
    
}



// 将得到的deviceToken传给SDK
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [[EMClient sharedClient] bindDeviceToken:deviceToken];
    NSLog(@"将得到的deviceToken传给SDK");
    
}
// 注册deviceToken失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"注册deviceToken失败error -- %@",error);
}



-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    
    NSLog(@"didReceiveRemoteNotification---%@",userInfo);
    
}

/**
 * 倒计时
 */
-(void)TimeNumAction
{
    
    __block int timeout = 3; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(self.timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(self.timer, ^{
        
        if(timeout<=0){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self jumpClick];
                
            });
        }else{
            int seconds = timeout % 60 ;
            NSString *strTime = [NSString stringWithFormat:@"%d跳过", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.jump_btn setTitle:strTime forState:0];
                NSLog(@"____%@",strTime);
                
                
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
    //    }
}


-(void)loginOutBletcShop{
    
    
    
    
    
    EMError *aError = [[EMClient sharedClient]logout:YES];
    if (aError) {
        [self loginOutBletcShop];
        NSLog(@"环信退出失败==%@",aError.errorDescription);
        
    }else{
        NSLog(@"环信退出成功");
        
    }
    
    
    
    
    
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    
    [defaults removeObjectForKey:@"phone"];
    [defaults removeObjectForKey:@"passwd"];
    [defaults removeObjectForKey:@"log_type"];
    [defaults removeObjectForKey:@"remeberShop"];
    
    
    [defaults removeObjectForKey:@"userID"];
    [defaults removeObjectForKey:@"userpwd"];
    [defaults removeObjectForKey:@"remeber"];
    
    
    [defaults removeObjectForKey:@"shopselectedIndex"];
    
    [defaults synchronize];
    self.socketCutBy=1;
    [self cutOffSocket];
}


// 本地通知回调函数，当应用程序在前台时调用
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    //    NSLog(@"noti:%@======%ld",notification,(long)application.applicationState);
    
    
    
    
    
    
    
    
}



-(void)superAccountTextListGet{
    
    
    NSString *url = [NSString stringWithFormat:@"%@Extra/source/superAccount",BASEURL];
    
    [KKRequestDataService requestWithURL:url params:nil httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        NSLog(@"===--%@",result);
        if (result) {
            _superAccoutArray=result;
        }
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}
@end
