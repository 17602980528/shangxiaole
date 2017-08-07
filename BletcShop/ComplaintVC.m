//
//  ComplaintVC.m
//  BletcShop
//
//  Created by Bletc on 2017/1/12.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "ComplaintVC.h"
#import "ComplaintDetailVC.h"
#import "ComplainProcessNormalVC.h"
#import "ComplainUnnormalVC.h"
@interface ComplaintVC ()
{
    UILabel *labl;
    
    UILabel *oldLab;
    
}
@property(nonatomic,strong)NSArray *complaint_A;

@end

@implementation ComplaintVC

-(NSArray *)complaint_A{
    if (!_complaint_A) {
        _complaint_A = @[@"商家倒闭",@"商家跑路",@"服务态度差",@"环境卫生差",@"直接申请理赔（只赔付卡内剩余金额）",@"其他"];
        
    }
    return _complaint_A;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"投诉";
   LEFTBACK
    self.view.backgroundColor = RGB(240, 240, 240);
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 30)];
    backView.backgroundColor= RGB(240, 240, 240);
    [self.view addSubview:backView];
    
    
    labl = [[UILabel alloc]initWithFrame:CGRectMake(16, 0, backView.width-16, backView.height)];
    labl.text = @"请选择投诉原因";
    labl.textColor = RGB(153,153,153);
    labl.font = [UIFont systemFontOfSize:13];
    [backView addSubview:labl];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.layer.cornerRadius = 5;
    button.backgroundColor = NavBackGroundColor;
    [button setTitle:@"提交" forState:0];
    button.titleLabel.font = [UIFont systemFontOfSize:18];
    [button addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    for (int i = 0; i < self.complaint_A.count; i ++) {
        UIView *listbackView = [[UIView alloc]initWithFrame:CGRectMake(0, backView.bottom + i *44, SCREENWIDTH, 44)];
        listbackView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:listbackView];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(12, listbackView.height-1, SCREENWIDTH, 1)];
        line.backgroundColor = RGB(234,234,234);
        [listbackView addSubview:line];
        
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, SCREENWIDTH-30, 43)];
        lab.textColor = RGB(51,51,51);
        lab.font = [UIFont systemFontOfSize:16];
        lab.text = _complaint_A[i];
        if (i==4) {
            NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString: _complaint_A[i]];
            [AttributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.0] range:NSMakeRange(6, 11)];
            
               [AttributedStr addAttribute:NSForegroundColorAttributeName value:RGB(192, 192, 192) range:NSMakeRange(6, 11)];
            lab.attributedText=AttributedStr;
        }
        
        [listbackView addSubview:lab];
        lab.userInteractionEnabled = YES;
        lab.tag = i;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
        
        [lab addGestureRecognizer:tap];
        
        
        if (i == _complaint_A.count-1) {
            line.backgroundColor = [UIColor clearColor];
            
            button.frame = CGRectMake(12, listbackView.bottom+36, SCREENWIDTH-24, 50);
            
 
        }
            UIImageView *imgView= [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-40, 7, 30, 30)];
            imgView.image = [UIImage imageNamed:@"settlement_unchoose_n"];
            [listbackView addSubview:imgView];
        
    }

}

-(void)tapClick:(UITapGestureRecognizer*)gesture{
    
    UILabel *lab = (UILabel*)gesture.view;
    
    for (UIView *objView in oldLab.superview.subviews) {
        if ([objView isKindOfClass:[UIImageView class]]) {
            UIImageView *imgV =(UIImageView*)objView;
                 imgV.image = [UIImage imageNamed:@"settlement_unchoose_n"];
            }
    }

    if (lab.tag ==_complaint_A.count-1) {
        ComplaintDetailVC *VC = [[ComplaintDetailVC alloc]init];
        VC.card_info = self.card_info;
        [self.navigationController pushViewController:VC animated:YES];
        
    }else if (lab.tag ==_complaint_A.count-2){
        ComplainUnnormalVC *vc=[[ComplainUnnormalVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        for (UIView *objView in lab.superview.subviews) {
            if ([objView isKindOfClass:[UIImageView class]]) {
                UIImageView *imgV =(UIImageView*)objView;
                                   imgV.image = [UIImage imageNamed:@"settlement_choose_n"];
                }
        }
 
    }
   
    oldLab = lab;

    NSLog(@"lab.tag==%ld",(long)lab.tag);
}
-(void)btnClick{
    NSLog(@"=====%@",oldLab.text);
    if (oldLab.text&&![oldLab.text isEqualToString:[self.complaint_A lastObject]]&&![oldLab.text isEqualToString:[self.complaint_A objectAtIndex:4]]) {
        NSString *url = [NSString stringWithFormat:@"%@UserType/complaint/commit",BASEURL];
        NSMutableDictionary *paramer = [NSMutableDictionary dictionary];
        
        AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        
        [paramer setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
        [paramer  setValue:self.card_info[@"merchant"] forKey:@"muid"];
        
        [paramer  setValue:oldLab.text forKey:@"reason"];
        
        
        [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
            
            NSLog(@"-----%@==%@",paramer,result);
            if ([result[@"result_code"] integerValue] ==1) {
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"投诉成功，是否查看投诉进度？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                [cancelAction setValue:RGB(51, 51, 51) forKey:@"titleTextColor"];
                
                UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    ComplainProcessNormalVC *complainProcessNormalVC=[[ComplainProcessNormalVC alloc]init];
                    complainProcessNormalVC.complainReason=oldLab.text;
                    [self.navigationController pushViewController:complainProcessNormalVC animated:YES];
                    
                }];
                [sureAction setValue:RGB(243, 73, 78) forKey:@"titleTextColor"];
                [alert addAction:cancelAction];
                [alert addAction:sureAction];
                
                [self presentViewController:alert animated:YES completion:nil];
                
            }
            
        } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"===%@",error);
            
        }];

    }else{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"请选择原因", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:13];
        [hud hideAnimated:YES afterDelay:2.f];
        
    }
    
}

@end
