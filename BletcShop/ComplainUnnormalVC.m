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
@property (weak, nonatomic) IBOutlet UILabel *warmNotice;
@property (weak, nonatomic) IBOutlet UILabel *revokeResultNotice;//当为其它卡时，成功时显示。revokeResultNotice

@end

@implementation ComplainUnnormalVC
-(NSArray *)reasonArr{
    if (!_reasonArr) {
        _reasonArr=@[@"商家倒闭",@"商家跑路"];
    }
    return _reasonArr;
}
- (IBAction)commitBtnClick:(id)sender {
    
    if (![self.dic[@"claim_state"] isEqualToString:@"null"]){
        //调用撤销理赔接口,撤销成功后将calim_state换成null,还要将proceedview隐藏，上面的原因去掉;
        [self postRequestCompensateRevoke];
    }else{
        if (self.reasonStr&&![self.reasonStr isEqualToString:@""]) {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"理赔处理期间，您的卡片将停止一切操作和消费，您确定要投诉理赔吗？？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [cancelAction setValue:RGB(51, 51, 51) forKey:@"titleTextColor"];
            
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                 [self postRequestComplain];
            }];
            [sureAction setValue:RGB(243, 73, 78) forKey:@"titleTextColor"];
            
            [alert addAction:cancelAction];
            [alert addAction:sureAction];
            [self presentViewController:alert animated:YES completion:nil];
            
        }else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"请选择原因", @"HUD message title");
            hud.label.font = [UIFont systemFontOfSize:13];
            [hud hideAnimated:YES afterDelay:2.f];
            
        }
    }

}

- (IBAction)chooseReasonBtnClick:(UIButton *)sender {
   
    if (![self.dic[@"claim_state"] isEqualToString:@"null"]) {
       
    }else{
         self.reasonStr=self.reasonArr[sender.tag];
        if (sender.tag==0) {
            _topTip.image=[UIImage imageNamed:@"选中sex"];
            _bottomTip.image=[UIImage imageNamed:@"默认sex.png"];
        }else{
            _topTip.image=[UIImage imageNamed:@"默认sex.png"];
            _bottomTip.image=[UIImage imageNamed:@"选中sex"];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"理赔申请";
    LEFTBACK
    _proceedView.hidden=YES;
    
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString: _complainChoosement.text];
    [AttributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.0] range:NSMakeRange(4, 14)];
    
    [AttributedStr addAttribute:NSForegroundColorAttributeName value:RGB(192, 192, 192) range:NSMakeRange(4, 14)];
    self.complainChoosement.attributedText=AttributedStr;
    NSLog(@"???????%@",self.dic);
    if ([self.dic[@"claim_state"] isEqualToString:@"null"]||[self.dic[@"claim_state"] isEqualToString:@"COMMITTED"]) {
        self.commitButton.hidden=NO;
    }else{
        self.commitButton.hidden=YES;
    }
    
    if (![self.dic[@"claim_state"] isEqualToString:@"null"]) {
        [self.commitButton setTitle:@"撤销理赔" forState:UIControlStateNormal];
         [self postRequestComplainProceed];
    }else{
         [self.commitButton setTitle:@"提交" forState:UIControlStateNormal];
    }
    
    if (![self.dic[@"card_type"] isEqualToString:@"储值卡"]) {
        
        self.revokeResultNotice.hidden=NO;
        self.cardPrice.hidden=YES;
        self.cardReamin.hidden=YES;
        CGRect frame=self.complainMoney.frame;
        frame.size.height=0.01;
        self.complainMoney.frame=frame;
        
    }else{
        
        self.cardPrice.hidden=NO;
        self.cardReamin.hidden=NO;
        self.revokeResultNotice.hidden=YES;
    }
}

-(void)postRequestComplain{
    NSString *url = [NSString stringWithFormat:@"%@UserType/claim/commit",BASEURL];
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
            
             self.resultBlock(@"COMMITTED");
             [self.commitButton setTitle:@"撤销理赔" forState:UIControlStateNormal];
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提交申请成功！" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            

            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self postRequestComplainProceed];
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
        if (result) {
            if ([result count]==0) {
                _proceedView.hidden=YES;
            }else{
                _proceedView.hidden=NO;
                NSDictionary *dic=result[0];
                NSString *state=dic[@"state"];
                NSString *reason=dic[@"reason"];
                //
                NSMutableDictionary *new_dic=[self.dic mutableCopy];
                [new_dic setObject:state forKey:@"claim_state"];
                self.dic=new_dic;
               
                 self.resultBlock(state);
                if ([reason isEqualToString:@"商家倒闭"]) {
                    self.topTip.image=[UIImage imageNamed:@"选中sex"];
                    self.bottomTip.image=[UIImage imageNamed:@"默认sex.png"];
                }else{
                    self.topTip.image=[UIImage imageNamed:@"默认sex.png"];
                    self.bottomTip.image=[UIImage imageNamed:@"选中sex"];
                }
                //根据state获取进度
                if ([state isEqualToString:@"CHECK"]) {
                    self.lineTwo.backgroundColor=RGB(243, 73, 78);
                    self.lineThree.backgroundColor=RGB(222, 222, 222);
                    self.tipThree.backgroundColor=RGB(243, 73, 78);
                    self.tipFour.backgroundColor=RGB(222, 222, 222);
                    self.tipFive.backgroundColor=RGB(222, 222, 222);
                    //self.commitButton.hidden=YES;
                }else if ([state isEqualToString:@"CHECK_FAILED"]){
                    self.lineTwo.backgroundColor=RGB(243, 73, 78);
                    self.lineThree.backgroundColor=RGB(222, 222, 222);
                    self.tipThree.backgroundColor=RGB(243, 73, 78);
                    self.tipFour.backgroundColor=RGB(222, 222, 222);
                    self.tipFive.backgroundColor=RGB(222, 222, 222);
                    
                }else if([state isEqualToString:@"HANDLE"]){
                    self.lineTwo.backgroundColor=RGB(243, 73, 78);
                    self.lineThree.backgroundColor=RGB(222, 222, 222);
                    self.tipThree.backgroundColor=RGB(243, 73, 78);
                    self.tipFour.backgroundColor=RGB(243, 73, 78);
                    self.tipFive.backgroundColor=RGB(222, 222, 222);
                    //self.commitButton.hidden=YES;
                }else if ([state isEqualToString:@"ACCESS"]){
                    self.lineTwo.backgroundColor=RGB(243, 73, 78);
                    self.lineThree.backgroundColor=RGB(243, 73, 78);
                    self.tipThree.backgroundColor=RGB(243, 73, 78);
                    self.tipFour.backgroundColor=RGB(243, 73, 78);
                    self.tipFive.backgroundColor=RGB(243, 73, 78);
                    self.warmNotice.hidden=YES;
                    //self.commitButton.hidden=YES;
                    
                    self.comPlainResults.text=@"温馨提醒：您的理赔金额已赔付到商消乐钱包中，请注意查看。";
                    self.complainMoney.text=[NSString stringWithFormat:@"理赔金额：￥%@",dic[@"sum"]];
                    self.revokeResultNotice.text=[NSString stringWithFormat:@"商消乐平台根据专业计算，您申请理赔的卡的赔付金额为%@元。",dic[@"sum"]];
                    CGRect frame=self.complainMoney.frame;
                    frame.size.height=13;
                    self.complainMoney.frame=frame;
                }
            }
        }else{
             _proceedView.hidden=YES;
        }
      
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"===%@",error);
        
    }];

}
//撤销理赔
-(void)postRequestCompensateRevoke{
    
    NSString *url = [NSString stringWithFormat:@"%@UserType/claim/revoke",BASEURL];
    NSMutableDictionary *paramer = [NSMutableDictionary dictionary];
    
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    [paramer setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    [paramer  setValue:self.dic[@"merchant"] forKey:@"muid"];
    [paramer  setValue:self.dic[@"card_code"] forKey:@"card_code"];
    [paramer  setValue:self.dic[@"card_level"] forKey:@"card_level"];
    [paramer  setValue:self.dic[@"card_type"] forKey:@"card_type"];
    
    NSLog(@"paramer===+++++%@",paramer);
    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"-----%@==%@",paramer,result);
        if ([result[@"result_code"]integerValue]==1) {
            
            self.resultBlock(@"null");
            
            NSMutableDictionary *dic=[self.dic mutableCopy];
            [dic setObject:@"null" forKey:@"claim_state"];
            self.dic=dic;
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"撤销成功！" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [sureAction setValue:RGB(243, 73, 78) forKey:@"titleTextColor"];
            [alert addAction:sureAction];
            [self presentViewController:alert animated:YES completion:nil];
        }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"撤销失败！" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            
            
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
