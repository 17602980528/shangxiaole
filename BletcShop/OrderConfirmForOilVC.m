//
//  OrderConfirmForOilVC.m
//  BletcShop
//
//  Created by apple on 2017/8/8.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "OrderConfirmForOilVC.h"
#import "PayWaysForOilTableViewCell.h"
@interface OrderConfirmForOilVC ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *tableHeaderView;
@property(nonatomic,strong)NSMutableArray *dataArr;
@end

@implementation OrderConfirmForOilVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"订单确认";
    LEFTBACK
    self.tableView.tableHeaderView=self.tableHeaderView;
    NSArray *array=@[@{@"image":@"支付宝icon",@"title":@"支付宝支付",@"state":@"yes"},@{@"image":@"银联icon",@"title":@"银联支付",@"state":@"no"},@{@"image":@"商消乐钱包icon",@"title":@"商消乐钱包",@"state":@"no"},@{@"image":@"加油卡icon",@"title":@"加油卡",@"state":@"no"}];
    self.dataArr=[[NSMutableArray alloc]initWithArray:array];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return 48;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PayWaysForOilTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PayWaysForOilCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"PayWaysForOilTableViewCell" owner:self options:nil] lastObject];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    cell.payTitle.text=self.dataArr[indexPath.row][@"title"];
    cell.headImage.image=[UIImage imageNamed:self.dataArr[indexPath.row][@"image"]];
    if ([self.dataArr[indexPath.row][@"state"] isEqualToString:@"no"]) {
        cell.chooseState.image=[UIImage imageNamed:@"默认sex.png"];
    }else{
        cell.chooseState.image=[UIImage imageNamed:@"选中sex.png"];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    for (int i=0; i<self.dataArr.count; i++) {
        NSDictionary *dic=self.dataArr[i];
        NSMutableDictionary *mutDic=[dic mutableCopy];
        [mutDic setObject:@"no" forKey:@"state"];
        [self.dataArr replaceObjectAtIndex:i withObject:mutDic];
    }
    NSMutableDictionary *selectedDic=self.dataArr[indexPath.row];
    [selectedDic setObject:@"yes" forKey:@"state"];
    [self.dataArr replaceObjectAtIndex:indexPath.row withObject:selectedDic];
    [self.tableView reloadData];
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
