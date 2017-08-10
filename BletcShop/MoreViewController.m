//
//  MoreViewController.m
//  BletcShop
//
//  Created by wuzhengdong on 16/1/25.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "MoreViewController.h"
#import "MoreViewCell.h"

#import "FeedBackViewController.h"
//#import "UMSocial.h"
#import <UMSocialCore/UMSocialCore.h>
#import "LZDConversationViewController.h"

#import "ShareViewController.h"

//#import "LZDCommonViewController.h"
#import "LZDBASEViewController.h"


#import "LZDContactViewController.h"

#import "SDImageCache.h"
#import "ContactSeverViewController.h"
#import "HotNewsVC.h"
@interface MoreViewController()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSArray *data;
@property(nonatomic,weak)UITableView *setTable;

@end

@implementation MoreViewController
{
    float folderSize ;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    folderSize =[[SDImageCache sharedImageCache] getSize]/1000.0/1000.0;

    [_setTable reloadData];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(240, 240, 240);
    self.navigationItem.title = @"设置";
    LEFTBACK
    [self _initTable];
    
    
}
-(NSArray *)data
{
    if (_data == nil) {
//        _data = @[@[@"联系共同会员",@"邀请好友使用"],@[@"退出",@"切换用户"],@[@"意见反馈"]];
        _data = @[@"清理缓存",@"意见反馈",@"联系客服",@"帮助中心"];

    }
    return _data;
}
-(void)_initTable
{
    UITableView *setTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) style:UITableViewStyleGrouped];
    setTable.backgroundColor=RGB(240, 240, 240);
    setTable.delegate = self;
    setTable.dataSource = self;
    setTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    setTable.showsVerticalScrollIndicator = NO;
   // setTable.bounces = NO;
    self.setTable = setTable;
    [self.view addSubview:setTable];
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 78;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 78)];
    view.backgroundColor=RGB(240, 240, 240);
    
    UIButton *loginOut=[UIButton buttonWithType:UIButtonTypeCustom];
    loginOut.frame=CGRectMake(13, 16, SCREENWIDTH-26, 46);
    loginOut.backgroundColor=[UIColor whiteColor];
    [loginOut setTitle:@"退出登录" forState:UIControlStateNormal];
    [loginOut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    loginOut.layer.cornerRadius=5.0f;
    loginOut.clipsToBounds=YES;
    [loginOut addTarget:self action:@selector(loginOutBtnClick) forControlEvents:UIControlEventTouchUpInside];
    loginOut.titleLabel.font=[UIFont systemFontOfSize:14.0f];
    [view addSubview:loginOut];
    
    return view;
}
//退出登录
-(void)loginOutBtnClick{
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    [appdelegate loginOutBletcShop];
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 14;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *resuseIdentify=@"moreViewCell";
    MoreViewCell *cell=[tableView dequeueReusableCellWithIdentifier:resuseIdentify];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MoreViewCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor clearColor];
        cell.contentView.backgroundColor=RGB(240, 240, 240);
    }
    if (indexPath.row==0) {
        cell.bgImageView.image=[UIImage imageNamed:@"导角矩形上"];
    }else if(indexPath.row==3){
        cell.bgImageView.image=[UIImage imageNamed:@"导角矩形下"];
    }else{
        cell.bgImageView.image=[UIImage imageNamed:@"设置   矩形"];
    }
    cell.title.text = self.data[indexPath.row];
    cell.headImageView.image = [UIImage imageNamed:self.data[indexPath.row]];

    if (indexPath.row==0) {
        cell.caches.text=[NSString stringWithFormat:@"%.2fM",folderSize];
        cell.caches.hidden=NO;
        cell.moreTip.hidden=YES;
    }else{
        cell.caches.hidden=YES;
        cell.moreTip.hidden=NO;
    }
    if (indexPath.row==3) {
        cell.line.hidden=YES;
    }else{
        cell.line.hidden=NO;
    }
    
    return cell;

    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
           if (indexPath.row==0) {
            [[SDImageCache sharedImageCache] clearDisk];
            [[SDImageCache sharedImageCache] clearMemory];//可有可无
            folderSize=0;
            [tableView reloadData];
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.frame = CGRectMake(0, 64, 375, 667);
            // Set the annular determinate mode to show task progress.
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"清理缓存成功", @"HUD message title");
            hud.label.font = [UIFont systemFontOfSize:13];
            hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
            [hud hideAnimated:YES afterDelay:2.f];
        }else if (indexPath.row==1){
            FeedBackViewController *feedBackView = [[FeedBackViewController alloc]init];
            [self.navigationController pushViewController:feedBackView animated:YES];
        }else if (indexPath.row==2){
            ContactSeverViewController *severVC=[[ContactSeverViewController alloc]init];
            [self.navigationController pushViewController:severVC animated:YES];
        }else{
            
            
            PUSH(HotNewsVC)

            vc.title = @"帮助中心";
            vc.href = @"http://www.cnconsum.com/cnconsum/helpCenter/user";

            
        }
        
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
