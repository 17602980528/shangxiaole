//
//  AddFriendVC.m
//  BletcShop
//
//  Created by apple on 2017/6/30.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "AddFriendVC.h"
#import "AddFriendTableViewCell.h"
#import "MorePubTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "NewShopDetailVC.h"
@interface AddFriendVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UIImageView *noneData;
}
//tableview
@property (strong, nonatomic) IBOutlet UITableView *tableView;
//tableHead
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIImageView *head;
@property (strong, nonatomic) IBOutlet UILabel *nick;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;
//sectionHead
@property (strong, nonatomic) IBOutlet UIView *sectionHeadView;
@property (strong, nonatomic) IBOutlet UIButton *appriseButton;
@property (strong, nonatomic) IBOutlet UIButton *publishButton;
@property (strong, nonatomic) IBOutlet UIView *moveView;
@property (strong, nonatomic) IBOutlet UIButton *addFrdBtn;
@property (nonatomic)NSInteger apriseOrPublish;// 0 代表评价--1 代表发布
@property (weak, nonatomic) IBOutlet UIButton *priseButton;
@property (weak, nonatomic) IBOutlet UIButton *pubButton;
@property(nonnull,strong)NSMutableArray *noEvaluateShopArray;
@end

@implementation AddFriendVC
- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}
//已评价
- (IBAction)appriseBtnClick:(UIButton *)sender {
    noneData.hidden=YES;
    _apriseOrPublish=0;
    
    [UIView animateWithDuration:0.2 animations:^{
        CGPoint center=self.moveView.center;
        center.x=sender.center.x;
        self.moveView.center=center;
    }];
    [self.noEvaluateShopArray removeAllObjects];
    [self.tableView reloadData];
    
    [self postRequestEvaluate];
    
}
//已发布
- (IBAction)publishBtnClick:(UIButton *)sender {
    noneData.hidden=YES;
    [noneData removeFromSuperview];
    _apriseOrPublish=1;
    
    [UIView animateWithDuration:0.2 animations:^{
        CGPoint center=self.moveView.center;
        center.x=sender.center.x;
        self.moveView.center=center;
    }];
    [self.noEvaluateShopArray removeAllObjects];
    self.noEvaluateShopArray=[NSMutableArray arrayWithObject:self.dic];
   [self.tableView reloadData];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _apriseOrPublish=0;
    NSLog(@"self.dic====%@",self.dic);
    self.navigationController.navigationBar.hidden=YES;
//    self.addFrdBtn.layer.borderWidth=1.0f;
//    self.addFrdBtn.layer.borderColor=[RGB(237, 72, 77)CGColor];
//    self.addFrdBtn.layer.cornerRadius=6.0f;
//    self.addFrdBtn.clipsToBounds=YES;

    [[EMClient sharedClient].contactManager getContactsFromServerWithCompletion:^(NSArray *aList, EMError *aError) {
        
        AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];

        
        if ([aList containsObject:_dic[@"uuid"]] ||[appdelegate.userInfoDic[@"uuid"] isEqualToString:_dic[@"uuid"]]) {
            _addFrdBtn.hidden = YES;
        }
        
    }];
    
    _tableView.tableHeaderView=self.headerView;
    _tableView.estimatedRowHeight=500;
    _tableView.rowHeight=UITableViewAutomaticDimension;
    
    noneData=[[UIImageView alloc]initWithFrame:CGRectMake((SCREENWIDTH-100)/2, 350, 100, 100)];
    noneData.image=[UIImage imageNamed:@"无数据.png"];
    [self.view addSubview:noneData];
    
    [self postRequestEvaluate];
    
    [self.head sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HEADIMAGE,self.dic[@"headimage"]]] placeholderImage:[UIImage imageNamed:@"userHeader"]];
    self.head.layer.cornerRadius=32.5;
    self.head.clipsToBounds=YES;
    
    self.nick.text=self.dic[@"nickname"];
    
    [self.addFrdBtn addTarget:self action:@selector(addFriend:) forControlEvents:UIControlEventTouchUpInside];
}
//添加好友
-(void)addFriend:(UIButton*)sender{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"说点什么吧" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    // 请求信息
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"";
    }];
    
    // 获取alert中的文本输入框
    UITextField *descriptionFiled = [alert.textFields lastObject];
    
    // 添加按钮
    UIAlertAction *comitAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 如果附带信息输入为空,那么就自定义一个
        NSString *message = (descriptionFiled.text.length == 0)?@"我想加你":descriptionFiled.text;
        // 发送好友请求
        
        NSLog(@"account===%@",self.dic[@"uuid"]);
        [[EMClient sharedClient].contactManager addContact:self.dic[@"uuid"] message:message completion:^(NSString *aUsername, EMError *aError) {
            if (!aError) {
                NSLog(@"添加成功");
                
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                NSLog(@"添加失败");
                
            }
            
        }];
        
        
    }];
    // 取消按钮
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    // 添加两个按钮
    [alert addAction:cancelAction];
    [alert addAction:comitAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden=NO;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden=YES;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (_apriseOrPublish==0) {
         [_appriseButton setTitle:[NSString stringWithFormat:@"她的评价(%lu)",(unsigned long)self.noEvaluateShopArray.count] forState:UIControlStateNormal];
    }
    return self.sectionHeadView;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.noEvaluateShopArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //MorePubTableViewCell
    if (_apriseOrPublish==0) {
        static NSString *resuseIdentify=@"AddFriendTableCell";
        AddFriendTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:resuseIdentify];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"AddFriendTableViewCell" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor=[UIColor clearColor];
        }
        NSString *string=[NSString stringWithFormat:@"%@%@",HEADIMAGE,self.noEvaluateShopArray[indexPath.row][@"headimage"]];
        NSURL * nurl1=[NSURL URLWithString:[string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
        [cell.headImage sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"userHeader"] options:SDWebImageRetryFailed];
        cell.starRateView.currentScore=[self.noEvaluateShopArray[indexPath.row][@"stars"] floatValue];
        cell.nickName.text=self.noEvaluateShopArray[indexPath.row][@"nickname"];
        cell.shopName.text=self.noEvaluateShopArray[indexPath.row][@"store"];
        cell.appriseLable.text=self.noEvaluateShopArray[indexPath.row][@"content"];
        cell.publishTime.text=self.noEvaluateShopArray[indexPath.row][@"datetime"];
        cell.goShopDetailButton.tag=indexPath.row;
        [cell.goShopDetailButton addTarget:self action:@selector(goShopDetailButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }else{
        static NSString *resuseIdentifyss=@"MorePubCell";
        MorePubTableViewCell *cell2=[tableView dequeueReusableCellWithIdentifier:resuseIdentifyss];
        if (!cell2) {
            cell2 = [[[NSBundle mainBundle]loadNibNamed:@"MorePubTableViewCell" owner:self options:nil] lastObject];
            cell2.selectionStyle = UITableViewCellSelectionStyleNone;
            cell2.backgroundColor=[UIColor clearColor];
        }
        cell2.goShopBtn.tag=indexPath.row;
        [cell2.goShopBtn addTarget:self action:@selector(goNextVC:) forControlEvents:UIControlEventTouchUpInside];
        
        cell2.userNick.text=self.noEvaluateShopArray[indexPath.row][@"nickname"];
        NSString *string=[NSString stringWithFormat:@"%@%@",HEADIMAGE,self.noEvaluateShopArray[indexPath.row][@"headimage"]];
        NSURL * nurl1=[NSURL URLWithString:[string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
        [cell2.userHead sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"userHeader"] options:SDWebImageRetryFailed];
       cell2.starRateView.currentScore=5;
       cell2.publishDate.text=self.noEvaluateShopArray[indexPath.row][@"datetime"];
       cell2.cardTrade.text=self.noEvaluateShopArray[indexPath.row][@"trade"];
       cell2.cardRemain.text=[NSString stringWithFormat:@"￥%@",self.noEvaluateShopArray[indexPath.row][@"card_remain"]];
        cell2.shopName.text=self.noEvaluateShopArray[indexPath.row][@"store"];
        if ([self.noEvaluateShopArray[indexPath.row][@"method"] isEqualToString:@"transfer"]) {
            cell2.discription.text = [NSString stringWithFormat:@"【转让】现有%@%@元%@%@一张(%.1f折卡),%.1f折转让,需要的朋友尽快下手",self.noEvaluateShopArray[indexPath.row][@"store"],self.noEvaluateShopArray[indexPath.row][@"card_remain"],self.noEvaluateShopArray[indexPath.row][@"card_level"],self.noEvaluateShopArray[indexPath.row][@"card_type"],[self.noEvaluateShopArray[indexPath.row][@"rule"] floatValue]*0.1,[self.noEvaluateShopArray[indexPath.row][@"rate"] floatValue]*0.1];
        }else{
            cell2.discription.text = [NSString stringWithFormat:@"【分享】现有%@%@元%@%@一张(%g折卡),需要的朋友尽快下手,手续费仅(%@%%)",self.noEvaluateShopArray[indexPath.row][@"store"],self.noEvaluateShopArray[indexPath.row][@"card_remain"],self.noEvaluateShopArray[indexPath.row][@"card_level"],self.noEvaluateShopArray[indexPath.row][@"card_type"],[self.noEvaluateShopArray[indexPath.row][@"rule"] floatValue]*0.1,self.noEvaluateShopArray[indexPath.row][@"rate"]];
        }
        cell2.lllable.backgroundColor=[UIColor colorWithHexString:self.noEvaluateShopArray[indexPath.row][@"card_temp_color"]];
        
        cell2.lllable.text = [NSString stringWithFormat:@"VIP%@",self.noEvaluateShopArray[indexPath.row][@"card_level"]];
        
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:cell2.lllable.text];
        
        [attr setAttributes:@{NSForegroundColorAttributeName:RGB(253,108,110),NSFontAttributeName:[UIFont boldSystemFontOfSize:25]} range:NSMakeRange(0, 3)];
        
        [attr setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} range:NSMakeRange(3, cell2.lllable.text.length-3)];
        
        cell2.lllable.attributedText = attr;
        
        
        
        return cell2;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 45;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(void)postRequestEvaluate
{
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/evaluate/userGet",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.dic[@"uuid"] forKey:@"uuid"];
    
    NSLog(@"%@",params);
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         NSLog(@"result===%@", result);
         if (result&&[result count]>0) {
             NSMutableArray *evaluateArray = [result mutableCopy];
             self.noEvaluateShopArray = evaluateArray;;
             [_tableView reloadData];
             noneData.hidden=YES;
         }else{
             noneData.hidden=NO;
         }
         
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         //         [self noIntenet];
         NSLog(@"%@", error);
     }];
    
}
-(void)goShopDetailButtonClick:(UIButton *)sender{
    NewShopDetailVC *controller = [[NewShopDetailVC alloc]init];
    controller.videoID=@"";
    NSMutableDictionary *dic=[self.noEvaluateShopArray[sender.tag] mutableCopy];
    [dic setObject:dic[@"merchant"] forKey:@"muid"];
    controller.infoDic=dic;
    controller.title = @"商铺信息";
    [self.navigationController pushViewController:controller animated:YES];
}
-(void)goNextVC:(UIButton *)sender{
    NewShopDetailVC *controller = [[NewShopDetailVC alloc]init];
    controller.videoID=@"";
    controller.infoDic=self.noEvaluateShopArray[sender.tag];
    controller.title = @"商铺信息";
    [self.navigationController pushViewController:controller animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
