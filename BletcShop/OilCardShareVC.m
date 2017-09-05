//
//  OilCardShareVC.m
//  BletcShop
//
//  Created by Bletc on 2017/9/5.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "OilCardShareVC.h"
#import "ShareCardCell.h"
@interface OilCardShareVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@end

@implementation OilCardShareVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"共享会员卡";
    
    LEFTBACK
    LZDButton *rightBtn = [LZDButton creatLZDButton];
    rightBtn.frame = CGRectMake(kWeChatScreenWidth-50, 20,40, 30);
    [rightBtn setTitle:@"添加" forState:0];
    [rightBtn setTitleColor:RGB(51, 51, 51) forState:0];
    
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem=rightButton;
    
    
    rightBtn.block = ^(LZDButton *btn){
        UIAlertView *aletView = [[UIAlertView alloc]initWithTitle:@"设置共享人" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [aletView setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
        
        
        
        UITextField *nameField = [aletView textFieldAtIndex:0];
        nameField.placeholder = @"请输入共享人姓名";
        nameField.delegate = self;
        
        UITextField *phoneField = [aletView textFieldAtIndex:1];
        phoneField.placeholder = @"请输入共享人手机号";
        phoneField.keyboardType = UIKeyboardTypeNumberPad;
        phoneField.secureTextEntry = NO;
        phoneField.delegate = self;
        
        [aletView show];
        
    };

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShareCardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (!cell) {
        cell = [[ShareCardCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
 
    
        cell.choseBtn.tag = indexPath.row;
        
        [cell.choseBtn addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
    return cell;

    
}

-(void)deleteClick:(UIButton*)sender{

    
    
    UIAlertView *altview = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定要删除该共享人?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    altview.tag = 999;
    
    [altview show];
    
    
}

#pragma mark alertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==999) {
        //删除共享人
        if (buttonIndex==1) {
            
            [self showHint:@"测试数据,不可删除!"];
            
          
        }
        
        
    }else{
        
        //添加共享人
        if (buttonIndex == alertView.firstOtherButtonIndex) {
            UITextField *nameField = [alertView textFieldAtIndex:0];
            UITextField *phoneField = [alertView textFieldAtIndex:1];
            
            if (nameField.text.length==0||phoneField.text.length==0) {
                
                [self showHint:@"请输入名字或手机号!"];

            }else{
                
                
                [self showHint:@"测试数据,不可修改!"];

                
            }
            
        }
        
    }
    
    
    
    
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
@end
