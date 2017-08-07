//
//  InsureVC.m
//  BletcShop
//
//  Created by Bletc on 2017/7/10.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "InsureVC.h"
#import "UIImageView+WebCache.h"
@interface InsureVC ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation InsureVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"保障详情";
    LEFTBACK
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   return  self.insure_A.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SCREENWIDTH*2/3;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"insureID"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"insureID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH*2/3)];
    [cell addSubview:imgView];
    if (self.insure_A.count!=0) {
        
        NSDictionary *dic = _insure_A[indexPath.row];
        
        NSURL * nurl1=[[NSURL alloc] initWithString:[[INSURE_IMAGE stringByAppendingString:dic[@"image_url"]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
        [imgView sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"icon3.png"] options:SDWebImageRetryFailed];
        
        NSLog(@"nurl1-------%@",nurl1);
    }
    
    
    
    return cell;
    
    
}

@end
