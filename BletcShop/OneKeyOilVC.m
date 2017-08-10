
//
//  OneKeyOilVC.m
//  BletcShop
//
//  Created by apple on 2017/8/8.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "OneKeyOilVC.h"
#import "OrderConfirmForOilVC.h"
@interface OneKeyOilVC ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSArray *dataArr;
    UIView *windowBgView;
}
@property (weak, nonatomic) IBOutlet UITextField *oilGunTF;
@property (weak, nonatomic) IBOutlet UITextField *oilMoneyTF;
@property (weak, nonatomic) IBOutlet UITextField *carNum;
@property (weak, nonatomic) IBOutlet UIButton *goNextButton;

@end

@implementation OneKeyOilVC
- (IBAction)goNextVC:(id)sender {
    [_oilGunTF resignFirstResponder];
    [_oilMoneyTF resignFirstResponder];
    [_carNum resignFirstResponder];
    
    if ([_oilGunTF.text noWhiteSpaceString].length>0&&[_oilMoneyTF.text noWhiteSpaceString].length>0&&[_carNum.text noWhiteSpaceString].length>0) {
        //
        OrderConfirmForOilVC *vc=[[OrderConfirmForOilVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(void)cancelButtonClick:(UIButton *)sender{
    [UIView animateWithDuration:0.3 animations:^{
        windowBgView.frame=CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, SCREENHEIGHT);
    } completion:^(BOOL finished) {
        windowBgView.hidden=YES;
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"一键加油";
    LEFTBACK
    
    dataArr=@[@"1号枪（柴油）",@"2号枪（95#）",@"3号枪（92#）",@"4号枪（柴油）",@"5号枪（92#）",@"6号枪（95#）"];
    
    [_oilGunTF addTarget:self  action:@selector(valueChanged:)  forControlEvents:UIControlEventAllEditingEvents];
    [_oilMoneyTF addTarget:self  action:@selector(valueChanged:)  forControlEvents:UIControlEventAllEditingEvents];
    [_carNum addTarget:self  action:@selector(valueChanged:)  forControlEvents:UIControlEventAllEditingEvents];
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    
    windowBgView=[[UIView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, SCREENHEIGHT)];
    windowBgView.backgroundColor=[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:0.2];
    windowBgView.hidden=YES;
    [window addSubview:windowBgView];
    
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 266, SCREENWIDTH, SCREENHEIGHT-266)];
    bgView.backgroundColor=RGB(238, 238, 238);
    [windowBgView addSubview:bgView];
    
    UILabel *titleLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 48)];
    titleLable.font=[UIFont systemFontOfSize:16];
    titleLable.text=@"选择油枪号";
    titleLable.textAlignment=NSTextAlignmentCenter;
    [bgView addSubview:titleLable];
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 48, SCREENWIDTH, bgView.height-48-49)];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [bgView addSubview:_tableView];
    
    UIButton *cancelButton=[[UIButton alloc]initWithFrame:CGRectMake(0, bgView.height-44, SCREENWIDTH, 44)];
    cancelButton.backgroundColor=[UIColor whiteColor];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
    cancelButton.titleLabel.font=[UIFont systemFontOfSize:15.0f];
    [bgView addSubview:cancelButton];
    [cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, 39, SCREENWIDTH, 1)];
        line.backgroundColor=RGB(229, 229, 229);
        [cell addSubview:line];
    }
    cell.textLabel.font=[UIFont systemFontOfSize:14.0f];
    cell.textLabel.text=dataArr[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [UIView animateWithDuration:0.3 animations:^{
        windowBgView.frame=CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, SCREENHEIGHT);
    } completion:^(BOOL finished) {
        windowBgView.hidden=YES;
    }];
    _oilGunTF.text=dataArr[indexPath.row];
}
-(void)valueChanged:(UITextField *)tf{
    if ([_oilGunTF.text noWhiteSpaceString].length>0&&[_oilMoneyTF.text noWhiteSpaceString].length>0&&[_carNum.text noWhiteSpaceString].length>0) {
        self.goNextButton.backgroundColor=RGB(243, 73, 78);
    }else{
        self.goNextButton.backgroundColor=RGB(192, 192, 192);
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return NO;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField==_oilGunTF) {
        windowBgView.hidden=NO;
        [UIView animateWithDuration:0.3 animations:^{
            windowBgView.frame=CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
        }];
        return NO;
    }else{
        return YES;
    }
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
