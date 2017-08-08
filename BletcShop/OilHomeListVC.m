//
//  OilHomeListVC.m
//  BletcShop
//
//  Created by apple on 2017/8/7.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "OilHomeListVC.h"
#import "OilListTableViewCell.h"
@interface OilHomeListVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableVeiw;

@end

@implementation OilHomeListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"加油站列表";
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 12;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 92;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OilListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FavorateTableCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"OilListTableViewCell" owner:self options:nil] lastObject];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
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
