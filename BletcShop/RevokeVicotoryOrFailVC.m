//
//  RevokeVicotoryOrFailVC.m
//  BletcShop
//
//  Created by apple on 2017/7/28.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "RevokeVicotoryOrFailVC.h"
#import "ComplainUnnormalVC.h"
#import "OtherCardComplainVC.h"
@interface RevokeVicotoryOrFailVC ()
@property (strong, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UIImageView *topTip;
@property (weak, nonatomic) IBOutlet UIImageView *bottomTip;



@property (strong, nonatomic) IBOutlet UIView *middleView;
@property (weak, nonatomic) IBOutlet UILabel *resultContent;



@property (strong, nonatomic) IBOutlet UIView *bottomView;

@end

@implementation RevokeVicotoryOrFailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"理赔结果";
    LEFTBACK
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithTitle:@"继续申请" style:UIBarButtonItemStylePlain target:self action:@selector(buttonClick)];
    self.navigationItem.rightBarButtonItem=rightItem;
    
    self.middleView.frame=CGRectMake(0, self.topView.bottom+10, SCREENWIDTH, self.resultContent.bottom+15);
    self.bottomView.frame=CGRectMake(0, self.middleView.bottom+10, SCREENWIDTH, 105);
    
    [self postRequestComplainProceed];
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
        if (result&&[result count]!=0) {
            NSString *reason=result[0][@"reason"];
            if ([reason isEqualToString:@"商家倒闭"]) {
                self.topTip.image=[UIImage imageNamed:@"选中sex"];
                self.bottomTip.image=[UIImage imageNamed:@"默认sex.png"];
            }else{
                self.topTip.image=[UIImage imageNamed:@"默认sex.png"];
                self.bottomTip.image=[UIImage imageNamed:@"选中sex"];
            }
        }
            
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"===%@",error);
        
    }];
    
}

-(void)buttonClick{
    NSLog(@"%@",self.dic);
    [self postRequestCompensateRevoke];
}
//撤销理赔
-(void)postRequestCompensateRevoke{
    
    NSString *url = [NSString stringWithFormat:@"%@UserType/claim/Revoke",BASEURL];
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
       
        if ([result[@"result_code"]integerValue]==1) {
             self.resultBlock(@"null");
            
//            if ([self.dic[@"card_type"] isEqualToString:@"储值卡"]) {
                ComplainUnnormalVC *vc=[[ComplainUnnormalVC alloc]init];
                NSMutableDictionary *dic=[self.dic mutableCopy];
                [dic setObject:@"null" forKey:@"claim_state"];
                vc.dic=dic;
                [self.navigationController pushViewController:vc animated:YES];
//            }else{
//                OtherCardComplainVC *vc=[[OtherCardComplainVC alloc]init];
//                NSMutableDictionary *dic=[self.dic mutableCopy];
//                [dic setObject:@"null" forKey:@"claim_state"];
//                vc.dic=dic;
//                [self.navigationController pushViewController:vc animated:YES];
//            }
        }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"===%@",error);
        
    }];
    
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
