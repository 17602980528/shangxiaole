//
//  NewAllCouponsVC.m
//  BletcShop
//
//  Created by apple on 2017/8/14.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "NewAllCouponsVC.h"

@interface NewAllCouponsVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *indicatorView;
@property (nonatomic,strong)NSMutableArray *shopCouponArray;

@end

@implementation NewAllCouponsVC
- (IBAction)goOutDateVC:(id)sender {
    
}
- (IBAction)getShopOrPlatCoupons:(UIButton *)sender {
    self.indicatorView.center=sender.center;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
