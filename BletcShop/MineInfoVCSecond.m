//
//  MineInfoVCSecond.m
//  BletcShop
//
//  Created by apple on 2017/6/30.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "MineInfoVCSecond.h"
#import "LZDUserInfoVC.h"
#import "ChangeLoginOrPayVC.h"
@interface MineInfoVCSecond ()
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation MineInfoVCSecond
- (IBAction)buttonClick:(UIButton *)sender {
    NSLog(@"%ld",(long)sender.tag);
    switch (sender.tag) {
        case 0:
        {
                LZDUserInfoVC *VC = [[LZDUserInfoVC alloc]init];
                [self.navigationController pushViewController:VC animated:YES];
        }
            break;
        case 1:
        {
            ChangeLoginOrPayVC *passVC=[[ChangeLoginOrPayVC alloc]init];
            [self.navigationController pushViewController:passVC animated:YES];
        }
            break;
        case 2:
        {
            NSString *urlStr = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@&pageNumber=0&sortOrdering=2&mt=8", @"1130860710"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
        }
            break;
            
        default:
            break;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bgView.layer.cornerRadius=6.0f;
    self.bgView.clipsToBounds=YES;
    LEFTBACK
    self.navigationItem.title=@"资料";
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
