//
//  PayVictoryVC.m
//  BletcShop
//
//  Created by apple on 2017/8/1.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "PayVictoryVC.h"
#import "ShaperView.h"
#import "NewMyPayMentsVC.h"
@interface PayVictoryVC ()
@property (weak, nonatomic) IBOutlet UILabel *realPayMoney;
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UILabel *cardType;
@property (weak, nonatomic) IBOutlet UILabel *oldPrice;
@property (weak, nonatomic) IBOutlet UILabel *currentPrice;
@property (weak, nonatomic) IBOutlet UIButton *checkCostRecord;
@property (weak, nonatomic) IBOutlet UIButton *backToCardManager;
@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (weak, nonatomic) IBOutlet UIView *shap1;
@property (weak, nonatomic) IBOutlet UIView *shap2;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation PayVictoryVC
- (IBAction)taskBtnClick:(UIButton *)sender {
    if (sender.tag==0) {
        NewMyPayMentsVC *vc=[[NewMyPayMentsVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title=@"支付完成";
    LEFTBACK
    
    self.leftView.layer.cornerRadius=8.0f;
    self.leftView.clipsToBounds=YES;
    self.rightView.layer.cornerRadius=8.0f;
    self.rightView.clipsToBounds=YES;
    
    self.checkCostRecord.layer.borderColor=RGB(102, 102, 102).CGColor;
    self.checkCostRecord.layer.borderWidth=1.0f;
    self.checkCostRecord.layer.cornerRadius=12.0f;
    self.checkCostRecord.clipsToBounds=YES;
    
    self.backToCardManager.layer.borderColor=RGB(102, 102, 102).CGColor;
    self.backToCardManager.layer.borderWidth=1.0f;
    self.backToCardManager.layer.cornerRadius=12.0f;
    self.backToCardManager.clipsToBounds=YES;
    
    CGRect frame1=self.shap1.frame;
    CGRect frame2=self.shap2.frame;
    
    ShaperView *viewr1=[[ShaperView alloc]initWithFrame:frame1];
    
    ShaperView *viewt1= [viewr1 drawDashLine:viewr1 lineLength:3 lineSpacing:3 lineColor:[UIColor colorWithRed:234/255.0f green:234/255.0f blue:234/255.0f alpha:1.0f]];
    [self.bgView addSubview:viewt1];
    
    ShaperView *viewr2=[[ShaperView alloc]initWithFrame:frame2];
    
    ShaperView *viewt2= [viewr2 drawDashLine:viewr2 lineLength:3 lineSpacing:3 lineColor:[UIColor colorWithRed:234/255.0f green:234/255.0f blue:234/255.0f alpha:1.0f]];
    [self.bgView addSubview:viewt2];
    NSLog(@"self.dic==========%@",self.dic);
    self.shopName.text=self.dic[@"store"];
    self.cardType.text=[NSString stringWithFormat:@"消费卡种：%@",self.dic[@"cardType"]];
    if ([self.dic[@"cardType"] isEqualToString:@"储值卡"]) {
        self.realPayMoney.hidden=NO;
        self.oldPrice.text=[NSString stringWithFormat:@"原价：%@",self.dic[@"oldNeed"]];
        self.currentPrice.text=[NSString stringWithFormat:@"现价：%@",self.dic[@"sum"]];
        self.currentPrice.hidden=NO;
        self.realPayMoney.text=[NSString stringWithFormat:@"￥%@",self.dic[@"sum"]];
        
    }else{
        self.realPayMoney.hidden=YES;
        self.currentPrice.hidden=YES;
        if ([self.dic[@"cardType"] isEqualToString:@"计次卡"]) {
            self.oldPrice.text=[NSString stringWithFormat:@"消费：%@次",self.dic[@"oldNeed"]];
        }else if([self.dic[@"cardType"] isEqualToString:@"套餐卡"]){
             self.oldPrice.text=[NSString stringWithFormat:@"消费项目：%@",self.dic[@"oldNeed"]];
        }else if ([self.dic[@"cardType"] isEqualToString:@"体验卡"]){
            self.oldPrice.text=[NSString stringWithFormat:@"消费：￥%@",self.dic[@"oldNeed"]];
        }
    }
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
