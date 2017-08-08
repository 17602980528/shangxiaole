//
//  ShareCardManageVC.m
//  BletcShop
//
//  Created by Bletc on 2017/7/21.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "ShareCardManageVC.h"
#import "NewShopDetailVC.h"
#import "MoneyPAYViewController.h"
#import "CountPAYViewController.h"
@interface ShareCardManageVC ()

{
    NSDictionary *cardInfo_dic;

}
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UILabel *shapName1;
@property (weak, nonatomic) IBOutlet UIImageView *cardImg;
@property (weak, nonatomic) IBOutlet UILabel *type_level;
@property (weak, nonatomic) IBOutlet UILabel *type_level_1;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UILabel *start_end;
@property (weak, nonatomic) IBOutlet UILabel *remainlab;
@property (weak, nonatomic) IBOutlet UIImageView *redImg;
@property (strong, nonatomic) IBOutlet UIView *headView;

@end

@implementation ShareCardManageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"会员卡";

    LEFTBACK
    self.headView.frame = CGRectMake(13, 212*LZDScale-21, SCREENWIDTH-26, 667);
    
    [self.view addSubview:self.headView];

    
    self.shopName.text =  self.shapName1.text = _card_dic[@"store"];
    self.cardImg.backgroundColor = [UIColor colorWithHexString:_card_dic[@"card_temp_color"]];
    
    self.type_level_1.text =  self.type_level.text = @"分享卡";
    self.start_end.text = [NSString stringWithFormat:@"%@-%@",[_card_dic[@"date_start"] substringToIndex:10],[_card_dic[@"date_end"] substringToIndex:10]];
    
    if ([_card_dic[@"card_type"] isEqualToString:@"计次卡"]) {
        self.contentLab.text = @"计次卡用完为止。";
        
        int cishu =  [_card_dic[@"card_remain"] floatValue]  /   ([_card_dic[@"price"] floatValue]/[_card_dic[@"rule"] floatValue]);
        
        
        self.remainlab.text = [NSString stringWithFormat:@"剩余:%d次",cishu];
    }else{
        self.contentLab.text = @"店内项目可使用会员卡任意消费。";
        //            self.card_contentLab.text = @"您应该已经收到系统生成的电子邮件，您可以访问电子邮件中的链接，并在我们的计划中注册您的公司。请注意，在迁移完成之前，您将无法访问“Certificates, Identifiers & Profiles”（证书、标识符和描述文件）门户";
        
        self.remainlab.text = [NSString stringWithFormat:@"余额:%@元",_card_dic[@"card_remain"]];
        
    }

    

    [self postRequestAllInfo];

}


- (IBAction)shousuoBtn:(UIButton *)sender {
    
    if (sender.selected) {
        
        [UIView animateWithDuration:0.3 animations:^{
            
            self.redImg.transform = CGAffineTransformMakeRotation(M_PI);
            
            
            CGRect tabheaderFrame =  self.headView.frame;
            
            tabheaderFrame.origin.y = SCREENHEIGHT-64-99;
            self.headView.frame = tabheaderFrame;
            
            
        }];
        
    }else{
        
        
        [UIView animateWithDuration:0.3 animations:^{
            
            CGRect tabheaderFrame =  self.headView.frame;
            
            tabheaderFrame.origin.y = self.cardImg.bottom-21;
            self.headView.frame = tabheaderFrame;
            
            
            
            
            
            
        } completion:^(BOOL finished) {
            
            
            self.redImg.transform = CGAffineTransformMakeRotation(0);
        }];
        
        
    }
    sender.selected = !sender.selected;
    

    
}

- (IBAction)payBtnClcik:(id)sender {
    
    if ([cardInfo_dic[@"card_type"] isEqualToString:@"储值卡"]) {
        PUSH(MoneyPAYViewController)
        vc.refresheDate = ^{
            self.refresheDate();
            
            [self postRequestAllInfo];
        };
        
        vc.card_dic = cardInfo_dic;
        vc.user = self.card_dic[@"user"];
        
        
    }else if ([cardInfo_dic[@"card_type"] isEqualToString:@"计次卡"]){
        
        PUSH(CountPAYViewController)
        vc.card_dic = cardInfo_dic;
        vc.refresheDate = ^{
            self.refresheDate();
            
            [self postRequestAllInfo];
        };
        vc.user = self.card_dic[@"user"];
        
    }

    
}

- (IBAction)shopClcik:(id)sender {
    
    
    PUSH(NewShopDetailVC)
    
    
    NSMutableDictionary *muta_dic =[NSMutableDictionary dictionaryWithDictionary:_card_dic];
    [muta_dic setValue:_card_dic[@"merchant"] forKey:@"muid"];
    vc.videoID = @"";
    vc.infoDic =muta_dic;

}


-(void)postRequestAllInfo
{
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/card/detailGet",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:self.card_dic[@"user"] forKey:@"uuid"];
    
    [params setObject:self.card_dic[@"merchant"] forKey:@"muid"];
    [params setObject:appdelegate.cardInfo_dic[@"card_level"] forKey:@"cardLevel"];
    [params setObject:self.card_dic[@"card_code"] forKey:@"cardCode"];
    
    
    
    NSLog(@"---%@",appdelegate.cardInfo_dic);
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"result===%@", result);
        cardInfo_dic = [NSDictionary dictionaryWithDictionary:result];
        
        AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        
        appdelegate.cardInfo_dic = cardInfo_dic;
        
        cardInfo_dic = result;
        
        
        
        
        
        self.shopName.text =  self.shapName1.text = cardInfo_dic[@"store"];
        self.cardImg.backgroundColor = [UIColor colorWithHexString:cardInfo_dic[@"card_temp_color"]];
        
        self.type_level_1.text =  self.type_level.text = @"分享卡";
        self.start_end.text = [NSString stringWithFormat:@"%@-%@",[cardInfo_dic[@"date_start"] substringToIndex:10],[cardInfo_dic[@"date_end"] substringToIndex:10]];
        
        if ([cardInfo_dic[@"card_type"] isEqualToString:@"计次卡"]) {
            self.contentLab.text = @"计次卡用完为止。";
            
            int cishu =  [cardInfo_dic[@"card_remain"] floatValue]  /   ([cardInfo_dic[@"price"] floatValue]/[cardInfo_dic[@"rule"] floatValue]);
            
            
            self.remainlab.text = [NSString stringWithFormat:@"剩余:%d次",cishu];
        }else{
            self.contentLab.text = @"店内项目可使用会员卡任意消费。";
            //            self.card_contentLab.text = @"您应该已经收到系统生成的电子邮件，您可以访问电子邮件中的链接，并在我们的计划中注册您的公司。请注意，在迁移完成之前，您将无法访问“Certificates, Identifiers & Profiles”（证书、标识符和描述文件）门户";
            
            self.remainlab.text = [NSString stringWithFormat:@"余额:%@元",cardInfo_dic[@"card_remain"]];
            
        }
        
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
}


@end
