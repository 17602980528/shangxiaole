//
//  AddFriendTableViewController.m
//  BletcShop
//
//  Created by Bletc on 16/9/1.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "AddFriendTableViewController.h"
#import "AddFriendCell.h"
#import "UIImageView+WebCache.h"
@interface AddFriendTableViewController ()<UITextFieldDelegate>
@property(nonatomic,strong)NSArray *friendList;

@property(nonatomic,strong)UITextField *textFiled;
@end

@implementation AddFriendTableViewController

-(instancetype)initWithStyle:(UITableViewStyle)style{
    self = [super initWithStyle:UITableViewStyleGrouped];
    
    return self;
}
-(NSArray *)friendList{
    if (!_friendList) {
        _friendList = [NSArray array];
    }
    return _friendList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加好友";
    LEFTBACK
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 240;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.separatorColor =[UIColor clearColor];
    
    LZDButton *rightBtn = [LZDButton creatLZDButton];
    rightBtn.frame = CGRectMake(kWeChatScreenWidth-50, 0, 40, 30);
    
    [rightBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    rightBtn.block = ^(LZDButton *btn){
        NSLog(@"搜所");
        [self getData];
    };
    
    [self getRecommendFriendList];
   
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"搜所Return");
    
    [textField resignFirstResponder];
    [self getData];
    
    return YES;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 70;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor = RGB(240 , 240, 240);
    UITextField *textFiled = [[UITextField alloc]initWithFrame:CGRectMake(13, 16, kWeChatScreenWidth-2*13, 38)];
    textFiled.backgroundColor = [UIColor whiteColor];
    textFiled.textColor = RGB(51,51,51);
    textFiled.font = [UIFont systemFontOfSize:13];
    textFiled.layer.cornerRadius = 10;
    textFiled.layer.masksToBounds = YES;
    textFiled.placeholder = @"  输入要查找的好友";
    textFiled.delegate = self;
    textFiled.returnKeyType = UIReturnKeySearch;
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(textFiled.width-13-13, (textFiled.height-13)/2, 13, 13)];
    imgView.image =[UIImage imageNamed:@"灰色搜索icon"];
   
    [textFiled addSubview:imgView];
    [view addSubview:textFiled];
    self.textFiled = textFiled;
    return view;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.friendList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AddFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addFriendCellID"];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"AddFriendCell" owner:self options:nil]lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
//    [cell.acceptBtn setTitle:@"添加" forState:UIControlStateNormal];
//    cell.acceptBtn.titleLabel.font = [UIFont systemFontOfSize:15];
//    [cell.acceptBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [cell.acceptBtn setBackgroundColor:NavBackGroundColor];

    [cell.acceptBtn addTarget:self action:@selector(addFriend:) forControlEvents:UIControlEventTouchUpInside];
    cell.acceptBtn.tag = indexPath.row;
    
    
    if (self.friendList.count!=0) {
        
           cell.titlelab.text = self.friendList[indexPath.row][@"nickname"];
        
        NSString *header_S = [[self.friendList[indexPath.row][@"account"] componentsSeparatedByString:@"_"] firstObject];
        

        
        if ([header_S isEqualToString:@"m"]) {

            [cell.imgV sd_setImageWithURL:[NSURL URLWithString:[[SHOPIMAGE_ADDIMAGE stringByAppendingString:self.friendList[indexPath.row][@"headimage"]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]] placeholderImage:[UIImage imageNamed:@"userHeader"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                NSLog(@"=%@==%@",cell.titlelab.text,[SHOPIMAGE_ADDIMAGE stringByAppendingString:self.friendList[indexPath.row][@"headimage"]]);

//        NSLog(@"-error---%@",error.description);
        
    }];
//            [cell.imgV sd_setImageWithURL:[NSURL URLWithString:[SHOPIMAGE_ADDIMAGE stringByAppendingString:self.friendList[indexPath.row][2]]] placeholderImage:[UIImage imageNamed:@"user"]];
            
        }else{
            [cell.imgV sd_setImageWithURL:[NSURL URLWithString:[[HEADIMAGE stringByAppendingString:self.friendList[indexPath.row][@"headimage"]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]] placeholderImage:[UIImage imageNamed:@"userHeader"]];
            NSLog(@"=%@==%@",cell.titlelab.text,[HEADIMAGE stringByAppendingString:self.friendList[indexPath.row][@"headimage"]]);

        }
        

        
    }
    
    
    
    return cell;
}
//添加好友
-(void)addFriend:(UIButton*)sender{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"说点什么吧" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        // 请求信息
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"";
    }];
    
    // 获取alert中的文本输入框
    UITextField *descriptionFiled = [alert.textFields lastObject];
    
    // 添加按钮
    UIAlertAction *comitAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
               // 如果附带信息输入为空,那么就自定义一个
        NSString *message = (descriptionFiled.text.length == 0)?@"我想加你":descriptionFiled.text;
        // 发送好友请求
        
        NSLog(@"=self.friendList[sender.tag]===%@",self.friendList[sender.tag]);
        [[EMClient sharedClient].contactManager addContact:self.friendList[sender.tag][@"account"] message:message completion:^(NSString *aUsername, EMError *aError) {
            if (!aError) {
                NSLog(@"添加成功");
                
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                NSLog(@"添加失败");

            }
            
        }];
              
        
    }];
    // 取消按钮
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    // 添加两个按钮
    [alert addAction:cancelAction];
    [alert addAction:comitAction];

    [self presentViewController:alert animated:YES completion:nil];
}
//获取好友数据
-(void)getData{
    
    [[[UIApplication sharedApplication].delegate.window viewWithTag:777]removeFromSuperview];

    NSString *url = [NSString stringWithFormat:@"%@Extra/IM/search",BASEURL];
    NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
    [mdic setValue:self.textFiled.text forKey:@"account"];
    
    if ([self isPureInt:self.textFiled.text]) {
        [mdic setValue:@"phone" forKey:@"type"];
    }else{
        [mdic setValue:@"name" forKey:@"type"];

    }
    NSLog(@"=mdic==%@\n url = %@",mdic,url);
    [KKRequestDataService requestWithURL:url params:mdic httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        self.friendList = (NSArray*)result;
        
        if (self.friendList.count==0) {
            [self creatNodataView];
            
                   }
        
        [self.tableView reloadData];

        
        NSLog(@"result===%@",result);
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"-error--%@",error.description);
    }];
    
}

//获取推荐好友列表
-(void)getRecommendFriendList{
    NSString *url = [NSString stringWithFormat:@"%@Extra/IM/getRec",BASEURL];
    
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
    [mdic setValue:appdelegate.userInfoDic[@"uuid"] forKey:@"account"];
    
       NSLog(@"=mdic==%@\n url = %@",mdic,url);
    [KKRequestDataService requestWithURL:url params:mdic httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        self.friendList = (NSArray*)result;
        
        if (self.friendList.count!=0) {
            [self.tableView reloadData];
            
        }
        NSLog(@"result===%@",result);
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"-error--%@",error.description);
    }];
    
}



-(void)creatNodataView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    
    view.tag =777;
    view.backgroundColor = RGBA_COLOR(51, 51, 51, 0.2);
    
    
    [[UIApplication sharedApplication].delegate.window addSubview:view];
    
    
    UIView *backView = [[UIView alloc]init];
    backView.bounds = CGRectMake(0, 0, 250, 128);
    backView.center = CGPointMake(view.center.x, view.center.y-80);
    backView.layer.cornerRadius = 12;
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.masksToBounds = YES;
    [view addSubview:backView];
    
    
    
    UILabel *lab = [[UILabel alloc]init];
    lab.bounds = CGRectMake(0, 0, backView.width, 14);
    lab.center = CGPointMake(backView.width/2, 15+7);
    lab.font = [UIFont systemFontOfSize:14];
    lab.text = @"该用户不存在";
    lab.textColor = RGB(51,51,51);
    lab.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:lab];
    
    UILabel *lab1 = [[UILabel alloc]init];
    lab1.frame = CGRectMake(18, lab.bottom +15, backView.width-36, 32);
    
    lab1.font = [UIFont systemFontOfSize:12];
    lab1.text = @"无法找到该用户，请检查您输入的账号是否正确。";
    lab1.numberOfLines = 2;
    lab1.textColor = RGB(172,173,173);
    lab1.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:lab1];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, backView.height-35, backView.width, 0.5)];
    line.backgroundColor = RGB(172,173,173);
    [backView addSubview:line];
    
    
    LZDButton *cancel_btn = [LZDButton creatLZDButton];
    cancel_btn.frame = CGRectMake(0, line.bottom, backView.width, backView.height-line.bottom);
    [cancel_btn setTitle:@"我知道了" forState:0];
    [cancel_btn setTitleColor:RGB(243,73,78) forState:0];
    cancel_btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [backView addSubview:cancel_btn];
    
    cancel_btn.block = ^(LZDButton *sender) {
        
        [[[UIApplication sharedApplication].delegate.window viewWithTag:777]removeFromSuperview];
        
        
    };
    

}
/**
 *  判断是不是数字,是返回yes
 */
- (BOOL)isPureInt:(NSString *)string{
    
　　NSScanner* scan = [NSScanner scannerWithString:string];
　　int val;
　　return [scan scanInt:&val] && [scan isAtEnd];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
