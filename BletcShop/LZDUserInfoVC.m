//
//  LZDUserInfoVC.m
//  BletcShop
//
//  Created by Bletc on 2017/3/15.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "LZDUserInfoVC.h"
#import "UserInfoCell.h"
#import "UserInfoHeaderCell.h"
#import "UserInfoSexyCell.h"
#import "UIImageView+WebCache.h"
#import "NewChangePsWordViewController.h"
#import "ResetPhoneViewController.h"
#import "ProfessionEditVC.h"
#import "UserInfoEditVC.h"

#import "NewModelImageViewController.h"
#import "ChangeLoginOrPayVC.h"
#import "RailNameConfirmVC.h"
#import "HobbyChooseVC.h"
#import "ValuePickerView.h"
#import "LZDCenterViewController.h"
@interface LZDUserInfoVC ()<UITableViewDelegate,UITableViewDataSource,NewModelImageViewControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource>

{
    
    NSData *imageData;
    NSData *imageData2;
    
    UIPickerView *datePickView;
    UIToolbar *toolbarCancelDone;
    
    NSMutableArray *yearArray;
    NSArray *monthArray;
    NSMutableArray *monthMutableArray;
    NSMutableArray *DaysMutableArray;
    NSMutableArray *DaysArray;
    NSString *currentMonthString;
    NSString *currentDateString;
    NSString *currentyearString;
    NSInteger selectedYearRow;
    NSInteger selectedMonthRow;
    NSInteger selectedDayRow;
    
    BOOL firstTimeLoad;
    
    NSInteger m ;
    int year;
    int month;
    int day;
    
    NSInteger selectedHourRowOnLine;
    NSInteger selectedMonthRowOnLine;
    NSInteger selectedDayRowOnLine;
}
@property (nonatomic, strong) ValuePickerView *educationPickerView;
@property (nonatomic, strong) ValuePickerView *pickerView;//婚姻
@property (nonatomic, strong) ValuePickerView *sexyPickerView;//性别
@property (nonatomic, strong) NSArray *marray_A;
@property (nonatomic, strong) NSArray *education_A;
@property(nonatomic,strong)NSArray *sexy_A;

@property (weak, nonatomic) IBOutlet UITableView *tabView;
@property(nonatomic,strong)NSArray *title_A;
@property(nonatomic,strong)NSArray *title_headImage;
@property (nonatomic,strong) UIImageView* imageView;
@property long long int date;//发送图片的时间戳

@property (weak, nonatomic) IBOutlet UIView *tishiview;
@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UILabel *tishiwenzi;

@end

@implementation LZDUserInfoVC
//性别
-(ValuePickerView *)sexyPickerView{
    if (!_sexyPickerView) {
        _sexyPickerView = [[ValuePickerView alloc]init];
        
    }
    return _sexyPickerView;
    
}

//教育
-(ValuePickerView *)educationPickerView{
    if (!_educationPickerView) {
        _educationPickerView = [[ValuePickerView alloc]init];
        
    }
    return _educationPickerView;
    
}
//婚姻
-(ValuePickerView *)pickerView{
    if (!_pickerView) {
        _pickerView = [[ValuePickerView alloc]init];
        
    }
    return _pickerView;
    
}
//
-(NSArray *)sexy_A{
    if (!_sexy_A) {
        _sexy_A = @[@"男",@"女"];
    }
    return _sexy_A;
}
//
-(NSArray *)education_A{
    if (!_education_A) {
        _education_A = @[@"小学",@"初中",@"高中",@"大专",@"本科",@"硕士",@"博士",@"其他"];
    }
    return _education_A;
}
-(NSArray *)marray_A{
    if (!_marray_A) {
        _marray_A = @[@"已婚",@"单身"];
    }
    return _marray_A;
}

-(NSArray *)title_A{
    if (!_title_A) {
        _title_A = @[@[@"实名认证",@"昵称",@"性别",@"手机号",@"邮箱"]
                     ,@[@"地址",@"生日",@"职业",@"教育",@"婚姻",@"爱好"]];
    }
    return _title_A;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    [self postRequestAllInfoForUser];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"资料";
    LEFTBACK
    self.tishiview.frame = CGRectMake(0, 0, SCREENWIDTH,SCREENHEIGHT);
    self.cancleBtn.layer.borderColor = NavBackGroundColor.CGColor;
    self.cancleBtn.layer.borderWidth =1;
    self.tishiview.hidden = YES;
    [self.view addSubview:self.tishiview];
    [self _inittableDate];
   
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
   return  0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 127;
    }else{
        return 40;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }else if (section==1){
        return [self.title_A[section-1]count];
    }else{
         return [self.title_A[section-1]count];
    }
    
    return 0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    if (indexPath.section==0) {
        UserInfoHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userinfoHeadID"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"UserInfoHeaderCell" owner:self options:nil] lastObject];
        }
        
        NSString *str = [[NSString alloc]init];
        
        str = [[[NSString alloc]initWithFormat:@"%@%@",HEADIMAGE,[appdelegate.userInfoDic objectForKey:@"headimage"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        DebugLog(@"headerImg ==%@",str);
        cell.headImg.contentMode=UIViewContentModeScaleAspectFill;
        [cell.headImg sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"userHeader"] options:SDWebImageRetryFailed];
        
        return cell;

    }else if (indexPath.section==1){
         NSArray *key_A = @[@"state",@"nickname",@"sex",@"phone",@"mail"];
        
        if (indexPath.row==2) {
            
            UserInfoSexyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userInfoSexyCell"];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"UserInfoSexyCell" owner:self options:nil] lastObject];
            }
            if ([appdelegate.userInfoDic[key_A[indexPath.row]] isEqualToString:@"女"]) {
                cell.sexImageLeft.image=[UIImage imageNamed:@"默认sex"];
                cell.sexImageRight.image=[UIImage imageNamed:@"选中sex"];
            }else if([appdelegate.userInfoDic[key_A[indexPath.row]] isEqualToString:@"男"]){
                cell.sexImageLeft.image=[UIImage imageNamed:@"选中sex"];
                cell.sexImageRight.image=[UIImage imageNamed:@"默认sex"];
            }else{
                cell.sexImageLeft.image=[UIImage imageNamed:@"默认sex"];
                cell.sexImageRight.image=[UIImage imageNamed:@"默认sex"];
            }
            return cell;
            
        }else{
            
            UserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userinfoID"];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"UserInfoCell" owner:self options:nil] lastObject];
            }
            cell.title_lab.text = _title_A[0][indexPath.row];
            
           //,@[@"sex",@"age",@"occupation",@"education",@"mate",@"hobby",@"",@"",@"",@"",@""];
            
            cell.content_lab.text = appdelegate.userInfoDic[key_A[indexPath.row]];
            
            if (indexPath.row==0) {
                if ([appdelegate.userInfoDic[key_A[indexPath.row]] isEqualToString:@"not_auth"]) {
                    cell.content_lab.text =@"未认证";
                }else if ([appdelegate.userInfoDic[key_A[indexPath.row]] isEqualToString:@"access"]){
                    cell.content_lab.text =@"认证通过";
                }else if([appdelegate.userInfoDic[key_A[indexPath.row]] isEqualToString:@"auditing"]){
                    
                    cell.content_lab.text =@"审核中";
                }else{
                    cell.content_lab.text =@"认证失败";
                }
            }
            if (indexPath.row==0) {
                cell.bgImageView.image=[UIImage imageNamed:@"导角矩形上"];
            }else if (indexPath.row==4){
                 cell.bgImageView.image=[UIImage imageNamed:@"导角矩形下"];
            }else{
                 cell.bgImageView.image=[UIImage imageNamed:@"设置   矩形"];
            }
            return cell;
        }
        
    }else if(indexPath.section==2){
       
            UserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userinfoID"];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"UserInfoCell" owner:self options:nil] lastObject];
            }
            cell.title_lab.text = _title_A[1][indexPath.row];
            
//            NSArray *key_A = @[@"state",@"nickname",@"address",@"phone",@"mail",@"sex",@"age",@"occupation",@"education",@"mate",@"hobby",@"",@"",@"",@"",@""];
         NSArray *key_A = @[@"address",@"age",@"occupation",@"education",@"mate",@"hobby"];
        
            cell.content_lab.text = appdelegate.userInfoDic[key_A[indexPath.row]];
        
        if (indexPath.row==0) {
             cell.bgImageView.image=[UIImage imageNamed:@"导角矩形上"];
        }else if (indexPath.row==5){
             cell.bgImageView.image=[UIImage imageNamed:@"导角矩形下"];
        }else{
             cell.bgImageView.image=[UIImage imageNamed:@"设置   矩形"];
        }

            return cell;
        }
  return nil;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    if (indexPath.section==0) {
         [self changeUserImg];
    }else if(indexPath.section==1){
        if (indexPath.row==0) {
            NSLog(@"你好帅");
           
            if ([appdelegate.userInfoDic[@"state"] isEqualToString:@"not_auth"]) {
                RailNameConfirmVC *confirmVC=[[RailNameConfirmVC alloc]init];
                confirmVC.title=_title_A[0][indexPath.row];
                [self.navigationController pushViewController:confirmVC animated:YES];
            }else if ([appdelegate.userInfoDic[@"state"] isEqualToString:@"fail"]){
                [self postRequest];
            }else{
                NSLog(@"你好帅");
            }
        }
        
        if (indexPath.row ==1 /*|| indexPath.row ==2*/ || indexPath.row ==4) {
            UserInfoEditVC *VC = [[UserInfoEditVC alloc]init];
            
            VC.resultBlock=^(NSDictionary*result) {
                
                NSLog(@"UserInfoEditVC.block====%@",result);
                
                if (![result[@"award"] isEqualToString:@"false"]) {
                    self.tishiwenzi.text = [NSString stringWithFormat:@"恭喜你，完成个人信息获得 %@ 个积分，快去看看吧",[NSString getTheNoNullStr:result[@"award"] andRepalceStr:@"0"]];
                    self.tishiview.hidden = NO;
                    
                }
                
            };
            VC.leibie = self.title_A[0][indexPath.row];
            [self.navigationController pushViewController:VC animated:YES];
        }
        
        if (indexPath.row==2) {
            self.sexyPickerView.dataSource = self.sexy_A;
            
            __weak typeof(self) weakSelf = self;
            
            self.sexyPickerView.valueDidSelect = ^(NSString * value){
                
                NSString *title= [[value componentsSeparatedByString:@"/"] firstObject];
                [weakSelf postRevise:title type:@"sex"];
                
            };
            
            [self.sexyPickerView show];
        }
        
        if (indexPath.row ==3) {
            ResetPhoneViewController *VC = [[ResetPhoneViewController alloc]init];
            
            [self.navigationController pushViewController:VC animated:YES];
        }

    }else if (indexPath.section==2){
        if (indexPath.row ==0 /*|| indexPath.row ==1 || indexPath.row ==3|| indexPath.row ==4|| indexPath.row ==5*/) {
            UserInfoEditVC *VC = [[UserInfoEditVC alloc]init];
            
            VC.resultBlock=^(NSDictionary*result) {
                
                NSLog(@"UserInfoEditVC.block====%@",result);
                
                if (![result[@"award"] isEqualToString:@"false"]) {
                    self.tishiwenzi.text = [NSString stringWithFormat:@"恭喜你，完成个人信息获得 %@ 个积分，快去看看吧",[NSString getTheNoNullStr:result[@"award"] andRepalceStr:@"0"]];
                    self.tishiview.hidden = NO;
                    
                }
                
            };
            VC.leibie = self.title_A[1][indexPath.row];
            [self.navigationController pushViewController:VC animated:YES];
        }
        
        if (indexPath.row==1) {
            [self creatPickView];
        }
        
        if (indexPath.row ==2) {
            ProfessionEditVC *VC=[[ProfessionEditVC alloc]init];
            VC.prodessionBlock=^(NSDictionary*result) {
                
                NSLog(@"UserInfoEditVC.block====%@",result);
                
                if (![result[@"award"] isEqualToString:@"false"]) {
                    self.tishiwenzi.text = [NSString stringWithFormat:@"恭喜你，完成个人信息获得 %@ 个积分，快去看看吧",[NSString getTheNoNullStr:result[@"award"] andRepalceStr:@"0"]];
                    
                    self.tishiview.hidden = NO;
                    
                }
                
            };
            
            [self.navigationController pushViewController:VC animated:YES];
            
        }
        
        if (indexPath.row==3) {
            self.educationPickerView.dataSource = self.education_A;
            
            __weak typeof(self) weakSelf = self;
            
            self.educationPickerView.valueDidSelect = ^(NSString * value){
                
                NSString *title= [[value componentsSeparatedByString:@"/"] firstObject];
                [weakSelf postRevise:title type:@"education"];
                
            };
            
            [self.educationPickerView show];
        }
        
        if (indexPath.row==4) {
            
           
            self.pickerView.dataSource = self.marray_A;
                
            __weak typeof(self) weakSelf = self;
            
            self.pickerView.valueDidSelect = ^(NSString * value){
                
                NSString *title= [[value componentsSeparatedByString:@"/"] firstObject];
                [weakSelf postRevise:title type:@"mate"];
                
            };
            
            [self.pickerView show];
            
        }
        if (indexPath.row==5) {
            HobbyChooseVC *hobbyVC=[[HobbyChooseVC alloc]init];
            hobbyVC.hobby=[NSString getTheNoNullStr:appdelegate.userInfoDic[@"hobby"] andRepalceStr:@""];
            hobbyVC.resultBlock=^(NSDictionary*result) {
                NSLog(@"UserInfoEditVC.block====%@",result);
                
            if (![result[@"award"] isEqualToString:@"false"]) {
                    self.tishiwenzi.text = [NSString stringWithFormat:@"恭喜你，完成个人信息获得 %@ 个积分，快去看看吧",[NSString getTheNoNullStr:result[@"award"] andRepalceStr:@"0"]];
                    self.tishiview.hidden = NO;
                    
                }
                
            };

            [self.navigationController pushViewController:hobbyVC animated:YES];
        }

    }
    
}


-(void)changeUserImg
{
    UIActionSheet *sheet;
    
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选择",@"系统推荐", nil];
        
    }
    
    else {
        
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册选择", @"系统推荐",nil];
        
    }
    
    sheet.tag = 255;
    
    [sheet showInView:self.view];
}

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255) {
        
        NSUInteger sourceType = 0;
        
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            switch (buttonIndex) {
                case 0:
                    // 取消
                    return;
                case 1:
                    // 相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                    
                case 2:
                    // 相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
                case 3:{
                    NewModelImageViewController *ModelImageVC=[[NewModelImageViewController alloc]init];
                    ModelImageVC.image=self.imageView.image;
                    ModelImageVC.delegate=self;
                    [self.navigationController pushViewController:ModelImageVC animated:YES];
                    return;
                }
            }
        }
        else {
            if (buttonIndex == 0) {
                
                return;
            }else if (buttonIndex==1){
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }else {
                NewModelImageViewController *ModelImageVC=[[NewModelImageViewController alloc]init];
                ModelImageVC.image=self.imageView.image;
                ModelImageVC.delegate=self;
                [self.navigationController pushViewController:ModelImageVC animated:YES];
                //[self presentViewController:ModelImageVC animated:YES completion:nil];
                return;
            }
        }
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        
        imagePickerController.delegate = self;
        
        imagePickerController.allowsEditing = YES;
        
        imagePickerController.sourceType = sourceType;
        [self presentViewController:imagePickerController animated:YES completion:^{}];
        
    }
}
//点击选取按钮触发事件
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    /* 此处info 有六个值
     * UIImagePickerControllerMediaType; // an NSString UTTypeImage)
     * UIImagePickerControllerOriginalImage;  // a UIImage 原始图片
     * UIImagePickerControllerEditedImage;    // a UIImage 裁剪后图片
     * UIImagePickerControllerCropRect;       // an NSValue (CGRect)
     * UIImagePickerControllerMediaURL;       // an NSURL
     * UIImagePickerControllerReferenceURL    // an NSURL that references an asset in the AssetsLibrary framework
     * UIImagePickerControllerMediaMetadata    // an NSDictionary containing metadata from a captured photo
     */
    // 保存图片至本地，方法见下文
    [self saveImage:image withName:@"currentImage.png"];
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"currentImage.png"];
    
    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@Extra/upload/upload",BASEURL];
    [self.imageView setImage:savedImage];
    
    
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    self.date = (long long int)time;
    
    NSString *nameValue = [[NSString alloc]initWithFormat:@"%@_%lld",[appdelegate.userInfoDic objectForKey:@"uuid"],self.date];
    
    
    NSData *img_Data = [NSData dataWithContentsOfFile:fullPath];
    NSMutableDictionary *parmer = [NSMutableDictionary dictionary];
    [parmer setValue:nameValue forKey:@"name"];
    [parmer setValue:@"head_image" forKey:@"type"];
    [parmer setObject:img_Data forKey:@"file1"];
    
    [KKRequestDataService requestWithURL:url params:parmer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        if ([result[@"result_code"] isEqualToString:@"access"]) {
            //            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            //            hud.mode = MBProgressHUDModeText;
            //
            //            hud.label.text = NSLocalizedString(@"上传成功", @"HUD message title");
            //            hud.label.font = [UIFont systemFontOfSize:13];
            //            hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
            //            [hud hideAnimated:YES afterDelay:3.f];
            [self postUploadImageWithNameValue:nameValue];
            
            
            
        }
        NSLog(@"result===%@", result);
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        //        DebugLog(@"error-----%@",error.description);
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"图片太大,上传失败", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:13];
        hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
        [hud hideAnimated:YES afterDelay:4.f];
        
    }];
    
    
}

-(void)postUploadImageWithNameValue:(NSString*)nameValue
{
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/user/accountSet",BASEURL];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    //    NSString *nameValue = [[NSString alloc]initWithFormat:@"%@_%lld.png",[appdelegate.userInfoDic objectForKey:@"uuid"],self.date ];
    
    nameValue =[NSString stringWithFormat:@"%@.png",nameValue];
    
    [params setObject:@"headImage" forKey:@"type"];
    [params setObject:nameValue forKey:@"para"];
    
    
    NSLog(@"%@",params);
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         NSLog(@"result===%@", result);
         
         if ([result[@"result_code"] intValue]==1) {
             MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
             hud.mode = MBProgressHUDModeText;
             
             hud.label.text = NSLocalizedString(@"图片上传成功", @"HUD message title");
             hud.label.font = [UIFont systemFontOfSize:13];
             hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
             [hud hideAnimated:YES afterDelay:3.f];
             AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
             NSMutableDictionary *new_dic = [appdelegate.userInfoDic mutableCopy];
             [new_dic setValue:result[@"para"] forKey:@"headimage"];
             
             appdelegate.userInfoDic = new_dic;
             
             
             [self.tabView reloadData];
             
         }else
         {
             MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
             //            hud.frame = CGRectMake(0, 64, 375, 667);
             // Set the annular determinate mode to show task progress.
             hud.mode = MBProgressHUDModeText;
             
             hud.label.text = NSLocalizedString(@"图片上传失败,请重试", @"HUD message title");
             hud.label.font = [UIFont systemFontOfSize:13];
             // Move to bottm center.
             //    hud.offset = CGPointMake(0.f, );
             hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
             [hud hideAnimated:YES afterDelay:3.f];
         }
         
         
         
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         //         [self noIntenet];
         NSLog(@"%@", error);
     }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}
- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    
    imageData2=[NSData data];
    imageData = UIImageJPEGRepresentation(currentImage, 1.0);
    while ([imageData length]/1000>400) {
        if (imageData.length==imageData2.length) {
            break;
        }
        imageData2=imageData;
        UIImage *image=[[UIImage alloc]initWithData:imageData];
        imageData = UIImageJPEGRepresentation(image, 0.2);
    }
    //    if ([imageData length]/1000>400) {
    //            UIImage *image=[[UIImage alloc]initWithData:imageData];
    //            imageData = UIImageJPEGRepresentation(image, 0.1);
    //    }
    NSLog(@"+++++++=++++=+++=+%lu",(unsigned long)imageData.length);
    //    UIImage *result = [UIImage imageWithData:imageData];
    //
    //    while ((imageData.length/1024)>500) {
    //        imageData = UIImageJPEGRepresentation(result, 0.5);
    //        result = [UIImage imageWithData:imageData];
    //    }
    // 获取沙盒目录
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    
    [imageData writeToFile:fullPath atomically:NO];
}

/**
 修改用户头像
 
 @param image 所修改的头像
 */
-(void)changeUserImage:(UIImage *)image{
    
    self.imageView.image=image;
    
    
    [self saveImage:image withName:@"currentImage.png"];
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"currentImage.png"];
    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
    NSString *url =[[NSString alloc]initWithFormat:@"%@Extra/upload/upload",BASEURL];
    [self.imageView setImage:savedImage];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    self.date = (long long int)time;
    NSString *nameValue = [[NSString alloc]initWithFormat:@"%@_%lld",appdelegate.userInfoDic[@"uuid"],self.date ];
    NSLog(@"userInfoArray===%@",appdelegate.userInfoArray);
    
    NSData *img_Data = [NSData dataWithContentsOfFile:fullPath];
    
    NSMutableDictionary *parmer = [NSMutableDictionary dictionary];
    [parmer setValue:nameValue forKey:@"name"];
    [parmer setValue:@"head_image" forKey:@"type"];
    [parmer setObject:img_Data forKey:@"file1"];
    
    //    DebugLog(@"pareme ===%@",parmer);
    [KKRequestDataService requestWithURL:url params:parmer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        if ([result[@"result_code"] isEqualToString:@"access"]) {
          
            [self postUploadImageWithNameValue:nameValue];
            
            
            
        }
        NSLog(@"result===%@", result);
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"图片太大,上传失败", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:13];
        hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
        [hud hideAnimated:YES afterDelay:4.f];
        NSLog(@"请求失败");
        
    }];
    
    
    
}

- (IBAction)cancleClick:(UIButton *)sender {
    
    self.tishiview.hidden = YES;

}
- (IBAction)sureBtnClcik:(UIButton *)sender {

    self.tishiview.hidden = YES;
    LZDCenterViewController *vc=[[LZDCenterViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(void)postRequest
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/info/getAuthResult",BASEURL];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];

    [KKRequestDataService requestWithURL:url params:nil httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         if (result) {
             NSString *state=result[@"state"];
             if ([state isEqualToString:@"auth_fail"]) {
                UIAlertView *alert= [[UIAlertView alloc]initWithTitle:result[@"tip"] message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重新认证", nil];
                [alert show];

             }
         }
       
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
         
     }];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        RailNameConfirmVC *confirmVC=[[RailNameConfirmVC alloc]init];
        confirmVC.title=@"实名认证";
        [self.navigationController pushViewController:confirmVC animated:YES];
    }
}

-(void)postRequestAllInfoForUser{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/info/get",BASEURL];
    __block AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         if (result) {
             NSLog(@"%@",result);
             appdelegate.userInfoDic=[NSMutableDictionary dictionaryWithDictionary:result];
             [self.tabView reloadData];
         }
         
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
         
     }];

}
-(void)postRevise:(NSString *)string type:(NSString *)type
{
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/user/accountSet",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    
    [params setObject:string forKey:@"para"];
    
    [params setObject:type forKey:@"type"];
    
    NSLog(@"params===%@",params);
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         DebugLog(@"result===+%@",result);
         MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
         hud.mode = MBProgressHUDModeText;
         if ([result[@"result_code"] intValue]==1 ) {
            
             
             hud.label.font = [UIFont systemFontOfSize:13];
             //    [hud setColor:[UIColor blackColor]];
             hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
             hud.userInteractionEnabled = YES;
             
            
             
             [self postRequestAllInfoForUser];
             
             if (![result[@"award"] isEqualToString:@"false"]) {
                 self.tishiwenzi.text = [NSString stringWithFormat:@"恭喜你，完成个人信息获得 %@ 个积分，快去看看吧",[NSString getTheNoNullStr:result[@"award"] andRepalceStr:@"0"]];
                 self.tishiview.hidden = NO;
                  [hud hideAnimated:YES afterDelay:0.01f];
             }else{
                  hud.label.text = NSLocalizedString(@"修改成功", @"HUD message title");
                  [hud hideAnimated:YES afterDelay:1.f];
             }
//             NSMutableDictionary *new_dic = [appdelegate.userInfoDic mutableCopy];
//             
//             
//             [new_dic setValue:result[@"para"] forKey:result[@"type"]];
//             
//             appdelegate.userInfoDic = new_dic;
             
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
#pragma mark 生日
-(void)_inittableDate
{
    
    m=0;
    
    NSDate *date = [NSDate date];
    
    // Get Current Year
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy"];
    
    currentyearString = [NSString stringWithFormat:@"%@",
                         [formatter stringFromDate:date]];
    year =[currentyearString intValue];
    
    
    // Get Current  Month
    
    [formatter setDateFormat:@"MM"];
    
    currentMonthString = [NSString stringWithFormat:@"%ld",(long)[[formatter stringFromDate:date]integerValue]];
    month=[currentMonthString intValue];
    
    // Get Current  Date
    
    [formatter setDateFormat:@"dd"];
    currentDateString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    
    day =[currentDateString intValue];
    
    
    yearArray = [[NSMutableArray alloc]init];
    monthMutableArray = [[NSMutableArray alloc]init];
    DaysMutableArray= [[NSMutableArray alloc]init];
    for (int i = year-100; i <= year ; i++)
    {
        [yearArray addObject:[NSString stringWithFormat:@"%d",i]];
        
    }
    
    monthArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"];
    
    for (int i=1; i<month+1; i++) {
        [monthMutableArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    DaysArray = [[NSMutableArray alloc]init];
    
    for (int i = 1; i <= 31; i++)
    {
        [DaysArray addObject:[NSString stringWithFormat:@"%d",i]];
        
    }
    for (int i = 1; i <day+1; i++)
    {
        [DaysMutableArray addObject:[NSString stringWithFormat:@"%d",i]];
        
    }
    
}
-(void)creatPickView{
    
    
    datePickView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT-160-64, SCREENWIDTH, 160)] ;
    datePickView.backgroundColor = [UIColor whiteColor];
    datePickView.delegate = self;
    datePickView.dataSource = self;
    toolbarCancelDone = [[UIToolbar alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT-200-64, SCREENWIDTH, 40)];
    [self.view addSubview: datePickView];
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(SCREENWIDTH-60, 0, 60, 40);
    [okBtn setTitle:@"确定" forState:UIControlStateNormal];
    //[okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    okBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [okBtn addTarget:self action:@selector(actionDone) forControlEvents:UIControlEventTouchUpInside];
    [toolbarCancelDone addSubview:okBtn];
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, 0, 60, 40);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelBtn addTarget:self action:@selector(actionCancel) forControlEvents:UIControlEventTouchUpInside];
    [toolbarCancelDone addSubview:cancelBtn];
    
    [self.view addSubview:toolbarCancelDone];
    
    [datePickView selectRow:[yearArray indexOfObject:currentyearString] inComponent:0 animated:NO];
    
    [datePickView selectRow:[monthArray indexOfObject:currentMonthString] inComponent:1 animated:YES];
    
    
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *pickerLabel = (UILabel *)view;
    
    if (pickerLabel == nil) {
        CGRect frame = CGRectMake(0.0, 0.0, 50, 60);
        pickerLabel = [[UILabel alloc] initWithFrame:frame];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:15.0f]];
    }
    if (component == 0)
    {
        pickerLabel.text =  [yearArray objectAtIndex:row]; // Year
    }
    else if (component == 1)
    {
        pickerLabel.text =  [monthArray objectAtIndex:row];  // Month
    }
    else if (component == 2)
    {
        pickerLabel.text =  [DaysArray objectAtIndex:row]; // Date
        
    }
    
    
    return pickerLabel;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    {
        if (component == 0)
        {
            return [yearArray count];
            
        }
        else if (component == 1)
        {
            NSInteger selectRow =  [pickerView selectedRowInComponent:0];
            int n;
            n= year-1970;
            if (selectRow==n) {
                return [monthMutableArray count];
            }else
            {
                return [monthArray count];
                
            }
        }
        else
        {
            NSInteger selectRow1 =  [pickerView selectedRowInComponent:0];
            int n;
            n= year-1970;
            NSInteger selectRow =  [pickerView selectedRowInComponent:1];
            
            if (selectRow==month-1 &selectRow1==n) {
                
                return day;
                
            }else{
                
                if (selectedMonthRow == 0 || selectedMonthRow == 2 || selectedMonthRow == 4 || selectedMonthRow == 6 || selectedMonthRow == 7 || selectedMonthRow == 9 || selectedMonthRow == 11)
                {
                    return 31;
                }
                else if (selectedMonthRow == 1)
                {
                    int yearint = [[yearArray objectAtIndex:selectedYearRow]intValue ];
                    
                    if(((yearint %4==0)&&(yearint %100!=0))||(yearint %400==0)){
                        return 29;
                    }
                    else
                    {
                        return 28; // or return 29
                    }
                    
                }
                else
                {
                    return 30;
                }
            }
        }
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    m=row;
    
    
    
    if (component == 0)
    {
        selectedYearRow = row;
        [datePickView reloadAllComponents];
    }
    else if (component == 1)
    {
        selectedMonthRow = row;
        [datePickView reloadAllComponents];
    }
    else if (component == 2)
    {
        selectedDayRow = row;
        
        [datePickView reloadAllComponents];
        
    }
    
    
}

- (void)actionCancel
{
    
    [UIView animateWithDuration:0.5
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         datePickView.hidden = YES;
                         toolbarCancelDone.hidden = YES;
                         
                         
                     }
                     completion:^(BOOL finished){
                         
                         
                     }];
    
    
}
- (void)actionDone
{
    
    NSString *birthday  = [NSString stringWithFormat:@"%@-%@-%@",[yearArray objectAtIndex:[datePickView selectedRowInComponent:0]],[monthArray objectAtIndex:[datePickView selectedRowInComponent:1]],[DaysArray objectAtIndex:[datePickView selectedRowInComponent:2]]];
    [self postRevise:birthday type:@"age"];
    
    [UIView animateWithDuration:0.5
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         datePickView.hidden = YES;
                         toolbarCancelDone.hidden = YES;
                         
                         
                     }
                     completion:^(BOOL finished){
                         
                         
                     }];
    
}



@end
