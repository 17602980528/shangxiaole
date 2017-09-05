//
//  OilCardManagerVC.m
//  BletcShop
//
//  Created by Bletc on 2017/8/8.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "OilCardManagerVC.h"
#import "OilManagerCell.h"
#import "OilCardRechargeVC.h"
#import "OilCardShareVC.h"

@interface OilCardManagerVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *redImg;
@property (weak, nonatomic) IBOutlet UIImageView *card_img;
@property (weak, nonatomic) IBOutlet UILabel *type_level;
@property (weak, nonatomic) IBOutlet UILabel *type_level1;
@property (weak, nonatomic) IBOutlet UILabel *storelab1;
@property (weak, nonatomic) IBOutlet UILabel *remainlab;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) IBOutlet UIView *sectionhead;
@property(nonatomic,strong)UITableView *tabView;

@property(nonatomic,strong)NSArray *data_A;
@end

@implementation OilCardManagerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"会员卡";
    LEFTBACK
     self.storelab1.text = self.card_dic[@"store"];
    self.card_img.backgroundColor = [UIColor colorWithHexString:self.card_dic[@"card_temp_color"]];
    
    self.type_level.text =  self.type_level1.text = [NSString stringWithFormat:@"%@(储值)",self.card_dic[@"card_type"]];
    
    
        self.remainlab.text = [NSString stringWithFormat:@"余额:%@元",self.card_dic[@"card_remain"]];
        

    
    UITableView *tabView = [[UITableView alloc]initWithFrame:CGRectMake(13, self.bottomView.height+212*LZDScale-3, SCREENWIDTH-26, SCREENHEIGHT-(self.bottomView.height+212*LZDScale-3)-99-37) style:UITableViewStyleGrouped];
  
    tabView.separatorStyle =UITableViewCellSeparatorStyleNone;
    tabView.delegate = self;
    tabView.dataSource = self;
    tabView.estimatedRowHeight = 100;
    tabView.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview:tabView];
    
    self.tabView =tabView;
    
    self.headerView.frame = CGRectMake(13, 212*LZDScale-21, SCREENWIDTH-26, 667);
    
    [self.view addSubview:self.headerView];

}


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.sectionhead;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data_A.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OilManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OilManagerCellID"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"OilManagerCell" owner:self options:nil] firstObject];
        
    }
    cell.addresslab.text = _data_A[indexPath.row];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self showHint:@"正在开发中..."];

}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
    if (scrollView.contentOffset.y<-50) {
        
        
        
        [UIView animateWithDuration:0.3 animations:^{
           
            if (_tabView.frame.origin.y == 0) {
                CGRect frame =_tabView.frame;
                frame.origin.y= self.bottomView.height+212*LZDScale-3;
                frame.size.height = SCREENHEIGHT-(self.bottomView.height+212*LZDScale-3)-99-37;

                _tabView.frame = frame;
                
            }

            
        }];
        
        
    }else if(scrollView.contentOffset.y>30){
        
        [UIView animateWithDuration:0.3 animations:^{
           
            if (_tabView.frame.origin.y!=0) {
                CGRect frame =_tabView.frame;
                frame.origin.y= 0;
                frame.size.height = SCREENHEIGHT-64-37;
                _tabView.frame = frame;
            }
            
           
            
        }];
    }
    
}

- (IBAction)addOilBtn:(id)sender {
    
    [self showHint:@"正在开发中..."];
}


- (IBAction)shouSuoBtn:(UIButton*)sender {
    
    
    if (sender.selected) {
        
        [UIView animateWithDuration:0.3 animations:^{
            
            self.redImg.transform = CGAffineTransformMakeRotation(M_PI);
            
            
            CGRect tabheaderFrame =  self.headerView.frame;
            
            tabheaderFrame.origin.y = SCREENHEIGHT-64-99;
            self.headerView.frame = tabheaderFrame;
            
            
        }];
        
    }else{
        
        
        
        
        [UIView animateWithDuration:0.3 animations:^{
            
            if (_tabView.frame.origin.y == 0) {
                CGRect frame =_tabView.frame;
                frame.origin.y= self.bottomView.height+212*LZDScale-3;
                frame.size.height = SCREENHEIGHT-(self.bottomView.height+212*LZDScale-3)-99-37;

                _tabView.frame = frame;
                
            }

            
            CGRect tabheaderFrame =  self.headerView.frame;
            
            tabheaderFrame.origin.y = self.card_img.bottom-21;
            self.headerView.frame = tabheaderFrame;
            
            
            
            
            
            
        } completion:^(BOOL finished) {
          
            
            self.redImg.transform = CGAffineTransformMakeRotation(0);
        }];
        
        
    }
    sender.selected = !sender.selected;
    

}

- (IBAction)rechargeORShare:(UIButton*)sender {
    
    if (sender.tag==0) {
        PUSH(OilCardRechargeVC)
    }else if (sender.tag== 1){
        PUSH(OilCardShareVC)
        
    }else
    [self showHint:@"正在开发中..."];

}





-(NSArray *)data_A{
    if (!_data_A) {
        _data_A = @[@"中国石化（西三环一站加油站",@"中国石化（红光路）",@"中国石化（宏宝加油站）",@"中国石化（聚家花园北）",@"中国石化（恒瑞加油站）",@"中国石化（枣园西路店）",@"中国石化（枣园东路店）",@"中国石化（富裕路店）",@"中国石化（人民西路店）",@"中国石化（咸户路店）"];
    }
    return _data_A;
}


@end
