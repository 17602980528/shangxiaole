//
//  CreatTempGroupVC.m
//  BletcShop
//
//  Created by apple on 2017/8/11.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "CreatTempGroupVC.h"

@interface CreatTempGroupVC ()

@end

@implementation CreatTempGroupVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)creatNoticeViewWhenNoneData{
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake((SCREENWIDTH-222)/2, 222, 160, 60)];
    label.text=@"好友还不够多\n无法创建群组，好伤心哦";//您还没有会话记录哦！ 快去找一个好友和她聊聊吧//暂无聊天的群哦 快快创建一个吧
    label.textAlignment=NSTextAlignmentCenter;
    label.font=[UIFont systemFontOfSize:13];
    label.textColor=RGB(164, 164, 164);
    label.numberOfLines=0;
    [self.view addSubview:label];
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
