//
//  NewAppriseVC.m
//  BletcShop
//
//  Created by apple on 2017/7/12.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "NewAppriseVC.h"
#import "XHStarRateView.h"
@interface NewAppriseVC ()<UITextViewDelegate,XHStarRateViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *noticeLable;
@property (weak, nonatomic) IBOutlet UIView *starsView;
@property (weak, nonatomic) IBOutlet UIImageView *hideOrNotImage;
@property(nonatomic,assign) BOOL hide;
@property CGFloat indoorStars;
@end

@implementation NewAppriseVC
- (IBAction)hideOrShowNameBtnClick:(id)sender {
    if (_hide) {
        _hideOrNotImage.image=[UIImage imageNamed:@"默认sex"];
    }else{
        _hideOrNotImage.image=[UIImage imageNamed:@"选中sex"];
    }
    _hide=!_hide;
}
- (IBAction)publishAppriseBtnClick:(id)sender {
    if ([[_textView.text noWhiteSpaceString] isEqualToString:@""]) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"评价内容不能为空！" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertVC addAction:okAction];
        [self presentViewController:alertVC animated:YES completion:nil];
        

    }else{
        [self postSocketAppraise];
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"评价";
    _indoorStars=5.0;
    LEFTBACK
    XHStarRateView *star = [[XHStarRateView alloc] initWithFrame:CGRectMake(0, 0, _starsView.frame.size.width,_starsView.frame.size.height)];
    star.delegate=self;
    star.isAnimation = YES;
    star.rateStyle = IncompleteStar;
    star.tag = 1;
    star.currentScore=5.0;
    [_starsView addSubview:star];
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    _noticeLable.hidden=YES;
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@""]) {
        _noticeLable.hidden=NO;
    }
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [_textView resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    return YES;
}
-(void)starRateView:(XHStarRateView *)starRateView currentScore:(CGFloat)currentScore{
    NSLog(@"currentScore====%f",currentScore);
    _indoorStars=currentScore;
}
-(void)postSocketAppraise
{
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/evaluate/commit",BASEURL];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    [params setObject:self.evaluate_dic[@"merchant"] forKey:@"muid"];
    [params setObject:self.textView.text forKey:@"content"];
    NSString *stars = [[NSString alloc]initWithFormat:@"%.1f",_indoorStars];
    [params setObject:stars forKey:@"stars"];
    [params setObject:self.evaluate_dic[@"datetime"] forKey:@"datetime"];
    
    NSLog(@"%@",params);
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         NSLog(@"result====%@",result);
         
         if ([result[@"result_code"] intValue]==1) {

             UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"恭喜您，评价成功！" message:@"" preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                 [self.navigationController popViewControllerAnimated:YES];
             }];
             [alertVC addAction:okAction];
             [self presentViewController:alertVC animated:YES completion:nil];
         }else{
             UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"评价失败！" message:@"" preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                 
             }];
             [alertVC addAction:okAction];
             [self presentViewController:alertVC animated:YES completion:nil];
         }
         
         
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         NSLog(@"%@", error);
     }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
