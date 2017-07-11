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
@interface AddFriendVC ()<UITableViewDelegate,UITableViewDataSource>
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
@end

@implementation AddFriendVC
- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}
//已评价
- (IBAction)appriseBtnClick:(UIButton *)sender {
    _apriseOrPublish=0;
    
    [UIView animateWithDuration:0.2 animations:^{
        CGPoint center=self.moveView.center;
        center.x=sender.center.x;
        self.moveView.center=center;
    }];
    [_tableView reloadData];
    
}
//已发布
- (IBAction)publishBtnClick:(UIButton *)sender {
    _apriseOrPublish=1;
    
    [UIView animateWithDuration:0.2 animations:^{
        CGPoint center=self.moveView.center;
        center.x=sender.center.x;
        self.moveView.center=center;
    }];
    [_tableView reloadData];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _apriseOrPublish=0;
    
    self.navigationController.navigationBar.hidden=YES;
    self.addFrdBtn.layer.borderWidth=1.0f;
    self.addFrdBtn.layer.borderColor=[RGB(237, 72, 77)CGColor];
    self.addFrdBtn.layer.cornerRadius=6.0f;
    self.addFrdBtn.clipsToBounds=YES;
    
    _tableView.tableHeaderView=self.headerView;
    _tableView.estimatedRowHeight=500;
    _tableView.rowHeight=UITableViewAutomaticDimension;
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden=NO;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.sectionHeadView;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
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
        return cell;
    }else{
        static NSString *resuseIdentifyss=@"MorePubCell";
        MorePubTableViewCell *cell2=[tableView dequeueReusableCellWithIdentifier:resuseIdentifyss];
        if (!cell2) {
            cell2 = [[[NSBundle mainBundle]loadNibNamed:@"MorePubTableViewCell" owner:self options:nil] lastObject];
            cell2.selectionStyle = UITableViewCellSelectionStyleNone;
            cell2.backgroundColor=[UIColor clearColor];
        }
        return cell2;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 45;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
