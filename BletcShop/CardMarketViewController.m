//
//  CardMarketViewController.m
//  BletcShop
//
//  Created by Bletc on 2017/1/16.
//  Copyright © 2017年 bletc. All rights reserved.
//


#import "CardMarketViewController.h"
#import "AddressPickerDemo.h"
#import "CardmarketDetailVC.h"

#import "CardMarketCell.h"
#import "CardMarketModel.h"

#import "CardMarketSearchVC.h"

#import "JFCityViewController.h"
#import "BaseNavigationController.h"
#import "CardBusinessTableViewCell.h"
#import "AddFriendVC.h"
#import "LZDChartViewController.h"
#import "LandingController.h"
@interface CardMarketViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SelectCityDelegate>

{
    UIImageView *dingwei_img;
    UIView*searchView;
    UIButton *dingweiBtn;
    UITextField*search_tf; // placeholder
    UIView *topView;
    
    UIButton *oldBtn;
    
    UITableView *table_View;
    UIView *move_line;
    SDRefreshFooterView *_refreshFooter;
    SDRefreshHeaderView *_refreshheader;
    
    NSString *address_old;//之前的地址
    
}
@property(nonatomic,copy)NSString *cityChoice;//选择的地点
@property (nonatomic,assign)BOOL ifOpen;
@property(nonatomic,strong)UIView *areaView;

@property(nonatomic,copy) NSString *city_district;//市区
@property(nonatomic,strong)NSArray *areaListArray;
@property (nonatomic,strong)UICollectionView *collectionView;

@property(nonatomic,assign)int currentIndex1;

@end

@implementation CardMarketViewController


-(NSMutableArray *)data_A{
    if (!_data_A) {
        _data_A = [NSMutableArray array];
    }
    return _data_A;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden= YES;
    
    [self initTopView];
    
    
    
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden= NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGB(240, 240, 240);
    
    
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    self.city_district = [appdelegate.city stringByAppendingString:appdelegate.addressDistrite];
    
    
    self.cityChoice = appdelegate.cityChoice;
    
    self.currentIndex1 =1;
    
    
    
    NSLog(@"viewDidLoad===%@",self.city_district);
    if (!self.city_district) {
        self.city_district = @"西安市雁塔区";
    }
    
    
    [self initTableView];
    
    address_old = appdelegate.districtString.length>0?appdelegate.districtString:appdelegate.cityChoice;
    
    
}


//创建顶部导航
-(void)initTopView{
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPath = [bundle pathForResource:@"area" ofType:@"plist"];
    NSDictionary *area_dic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSArray *allCityKeys = [area_dic allKeys];
    NSMutableDictionary *allCityss = [NSMutableDictionary dictionary];
    
    for (int i = 0; i < allCityKeys.count; i ++) {
        [allCityss addEntriesFromDictionary:[area_dic objectForKey:[allCityKeys objectAtIndex:i]]];
    }
    self.areaListArray = [[NSArray alloc] initWithArray: [allCityss objectForKey: self.cityChoice]];
    
    
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    //    self.city_district = [appdelegate.city stringByAppendingString:appdelegate.addressDistrite];
    
    NSLog(@"initTopView=====%@",self.city_district);
    if (!self.city_district) {
        self.city_district = @"西安市雁塔区";
    }
    appdelegate.areaListArray = self.areaListArray;
    
    
    topView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 64)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    
    
    
    UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(15, 30, 11, 15)];
    imgV.image = [UIImage imageNamed:@"导航栏定位"];
    [topView addSubview:imgV];
    
    
    dingweiBtn = [[UIButton alloc]initWithFrame:CGRectMake(27, 20-5, 43, 44)];
    [dingweiBtn addTarget:self action:@selector(dingweiClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [dingweiBtn setTitle:appdelegate.districtString.length>0?appdelegate.districtString:appdelegate.cityChoice forState:UIControlStateNormal];
    [dingweiBtn setTitleColor:RGB(119,119,119) forState:UIControlStateNormal];
    dingweiBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [topView addSubview:dingweiBtn];
    
    
    CGFloat ww = [dingweiBtn.titleLabel.text boundingRectWithSize:CGSizeMake(200, 44) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:dingweiBtn.titleLabel.font} context:nil].size.width;
    
    NSLog(@"--------------%f",ww);
    
    CGRect btn_frame = dingweiBtn.frame;
    btn_frame.size.width =  ww<43 ? 43:58;
    dingweiBtn.frame = btn_frame;
    
    dingwei_img = [[UIImageView alloc]initWithFrame:CGRectMake(dingweiBtn.right, dingweiBtn.top+(44-12)/2, 12, 12)];
    dingwei_img.image = [UIImage imageNamed:@"下拉（灰）"];
    [topView addSubview:dingwei_img];
    
    
    
    searchView=[[UIView alloc]init];
    searchView.frame=CGRectMake(dingwei_img.right+13, 24, SCREENWIDTH-(dingwei_img.right-13)*2, 28);
    searchView.backgroundColor=RGB(221,221,221);
    searchView.layer.cornerRadius=12;

    [topView addSubview:searchView];
    
    
    UIImageView *search1= [[UIImageView alloc]initWithFrame:CGRectMake(11, 5+2, 14, 14)];
    search1.image = [UIImage imageNamed:@"灰色搜索icon"];
    [searchView addSubview:search1];
    
    
    search_tf=[[UITextField alloc]initWithFrame:CGRectMake(search1.right+10, 8, searchView.width-(search1.right+10), 20)];
    search_tf.placeholder=@"总有一款适合你";
    search_tf.delegate=self;
    [search_tf setValue:[UIFont systemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    [search_tf setValue:RGB(153, 153, 153) forKeyPath:@"_placeholderLabel.color"];
    search_tf.userInteractionEnabled=NO;
    search_tf.alpha=0.8;
    [searchView addSubview:search_tf];
    
    UIButton *search_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    search_btn.frame = searchView.frame;
    [search_btn addTarget:self action:@selector(searchViewClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:search_btn];
    
    
    
    self.cityChoice = appdelegate.cityChoice;
    self.city_district = [NSString stringWithFormat:@"%@%@",appdelegate.cityChoice,[appdelegate.districtString isEqualToString:appdelegate.cityChoice] ? @"":appdelegate.districtString];
    
    
    
    NSLog(@"address_old------%@===%@",address_old,dingweiBtn.titleLabel.text);
    
    
    if (![address_old isEqualToString:dingweiBtn.titleLabel.text]) {
        address_old = dingweiBtn.titleLabel.text;
        _currentIndex1 = 1;
        [self getDataWithMore:_currentIndex1];

        
    }
    
    
}



-(void)initTableView{
    
    UIView *selectView = [[UIView alloc]initWithFrame:CGRectMake(0, 64+1, SCREENWIDTH, 42)];
    selectView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:selectView];
    NSArray *arr = @[@"二手卡",@"蹭卡"];
    
    
    for (int i = 0; i < arr.count; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i*SCREENWIDTH*0.5, 0, SCREENWIDTH*0.5, selectView.height);
        [button setTitle:arr[i] forState:0];
        button.titleLabel.font = [UIFont systemFontOfSize:17];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        [button setTitleColor:RGB(51, 51, 51) forState:0];
        [selectView addSubview:button];
        
        if (i == 0) {
            oldBtn = button;
            move_line = [[UIView alloc]init];
            move_line.bounds = CGRectMake(0, 0, 51, 1);
            move_line.center = CGPointMake(button.center.x, button.bottom-1);
            move_line.backgroundColor = RGB(228,96,98);
            [selectView addSubview:move_line];
        }
        
        
    }
    
    table_View = [[UITableView alloc]initWithFrame:CGRectMake(0, selectView.bottom+1, SCREENWIDTH, SCREENHEIGHT-(selectView.bottom+1)-self.tabBarController.tabBar.frame.size.height) style:UITableViewStyleGrouped];
    

    
    table_View.dataSource = self;
    table_View.delegate = self;
    table_View.separatorStyle= UITableViewCellSeparatorStyleNone;
    table_View.estimatedRowHeight = 92;
    
    [self.view addSubview: table_View];
    
    


    
    _refreshheader = [SDRefreshHeaderView refreshView];
    [_refreshheader addToScrollView:table_View];
    _refreshheader.isEffectedByNavigationController = NO;
    
    __block CardMarketViewController *blockSelf = self;
    _refreshheader.beginRefreshingOperation = ^{
        blockSelf.currentIndex1 = 1;
        [blockSelf.data_A removeAllObjects];
        [blockSelf getDataWithMore:blockSelf.currentIndex1];
    };
    
    
    _refreshFooter = [SDRefreshFooterView refreshView];
    [_refreshFooter addToScrollView:table_View];
    
    _refreshFooter.beginRefreshingOperation =^{
        [blockSelf getDataWithMore:++blockSelf.currentIndex1];
        
    };
    
    
    
    
    [self getDataWithMore:_currentIndex1];
    
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data_A.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat cellH = 0.1;
    
    if (self.data_A.count!=0) {
        CardMarketModel *m = self.data_A[indexPath.row];
        cellH = m.cellHight;
    }
    return cellH;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    CardMarketCell *cell = [CardMarketCell creatCellWithTableView:tableView];
    //
    //    if (self.data_A.count !=0) {
    //        cell.model = self.data_A[indexPath.row];
    //
    //    }
    CardBusinessTableViewCell *cell = [CardBusinessTableViewCell creatCellWithTableView:tableView];
    
    if (self.data_A.count !=0) {
        cell.model = self.data_A[indexPath.row];
        
    }
     cell.addFriendBtn.tag=indexPath.row;
    [cell.addFriendBtn addTarget:self action:@selector(addFriendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.contactButton.tag=indexPath.row;
     [cell.contactButton addTarget:self action:@selector(contactButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

//-(void)saveInfo:(NSString*)auserName{
//    NSString *url = [NSString stringWithFormat:@"%@Extra/IM/get",BASEURL];
//    
//    NSMutableDictionary *paramer = [NSMutableDictionary dictionary];
//    
//    [paramer setObject:auserName forKey:@"account"];
//    NSLog(@"-saveInfo--%@",paramer);
//    
//    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
//        
//        NSArray *arr = (NSArray *)result;
//        if (arr.count!=0) {
//            Person *p = [Person modalWith:arr[0][@"nickname"] imgStr:arr[0][@"headimage"]  idstring:arr[0][@"account"]];
//            
//            [Database savePerdon:p];
//        }
//        
//        
//    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//    }];
//    
//    
//}

-(void)contactButtonClick:(UIButton *)sender{
    
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    if (!appdelegate.IsLogin) {
        LandingController *landVc = [[LandingController alloc]init];
        [self.navigationController pushViewController:landVc animated:YES];
    }else{
        CardMarketModel *M=self.data_A[sender.tag];
        NSDictionary *dic=M.dic;
        //     [self saveInfo:dic[@"uuid"]];
        
        Person *p = [Person modalWith:dic[@"nickname"] imgStr:dic[@"headimage"]  idstring:dic[@"uuid"]];
        
        [Database savePerdon:p];
        
        
        NSLog(@"dic--dic==%@",dic);
        LZDChartViewController *chatCtr = [[LZDChartViewController alloc]init];
        [chatCtr setHidesBottomBarWhenPushed:YES];
        chatCtr.title=dic[@"nickname"];
        chatCtr.username = dic[@"uuid"];
        chatCtr.state=YES;
        NSLog(@"chatCtr.username---%@",chatCtr.username);
        
        
        chatCtr.chatType = EMChatTypeChat;
        
        [self.navigationController pushViewController:chatCtr animated:YES];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [_refreshFooter endRefreshing];
    [_refreshheader endRefreshing];
    
    CardmarketDetailVC *VC = [[CardmarketDetailVC alloc]init];
    VC.block = ^{
        _currentIndex1 = 1;
        [self getDataWithMore:_currentIndex1];
    };
    
    VC.model = self.data_A[indexPath.row];
    [self.navigationController pushViewController:VC animated:YES];
}
//搜索
-(void)searchViewClick{
    NSLog(@"搜索");
    CardMarketSearchVC *VC = [[CardMarketSearchVC alloc]init];
    
    [self.navigationController pushViewController:VC animated:YES];
}

-(void)goMineCenter:(UIButton*)sender{
    NSLog(@"闹铃");
    if (sender.tag==0) {
        //        ScanViewController *VC = [[ScanViewController alloc]init];
        //        [self.navigationController pushViewController:VC animated:YES];
        
    }else{
        
        [self showHint:@"暂未开放!"];
        
        
        //        NewMessageVC *VC = [[NewMessageVC alloc]init];
        //        [self.navigationController pushViewController:VC animated:YES];
    }
}
//定位
-(void)dingweiClick:(UIButton*)btn{
    NSLog(@"定位");
    
    
    JFCityViewController *cityViewController = [[JFCityViewController alloc] init];
    
    cityViewController.title = @"城市";
    __block typeof(self) weakSelf = self;
    [cityViewController choseCityBlock:^(NSString *cityName,NSString *eareName){
        
        
        AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        appdelegate.cityChoice= cityName;
        appdelegate.districtString = eareName.length>0 ? eareName:cityName;
        
        NSLog(@"-----%@====%@\\\\",cityName,eareName);
        
        
        [dingweiBtn setTitle:eareName.length>0 ? eareName:cityName forState:UIControlStateNormal];
        
        
        weakSelf.city_district = [NSString stringWithFormat:@"%@%@",cityName,eareName];
        
        [weakSelf resetFrame];
        
        
        //        [self getDataWithMore:@"one"];
        
        
        
        
    }];
    BaseNavigationController *navigationController = [[BaseNavigationController alloc]initWithRootViewController:cityViewController];
    
    [self presentViewController:navigationController animated:YES completion:nil];
    
    
}
#pragma mark 选则城市delegate
-(void)senderSelectCity:(NSString *)selectCity{
    self.city_district = [selectCity stringByAppendingString:@"市"];
    
    
    
    NSLog(@"senderSelectCity==%@===%@",selectCity,self.city_district);
    _currentIndex1 = 1;
    [self getDataWithMore:_currentIndex1];
    
}
-(void)buttonClick:(UIButton*)sender{
    if (oldBtn !=sender) {
        oldBtn = sender;
        
        [UIView animateWithDuration:0.3 animations:^{
            move_line.center = CGPointMake(sender.center.x, sender.bottom-1);
            
        }];
        
        _currentIndex1 = 1;
        [self getDataWithMore:_currentIndex1];
        
    }
    
    
}

-(void)resetFrame{
    
    CGFloat ww = [dingweiBtn.titleLabel.text boundingRectWithSize:CGSizeMake(200, 44) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:dingweiBtn.titleLabel.font} context:nil].size.width;
    
    
    
    
    NSLog(@"--------------%f",ww);
    
    CGRect btn_frame = dingweiBtn.frame;
    btn_frame.size.width =  ww<43 ? 43:58;
    dingweiBtn.frame = btn_frame;
    
    dingwei_img.frame = CGRectMake(dingweiBtn.right, dingweiBtn.top+(44-12)/2, 12, 12);
    searchView.frame=CGRectMake(dingwei_img.right+13, 24, SCREENWIDTH-dingwei_img.right-13-35-35-15, 28);
    
    
}



-(void)getDataWithMore:(NSInteger )page{
    
    
    NSLog(@"oldBtn.tag---%ld===more:%ld",oldBtn.tag,page);
    NSString *url = [NSString stringWithFormat:@"%@UserType/CardMarket/get",BASEURL];
    
    NSMutableDictionary *paramer = [NSMutableDictionary dictionary];
    [paramer setValue:self.city_district forKey:@"address"];
    
    switch (oldBtn.tag) {
        case 0:
            [paramer setValue:@"transfer" forKey:@"method"];
            
            break;
        case 1:
            [paramer setValue:@"share" forKey:@"method"];
            
            break;
            
            
        default:
            break;
    }
    
    [paramer setValue:self.city_district forKey:@"address"];
    
   
        [paramer setValue:[NSString stringWithFormat:@"%ld",page] forKey:@"page"];
        
    if (page==1) {
        [self.data_A removeAllObjects];
        [table_View reloadData];
    }
    
    
    NSLog(@"CardMarket===%@",paramer);
    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        [_refreshheader endRefreshing];
        [_refreshFooter endRefreshing];
        NSLog(@"CardMarket===%@",result);
        
        NSArray *arr = (NSArray *)result;
        
        for (int i = 0; i <arr.count; i ++) {
            
            CardMarketModel *M = [[CardMarketModel alloc]intiWithDictionary:arr[i]];
            [self.data_A addObject:M];
        }
        
        
        
        
        
        [table_View reloadData];
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"=====%@",error);
        [_refreshheader endRefreshing];
        [_refreshFooter endRefreshing];
        
    }];
    
}
//
-(void)addFriendBtnClick:(UIButton *)sender{
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    if (!appdelegate.IsLogin) {
        LandingController *landVc = [[LandingController alloc]init];
        [self.navigationController pushViewController:landVc animated:YES];
    }else{
        AddFriendVC *vc=[[AddFriendVC alloc]init];
        CardMarketModel *M=self.data_A[sender.tag];
        vc.dic=M.dic;
        [self.navigationController pushViewController:vc animated:YES];
    }
}



@end
