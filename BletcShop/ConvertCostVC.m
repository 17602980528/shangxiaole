//
//  ConvertCostVC.m
//  BletcShop
//
//  Created by apple on 17/2/28.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "ConvertCostVC.h"

#import "OrderDetailViewController.h"

#import "UIImageView+WebCache.h"
@interface ConvertCostVC ()<UIWebViewDelegate>
{
    UIScrollView *_scrollView;
    NSDictionary *pointAndSign_dic;
    UILabel *totalPointLable;
    UILabel *noticeLabel;
    UIButton *convertButton;
}
@end

@implementation ConvertCostVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    AppDelegate *delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;

    
    if (delegate.IsLogin) {
        [self postRequestPointWithSign:delegate.userInfoDic[@"uuid"]];
        
        if ([self.totalPoint floatValue]<[self.shopNeedPoint floatValue]) {
            noticeLabel.text=@"亲！您的积分还不够哦～";
            convertButton.backgroundColor=[UIColor lightGrayColor];
            [convertButton setTitle:@"积分不够" forState:UIControlStateNormal];
            convertButton.userInteractionEnabled = NO;
        }else{
            convertButton.userInteractionEnabled = YES;

            noticeLabel.text=@"恭喜！积分可兑换该商品";
            convertButton.backgroundColor=[UIColor orangeColor];
            [convertButton setTitle:@"立即兑换" forState:UIControlStateNormal];
            [convertButton addTarget:self action:@selector(costPoint:) forControlEvents:UIControlEventTouchUpInside];
        }

        
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    LEFTBACK

    
    self.view.backgroundColor=RGB(238, 238, 238);
    self.navigationItem.title=@"积分兑换";
    _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64-100)];
    _scrollView.contentSize=CGSizeMake(SCREENWIDTH, 336+200);
    [self.view addSubview:_scrollView];
    
    //top
    UIView *topBgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 326)];
    topBgView.backgroundColor=[UIColor whiteColor];
    [_scrollView addSubview:topBgView];
    
    UIImageView *shopImageView=[[UIImageView alloc]init];
    //NSLog(@"%@",[NSString stringWithFormat:@"%@%@",POINT_GOODS,self.imageNameString]);
    NSURL * nurl1=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",POINT_GOODS,self.imageNameString]];
    [shopImageView sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"icon3.png"] options:SDWebImageRetryFailed];
    
    shopImageView.frame=CGRectMake((SCREENWIDTH-200)/2, 15, 200, 200);
    [topBgView addSubview:shopImageView];
    
    UILabel *shopNameLable=[[UILabel alloc]initWithFrame:CGRectMake(20, 230, SCREENWIDTH-40, 59)];
    shopNameLable.text=[NSString stringWithFormat:@"%@  %@积分",self.shopNameString,self.shopNeedPoint];
    shopNameLable.font=[UIFont systemFontOfSize:20.0f];
    shopNameLable.numberOfLines = 2;
    [topBgView addSubview:shopNameLable];
    
//    UILabel *detailLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 260, SCREENWIDTH-40, 30)];
//    detailLabel.text=@"3款颜色随机发放";
//    detailLabel.backgroundColor=[UIColor whiteColor];
//    detailLabel.textColor=[UIColor grayColor];
//    [topBgView addSubview:detailLabel];
//    detailLabel.font=[UIFont systemFontOfSize:13.0f];
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 290, SCREENWIDTH, 1)];
    lineView.backgroundColor=RGB(238, 238, 238);
    [topBgView addSubview:lineView];
    
     totalPointLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 291, SCREENWIDTH/2, 35)];
    
    totalPointLable.text=[NSString stringWithFormat:@"我的积分:%@",[NSString getTheNoNullStr:_totalPoint andRepalceStr:@"0"]];
    totalPointLable.textAlignment=1;
    totalPointLable.font=[UIFont systemFontOfSize:15.0f];
    [topBgView addSubview:totalPointLable];
    
    UILabel *allConvertCountLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/2, 291, SCREENWIDTH/2, 35)];
    allConvertCountLabel.textAlignment=1;
    allConvertCountLabel.text=[NSString stringWithFormat:@"已兑出:%@件",self.converRecordCount];
    allConvertCountLabel.font=[UIFont systemFontOfSize:15.0f];
    [topBgView addSubview:allConvertCountLabel];
    //bottom
    UIView *bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT-64-100, SCREENWIDTH, 100)];
    bottomView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    noticeLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 40)];
    noticeLabel.textAlignment=1;
    noticeLabel.textColor=[UIColor redColor];
    noticeLabel.font=[UIFont systemFontOfSize:13.0f];
    [bottomView addSubview:noticeLabel];
    
    
    
    convertButton=[UIButton buttonWithType:UIButtonTypeCustom];
    convertButton.frame=CGRectMake(20, 40, SCREENWIDTH-40, 40);
    [convertButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    convertButton.layer.cornerRadius=20;
    convertButton.clipsToBounds=YES;
    [bottomView addSubview:convertButton];
    if ([self.totalPoint floatValue]<[self.shopNeedPoint floatValue]) {
        noticeLabel.text=@"亲！您的积分还不够哦～";
        convertButton.backgroundColor=[UIColor lightGrayColor];
        [convertButton setTitle:@"积分不够" forState:UIControlStateNormal];
    }else{
        noticeLabel.text=@"恭喜！积分可兑换该商品";
        convertButton.backgroundColor=[UIColor orangeColor];
        [convertButton setTitle:@"立即兑换" forState:UIControlStateNormal];
        [convertButton addTarget:self action:@selector(costPoint:) forControlEvents:UIControlEventTouchUpInside];
    }
//    UIImageView *scanImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 336, SCREENWIDTH, SCREENWIDTH*3370/790.0)];
//    scanImageView.image=[UIImage imageNamed:@"timg-3.jpeg"];
    UIWebView *_webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 336, SCREENWIDTH, 200)];
    _webView.delegate=self;
    _webView.scrollView.bounces=NO;
    [_scrollView addSubview:_webView];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_infoDic[@"href"]]]];
//    UIImageView *
    
}
-(void)costPoint:(UIButton *)sender{
    //
    NSLog(@"积分可用");
    
    OrderDetailViewController *VC= [[OrderDetailViewController alloc]init];
    VC.product_dic=self.infoDic;
    [self.navigationController pushViewController:VC animated:YES];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    CGFloat webViewHeight=[webView.scrollView contentSize].height;
    CGRect newFrame=webView.frame;
    newFrame.size.height=webViewHeight;
    webView.frame=newFrame;
    _scrollView.contentSize=CGSizeMake(SCREENWIDTH, 336+webViewHeight);
    
}



-(void)postRequestPointWithSign:(NSString *)uuid {
    
    //请求乐点数
    NSString *url =[[NSString alloc]initWithFormat:@"%@Extra/mall/getIntegral",BASEURL ];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:uuid forKey:@"uuid"];
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"result==%@", result);
        if (result) {
            
            pointAndSign_dic = [NSDictionary dictionaryWithDictionary:result];
            _totalPoint = pointAndSign_dic[@"integral"];
            
            totalPointLable.text=[NSString stringWithFormat:@"我的积分:%@",[NSString getTheNoNullStr:_totalPoint andRepalceStr:@"0"]];
            
            
        }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
}



@end
