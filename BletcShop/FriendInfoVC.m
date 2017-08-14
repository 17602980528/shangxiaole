//
//  FriendInfoVC.m
//  BletcShop
//
//  Created by apple on 2017/8/11.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "FriendInfoVC.h"
#import "UIImageView+WebCache.h"
#import "CreatTempGroupVC.h"

@interface FriendInfoVC ()
@property (weak, nonatomic) IBOutlet UIImageView *userHeaderImg;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userAcount;

@end

@implementation FriendInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"详情";
    Person *uer_p= [[Database searchPersonFromID:_conversationID] firstObject];
    
    NSString *header_S = [[uer_p.idstring componentsSeparatedByString:@"_"] firstObject];
    
    if ([header_S isEqualToString:@"u"]) {
        [_userHeaderImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HEADIMAGE,uer_p.imgStr]] placeholderImage:[UIImage imageNamed:@"userHeader"]];

        
    }else{
        [_userHeaderImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SHOPIMAGE_ADDIMAGE,uer_p.imgStr]] placeholderImage:[UIImage imageNamed:@"userHeader"]];

    }


    _userName.text = uer_p.name;
    _userAcount.text = [NSString stringWithFormat:@"商消乐账号：%@",uer_p.idstring];
    
    
}


//修改备注
- (IBAction)changeNickName:(id)sender {
}
//清空聊天记录
- (IBAction)cleanChatRecords:(id)sender {
    
    
    UIAlertController *alertVC= [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要清空该聊天记录?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

    }];
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"清空" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action){
        
        EMConversation*conver=[[EMClient sharedClient].chatManager getConversation:_conversationID type:EMConversationTypeChat createIfNotExist:YES];
        
        
        EMError *error = [[EMError alloc]initWithDescription:@"错误" code:EMErrorGeneral];
        
        [conver deleteAllMessages:&error];
        
        
        [self performSelector:@selector(goback) withObject:nil afterDelay:1];
        
        
//        [[EMClient sharedClient].chatManager deleteConversation:_conversationID isDeleteMessages:YES completion:^(NSString *aConversationId, EMError *aError) {
//            if (!aError) {
//                POP
//                
//            }
//        }];

    }];

    [alertVC addAction:OKAction];
    [alertVC addAction:cancle];
    [self presentViewController:alertVC animated:YES completion:nil];

    
}

-(void)goback{
    POP
}
//邀请好友聊天
- (IBAction)invateToChat:(id)sender {
    
    
    PUSH(CreatTempGroupVC)
}






@end
