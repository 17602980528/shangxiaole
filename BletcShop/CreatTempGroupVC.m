//
//  CreatTempGroupVC.m
//  BletcShop
//
//  Created by apple on 2017/8/11.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "CreatTempGroupVC.h"
#import "GroupMemberTableViewCell.h"
@interface CreatTempGroupVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tabView;

@end

@implementation CreatTempGroupVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tabView.estimatedRowHeight = 100;
    self.tabView.rowHeight = UITableViewAutomaticDimension;


}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GroupMemberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupMemberCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"GroupMemberTableViewCell" owner:self options:nil] firstObject];
    }
    
    
    return cell;
    
    
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





@end
