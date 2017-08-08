//
//  BuyOilDetailInfoVC.m
//  BletcShop
//
//  Created by Bletc on 2017/8/8.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "BuyOilDetailInfoVC.h"

@interface BuyOilDetailInfoVC ()<UITextFieldDelegate>
{
    UITapGestureRecognizer *old_tap;
    
    UIButton *old_btn;
}
@property (weak, nonatomic) IBOutlet UIButton *four_price_btn;
@property (weak, nonatomic) IBOutlet UITextField *price_TF;
@property (weak, nonatomic) IBOutlet UIButton *priceBtn;
@property (weak, nonatomic) IBOutlet UILabel *card_pricelab;
@property (weak, nonatomic) IBOutlet UILabel *realPayMoney;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *ali_tap;
@end

@implementation BuyOilDetailInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    LEFTBACK
    self.navigationItem.title = @"购买详情";
    old_tap = _ali_tap;
    old_btn = _priceBtn;
    
    _realPayMoney.text = _card_pricelab.text;

    

}
- (IBAction)chosePayment:(UITapGestureRecognizer *)sender {
    
    if (sender !=old_tap) {
        
        UIImageView *imgV = [sender.view viewWithTag:999];
        imgV.image = [UIImage imageNamed:@"选中sex.png"];
        
        UIImageView *imgV_old = [old_tap.view viewWithTag:999];
        imgV_old.image = [UIImage imageNamed:@"默认sex.png"];
        
        old_tap = sender;
    }
    
}
- (IBAction)priceBtnClick:(UIButton *)sender {
    
    NSLog(@"---%ld",sender.tag);
   
    if (old_btn != sender) {
        sender.layer.borderColor = RGB(243,73,78).CGColor;
        [sender setTitleColor:RGB(243,73,78) forState:0];
        
        old_btn.layer.borderColor = RGB(143,143,143).CGColor;
        [sender setTitleColor:RGB(143,143,143) forState:0];

        if (sender !=_four_price_btn) {
     
            [_price_TF resignFirstResponder];
            _price_TF.text = @"";
            _card_pricelab.text = [NSString stringWithFormat:@"￥：%.2f",[sender.titleLabel.text floatValue]];
            
            _realPayMoney.text = _card_pricelab.text;

        }
        
        
        old_btn = sender;
    }
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField ==_price_TF) {
        if (old_btn!=_four_price_btn) {
            [self priceBtnClick:_four_price_btn];
        }
 
        
    }
    
    
    return YES;
    
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField ==_price_TF) {
        NSString * new_text_str = [textField.text stringByReplacingCharactersInRange:range withString:string];//变化后的字符串
        _card_pricelab.text = [NSString stringWithFormat:@"￥：%.2f",[new_text_str floatValue]];
        _realPayMoney.text = _card_pricelab.text;

    }
    

    return YES;
}

- (IBAction)goToPay:(id)sender {
    
    if (old_tap.view.tag==0) {
        [self showHint:@"使用支付宝支付"];
    }
    if (old_tap.view.tag==1) {
        [self showHint:@"使用银联支付"];
    }

    if (old_tap.view.tag==2) {
        [self showHint:@"使用商消乐钱包支付"];
    }

}



@end
