//
//  OilDetailsPageVC.m
//  BletcShop
//
//  Created by apple on 2017/8/8.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "OilDetailsPageVC.h"
#import "OneKeyOilVC.h"
#import "OilAppriseAndAunserTableViewCell.h"
#import "XHStarRateView.h"
#import "BuyOilCardVC.h"
@interface OilDetailsPageVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *tableHeaderView;
@property (strong,nonatomic)XHStarRateView *starRateView;
@property (weak, nonatomic) IBOutlet UIView *shopStars;
@property (strong, nonatomic) IBOutlet UIView *sectionHeadView;

@end

@implementation OilDetailsPageVC
- (IBAction)OneKeyOilBtnClick:(id)sender {
    OneKeyOilVC *vc=[[OneKeyOilVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)buyOilCardsBtnClick:(id)sender {
    
    PUSH(BuyOilCardVC)

    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"加油站详情";
    LEFTBACK
    self.starRateView = [[XHStarRateView alloc] initWithFrame:CGRectMake(0, 0, self.shopStars.frame.size.width,self.shopStars.frame.size.height)];
    self.starRateView.userInteractionEnabled=NO;
    self.starRateView.isAnimation = YES;
    self.starRateView.rateStyle = IncompleteStar;
    self.starRateView.tag = 1;
    self.starRateView.currentScore=5.0;
    [self.shopStars addSubview:self.starRateView];
    
    self.tableView.tableHeaderView=self.tableHeaderView;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return 113;
    }else if (indexPath.row==1){
        return 200;
    }
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 38;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.sectionHeadView;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OilAppriseAndAunserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OilAppriseAndAunserCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"OilAppriseAndAunserTableViewCell" owner:self options:nil] lastObject];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row==0) {
        cell.shopAnser.hidden=YES;
        cell.shopAnserTime.hidden=YES;
    }else{
        cell.shopAnser.hidden=NO;
        cell.shopAnserTime.hidden=NO;
    }
    return cell;
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
