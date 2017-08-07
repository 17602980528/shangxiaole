//
//  IntegralKnowledgeVC.m
//  BletcShop
//
//  Created by Bletc on 2017/7/20.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "IntegralKnowledgeVC.h"

@interface IntegralKnowledgeVC ()
@property (weak, nonatomic) IBOutlet UILabel *getLab;
@property (weak, nonatomic) IBOutlet UILabel *useLab;
@property (weak, nonatomic) IBOutlet UILabel *noticeLab;

@end

@implementation IntegralKnowledgeVC

- (void)viewDidLoad {
    [super viewDidLoad];
LEFTBACK
    self.navigationItem.title = @"积分知识";
    self.getLab.text = @" 1）完善个人信息，送20积分；\r 2）签到送20积分，连续签到第7天当天送50积分；\r 3）消费1元送1个积分；\r 4）每分享一次可得20积分，每天最多5次；\r 5）每推荐一位用户注册，送500积分；推荐新用户注册同时送5元红包；\r 6）每推荐一位商户入驻，送10000积分；推荐商户入驻同时送50元红包；\r 7）评价一次可得5积分；每消费1次享有1次评论送积分机会。\r\r 备注：以上积分按单次计算，累计可叠加。";
    
    self.useLab.text = @" 用户获取商消乐积分后，可在APP首页“会员中心”和我的“积分商城”中查询；\r 1）抵用现金：在商消乐购买产品时，系统显示是否使用积分及最大可使用积分数（100积分=1元）；\r 2）在“会员中心”的“积分商城”中可兑换商品。";
    self.noticeLab.text = @" 1）积分可以累积，有效期至次年年底，逾期自动作废（例如商消乐积分获取时间为2017年5月31日，有效期至2018年12月31日，过期作废）；\r 2）积分不能兑现，不可转让。";
    
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
