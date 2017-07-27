//
//  ComplainUnnormalVC.m
//  BletcShop
//
//  Created by apple on 2017/7/27.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "ComplainUnnormalVC.h"

@interface ComplainUnnormalVC ()
@property (weak, nonatomic) IBOutlet UILabel *complainChoosement;
@property (weak, nonatomic) IBOutlet UILabel *cardPrice;
@property (weak, nonatomic) IBOutlet UILabel *cardReamin;
@property (weak, nonatomic) IBOutlet UILabel *complainMoney;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;
@property (weak, nonatomic) IBOutlet UIView *proceedView;
@property (weak, nonatomic) IBOutlet UIView *lineTwo;
@property (weak, nonatomic) IBOutlet UIView *lineThree;
@property (weak, nonatomic) IBOutlet UIView *tipThree;
@property (weak, nonatomic) IBOutlet UIView *tipFour;
@property (weak, nonatomic) IBOutlet UIView *tipFive;
@property (weak, nonatomic) IBOutlet UILabel *comPlainResults;

@end

@implementation ComplainUnnormalVC
- (IBAction)commitBtnClick:(id)sender {
}

- (IBAction)chooseReasonBtnClick:(UIButton *)sender {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"理赔申请";
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString: _complainChoosement.text];
    [AttributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.0] range:NSMakeRange(4, 14)];
    
    [AttributedStr addAttribute:NSForegroundColorAttributeName value:RGB(192, 192, 192) range:NSMakeRange(4, 14)];
    self.complainChoosement.attributedText=AttributedStr;
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
