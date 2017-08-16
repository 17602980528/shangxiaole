//
//  CreatTempGroupVC.m
//  BletcShop
//
//  Created by apple on 2017/8/11.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "CreatTempGroupVC.h"
#import "GroupMemberTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "LZDChartViewController.h"
@interface CreatTempGroupVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tabView;
@property(nonatomic,strong)NSMutableArray *arrFriends;


@property(nonatomic,strong)NSMutableArray *select_A;


@end

@implementation CreatTempGroupVC
-(NSMutableArray *)select_A{
    if (!_select_A) {
        _select_A = [NSMutableArray array];
    }
    return _select_A;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"好友列表";
    self.tabView.estimatedRowHeight = 100;
    self.tabView.rowHeight = UITableViewAutomaticDimension;

    // 从服务器获取好友列表
    
    
    [[self.view viewWithTag:777]removeFromSuperview];

    
    [[EMClient sharedClient].contactManager getContactsFromServerWithCompletion:^(NSArray *aList, EMError *aError) {
        if (!aError) {
            NSLog(@"获取成功 -- %@",aList);

            
            self.arrFriends = [NSMutableArray arrayWithArray:aList];
            [self.tabView reloadData];
            
            if (_arrFriends.count==0) {
                
                
                [self creatNoticeViewWhenNoneData];
               
            }

           
            
        }else{
            NSLog(@"获取失败%@",aError.errorDescription);
            
        }
        
    }];

    

}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrFriends.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GroupMemberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupMemberCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"GroupMemberTableViewCell" owner:self options:nil] firstObject];
    }
    
    
    Person *p= [[Database searchPersonFromID:[_arrFriends objectAtIndex:indexPath.row]] firstObject];
    
    cell.nameLab.text =p.name;
    
    NSString *header_S = [[p.idstring componentsSeparatedByString:@"_"] firstObject];
    
    
    if ([header_S isEqualToString:@"u"]) {
        [cell.headerImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HEADIMAGE,p.imgStr]] placeholderImage:[UIImage imageNamed:@"userHeader"]];
        
    }else{
        [cell.headerImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SHOPIMAGE_ADDIMAGE,p.imgStr]] placeholderImage:[UIImage imageNamed:@"userHeader"]];
        
    }
    
    if (!p) {
        cell.nameLab.text =[_arrFriends objectAtIndex:indexPath.row];
        
    }

    
    if (cell.ischose) {
        cell.selectImg.image = [UIImage imageNamed:@"选中sex.png"];
    }else{
        cell.selectImg.image = [UIImage imageNamed:@"默认sex.png"];

    }
    
    return cell;
    
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    

    
    GroupMemberTableViewCell *cell = (GroupMemberTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    cell.ischose = !cell.ischose;
    

    [tableView reloadData];
    
    
    
    if (cell.ischose) {

        
        [self.select_A addObject:_arrFriends[indexPath.row]];
    }else{
        [self.select_A removeObject:_arrFriends[indexPath.row]];

    }
}


- (IBAction)surebtn:(UIButton *)sender {
    
    NSLog(@"===%@",_select_A);
    
    NSString *title_s=@"";
    for (NSString *uuid in _select_A) {
    
        Person *p= [[Database searchPersonFromID:uuid] firstObject];
        
        if (title_s.length==0) {
            title_s= p.name;
        }else{
            title_s = [NSString stringWithFormat:@"%@,%@",title_s,p.name];

        }
    }
    
    EMGroupOptions *options = [[EMGroupOptions alloc]init];
    options.style = EMGroupStylePrivateMemberCanInvite;
    options.maxUsersCount = 200;
    

    
    if (_select_A.count >options.maxUsersCount) {
        [self showHint:@"添加成员过多"];
    }else{
        [[EMClient sharedClient].groupManager createGroupWithSubject:title_s description:@"暂无描述!" invitees:_select_A message:@"欢迎加群!" setting:options completion:^(EMGroup *aGroup, EMError *aError) {
            
            if (!aError) {
                
                PUSH(LZDChartViewController)
                vc.chatType = EMChatTypeGroupChat;
                
                if (aGroup.subject && aGroup.subject.length > 0) {
                    vc.title = aGroup.subject;
                }
                else {
                    vc.title = aGroup.groupId;
                }
                vc.username =aGroup.groupId;
                
                
            }else{
                [self showHint:@"建群出错"];
            }
            
        }];
    }
    
   
}


-(void)creatNoticeViewWhenNoneData{
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake((SCREENWIDTH-222)/2, 222, 160, 60)];
    label.text=@"好友还不够多\n无法创建群组，好伤心哦";//您还没有会话记录哦！ 快去找一个好友和她聊聊吧//暂无聊天的群哦 快快创建一个吧
    label.textAlignment=NSTextAlignmentCenter;
    label.font=[UIFont systemFontOfSize:13];
    label.tag=777;
    label.textColor=RGB(164, 164, 164);
    label.numberOfLines=0;
    [self.view addSubview:label];
}





@end
