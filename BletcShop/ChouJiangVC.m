//
//  ChouJiangVC.m
//  BletcShop
//
//  Created by Bletc on 2017/4/6.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "ChouJiangVC.h"

@interface ChouJiangVC ()<UIWebViewDelegate>
{
    MBProgressHUD *hud;
}
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ChouJiangVC
@synthesize javascriptBridge = _bridge;
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title = @"积分抽奖";
//    self.navigationItem.title = @"周边";
    LEFTBACK
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.userInteractionEnabled = NO;
    NSLog(@"--------%@",self.urlString);
    
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:self.urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5];
    
    [self.webView loadRequest:request];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
//    AppDelegate *delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    [hud hideAnimated:YES afterDelay:0.0f];
//    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setUuid('%@','%@')",delegate.userInfoDic[@"uuid"],delegate.userInfoDic[@"integral"]]];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [hud hideAnimated:YES afterDelay:5.0];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [hud hideAnimated:YES afterDelay:0.0f];

    
}

@end
