//
//  NewMyPayMentsVC.m
//  BletcShop
//
//  Created by apple on 2017/7/13.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "NewMyPayMentsVC.h"
#import "NewCardPayTableViewCell.h"
#import "NewCardBuyTableViewCell.h"
#import "NewAppriseVC.h"
@interface NewMyPayMentsVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *cardCostButton;
@property (weak, nonatomic) IBOutlet UIButton *buyCardButton;
@property (weak, nonatomic) IBOutlet UIView *moveLine;
@property (nonatomic)NSInteger apriseOrPublish;// 0 代表评价--1 代表发布

@end

@implementation NewMyPayMentsVC
- (IBAction)btnClick:(UIButton *)sender {
    if (sender.tag==1) {
        _apriseOrPublish=0;
        [UIView animateWithDuration:0.3 animations:^{
            CGPoint center=self.moveLine.center;
            center.x=sender.center.x;
            self.moveLine.center=center;
        }];
        [_tableView reloadData];
    }else{
        _apriseOrPublish=1;
        [UIView animateWithDuration:0.3 animations:^{
            CGPoint center=self.moveLine.center;
            center.x=sender.center.x;
            self.moveLine.center=center;
        }];
        [_tableView reloadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _apriseOrPublish=0;
    _tableView.estimatedRowHeight=200;
    _tableView.rowHeight=UITableViewAutomaticDimension;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_apriseOrPublish==0) {
        static NSString *resuseIdentify=@"NewCardPayssCell";
        NewCardPayTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:resuseIdentify];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"NewCardPayTableViewCell" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor=[UIColor clearColor];
        }
        cell.appriseBtn.tag=indexPath.row;
        [cell.appriseBtn addTarget:self action:@selector(appriseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }else{
        static NSString *resuseIdentify=@"NewCardBuyTabCell";
        NewCardBuyTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:resuseIdentify];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"NewCardBuyTableViewCell" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor=[UIColor clearColor];
        }
        return cell;
    }
    
}
-(void)appriseBtnClick:(UIButton *)sender{
    NSLog(@"sender.tag====%ld",(long)sender.tag);
    NewAppriseVC *newAppriseVC=[[NewAppriseVC alloc]init];
    [self.navigationController pushViewController:newAppriseVC animated:YES];
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
