//
//  HobbyChooseVC.m
//  BletcShop
//
//  Created by apple on 2017/7/25.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "HobbyChooseVC.h"

@interface HobbyChooseVC ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
@property(nonatomic,strong)NSMutableArray *cardKindArray;
@property(nonatomic,strong)NSMutableArray *countArray;
@property(nonatomic,copy)NSMutableString *hobbyString;
@end

@implementation HobbyChooseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"爱好选择";
    LEFTBACK
    UIBarButtonItem *item=[[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveBtnClick)];
    self.navigationItem.rightBarButtonItem=item;
    
    _hobbyString=[[NSMutableString alloc]initWithString:self.hobby];

    self.countArr=[_hobbyString componentsSeparatedByString:@"  "];
    
    _countArray=[[NSMutableArray alloc]initWithCapacity:0];
    
    _cardKindArray=[NSMutableArray arrayWithArray:@[@{@"type":@"舞蹈"},@{@"type":@"瑜伽"},@{@"type":@"篮球"},@{@"type":@"户外"},@{@"type":@"跑步"},@{@"type":@"游泳"},@{@"type":@"健身"},@{@"type":@"轮滑"},@{@"type":@"散步"},@{@"type":@"滑雪"},@{@"type":@"爬山"},@{@"type":@"电影"},@{@"type":@"旅行"},@{@"type":@"美术"},@{@"type":@"音乐"},@{@"type":@"阅读"},@{@"type":@"写作"},@{@"type":@"书法"},@{@"type":@"魔术"},@{@"type":@"K歌"},@{@"type":@"美食"},@{@"type":@"网游"},@{@"type":@"手游"},@{@"type":@"桌游"},@{@"type":@"聚会"},@{@"type":@"追剧"},@{@"type":@"网购"},@{@"type":@"睡觉"},@{@"type":@"摄影"},@{@"type":@"乐器"},@{@"type":@"星座"},@{@"type":@"咖啡"},@{@"type":@"棋牌"},@{@"type":@"品茶"},@{@"type":@"钓鱼"},@{@"type":@"花鸟"},@{@"type":@"宠物"},@{@"type":@"动漫"},@{@"type":@"金融"},@{@"type":@"其它"}]];
    
    for (int i=0; i<self.countArr.count; i++) {
        NSString *str=self.countArr[i];
        for (int j=0; j<_cardKindArray.count; j++) {
            NSDictionary *dic=_cardKindArray[j];
            if ([dic[@"type"] isEqualToString:str]) {
                NSMutableDictionary *newDic=[dic mutableCopy];
                [newDic setObject:@"yes" forKey:@"choose"];
                [_cardKindArray replaceObjectAtIndex:j withObject:newDic];
                [_countArray addObject:newDic];
            }
            
        }
    }
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    layout.headerReferenceSize =CGSizeMake(SCREENWIDTH,38);//头视图大小
    layout.itemSize = CGSizeMake((SCREENWIDTH-56)/4.0, 30);
    layout.sectionInset=UIEdgeInsetsMake(0, 13, 0, 13);
    layout.minimumLineSpacing = 10.0f;
    layout.minimumInteritemSpacing = 5.0f;
    
    UICollectionView* collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64) collectionViewLayout:layout];
    collectionView.backgroundColor=[UIColor whiteColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.backgroundColor=RGB(240, 240, 240);
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:collectionView];
    
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];

}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
     return _cardKindArray.count;
}

- (UICollectionViewCell* )collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    UILabel *lab=[cell viewWithTag:1];
    if (lab==nil) {
        lab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, (SCREENWIDTH-56)/4.0, 30)];
        lab.font=[UIFont systemFontOfSize:14.0f];
        lab.layer.cornerRadius=3.0f;
        lab.layer.borderColor=[UIColor lightGrayColor].CGColor;
        lab.layer.borderWidth=1.0f;
        lab.clipsToBounds=YES;
        lab.textColor=RGB(51, 51, 51);
        lab.textAlignment=NSTextAlignmentCenter;
        lab.tag=1;
        [cell addSubview:lab];
    }
    if (_cardKindArray[indexPath.row][@"choose"]&&[_cardKindArray[indexPath.row][@"choose"] isEqualToString:@"yes"]) {
        lab.textColor=RGB(243, 73, 78);
        lab.layer.borderColor=RGB(243, 73, 78).CGColor;
    }else{
         lab.textColor=RGB(51, 51, 51);
         lab.layer.borderColor=[UIColor lightGrayColor].CGColor;
    }
    lab.text=_cardKindArray[indexPath.row][@"type"];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
   
   NSMutableDictionary *dic = [_cardKindArray[indexPath.row] mutableCopy];
    if (dic[@"choose"]&&[dic[@"choose"] isEqualToString:@"yes"]) {
        [dic setObject:@"no" forKey:@"choose"];
        [_countArray removeObjectAtIndex:_countArray.count-1];
    }else{
        [dic setObject:@"yes" forKey:@"choose"];
        [_countArray addObject:dic];
    }
    [_cardKindArray replaceObjectAtIndex:indexPath.row withObject:dic];
    [collectionView reloadData];

}
//保存
-(void)saveBtnClick{
    _hobbyString=@"";
    if (_countArray.count<=10) {
            for (int i=0; i<_cardKindArray.count; i++) {
            NSDictionary *dic=_cardKindArray[i];
            if (dic[@"choose"]&&[dic[@"choose"] isEqualToString:@"yes"]) {
                _hobbyString = [_hobbyString stringByAppendingString:[NSString stringWithFormat:@"%@  ",dic[@"type"]]];
            }
        }
        NSLog(@"_hobbyString==%@",_hobbyString);
        [self postRevise];
    }else{//最多选择十项爱好哦！
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"最多选择十项爱好哦！" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertVC addAction:cancel];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
}
-(void)postRevise
{
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/user/accountSet",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    
    [params setObject:_hobbyString forKey:@"para"];
    
    [params setObject:@"hobby" forKey:@"type"];
    
    NSLog(@"params===%@",params);
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         DebugLog(@"result===+%@",result);
         MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
         hud.mode = MBProgressHUDModeText;
         if ([result[@"result_code"] intValue]==1 ) {
             hud.label.text = NSLocalizedString(@"修改成功", @"HUD message title");
             
             hud.label.font = [UIFont systemFontOfSize:13];
             //    [hud setColor:[UIColor blackColor]];
             hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
             hud.userInteractionEnabled = YES;
             
             [hud hideAnimated:YES afterDelay:1.f];
             
             
             NSMutableDictionary *new_dic = [appdelegate.userInfoDic mutableCopy];
             
             
             [new_dic setValue:result[@"para"] forKey:result[@"type"]];
             
             appdelegate.userInfoDic = new_dic;
             
             
             
             self.resultBlock(result);
             
             
             [self performSelector:@selector(popVC) withObject:nil afterDelay:1.5];
             
         }else
         {
             hud.label.text = NSLocalizedString(@"请求失败 请重试", @"HUD message title");
             
             hud.label.font = [UIFont systemFontOfSize:13];
             //    [hud setColor:[UIColor blackColor]];
             hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
             hud.userInteractionEnabled = YES;
             
             [hud hideAnimated:YES afterDelay:1.f];
             
             
         }
         
         
         
         
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         NSLog(@"%@", error);
         
     }];
    
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"forIndexPath:indexPath];
    header.backgroundColor = RGB(240, 240,240);
    
    UILabel *notice = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 38)];
    notice.textAlignment=NSTextAlignmentCenter;
    notice.text=@"最多选择十项爱好哦！";
    notice.font=[UIFont systemFontOfSize:12.0f];
    notice.textColor=RGB(143,143 , 143);
    [header addSubview:notice];

    return header;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(SCREENWIDTH, 38);
}

-(void)popVC{
    [self.navigationController popViewControllerAnimated:YES];
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
