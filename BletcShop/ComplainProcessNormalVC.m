//
//  ComplainProcessNormalVC.m
//  BletcShop
//
//  Created by apple on 2017/7/27.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "ComplainProcessNormalVC.h"

@interface ComplainProcessNormalVC ()
@property (weak, nonatomic) IBOutlet UIView *topBgView;
@property (weak, nonatomic) IBOutlet UILabel *compReason;
@property (weak, nonatomic) IBOutlet UIButton *cancelComplainButton;
@property (weak, nonatomic) IBOutlet UIView *lineTwo;
@property (weak, nonatomic) IBOutlet UIView *lineThree;
@property (weak, nonatomic) IBOutlet UIView *noticeThree;
@property (weak, nonatomic) IBOutlet UIView *noticeFouth;
@property (weak, nonatomic) IBOutlet UIView *noticeFive;

@end

@implementation ComplainProcessNormalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    LEFTBACK

    [self.view sendSubviewToBack:_topBgView];
    self.compReason.text=self.complainReason;
    self.navigationItem.title=@"投诉处理中";
}
- (IBAction)revealComplainBtnClick:(id)sender {
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
