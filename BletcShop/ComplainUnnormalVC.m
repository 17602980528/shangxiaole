//
//  ComplainUnnormalVC.m
//  BletcShop
//
//  Created by apple on 2017/7/27.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "ComplainUnnormalVC.h"

@interface ComplainUnnormalVC ()
@property (weak, nonatomic) IBOutlet UIImageView *topTip;
@property (weak, nonatomic) IBOutlet UIImageView *bottomTip;

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
@property(nonatomic,strong)NSArray *reasonArr;
@property(nonatomic,copy)NSString *reasonStr;
@end

@implementation ComplainUnnormalVC
-(NSArray *)reasonArr{
    if (!_reasonArr) {
        _reasonArr=@[@"商家倒闭",@"商家跑路"];
    }
    return _reasonArr;
}
- (IBAction)commitBtnClick:(id)sender {
    if (self.reasonStr&&![self.reasonStr isEqualToString:@""]) {
        [self postRequestComplain];
    }else{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"请选择原因", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:13];
        [hud hideAnimated:YES afterDelay:2.f];

    }
}

- (IBAction)chooseReasonBtnClick:(UIButton *)sender {
    self.reasonStr=self.reasonArr[sender.tag];
    if (sender.tag==0) {
        _topTip.image=[UIImage imageNamed:@"选中sex"];
        _bottomTip.image=[UIImage imageNamed:@"默认sex.png"];
    }else{
        _topTip.image=[UIImage imageNamed:@"默认sex.png"];
        _bottomTip.image=[UIImage imageNamed:@"选中sex"];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"理赔申请";
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString: _complainChoosement.text];
    [AttributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.0] range:NSMakeRange(4, 14)];
    
    [AttributedStr addAttribute:NSForegroundColorAttributeName value:RGB(192, 192, 192) range:NSMakeRange(4, 14)];
    self.complainChoosement.attributedText=AttributedStr;
    if ([self.dic[@"claim_state"] isEqualToString:@"null"]) {
         _proceedView.hidden=YES;
    }else{
        _proceedView.hidden=NO;
        [_commitButton setTitle:@"撤销理赔" forState:UIControlStateNormal];
    }
   
    
    [self postRequestComplainProceed];
}

-(void)postRequestComplain{
    NSString *url = [NSString stringWithFormat:@"%@UserType/complaint/commit",BASEURL];
    NSMutableDictionary *paramer = [NSMutableDictionary dictionary];
    
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    [paramer setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    [paramer  setValue:self.dic[@"merchant"] forKey:@"muid"];
    [paramer  setValue:self.dic[@"card_code"] forKey:@"card_code"];
    [paramer  setValue:self.dic[@"card_level"] forKey:@"card_level"];
    [paramer  setValue:self.dic[@"card_type"] forKey:@"card_type"];
    [paramer  setValue:self.reasonStr forKey:@"reason"];
    NSLog(@"paramer===>>%@",paramer);
    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"-----%@==%@",paramer,result);
        if ([result[@"result_code"] integerValue] ==1) {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提交申请成功！" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            

            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [sureAction setValue:RGB(243, 73, 78) forKey:@"titleTextColor"];
            [alert addAction:sureAction];
            [self presentViewController:alert animated:YES completion:nil];
            
        }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提交申请失败！" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            
            
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [sureAction setValue:RGB(243, 73, 78) forKey:@"titleTextColor"];
            [alert addAction:sureAction];
            [self presentViewController:alert animated:YES completion:nil];

        }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"===%@",error);
        
    }];

}
-(void)postRequestComplainProceed{//
    NSString *url = [NSString stringWithFormat:@"%@UserType/claim/get",BASEURL];
    NSMutableDictionary *paramer = [NSMutableDictionary dictionary];
    
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    [paramer setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    [paramer  setValue:self.dic[@"merchant"] forKey:@"muid"];
    [paramer  setValue:self.dic[@"card_code"] forKey:@"card_code"];
    [paramer  setValue:self.dic[@"card_level"] forKey:@"card_level"];
    [paramer  setValue:self.dic[@"card_type"] forKey:@"card_type"];
    
    NSLog(@"paramer===>>%@",paramer);
    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"-----%@==%@",paramer,result);
      
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"===%@",error);
        
    }];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
