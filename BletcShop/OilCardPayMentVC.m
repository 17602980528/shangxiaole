//
//  OilCardPayMentVC.m
//  BletcShop
//
//  Created by Bletc on 2017/9/5.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "OilCardPayMentVC.h"
enum OrderTypes{
    
    Wares,
    points
    
};
enum PayTypes {
    Alipay,
    UPPay,
    WalletPay
} ;
@interface OilCardPayMentVC ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
@property(nonatomic,weak)UITableView*table_view;
@property enum PayTypes payType;

@end

@implementation OilCardPayMentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    LEFTBACK
    
    self.navigationItem.title  = @"支付方式";
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64) style:UITableViewStyleGrouped];
    table.delegate = self;
    table.dataSource = self;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.showsVerticalScrollIndicator = NO;
    table.bounces = NO;
    self.table_view = table;
    [self.view addSubview:table];
    
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.frame = CGRectMake(12, 300, SCREENWIDTH-24, 49);
    button.backgroundColor= NavBackGroundColor;
    [button setTitle:@"确定" forState:0];
    button.layer.cornerRadius = 5;
    button.titleLabel.font = [UIFont systemFontOfSize:17];
    [button setTitleColor:[UIColor whiteColor] forState:0];
    [button addTarget:self action:@selector(settlementClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section==0) {
        return 0.01;
        
    }else
        return 10;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0) {
        return 0.01;
    }else if(indexPath.section==1){
        return 51;
    }else{
        return 54;
    }
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0 || section==1) {
        return 0;
    }else
        return 3;
}



-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    for (UIView*view in cell.contentView.subviews ) {
        [view removeFromSuperview];
    }
    
    
    if (indexPath.section ==0) {
        
        
    }else if (indexPath.section==1){
      
        
    }else{
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(13, (51-31)/2, 31, 31)];
        [cell.contentView addSubview:imageView];
        
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(imageView.right+10, 0, 100, 51)];
        lable.textColor = RGB(51,51,51);
        lable.font = [UIFont systemFontOfSize:15];
        lable.numberOfLines=0;
        [cell.contentView addSubview:lable];
        
        UIImageView *image_select = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-30-13, (54-30)/2, 30, 30)];
        [cell.contentView addSubview:image_select];
        
        if (indexPath.row ==0) {
            lable.text = @"支付宝支付";
            if (self.payType==Alipay) {
                image_select.image = [UIImage imageNamed:@"settlement_choose_n"];
                
            }else{
                image_select.image = [UIImage imageNamed:@"settlement_unchoose_n"];
                
            }
            imageView.image = [UIImage imageNamed:@"支付宝支付L"];
            
            
        }else if(indexPath.row ==1){
            lable.text = @"银联支付";
            imageView.image = [UIImage imageNamed:@"银联支付L"];
            if (self.payType==UPPay) {
                image_select.image = [UIImage imageNamed:@"settlement_choose_n"];
                
            }else{
                image_select.image = [UIImage imageNamed:@"settlement_unchoose_n"];
                
            }
            
            
        }else if(indexPath.row ==2){
            lable.text = @"钱包支付";
            imageView.image = [UIImage imageNamed:@"钱包支付L"];
            if (self.payType==WalletPay) {
                image_select.image = [UIImage imageNamed:@"settlement_choose_n"];
                
            }else{
                image_select.image = [UIImage imageNamed:@"settlement_unchoose_n"];
                
            }
            
        }
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 54-1, SCREENWIDTH, 1)];
        line.backgroundColor = RGB(220,220,220);
        [cell.contentView addSubview:line];
        
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section ==2){
        
        self.payType = (int)indexPath.row;
        NSIndexSet *indexSet = [[NSIndexSet alloc]initWithIndex:2];
        [self.table_view reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
        
    }
}

-(void)settlementClick{
    
    
    if (self.payType==Alipay) {
        [self showHint:@"使用支付宝充值!"];

        
    }else  if (self.payType==UPPay) {
        
        
        
     
        
            [self showHint:@"使用银联充值!"];
     
        
        
    }else{
        
        [self showHint:@"使用钱包充值!"];

    }

    
}


@end
