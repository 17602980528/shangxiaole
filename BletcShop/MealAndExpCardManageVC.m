//
//  MealAndExpCardManageVC.m
//  BletcShop
//
//  Created by Bletc on 2017/6/29.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "MealAndExpCardManageVC.h"
#import "OrderViewController.h"
#import "ComplaintVC.h"
#import "NewShopDetailVC.h"
#import "MealCardPayVC.h"
#import "ExperienceCardGoToPayVC.h"
@interface MealAndExpCardManageVC ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *shopName1;
@property (weak, nonatomic) IBOutlet UILabel *typeAndLevel1;
@property (strong, nonatomic)  UITableView *table_View;
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UILabel *typeAndLevel;
@property (weak, nonatomic) IBOutlet UILabel *remainLab;
@property (weak, nonatomic) IBOutlet UILabel *startAndEndLab;
@property (weak, nonatomic) IBOutlet UILabel *card_contentLab;
@property (weak, nonatomic) IBOutlet UIButton *shousuoBtn;
@property (strong, nonatomic) IBOutlet UIView *tabheaderView;
@property (weak, nonatomic) IBOutlet UIView *content_back_View;
@property (weak, nonatomic) IBOutlet UIImageView *cardImgview;
@property (weak, nonatomic) IBOutlet UIImageView *redImg;

@property(nonatomic,strong)  NSArray *titles_array;
@property(nonatomic,strong) NSArray *imageNameArray;
@end

@implementation MealAndExpCardManageVC


-(NSArray *)titles_array{
    if (!_titles_array) {
        _titles_array = @[@"我要预约",@"投诉理赔"];
    }
    return _titles_array;
}
-(NSArray *)imageNameArray{
    if (!_imageNameArray) {
        _imageNameArray = @[@"vip_order_n",@"VIP_icon_comp_n"];
    }
    return _imageNameArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"会员卡";

    
    self.tabheaderView.frame = CGRectMake(13, self.cardImgview.bottom-52, SCREENWIDTH-26, 99);
    
    [self.view addSubview:self.tabheaderView];

    
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(13, self.tabheaderView.bottom, SCREENWIDTH-26, SCREENHEIGHT) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.showsVerticalScrollIndicator = NO;
    table.rowHeight = 42;
    table.backgroundColor = [UIColor clearColor];
    table.bounces = NO;
    self.table_View = table;
    [self.view addSubview:table];
    
    
    
    self.cardImgview.backgroundColor = [UIColor colorWithHexString:_card_dic[@"card_temp_color"]];
    self.shopName.text =self.shopName1.text = _card_dic[@"store"];

    self.typeAndLevel.text =self.typeAndLevel1.text = _card_dic[@"card_type"];
    if ([_card_dic[@"card_type"] isEqualToString:@"套餐卡"]) {
        self.remainLab.text = @"";

        [self getDataPost];

        self.startAndEndLab.text = @"长期有效，套餐用完为止。";
    }
    
    if ([_card_dic[@"card_type"] isEqualToString:@"体验卡"]) {
        self.remainLab.text = [NSString stringWithFormat:@"价值:%@",_card_dic[@"price"]];
        self.startAndEndLab.text = @"仅使用一次，长期有效。";

    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;

}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
//-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    return self.tabheaderView;
//}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titles_array.count+7;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIndentifier = @"cellIndentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if(cell==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        
    }
    if (indexPath.row<self.titles_array.count) {
        cell.textLabel.text=self.titles_array[indexPath.row];
        cell.imageView.image=[UIImage imageNamed:self.imageNameArray[indexPath.row]];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(13, 42-1, SCREENWIDTH-26, 1)];
        line.backgroundColor = RGB(220,220,220);
        [cell.contentView addSubview:line];

    }
    
    
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row==0) {
        
        [self  postRequestOrder];
    
    }
    
    
    
    if (indexPath.row==1) {
        
        
        ComplaintVC *VC = [[ComplaintVC alloc]init];
        VC.card_info = _card_dic;
        
        [self.navigationController pushViewController:VC animated:YES];
    }
}


-(void)getDataPost{
    
    
    [self showHudInView:self.view hint:@"加载中..."];
    
    NSString *url = [NSString stringWithFormat:@"%@UserType/MealCard/getOption",BASEURL];
    
    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSMutableDictionary*paramer = [NSMutableDictionary dictionary];
    [paramer setValue:self.card_dic[@"merchant"] forKey:@"muid"];
    
    [paramer setValue:app.userInfoDic[@"uuid"] forKey:@"uuid"];
    [paramer setValue:self.card_dic[@"card_code"] forKey:@"code"];
    
    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        [self hideHud];
        
        
        NSString *content_S ;
        for (NSDictionary *dic in result) {
            
                if (content_S.length ==0) {
                    content_S = [NSString stringWithFormat:@"%@   %@元   (可用%@次)",dic[@"name"],dic[@"price"],dic[@"option_count"]];
                }else
                    content_S = [NSString stringWithFormat:@"%@\n%@",content_S,[NSString stringWithFormat:@"%@   %@元   (可用%@次)",dic[@"name"],dic[@"price"],dic[@"option_count"]]];

            
            self.card_contentLab.text = content_S;
        }
        
        NSLog(@"------%@",result);
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        [self hideHud];
        
    }];
    
}



/**
 预约
 */
-(void)postRequestOrder
{
    //获取商家的商品列表
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/commodity/get",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    
    [params setObject:_card_dic[@"merchant"] forKey:@"muid"];
    
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"result = %@", result);
        
        OrderViewController *orderView = [[OrderViewController alloc]init];
        orderView.allClassArray =[NSMutableArray arrayWithArray:result];
        orderView.card_dic = _card_dic;
        
        
        [self.navigationController pushViewController:orderView animated:YES];
        
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
}
- (IBAction)shouSuoClcik:(UIButton*)sender {
    
    
    if (sender.selected) {
        
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = self.table_View.frame;
            
            frame.origin.y = SCREENHEIGHT;
            self.table_View.frame = frame;
            
            self.redImg.transform = CGAffineTransformMakeRotation(M_PI);
            
            
            CGRect tabheaderFrame =  self.tabheaderView.frame;
            
            tabheaderFrame.origin.y = SCREENHEIGHT-64-99;
            self.tabheaderView.frame = tabheaderFrame;
            
            
        }];
        
    }else{
        
        
        [UIView animateWithDuration:0.3 animations:^{
            
            CGRect tabheaderFrame =  self.tabheaderView.frame;
            
            tabheaderFrame.origin.y = self.cardImgview.bottom-21;
            self.tabheaderView.frame = tabheaderFrame;
            
            
            CGRect frame = self.table_View.frame;
            
            frame.origin.y = self.tabheaderView.bottom;
            self.table_View.frame = frame;
            
            
            
        } completion:^(BOOL finished) {
            
            
            self.redImg.transform = CGAffineTransformMakeRotation(0);
        }];
        
        
    }
    sender.selected = !sender.selected;
    
    
    
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
    
    
    
    if (scrollView.contentOffset.y<-100) {
        [UIView animateWithDuration:0.3 animations:^{
            
            self.shousuoBtn.selected = !self.shousuoBtn.selected;
            
            CGRect frame = self.table_View.frame;
            
            frame.origin.y = SCREENHEIGHT-64-99;
            self.table_View.frame = frame;
            
            
            self.redImg.transform = CGAffineTransformMakeRotation(M_PI);

        }];
        
    }
}


- (IBAction)payClick:(id)sender {
    
    if ([_card_dic[@"card_type"] isEqualToString:@"套餐卡"]){
        
        PUSH(MealCardPayVC)
        vc.card_dic = _card_dic;
        vc.refresheDate = ^{
            self.refresheDate();
            [self getDataPost];
        };
        
        
    }else if ([_card_dic[@"card_type"] isEqualToString:@"体验卡"]){
        
        PUSH(ExperienceCardGoToPayVC)
        vc.card_dic = _card_dic;
        vc.refresheDate = ^{
            self.refresheDate();
            
//            [self postRequestVipCard];
        };
        
        
        
    }

    
}
- (IBAction)shopClick:(id)sender {
    
    PUSH(NewShopDetailVC)
    
    
    NSMutableDictionary *muta_dic =[NSMutableDictionary dictionaryWithDictionary:_card_dic];
    [muta_dic setValue:_card_dic[@"merchant"] forKey:@"muid"];
    vc.videoID = @"";
    vc.infoDic =muta_dic;

}


@end
