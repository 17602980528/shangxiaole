//
//  AddFriendVC.m
//  BletcShop
//
//  Created by apple on 2017/6/30.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "AddFriendVC.h"
#import "AddFriendTableViewCell.h"
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

@end

@implementation AddFriendVC
- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}
//已评价
- (IBAction)appriseBtnClick:(UIButton *)sender {
    [UIView animateWithDuration:0.2 animations:^{
        CGPoint center=self.moveView.center;
        center.x=sender.center.x;
        self.moveView.center=center;
    }];
}
//已发布
- (IBAction)publishBtnClick:(UIButton *)sender {
    [UIView animateWithDuration:0.2 animations:^{
        CGPoint center=self.moveView.center;
        center.x=sender.center.x;
        self.moveView.center=center;
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden=YES;
    self.addFrdBtn.layer.borderWidth=1.0f;
    self.addFrdBtn.layer.borderColor=[RGB(237, 72, 77)CGColor];
    self.addFrdBtn.layer.cornerRadius=6.0f;
    self.addFrdBtn.clipsToBounds=YES;
    
    _tableView.tableHeaderView=self.headerView;
    _tableView.estimatedRowHeight=300;
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
    static NSString *resuseIdentify=@"AddFriendTableCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:resuseIdentify];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"AddFriendTableViewCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor clearColor];
    }
    return cell;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
