//
//  NewShopDetailVC.m
//  BletcShop
//
//  Created by Bletc on 2017/5/12.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "NewShopDetailVC.h"
#import "UIImageView+WebCache.h"
#import "DLStarRatingControl.h"
#import "LandingController.h"
#import "NewBuyCardViewController.h"
#import "BDMapViewController.h"
#import "NewShopCardListCell.h"
#import "SRVideoPlayer.h"
#import "ApriseVC.h"
#import "RailNameConfirmVC.h"
#import "ShopProductsDetailsVC.h"
#import "PictureAndTextVC.h"
#import "ShopDetailCouponsCell.h"
#import "XHStarRateView.h"
#import "InsureVC.h"
@interface NewShopDetailVC ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIWebViewDelegate,LandingDelegate,UIScrollViewDelegate>
{
    UIButton *collectBtn;
    NSDictionary *wholeInfoDic;

    UIButton *title_old_btn;
    UIView *title_old_line;
    
    SDRefreshHeaderView *_refreshheader;
    UIView *old_view;

    
    
    CGFloat scrollViewOffSet;
}
@property BOOL state;

@property(nonatomic,strong) NSMutableArray *card_arr;//包含不同类别会员卡
@property(nonatomic,strong) UITableView *shopTableView;
@property(nonatomic,strong)NSArray *pictureAndTextArray;
@property(nonatomic,strong)NSArray *insureImage_A;

@property (nonatomic, strong) SRVideoPlayer *videoPlayer;
@property(strong,nonatomic)UIButton *playImageView;
@property(strong,nonatomic)NSDictionary *deadLine_dic;


@property(nonatomic,strong)NSMutableDictionary *foldMuta_dia;//保存收起还是打开状态;
@end

@implementation NewShopDetailVC





-(void)viewDidDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
   
    if (![self.navigationController.viewControllers containsObject:self]) {
        [_videoPlayer destroyPlayer];

    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(234, 234, 234);
    self.navigationItem.title = @"店铺详情";

    scrollViewOffSet = 0.0f;
    title_old_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    title_old_btn.tag = 1;
    
    
    NSLog(@"------%ld",title_old_btn.tag);
    
        [self initTableView];

    [self initFootView];

    
    [self postRequestWholeInfo];
}

-(void)initTableView{
    
    
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64-49-1) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.backgroundColor = RGB(240, 240, 240);
    table.showsVerticalScrollIndicator = NO;
    self.shopTableView = table;
    [self.view addSubview:table];
    
    
    _refreshheader = [SDRefreshHeaderView refreshView];
    [_refreshheader addToScrollView:table];
    _refreshheader.isEffectedByNavigationController = NO;
    
    __block typeof(self)tempSelf =self;
    _refreshheader.beginRefreshingOperation = ^{
        //请求数据
        [tempSelf postRequestWholeInfo];
    };
    
    
   
    
    [self creatTableViewHeadView];
}
-(void)initFootView{
    UIView *footView=[[UIView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT-64-49, SCREENWIDTH, 49)];
    footView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:footView];
    NSArray *array = @[@"联系商家",@"立即购买",@"立即收藏"];
    
    for (int i = 0; i <array.count; i++) {
        
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(i*(SCREENWIDTH/array.count), 0, SCREENWIDTH/array.count, 49)];
        [footView addSubview:backView];
        
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake((backView.width-21)/2, 7, 21, 21)];
        imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_n",array[i]]];

        [backView addSubview:imgView];
        
       UIButton* Btn=[UIButton buttonWithType:UIButtonTypeCustom];
        Btn.frame=CGRectMake(0, imgView.bottom+5,backView.width, 10);
        Btn.titleLabel.font=[UIFont systemFontOfSize:10];
        [Btn setTitle:array[i] forState:UIControlStateNormal];
        [Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [backView addSubview:Btn];
        
        
        
        if (i==0) {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(call:)];
            [backView addGestureRecognizer:tap];
            [Btn setTitleColor:NavBackGroundColor forState:0];
            imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_h",array[i]]];

            old_view = backView;
        }
        if (i==1) {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(buyBtnClick:)];
            [backView addGestureRecognizer:tap];
        }

        if (i==2) {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(favorateAction:)];
            [backView addGestureRecognizer:tap];
            collectBtn = Btn;
        }

        
    }
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
    if (indexPath.section ==0) {
        
        return 40;

    }else if (indexPath.section==1){
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        
        return cell.frame.size.height;

    }else if (indexPath.section==2){
            return 32+10;
            
    }else if (indexPath.section==3){
        return 40;
        
    }else if (indexPath.section==4){
               
        return 80;
        
    }else if (indexPath.section==5){
        
        
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        
        return cell.frame.size.height;
        
    }
    
    
    else if(indexPath.section==6){
              
              NSLog(@"-title_old_btn.tag---%ld",title_old_btn.tag);

              
        if (title_old_btn.tag==1) {
            
            UIView *content_View = [self initcontentView];

            return content_View.height;
        }else if (title_old_btn.tag ==2){
           
            return SCREENWIDTH*2/3;

        
        }else{
//            if (indexPath.row!=0) {
                NSString *str = self.pictureAndTextArray[indexPath.row][@"type"];
                if ([str isEqualToString:@"1"]) {
                    return SCREENWIDTH*2/3;
                }else if([str isEqualToString:@"0"]||[str isEqualToString:@"2"]){
                    return (SCREENWIDTH/2-10)*2/3+10;
                }
                return SCREENWIDTH*2/3;
//            }else{
//                if (_pictureAndTextArray.count==0) {
//                    return 40;
//                }else{
//                    return SCREENWIDTH*2/3;
// 
//                }
//                
//            }

        }
        
        
    }
    else if (indexPath.section ==7){
        
                if ((title_old_btn.tag==0 &&self.pictureAndTextArray.count>=1) ||title_old_btn.tag==2) {
        
        
        return 44;
                }else
        
                    NSLog(@"section==7");
        
          return 10;
         
    }

       else if (indexPath.section ==8){
        return 39;
    }
    else if(indexPath.section==9)
    
    {
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        NSArray *arr = wholeInfoDic[@"evaluate_list"];
        if(arr.count>0) {
            return cell.frame.size.height;
        }else{
            return 40;
        }
    }    else if(indexPath.section==10){
        return 10;
    }

    else return 0.01;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 11;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section==0) {

       
        return self.card_arr.count? 1:0;

        
        
    }
    if (section==1) {
        
        return  [self.foldMuta_dia[@"1"] intValue]==1? self.card_arr.count:MIN(self.card_arr.count, 4);
        
    }else if (section==2){
    
        return self.card_arr.count>4? 1:0;
    }

    else if (section==3){
        return [wholeInfoDic[@"coupon_list"] count]? 1:0;
    }
    
    else if (section==4){
        
        
        
        return  [wholeInfoDic[@"coupon_list"] count];
    }
    
    
    else if (section==5){
        return [wholeInfoDic[@"commodity_list"] count]? 1:0;
    }
    
    
    else  if(section==6){
        if ((title_old_btn.tag==0 && self.pictureAndTextArray.count>0) ||(title_old_btn.tag==2 && self.insureImage_A.count>0) ||title_old_btn.tag==1) {
            return 1;
        }else
        
        return 0;
        

    }
    
    else if (section==7){
        
            return 1;
 
        }
    
    else if (section==8){
        return [wholeInfoDic[@"evaluate_list"] count]? 1:0;
    }
    
    else if(section==9){
        NSArray *evaluate_list = wholeInfoDic[@"evaluate_list"];
        
        return evaluate_list.count;

    }else if(section==10){
        return 1;
    }else
    return 0;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIndentifier = @"cellIndentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if(!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
    }

    for (UIView *vw in cell.subviews) {
        if ([vw isKindOfClass:[UIWebView class]]) {
            
            vw.hidden = YES;
        }else{
            [vw removeFromSuperview];

        }
    }

      if (indexPath.section==0) {
        
    
        
          UILabel *like_lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 40)];
          like_lab.text = @"会员卡";
          like_lab.textColor = RGB(61,61,61);
          like_lab.textAlignment = NSTextAlignmentCenter;
          like_lab.font = [UIFont systemFontOfSize:15];
        like_lab.backgroundColor = RGB(240,240,240);
          [cell addSubview:like_lab];
          
          CGFloat  WW = [like_lab.text boundingRectWithSize:CGSizeMake(200, 50) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:like_lab.font} context:nil].size.width;
          
          UIView *line1 = [[UIView alloc]init];
          line1.frame = CGRectMake(13, (like_lab.height-2)/2+like_lab.top, SCREENWIDTH/2-13-WW/2-13, 2);
          line1.backgroundColor = RGB(98,98,98);
          [cell addSubview:line1];
          
          UIView *line2 = [[UIView alloc]init];
          line2.frame = CGRectMake( SCREENWIDTH/2+WW/2+13, line1.top, line1.width, line1.height);
          line2.backgroundColor = RGB(98,98,98);
          [cell addSubview:line2];
          
          
        
          

      
          return cell;
              
         
       
          
        

       
    
    }else if (indexPath.section==1){

        
        return    [self creatCardListCell:indexPath];
        
    }else if(indexPath.section==2){
        
        
        
        UIImageView *backimg = [[UIImageView alloc]initWithFrame:CGRectMake(13, 0, SCREENWIDTH-26, 32)];
        backimg.image = [UIImage imageNamed:@"导角矩形下"];

        [cell addSubview:backimg];
        
        UILabel *lab = [[UILabel alloc]init];
        lab.frame= CGRectMake(0, 11, SCREENWIDTH-17, 12);
        lab.text = @"收起卡片";
        lab.textColor = RGB(88,87,87);
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = [UIFont systemFontOfSize:13];
        [cell addSubview:lab];
       
        UIImageView *imgVright = [[UIImageView alloc]initWithFrame:CGRectMake(lab.center.x+35, lab.center.y-6, 6, 12)];
        imgVright.image = [UIImage imageNamed:@"youjiantou"];
        [cell addSubview:imgVright];
        
        imgVright.transform= CGAffineTransformMakeRotation(-M_PI/2);
        
        cell.backgroundColor = [UIColor clearColor];
        
        
        UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, backimg.bottom, SCREENWIDTH, 10)];
        line1.backgroundColor = RGB(240,240,240);
        [cell addSubview:line1];

        
        
        return cell;
    }else if (indexPath.section==3){
        
        
        
        UILabel *like_lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 40)];
        like_lab.text = @"优惠券";
        like_lab.textColor = RGB(61,61,61);
        like_lab.textAlignment = NSTextAlignmentCenter;
        like_lab.font = [UIFont systemFontOfSize:15];
        like_lab.backgroundColor = RGB(240,240,240);
        [cell addSubview:like_lab];
        
        CGFloat  WW = [like_lab.text boundingRectWithSize:CGSizeMake(200, 50) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:like_lab.font} context:nil].size.width;
        
        UIView *line1 = [[UIView alloc]init];
        line1.frame = CGRectMake(13, (like_lab.height-2)/2+like_lab.top, SCREENWIDTH/2-13-WW/2-13, 2);
        line1.backgroundColor = RGB(98,98,98);
        [cell addSubview:line1];
        
        UIView *line2 = [[UIView alloc]init];
        line2.frame = CGRectMake( SCREENWIDTH/2+WW/2+13, line1.top, line1.width, line1.height);
        line2.backgroundColor = RGB(98,98,98);
        [cell addSubview:line2];
        
        return cell;
    }else if (indexPath.section==4){
        
        
        
        ShopDetailCouponsCell *couponsCell =[ShopDetailCouponsCell ShopDetailCouponsCellWithTableView:tableView];
        
        NSDictionary *dic =wholeInfoDic[@"coupon_list"][indexPath.row];
        
        couponsCell.pricelab.text = dic[@"sum"];
        couponsCell.descriplab.text = [NSString stringWithFormat:@"满%@元可用",dic[@"pri_condition"]];
        couponsCell.timeDesLab.text = dic[@"content"];

        
        if ([dic[@"coupon_type"] isEqualToString:@"OFFLINE"]) {
            couponsCell.upORdownImg.image = [UIImage imageNamed:@"线下shop"];
        }else{
            couponsCell.upORdownImg.image = [UIImage imageNamed:@"线上shop"];

        }
        
        if ([dic[@"received"] isEqualToString:@"true"]) {
            couponsCell.getlab.text =@"已领取";
            couponsCell.getlab.backgroundColor =RGB(191,191,191);
            couponsCell.overdueImg.hidden= NO;

        }else{
            couponsCell.getlab.text =@"领取";
            couponsCell.getlab.backgroundColor =RGB(243,73,78);
            couponsCell.overdueImg.hidden= YES;

        }

        
        return couponsCell;
    }
    
    else if (indexPath.section==5){
        
        UIView *product_v =[self creatproductView];
        
        [cell addSubview: product_v];
        
        
        CGRect frame = cell.frame;
        frame.size.height = product_v.height;
        cell.frame = frame;
        
        return cell;
        
    }
    
    
    else if (indexPath.section==6){
        UITableViewCell *DetailCell;

        
        if (title_old_btn.tag ==1) {
            
            UIView *content_View = [self initcontentView];
            
            [cell addSubview:content_View];
            DetailCell = cell;
            
        }else if (title_old_btn.tag ==2){
            
            UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH*2/3)];
            [cell addSubview:imgView];
            if (self.insureImage_A.count!=0) {

                NSDictionary *dic = _insureImage_A[indexPath.row];
                
                NSURL * nurl1=[[NSURL alloc] initWithString:[[INSURE_IMAGE stringByAppendingString:dic[@"image_url"]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
                [imgView sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"icon3.png"] options:SDWebImageRetryFailed];
                
                NSLog(@"nurl1-------%@",nurl1);
            }
            
           
            
            DetailCell = cell;
        }else{
            if (_pictureAndTextArray.count!=0) {
                DetailCell = [self creatCellWith:indexPath];

            }else{
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREENWIDTH, 40)];
                [cell addSubview:label];
                label.font = [UIFont systemFontOfSize:14];
                label.text = @"暂无详情，敬请期待";
                
                DetailCell = cell;
                
            }

            
        }
        
        
        return DetailCell;
    } else if(indexPath.section==7){
        
        

        
        if ((title_old_btn.tag==0 &&self.pictureAndTextArray.count>=1) ||(title_old_btn.tag==2 &&_insureImage_A.count>1)) {
            UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 33+11)];
            [cell addSubview:backView];
            
            
            
            UILabel *lab = [[UILabel alloc]init];
            lab.frame= CGRectMake(0, 0, SCREENWIDTH-17, 33);
            lab.text = @"查看更多";
            lab.textColor = RGB(51,51,51);
            lab.textAlignment = NSTextAlignmentCenter;
            lab.font = [UIFont systemFontOfSize:13];
            
            [backView addSubview:lab];
            
            UIImageView *imgVright = [[UIImageView alloc]initWithFrame:CGRectMake(lab.center.x+35, lab.center.y-6, 6, 12)];
            imgVright.image = [UIImage imageNamed:@"youjiantou"];
            [backView addSubview:imgVright];
            
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 1)];
            line.backgroundColor = RGB(240,240,240);
            [backView addSubview:line];
            
            
            UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, lab.bottom, SCREENWIDTH, 11)];
            line1.backgroundColor = RGB(240,240,240);
            [backView addSubview:line1];
            
            
        }else{
           
            UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 10)];
            line1.backgroundColor = RGB(240,240,240);
            [cell addSubview:line1];
  
            
        }
            
        
        
        
        return cell;
    }else if(indexPath.section==8){
        
        UIView *back_view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 39)];
        back_view.backgroundColor = RGB(210,210,210);
        [cell addSubview:back_view];

        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, back_view.height-1)];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.text = @"会员口碑";
        lab.textColor = RGB(51,51,51);
        lab.font = [UIFont systemFontOfSize:15];
        lab.backgroundColor = [UIColor whiteColor];
        [back_view addSubview:lab];
        
        
        UILabel *lab_more = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH-27, lab.height)];
        lab_more.textAlignment = NSTextAlignmentRight;
        lab_more.text = @"更多评价";
        lab_more.textColor = RGB(51,51,51);
        lab_more.font = [UIFont systemFontOfSize:12];
        [back_view addSubview:lab_more];
        
        UIImageView *imgVright = [[UIImageView alloc]initWithFrame:CGRectMake(lab_more.right+9, lab_more.center.y-6, 6, 12)];
        imgVright.image = [UIImage imageNamed:@"youjiantou"];
        [back_view addSubview:imgVright];
        
        
        return cell;

        
    }
    
    
    
    else if(indexPath.section==9){
        {
            NSArray *evaluate_list = wholeInfoDic[@"evaluate_list"];
            if (evaluate_list.count==0)
            {
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREENWIDTH, 40)];
                [cell addSubview:label];
                label.font = [UIFont systemFontOfSize:14];
                label.text = @"本店暂无评价";
            }
            if(evaluate_list.count>0){
                
                NSDictionary *dic = evaluate_list[indexPath.row];
                
                UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(13, 13, 34, 34)];
                [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HEADIMAGE,dic[@"headimage"]]] placeholderImage:[UIImage imageNamed:@"3.1-02"]];
                imageView.contentMode=UIViewContentModeScaleAspectFill;
                imageView.layer.cornerRadius = imageView.width/2;
                imageView.layer.masksToBounds = YES;
                [cell addSubview:imageView];
                
                UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(imageView.right+13, 17, SCREENWIDTH-53, 13)];
                nameLabel.text=dic[@"nickname"];
                nameLabel.textAlignment=NSTextAlignmentLeft;
                nameLabel.font=[UIFont systemFontOfSize:14.0f];
                nameLabel.textColor = RGB(51,51,51);
                [cell addSubview:nameLabel];
               
                UILabel *starLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH-110, nameLabel.center.y-12, 110, 35)];
                
                DLStarRatingControl* dlCtrl = [[DLStarRatingControl alloc]initWithFrame:CGRectMake(0, 0, 110, 35) andStars:5 isFractional:YES star:[UIImage imageNamed:@"result_small_star_disable_iphone"] highlightStar:[UIImage imageNamed:@"redstar"]];
                dlCtrl.autoresizingMask =  UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
                dlCtrl.userInteractionEnabled = NO;
                
                dlCtrl.rating = [[NSString getTheNoNullStr:[dic objectForKey:@"stars"] andRepalceStr:@"0"] floatValue];
                
                [starLabel addSubview:dlCtrl];
                [cell addSubview:starLabel];
                
                
                UILabel *timeLab = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel.left, nameLabel.bottom+7, 200, 10)];
                timeLab.text = dic[@"datetime"];
                timeLab.textColor =RGB(98,98,98);
                timeLab.font =[UIFont systemFontOfSize:10];
                [cell addSubview:timeLab];

                
                UILabel *contentLb = [[UILabel alloc]initWithFrame:CGRectMake(imageView.left, imageView.bottom+14, SCREENWIDTH-16-nameLabel.left, 20)];
                [contentLb setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0f]];
                contentLb.numberOfLines = 0;
                [contentLb setLineBreakMode:NSLineBreakByWordWrapping];
                contentLb.text =dic[@"content"];
                [cell addSubview:contentLb];

                CGRect labelSize = [contentLb.text boundingRectWithSize:CGSizeMake(contentLb.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"HelveticaNeue" size:12.0f],NSFontAttributeName, nil] context:nil];
                contentLb.frame = CGRectMake(contentLb.frame.origin.x, contentLb.frame.origin.y, labelSize.size.width, labelSize.size.height);
                
                
                
                
                CGRect frame = [cell frame];
                frame.size.height = contentLb.bottom+13;
                cell.frame = frame;
                
                
                if (indexPath.row!=evaluate_list.count-1) {
                    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(13, contentLb.bottom+12, SCREENWIDTH-25, 1)];
                    line.backgroundColor = RGB(210,210,210);
                    [cell addSubview:line];
                }
                
                
            }
            
        }
        
        
        return cell;
    }else {
        UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 10)];
        line1.backgroundColor = RGB(240,240,240);
        [cell addSubview:line1];
        return cell;

    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    
      return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==6) {
        return 41;
    }else{
        return 0.01;
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section==6){
        
        UIView *backView = [[UIView alloc]init];
        backView.frame = CGRectMake(0, 0, SCREENWIDTH, 41);
        
        backView.backgroundColor = [UIColor whiteColor];
        NSArray *arr = @[@"图文详情",@"购买须知",@"安全保障"];
        for (int i = 0; i <arr.count; i ++) {
            UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
           titleBtn.frame = CGRectMake(SCREENWIDTH/arr.count*i, 0, SCREENWIDTH/arr.count, 40);
            titleBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
            [titleBtn setTitleColor:RGB(51, 51, 51) forState:0];
            [titleBtn setTitle:arr[i] forState:0];
            [titleBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [backView addSubview:titleBtn];
            
            titleBtn.tag = i;
            
              UIView *red_line = [[UIView alloc]init];
            red_line.bounds = CGRectMake(0, 0, 57, 3);
            red_line.center = CGPointMake(titleBtn.center.x, titleBtn.center.y+18);
            red_line.backgroundColor = [UIColor whiteColor];
            red_line.tag = titleBtn.tag +99;
            [backView addSubview:red_line];
            
             if (titleBtn.tag==title_old_btn.tag) {
                    title_old_btn = titleBtn;
                 title_old_line = red_line;
                 
                 red_line.backgroundColor = NavBackGroundColor;

//                    [titleBtn setTitleColor:NavBackGroundColor forState:0];
                }
            }
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = RGB(225, 225, 225);
        line.frame= CGRectMake(0, 40, SCREENWIDTH, 1);
        [backView addSubview:line];
        
        
        return backView;
    }else{
        return nil;
    }
    
}

-(void)titleBtnClick:(UIButton*)sender{
    
    
    if (title_old_btn !=sender) {
//        [sender setTitleColor:NavBackGroundColor forState:0];
//        [title_old_btn setTitleColor:RGB(51, 51, 51) forState:0];
        title_old_btn = sender;
        
       UIView *lineView = [sender.superview viewWithTag:sender.tag +99];
        lineView.backgroundColor = NavBackGroundColor;
        title_old_line.backgroundColor =[UIColor whiteColor];
        title_old_line = lineView;
    }
    
    
//    NSIndexSet *indexset = [NSIndexSet indexSetWithIndex:6];
//    NSIndexSet *indexset1 =[NSIndexSet indexSetWithIndex:7];
//    
//    [self.shopTableView reloadSections:indexset withRowAnimation:UITableViewRowAnimationNone];
//    
//    [self.shopTableView reloadSections:indexset1 withRowAnimation:UITableViewRowAnimationNone];
    
    [_shopTableView reloadData];
//
    NSLog(@"===%@",title_old_btn);

}
-(UIView*)initcontentView{
    
    UIView *backView = [[UIView alloc]init];
    backView.backgroundColor = [UIColor whiteColor];
    
    UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(13, 10, 3, 15)];
    view1.backgroundColor=RGB(253,108,110);
    [backView addSubview:view1];
    
    UILabel *timeLable=[[UILabel alloc]initWithFrame:CGRectMake(22, 10, SCREENWIDTH-13, 13)];
    timeLable.textAlignment=NSTextAlignmentLeft;
    timeLable.text=@"使用时间:";
    timeLable.font=[UIFont systemFontOfSize:15.0f];
    [backView addSubview:timeLable];
    NSString *time=[NSString getTheNoNullStr:wholeInfoDic[@"time"] andRepalceStr:@"周一到周日  遇到节假日工作时间会有调整"];
    
    CGFloat labelHeight = [time getTextHeightWithShowWidth:SCREENWIDTH AndTextFont:[UIFont systemFontOfSize:15.0] AndInsets:5];
    
    UILabel *timeContent=[[UILabel alloc]initWithFrame:CGRectMake(13, 34, SCREENWIDTH-13, labelHeight)];
    timeContent.numberOfLines=0;
    timeContent.font=[UIFont systemFontOfSize:15.0f];
    timeContent.textAlignment=NSTextAlignmentLeft;
    timeContent.textColor=[UIColor grayColor];
    timeContent.text=time;
    [backView addSubview:timeContent];
    
    UIView *view2=[[UIView alloc]initWithFrame:CGRectMake(13, 34+labelHeight+13, 3, 15)];
    view2.backgroundColor=view1.backgroundColor;
    [backView addSubview:view2];
    
    NSString *notice=[NSString getTheNoNullStr:wholeInfoDic[@"notice"] andRepalceStr:@"本店会员卡优惠多多"];
    
    CGFloat labelHeight2 = [notice getTextHeightWithShowWidth:SCREENWIDTH AndTextFont:[UIFont systemFontOfSize:15.0] AndInsets:5];
    
    
    UILabel *noticeLable=[[UILabel alloc]initWithFrame:CGRectMake(22, 34+labelHeight+13, SCREENWIDTH-13, 13)];
    noticeLable.textAlignment=NSTextAlignmentLeft;
    noticeLable.text=@"注意事项";
    noticeLable.font=[UIFont systemFontOfSize:15.0f];
    [backView addSubview:noticeLable];
    
    UILabel *noticeContent=[[UILabel alloc]initWithFrame:CGRectMake(13, 34+labelHeight+13+13+11, SCREENWIDTH-26, labelHeight2)];
    noticeContent.numberOfLines=0;
    noticeContent.font=[UIFont systemFontOfSize:15.0f];
    noticeContent.text=notice;
    noticeContent.textAlignment=NSTextAlignmentLeft;
    noticeContent.textColor=[UIColor grayColor];
    [backView addSubview:noticeContent];
    
    UIView *view3=[[UIView alloc]initWithFrame:CGRectMake(13, CGRectGetMaxY(noticeContent.frame)+11, 3, 15)];
    view3.backgroundColor=view1.backgroundColor;
    [backView addSubview:view3];
    
    UILabel *phoneLable=[[UILabel alloc]initWithFrame:CGRectMake(22, CGRectGetMaxY(noticeContent.frame)+11, SCREENWIDTH-13, 13)];
    phoneLable.textAlignment=NSTextAlignmentLeft;
    phoneLable.text=@"商家电话:";
    phoneLable.font=[UIFont systemFontOfSize:15.0f];
    [backView addSubview:phoneLable];
    
    UILabel *phoneContent=[[UILabel alloc]initWithFrame:CGRectMake(13, CGRectGetMaxY(noticeContent.frame)+11+13+11, SCREENWIDTH-13, 13)];
    phoneContent.font=[UIFont systemFontOfSize:15.0f];
    phoneContent.numberOfLines=0;
    phoneContent.textAlignment=NSTextAlignmentLeft;
    phoneContent.textColor=[UIColor grayColor];
    phoneContent.text=[NSString getTheNoNullStr:[wholeInfoDic objectForKey:@"store_number"] andRepalceStr:[wholeInfoDic objectForKey:@"phone"]];
    [backView addSubview:phoneContent];
    
    
    backView.frame = CGRectMake(0, 0, SCREENWIDTH, phoneContent.bottom +20);
    return backView;
}



-(void)reloadAPI{
    [self postRequestWholeInfo];
}
-(void)getTheCoupons:(NSIndexPath*)indexPath{
    NSLog(@"领取优惠券");
    
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    if (!appdelegate.IsLogin) {
        LandingController *landVc = [[LandingController alloc]init];
        landVc.delegate =self;
        [self.navigationController pushViewController:landVc animated:YES];
    }else
    {
        
       
        
//        UIButton *btn = [tap.view.superview.subviews lastObject];
        
        
        
        
        NSArray *coupon_list = wholeInfoDic[@"coupon_list"];
        NSDictionary *dic = coupon_list[indexPath.row];
        
        if ([dic[@"received"] isEqualToString:@"true"]) {
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"已经领取过了!";
            hud.label.font = [UIFont systemFontOfSize:13];
            [hud hideAnimated:YES afterDelay:2];
        }else{
            
            [self postReceiveConponRequest:dic];
            
        }

    }
    
}
//创建我的商品view
-(UIView*)creatproductView{
    
    
    NSArray* commodity_list = wholeInfoDic[@"commodity_list"];
    
//    if (commodity_list.count==0) {
//        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREENWIDTH, 40)];
//        label.font = [UIFont systemFontOfSize:14];
//        label.text = @"本店暂无商品";
//        
//        return label;
//    }else{
    
        UIView *back_view = [[UIView alloc]init];
        back_view.backgroundColor = RGB(240,240,240);
        
        
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 35)];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.text = @"全部商品";
        lab.textColor = RGB(78,78,78);
        lab.font = [UIFont systemFontOfSize:15];
        lab.backgroundColor = [UIColor whiteColor];
        [back_view addSubview:lab];
       
        
        UILabel *lab_more = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH-27, 35)];
        lab_more.textAlignment = NSTextAlignmentRight;
        lab_more.text = @"更多商品";
        lab_more.textColor = RGB(61,61,61);
        lab_more.font = [UIFont systemFontOfSize:12];
        [back_view addSubview:lab_more];
        
        UIImageView *imgVright = [[UIImageView alloc]initWithFrame:CGRectMake(lab_more.right+9, lab_more.center.y-6, 6, 12)];
        imgVright.image = [UIImage imageNamed:@"youjiantou"];
        [back_view addSubview:imgVright];
        
        
        
        
        
    
        CGFloat product_ww = (SCREENWIDTH -13*2-9*2)/3;
        
        
        
        
        UIScrollView *commodity_scroView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, lab.bottom+1, SCREENWIDTH, product_ww +26+30+10)];
        commodity_scroView.showsVerticalScrollIndicator = NO;
        commodity_scroView.showsHorizontalScrollIndicator = NO;
        commodity_scroView.backgroundColor = [UIColor whiteColor];
        [back_view addSubview:commodity_scroView];
        
        
        for (int i = 0; i < MIN(commodity_list.count, 3); i ++) {
            NSDictionary *dic_comm = commodity_list[i];
            UIView *b_v = [[UIView alloc]initWithFrame:CGRectMake((product_ww +9)*i+13, 10, product_ww, product_ww +26+30)];
            b_v.tag = i;
            [commodity_scroView addSubview:b_v];
            
            UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(productClick)];
            
            [b_v addGestureRecognizer:tap];
            
            UIImageView *ImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, b_v.width, b_v.width)];
            NSURL * nurl1=[[NSURL alloc] initWithString:[[SOURCE_PRODUCT stringByAppendingString:dic_comm[@"image_url"]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
            [ImgView sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"icon3"]];
            [b_v addSubview:ImgView];
            
            
            UILabel *title_lab = [[UILabel alloc]initWithFrame:CGRectMake(0, ImgView.bottom, ImgView.width, 30)];
            title_lab.text =dic_comm[@"name"];
            title_lab.numberOfLines=2;
            title_lab.textAlignment =NSTextAlignmentCenter;
            title_lab.textColor = RGB(51, 51, 51);
            title_lab.font = [UIFont systemFontOfSize:14];
            [b_v addSubview:title_lab];
            
            CGFloat title_height = [title_lab.text boundingRectWithSize:CGSizeMake(ImgView.width, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:title_lab.font} context:nil].size.height;
            CGRect  frame = title_lab.frame;
            frame.size.height = title_height<20?29:title_height;
            title_lab.frame = frame;
            
            
            
            
            UILabel *price_lab = [[UILabel alloc]initWithFrame:CGRectMake(0, ImgView.bottom+30, ImgView.width, 13)];
            price_lab.text =[NSString stringWithFormat:@"¥%@",dic_comm[@"price"]];
            price_lab.textAlignment =NSTextAlignmentCenter;
            price_lab.textColor = RGB(243,73,78);
            price_lab.font = [UIFont systemFontOfSize:14];
            [b_v addSubview:price_lab];
            
            
        }
        
        
        back_view.frame = CGRectMake(0, 0, SCREENWIDTH, commodity_scroView.bottom+5);
        return back_view;
//    }
    
    
}
#pragma mark 会员卡列表cell
-(NewShopCardListCell*)creatCardListCell:(NSIndexPath*)indexPath
{
    
    NewShopCardListCell *card_cell = [self.shopTableView dequeueReusableCellWithIdentifier:@"NewShopCardListCell"];
    if (!card_cell) {
        card_cell = [[NewShopCardListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NewShopCardListCell"];
        card_cell.selectionStyle =UITableViewCellSelectionStyleNone;
        
    }
    
    NSDictionary *dic = self.card_arr[indexPath.row];
//    NSLog(@"creatCardListCell----%@",dic);

    if (indexPath.row==0) {
        card_cell.back_view.image = [UIImage imageNamed:@"导角矩形上"];
    }else{
        card_cell.back_view.image  = [UIImage imageNamed:@"设置   矩形"];
    }
    card_cell.cardImg.backgroundColor=[UIColor colorWithHexString:[dic objectForKey:@"template"]];
    
    card_cell.vipLab.text = [NSString stringWithFormat:@"VIP%@",[dic objectForKey:@"level"]];
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:card_cell.vipLab.text];
    
    [attr setAttributes:@{NSForegroundColorAttributeName:RGB(253,108,110),NSFontAttributeName:[UIFont boldSystemFontOfSize:17]} range:NSMakeRange(0, 3)];
    
    [attr setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} range:NSMakeRange(3, card_cell.vipLab.text.length-3)];
    
    card_cell.vipLab.attributedText = attr;
    card_cell.content_lab.text= [NSString getTheNoNullStr:[dic objectForKey:@"des"] andRepalceStr:@"暂无优惠!"];
    
    
    card_cell.cardPriceLable.text = [NSString stringWithFormat:@"￥%@",[dic objectForKey:@"price"]];
    
    NSMutableAttributedString *attr_price = [[NSMutableAttributedString alloc]initWithString:card_cell.cardPriceLable.text];
    
    
    [attr_price setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]} range:NSMakeRange(0, 1)];
    
    card_cell.cardPriceLable.attributedText = attr_price;
    
    
    
    NSString *discounts=[NSString getTheNoNullStr:[dic objectForKey:@"rule"] andRepalceStr:@"0"];
    CGFloat dis=[discounts floatValue]/10.0f;
    card_cell.discountLable.text=[NSString stringWithFormat:@"%g折",dis];
    
    
    
    
    if ([[dic objectForKey:@"type"] isEqualToString:@"计次卡"]) {
        card_cell.discountLable.hidden = NO;

        card_cell.discountLable.text=[NSString stringWithFormat:@"%@次",discounts];
    }else   if ([[dic objectForKey:@"type"] isEqualToString:@"储值卡"]){
        card_cell.discountLable.hidden = NO;

        if (dis==10) {
            card_cell.discountLable.text=@"无折扣";
 
        }
    }else{
        card_cell.discountLable.hidden = YES;
    }
    
    
    
    CGRect frame = card_cell.discountLable.frame ;
    
    CGFloat ww = [card_cell.discountLable.text boundingRectWithSize:CGSizeMake(1000, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:card_cell.discountLable.font} context:nil].size.width;
    
    frame.size.width = ww +5;
    card_cell.discountLable.frame = frame;
    
    CGRect timeFrame = card_cell.timeLable.frame;
    timeFrame.origin.x = card_cell.discountLable.right+5;
    card_cell.timeLable.frame = timeFrame;
    
    if ([[NSString getTheNoNullStr:[dic objectForKey:@"indate"] andRepalceStr:@"0"] isEqualToString:@"0"]) {
        card_cell.timeLable.text=[NSString stringWithFormat:@"有效期: 无期限(%@)",[NSString getTheNoNullStr:[dic objectForKey:@"type"] andRepalceStr:@"---"]];
    }else{
        card_cell.timeLable.text=[NSString stringWithFormat:@"有效期: %@(%@)",self.deadLine_dic[[NSString getTheNoNullStr:[dic objectForKey:@"indate"] andRepalceStr:@"0"]],[NSString getTheNoNullStr:[dic objectForKey:@"type"] andRepalceStr:@"---"]];
    }
    
    
    if ([dic[@"type"] isEqualToString:@"套餐卡"]) {
        
        
        CGRect price_frame = card_cell.cardPriceLable.frame;
        price_frame.origin.x = card_cell.content_lab.left;
        price_frame.origin.y = card_cell.content_lab.bottom +9;
        card_cell.cardPriceLable.frame = price_frame;
        
        
        card_cell.old_pricelab.text = [NSString stringWithFormat:@"¥%@",dic[@"option_sum"]];
        
        CGFloat price_W = [card_cell.cardPriceLable.text boundingRectWithSize:CGSizeMake(1000, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:card_cell.old_pricelab.font} context:nil].size.width;
        
        
        card_cell.old_pricelab.frame = CGRectMake(card_cell.cardPriceLable.left+price_W+9, card_cell.cardPriceLable.center.y-6, 100, 10);
    
        NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc]initWithString:card_cell.old_pricelab.text];
        
        
        [attributedString addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, card_cell.old_pricelab.text.length)];
        
        
        card_cell.old_pricelab.attributedText = attributedString;
        
        card_cell.detaillab.text =[NSString getTheNoNullStr:[dic objectForKey:@"des"] andRepalceStr:@"暂无优惠!"];
        
        CGRect card_frame = card_cell.detaillab.frame;
        
        
        CGFloat detail_h =[card_cell.detaillab.text boundingRectWithSize:CGSizeMake(SCREENWIDTH-13*2-7-43, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :card_cell.detaillab.font} context:nil].size.height;
        
        
        card_frame.size.height = detail_h;
        card_cell.detaillab.frame = card_frame;
        
        
        CGRect back_fram = card_cell.back_view.frame;
        
        back_fram.size.height = card_cell.detaillab.bottom+10;
        card_cell.back_view.frame = back_fram;
        
        
        
        
        CGRect line_fram = card_cell.line.frame;
        
        line_fram.origin.y = card_cell.back_view.height-0.5;
        card_cell.line.frame = line_fram;
        
        
        CGRect shu_fram =  card_cell.shulabView.frame ;
        
        shu_fram.size.height = card_cell.back_view.height-26;
        card_cell.shulabView.frame = shu_fram;
        
    }else{
        
        
        card_cell.old_pricelab.text = @"";
        
         card_cell.old_pricelab.frame =CGRectZero;


        CGRect price_frame = card_cell.cardPriceLable.frame;
        price_frame = CGRectMake(card_cell.back_view.width-87, card_cell.content_lab.top, 50, 14);
        
        card_cell.cardPriceLable.frame = price_frame;
        
        card_cell.detaillab.text =@"";
        
        
        CGRect back_fram = card_cell.back_view.frame;
        
        back_fram.size.height = card_cell.cardImg.bottom+10;
        card_cell.back_view.frame = back_fram;
        
        CGRect line_fram = card_cell.line.frame;
        
        line_fram.origin.y = card_cell.back_view.height-0.5;
        card_cell.line.frame = line_fram;
  
        CGRect shu_fram =  card_cell.shulabView.frame ;
        
        shu_fram.size.height = card_cell.back_view.height-26;
        card_cell.shulabView.frame = shu_fram;

    }
    
    
    CGRect cell_fram =  card_cell.frame;
    cell_fram.size.height = card_cell.back_view.bottom;
    
    card_cell.frame= cell_fram;
    
    
    return card_cell;
}

#pragma mark 图文详情cell
-(UITableViewCell*)creatCellWith:(NSIndexPath*)indexPath{
    UITableViewCell *cell=[self.shopTableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;

        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 5, SCREENWIDTH, SCREENWIDTH*2/3-10)];
        imageView.tag=100;
//        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [cell addSubview:imageView];
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0,(SCREENWIDTH*2/3)-80 , SCREENWIDTH, 100)];
        label.tag=200;
        label.alpha=0.5;
        label.font=[UIFont systemFontOfSize:13.0f];
        label.numberOfLines=0;
        label.backgroundColor=[UIColor blackColor];
        label.textColor=[UIColor whiteColor];
        [cell addSubview:label];
        UIImageView *imageView2=[[UIImageView alloc]initWithFrame:CGRectMake(0, 5, SCREENWIDTH/2, 140)];
        imageView2.tag=300;

        [cell addSubview:imageView2];
    }
    UIImageView *imgView=[cell viewWithTag:100];
    UILabel *label=[cell viewWithTag:200];
    UIImageView *imgView2=[cell viewWithTag:300];
//    if (indexPath.row==0) {
//        label.hidden=NO;
//        imgView2.hidden=YES;
//        imgView.hidden=NO;
//        imgView.contentMode =  UIViewContentModeScaleToFill;
//        imgView.image=[UIImage imageNamed:@"icon3"];
//        NSURL * nurl1=[[NSURL alloc] initWithString:[[SHOPIMAGE_ADDIMAGE stringByAppendingString:[self.infoDic objectForKey:@"image_url"]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
//        [imgView sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"icon3.png"] options:SDWebImageRetryFailed];
//        NSString *newStr=[self.infoDic objectForKey:@"store"];
//        CGFloat lableHeight=[newStr getTextHeightWithShowWidth:SCREENWIDTH AndTextFont:[UIFont systemFontOfSize:13.0f] AndInsets:5];
//        label.text=newStr;
//        label.frame=CGRectMake(0, SCREENWIDTH*2/3-lableHeight-5, SCREENWIDTH, lableHeight);
//    }
    
//    else{
        NSDictionary *dic = self.pictureAndTextArray[indexPath.row];
       

        NSString *newStr=dic[@"content"];
        CGFloat lableHeight=[newStr getTextHeightWithShowWidth:SCREENWIDTH AndTextFont:[UIFont systemFontOfSize:13.0f] AndInsets:5];
        CGFloat labelHeight2=[newStr getTextHeightWithShowWidth:SCREENWIDTH/2 AndTextFont:[UIFont systemFontOfSize:13.0f] AndInsets:5];
        label.text=newStr;
        label.frame=CGRectMake(0, SCREENWIDTH*2/3-lableHeight-5, SCREENWIDTH, lableHeight);
        
        NSURL * nurl1=[[NSURL alloc] initWithString:[[SHOPIMAGE_New stringByAppendingString:dic[@"image_url"]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
        [imgView2 sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"icon3.png"] options:SDWebImageRetryFailed];
        [imgView sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"icon3.png"] options:SDWebImageRetryFailed];

        
        imgView2.contentMode = UIViewContentModeScaleAspectFit;
        imgView.contentMode = UIViewContentModeScaleAspectFit;

        
        if([dic[@"type"] isEqualToString:@"0"]){
            label.hidden=NO;
            imgView2.hidden=NO;
            imgView.hidden=YES;
            imgView2.frame=CGRectMake(5, 5, SCREENWIDTH/2-10, (SCREENWIDTH/2-10)*2/3);
            if (labelHeight2<(SCREENWIDTH/2-10)*2/3) {
                label.frame=CGRectMake(SCREENWIDTH/2, (SCREENWIDTH/2-10)*1/3-labelHeight2/2+5, SCREENWIDTH/2, labelHeight2);
            }else{
                label.frame=CGRectMake(SCREENWIDTH/2, 5, SCREENWIDTH/2, (SCREENWIDTH/2-10)*2/3);
            }
            label.backgroundColor=[UIColor whiteColor];
            label.textColor=[UIColor blackColor];
           
        }else if ([dic[@"type"] isEqualToString:@"1"]){
            imgView2.hidden=YES;
            imgView.hidden=NO;
            label.hidden=NO;
        }else if ([dic[@"type"] isEqualToString:@"2"]){
            label.hidden=NO;
            imgView2.hidden=NO;
            imgView.hidden=YES;
            imgView2.frame=CGRectMake(SCREENWIDTH/2+5, 5, SCREENWIDTH/2-10,(SCREENWIDTH/2-10)*2/3);
            if (labelHeight2<(SCREENWIDTH/2-10)*2/3) {
                label.frame=CGRectMake(0, (SCREENWIDTH/2-10)*1/3-labelHeight2/2+5, SCREENWIDTH/2, labelHeight2);
            }else{
                label.frame=CGRectMake(0, 5, SCREENWIDTH/2, (SCREENWIDTH/2-10)*2/3);
            }
            label.backgroundColor=[UIColor whiteColor];
            label.textColor=[UIColor blackColor];
            
        }else if ([dic[@"type"] isEqualToString:@"3"]){
            
            imgView2.hidden=YES;
            imgView.hidden=NO;
            label.hidden=YES;
        }
//    }
    return cell;
}
-(void)gotoMapView
{
    
    
    BDMapViewController *controller = [[BDMapViewController alloc]init];
    controller.title = @"查看位置";
    controller.latitude = [[wholeInfoDic objectForKey:@"latitude"] doubleValue];
    controller.longitude = [[wholeInfoDic objectForKey:@"longtitude"] doubleValue];
    
    [self.navigationController pushViewController:controller animated:YES];
    
}

-(void)productClick{
    
    ShopProductsDetailsVC *vc=[[ShopProductsDetailsVC alloc]init];
    vc.wholeInfoDic=wholeInfoDic;
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(void)scanMoreInfo{
    
    ApriseVC *vc=[[ApriseVC alloc]init];
    vc.muid=wholeInfoDic[@"muid"];
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(void)call:(UITapGestureRecognizer*)tap{
    if (old_view !=tap.view) {
      UIImageView*imgView = tap.view.subviews[0];
        UIButton *btn = tap.view.subviews[1];
        [btn setTitleColor:NavBackGroundColor forState:0];
        imgView.image =[UIImage imageNamed:[NSString stringWithFormat:@"%@_h",btn.titleLabel.text]];

        
        UIImageView*imgView_old = old_view.subviews[0];
        UIButton *btn_old = old_view.subviews[1];
        [btn_old setTitleColor:[UIColor blackColor] forState:0];
        imgView_old.image =[UIImage imageNamed:[NSString stringWithFormat:@"%@_n",btn_old.titleLabel.text]];

        
        old_view = tap.view;
    }
    
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"拨打电话" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:[NSString getTheNoNullStr:[wholeInfoDic objectForKey:@"store_number"] andRepalceStr:[wholeInfoDic objectForKey:@"phone"]] otherButtonTitles:nil, nil];
    [sheet showInView:self.shopTableView];
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        NSMutableString* telStr = [[NSMutableString alloc]initWithString:@"tel://"];
        [telStr appendString:[NSString getTheNoNullStr:[wholeInfoDic objectForKey:@"store_number"] andRepalceStr:[wholeInfoDic objectForKey:@"phone"]]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telStr]];
    }
}




//获取商家所有信息
-(void)postRequestWholeInfo{
    
    [self showHudInView:self.view hint:@"加载中..."];
    
    AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/merchant/contentGet",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[self.infoDic objectForKey:@"muid"] forKey:@"muid"];
    
    if (appdelegate.IsLogin) {
        [params setValue:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    }else{
        [params setValue:@"null" forKey:@"uuid"];
 
    }
    
    [params setObject:@"1" forKey:@"index"];
    
    NSLog(@"paramer ===%@",params);
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         [_refreshheader endRefreshing];
         [self hideHud];
         
         NSLog(@"result====%@", result);
         NSDictionary *card_Arr_dic=result[@"card_list"];
         
         [self.card_arr removeAllObjects];
         
         [self.card_arr addObjectsFromArray:card_Arr_dic[@"value"]];
         [self.card_arr addObjectsFromArray:card_Arr_dic[@"count"]];
         [self.card_arr addObjectsFromArray:card_Arr_dic[@"meal"]];
         [self.card_arr addObjectsFromArray:card_Arr_dic[@"experience"]];

        
         
         wholeInfoDic=[result copy];
         
         if ([result[@"collect_state"] isEqualToString:@"true"]) {
             self.state = YES;
             
             [collectBtn setTitle:@"取消收藏" forState:0];
         }else if ([result[@"collect_state"] isEqualToString:@"false"]) {
             self.state = NO;
             [collectBtn setTitle:@"立即收藏" forState:0];
             
         }

         self.pictureAndTextArray = result[@"imgtxt_list"];
         
         
         
         [self creatTableViewHeadView];
//         [self postRequestGetInfo];
         [self getInsuranceImgs];
         
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         [_refreshheader endRefreshing];
         [self hideHud];

         //         [self noIntenet];
         NSLog(@"%@", error);
     }];
    
}


-(void)creatTableViewHeadView{
    
    UIView *backView = [[UIView alloc]init];
    backView.backgroundColor = [UIColor whiteColor];
    
    NSLog(@"--creatTableViewHeadView---");
    if ([self.videoID isEqualToString:@""]) {
        UIImageView *shopImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 221*LZDScale)];
        [backView addSubview:shopImageView];
        
        NSURL * nurl1=[[NSURL alloc] initWithString:[[SHOPIMAGE_ADDIMAGE stringByAppendingString:[NSString getTheNoNullStr:[wholeInfoDic  objectForKey:@"image_url"] andRepalceStr:@""]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
        [shopImageView sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"icon3.png"] options:SDWebImageRetryFailed];
        
        
        
        if ([wholeInfoDic[@"coupon_list"] count]!=0) {
            UILabel *coup_lab = [[UILabel alloc]init];
            [shopImageView addSubview:coup_lab];
            coup_lab.text = @"优惠券";
            coup_lab.textColor = [UIColor whiteColor];
            coup_lab.backgroundColor = RGB(255,0,0);
            coup_lab.layer.cornerRadius = 2;
            coup_lab.layer.masksToBounds = YES;
            coup_lab.textAlignment = NSTextAlignmentCenter;
            coup_lab.font = [UIFont systemFontOfSize:13];

            
            coup_lab.frame = CGRectMake(13, shopImageView.height-26, 50, 16);
            
        }
        
        if (self.card_arr.count!=0) {
            UILabel *card_lab = [[UILabel alloc]init];
            [shopImageView addSubview:card_lab];
            card_lab.font = [UIFont systemFontOfSize:13];

            card_lab.backgroundColor = RGB(253,108,110);
            card_lab.layer.cornerRadius = 2;
            card_lab.textColor = [UIColor whiteColor];
            card_lab.text = @"会员卡";
            card_lab.textAlignment = NSTextAlignmentCenter;
            card_lab.layer.masksToBounds = YES;
            
            if ([wholeInfoDic[@"coupon_list"] count]!=0) {
                
                card_lab.frame = CGRectMake(13 +60, shopImageView.height-26, 50, 16);

            }else{
                card_lab.frame = CGRectMake(13, shopImageView.height-26, 50, 16);
                
            }
            
        }
        
    }else{
        UIView *playerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 221*LZDScale)];
        [backView addSubview:playerView];
        
        NSString *url = [NSString stringWithFormat:@"%@%@",VEDIO_URL,self.videoID];
        NSLog(@"VEDIO_URL===%@",url);
        
        NSString *imgUrl =   [[SHOPIMAGE_ADDIMAGE stringByAppendingString:[NSString getTheNoNullStr:[wholeInfoDic  objectForKey:@"image_url"] andRepalceStr:@""]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
        
        self.videoPlayer = [SRVideoPlayer playerWithVideoURL:[NSURL URLWithString:url] playerView:playerView playerSuperView:playerView.superview andImgUrl:imgUrl];
        _videoPlayer.videoName = @"";

        
        _videoPlayer.playerEndAction = SRVideoPlayerEndActionStop;
        [_videoPlayer pause];
    }
    
   
    
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.textColor = RGB(61,61,61);
    nameLabel.numberOfLines = 0;
    nameLabel.font = [UIFont systemFontOfSize:16];
    nameLabel.text = [wholeInfoDic objectForKey:@"store"];
    [backView addSubview:nameLabel];
    
    CGFloat name_h = [UILabel getSizeWithLab:nameLabel andMaxSize:CGSizeMake(SCREENWIDTH-12-100, MAXFLOAT)].height;
    
    CGFloat name_w = [UILabel getSizeWithLab:nameLabel andMaxSize:CGSizeMake(SCREENWIDTH-12-100, MAXFLOAT)].width;

    
    nameLabel.frame=CGRectMake(13, 221*LZDScale+14, MIN (SCREENWIDTH-12-100,name_w) , name_h);
    

    if (![self.videoID isEqualToString:@""]) {
        
        if ([wholeInfoDic[@"coupon_list"] count]!=0) {
            UILabel *coup_lab = [[UILabel alloc]init];
            [backView addSubview:coup_lab];
            coup_lab.font = [UIFont systemFontOfSize:13];
            coup_lab.text = @"优惠券";
            coup_lab.textColor = [UIColor whiteColor];
            coup_lab.backgroundColor = RGB(255,0,0);
            coup_lab.layer.cornerRadius = 2;
            coup_lab.layer.masksToBounds = YES;
            coup_lab.textAlignment = NSTextAlignmentCenter;
            
            
            coup_lab.frame = CGRectMake(13 +nameLabel.width+10, nameLabel.top, 50, 16);

        }
        
        if (self.card_arr.count!=0) {
            UILabel *card_lab = [[UILabel alloc]init];
            [backView addSubview:card_lab];
            card_lab.font = [UIFont systemFontOfSize:13];

            card_lab.backgroundColor = RGB(253,108,110);
            card_lab.layer.cornerRadius = 2;
            card_lab.textColor = [UIColor whiteColor];
            card_lab.text = @"会员卡";
            card_lab.textAlignment = NSTextAlignmentCenter;
            card_lab.layer.masksToBounds = YES;
            
            
            if ([wholeInfoDic[@"coupon_list"] count]!=0) {
                
                card_lab.frame = CGRectMake(13 +nameLabel.width+10+60, nameLabel.top, 50, 16);
                
            }else{
                card_lab.frame = CGRectMake(13 +nameLabel.width+10, nameLabel.top, 50, 16);
                
            }        }

    }
    
    
    //评价星星
    
    XHStarRateView *starView = [[XHStarRateView alloc]initWithFrame:CGRectMake(nameLabel.left, nameLabel.bottom+19, 77, 15)];
    starView.userInteractionEnabled = NO;
    starView.currentScore = [[NSString getTheNoNullStr:[wholeInfoDic objectForKey:@"stars"] andRepalceStr:@"0"] floatValue];
    starView.rateStyle = IncompleteStar;
    [backView addSubview:starView];

    
//    UILabel *starLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, nameLabel.bottom+10, 110, 35)];
//
//    DLStarRatingControl* dlCtrl = [[DLStarRatingControl alloc]initWithFrame:CGRectMake(0, 0, 110, 35) andStars:5 isFractional:YES star:[UIImage imageNamed:@"result_small_star_disable_iphone"] highlightStar:[UIImage imageNamed:@"redstar"]];
//    dlCtrl.autoresizingMask =  UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
//    dlCtrl.userInteractionEnabled = NO;
//    
//    dlCtrl.rating = [[NSString getTheNoNullStr:[wholeInfoDic objectForKey:@"stars"] andRepalceStr:@"0"] floatValue];
//    
//    [starLabel addSubview:dlCtrl];
//    [backView addSubview:starLabel];
    
    
    UILabel *lab1=[[UILabel alloc]initWithFrame:CGRectMake(starView.right + 5, starView.top+1.5, SCREENWIDTH-90-95-20-62, 12)];
    lab1.textAlignment=NSTextAlignmentLeft;
    lab1.text=[[NSString alloc]initWithFormat:@"| 已售:%@",[NSString getTheNoNullStr:[wholeInfoDic objectForKey:@"sold"] andRepalceStr:@"0"]];
    lab1.textColor = RGB(102,102,102);
    lab1.font=[UIFont systemFontOfSize:12.0f];
    [backView addSubview:lab1];
    
    
    
    
    UIImageView *addressimg = [[UIImageView alloc]initWithFrame:CGRectMake(13, lab1.bottom+10, 13, 16)];
    addressimg.image = [UIImage imageNamed:@"location"];
    [backView addSubview:addressimg];
    
    UILabel *addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(addressimg.right+4, addressimg.top+6, SCREENWIDTH-(addressimg.right+4+20), 34)];
    addressLabel.font = [UIFont systemFontOfSize:11];
    addressLabel.text = [wholeInfoDic objectForKey:@"address"];
    addressLabel.textColor =RGB(98,98,98);
    
    addressLabel.text = [addressLabel.text  stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    addressLabel.text = [addressLabel.text  stringByReplacingOccurrencesOfString:@"\n" withString:@""];

    addressLabel.userInteractionEnabled = YES;
    addressLabel.numberOfLines=0;
    [backView addSubview:addressLabel];

    
//    UIGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoMapView)];
//    [addressLabel addGestureRecognizer:tapGesture];
    
    
    CGSize address_size = [UILabel getSizeWithLab:addressLabel andMaxSize:CGSizeMake(addressLabel.width, MAXFLOAT)];
    
    
    CGRect address_f = addressLabel.frame;
    
    address_f.size.height = address_size.height;
    address_f.size.width = address_size.width+3;

    addressLabel.frame = address_f;
    
    
    UIButton *gotomapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    gotomapBtn.frame = CGRectMake(0, addressLabel.top, SCREENWIDTH, addressLabel.bottom+14- addressLabel.top);
    [gotomapBtn addTarget:self action:@selector(gotoMapView) forControlEvents:UIControlEventTouchUpInside];
    
    [backView addSubview: gotomapBtn];


    UIImageView *imgV = [[UIImageView alloc]init];
    imgV.image = [UIImage imageNamed:@"youjiantou"];
    [backView addSubview:imgV];
    [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(6);
        make.height.mas_equalTo(12);
        make.right.equalTo(backView).offset(-12);
        make.centerY.mas_equalTo(addressLabel);
        
        
    }];
    
    backView.frame = CGRectMake(0, 0, SCREENWIDTH, addressLabel.bottom+14);


    self.shopTableView.tableHeaderView = backView;
}
//立即购买
-(void)buyBtnClick:(UITapGestureRecognizer*)tap{
    
    if (old_view !=tap.view) {
        UIImageView*imgView = tap.view.subviews[0];
        UIButton *btn = tap.view.subviews[1];
        [btn setTitleColor:NavBackGroundColor forState:0];
        imgView.image =[UIImage imageNamed:[NSString stringWithFormat:@"%@_h",btn.titleLabel.text]];

        
        UIButton *btn_old = old_view.subviews[1];
        [btn_old setTitleColor:[UIColor blackColor] forState:0];
        UIImageView*imgView_old = old_view.subviews[0];
        imgView_old.image =[UIImage imageNamed:[NSString stringWithFormat:@"%@_n",btn_old.titleLabel.text]];
       
        
        
        old_view = tap.view;
    }

    
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    if (!appdelegate.IsLogin) {
        LandingController *landVc = [[LandingController alloc]init];
        [self.navigationController pushViewController:landVc animated:YES];
    }else
    {
        if (self.card_arr.count) {
            
            [self postGetAuthStateindex:999];
            
           
        }else{
            [self showHint:@"本店暂无卡出售"];
           
        }
        
    }
    
}


//收藏点击

-(void)favorateAction:(UITapGestureRecognizer*)tap{

if (old_view !=tap.view) {
    UIImageView*imgView = tap.view.subviews[0];
    UIButton *btn = tap.view.subviews[1];
    [btn setTitleColor:NavBackGroundColor forState:0];
    imgView.image =[UIImage imageNamed:[NSString stringWithFormat:@"%@_h",btn.titleLabel.text]];

    
    UIImageView*imgView_old = old_view.subviews[0];
    UIButton *btn_old = old_view.subviews[1];
    [btn_old setTitleColor:[UIColor blackColor] forState:0];
    imgView_old.image =[UIImage imageNamed:[NSString stringWithFormat:@"%@_n",btn_old.titleLabel.text]];

    
    old_view = tap.view;
}

    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    if (!appdelegate.IsLogin) {
        LandingController *landingView = [[LandingController alloc]init];
        [self.navigationController pushViewController:landingView animated:YES];
    }else{
        NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/collect/stateSet",BASEURL];
        AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:[appdelegate.userInfoDic objectForKey:@"uuid"] forKey:@"user"];
        [params setObject:[self.infoDic objectForKey:@"muid"] forKey:@"merchant"];
        
        if (self.state==YES) {
            [params setObject:@"false" forKey:@"state"];
        }else{
            [params setObject:@"true" forKey:@"state"];
        }
        
        NSLog(@"%@",params);
        [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
         {
             NSLog(@"%@", result);
             NSDictionary *dic = [result copy];
             MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
             hud.mode = MBProgressHUDModeText;
             ;
             if (self.state==YES)
             {
                 if ([dic[@"result_code"] isEqualToString:@"false"])
                 {
                     hud.label.text = NSLocalizedString(@"取消收藏成功", @"HUD message title");
                     [collectBtn setTitle:@"立即收藏" forState:0];
                     self.state = NO;
                     hud.label.font = [UIFont systemFontOfSize:13];
                     //    [hud setColor:[UIColor blackColor]];
                     hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
                     hud.userInteractionEnabled = YES;
                     
                     [hud hideAnimated:YES afterDelay:2.f];
                 }
                 else
                 {
                     hud.label.text = NSLocalizedString(@"请求失败", @"HUD message title");
                     
                     hud.label.font = [UIFont systemFontOfSize:13];
                     //    [hud setColor:[UIColor blackColor]];
                     hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
                     hud.userInteractionEnabled = YES;
                     
                     [hud hideAnimated:YES afterDelay:2.f];
                 }
             }else
             {
                 if ([dic[@"result_code"] isEqualToString:@"true"])
                 {
                     hud.label.text = NSLocalizedString(@"收藏成功", @"HUD message title");
                     [collectBtn setTitle:@"取消收藏" forState:0];
                     
                     self.state = YES;
                     hud.label.font = [UIFont systemFontOfSize:13];
                     //    [hud setColor:[UIColor blackColor]];
                     hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
                     hud.userInteractionEnabled = YES;
                     
                     [hud hideAnimated:YES afterDelay:2.f];
                 }
                 else
                 {
                     hud.label.text = NSLocalizedString(@"请求失败", @"HUD message title");
                     
                     hud.label.font = [UIFont systemFontOfSize:13];
                     //    [hud setColor:[UIColor blackColor]];
                     hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
                     hud.userInteractionEnabled = YES;
                     
                     [hud hideAnimated:YES afterDelay:2.f];
                 }
                 
             }
         } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
             //         [self noIntenet];
             NSLog(@"%@", error);
         }];
    }
}


////获取图文介绍
//-(void)postRequestGetInfo
//{
//    
//    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/Imgtxt/get",BASEURL];
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    [params setObject:[self.infoDic objectForKey:@"muid"] forKey:@"muid"];
//    
//    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
//        
//        NSLog(@"postRequestGetInfo%@", result);
//        self.pictureAndTextArray = result;
//        
//        
//        [self getInsuranceImgs];
//
//    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//        NSLog(@"%@", error);
//        
//    }];
//    
//}
-(void)getInsuranceImgs{
    NSString *url =[[NSString alloc]initWithFormat:@"%@Extra/Source/insurance",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[self.infoDic objectForKey:@"muid"] forKey:@"muid"];
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"postRequestGetInfo%@", result);
        self.insureImage_A = result;
        
        [self.shopTableView reloadData];
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];

    
}
////获取收藏状态
//-(void)postRequestState
//{
//    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/collect/stateGet",BASEURL];
//    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    [params setObject:[appdelegate.userInfoDic objectForKey:@"uuid"] forKey:@"user"];
//    [params setObject:[self.infoDic objectForKey:@"muid"] forKey:@"merchant"];
//    
//    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
//     {
//         NSLog(@"result====%@", result);
//         NSDictionary *dic = [result copy];
//         if ([dic[@"result_code"] isEqualToString:@"true"]) {
//             self.state = YES;
//             
//             [collectBtn setTitle:@"取消收藏" forState:0];
//         }else if ([dic[@"result_code"] isEqualToString:@"false"]) {
//             self.state = NO;
//             [collectBtn setTitle:@"立即收藏" forState:0];
//             
//         }
//     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
//         //         [self noIntenet];
//         NSLog(@"%@", error);
//     }];
//    
//}

//领取优惠券;

-(void)postReceiveConponRequest:(NSDictionary *)dic{
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/coupon/receive",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    [params setObject:dic[@"muid"] forKey:@"muid"];
    [params setObject:dic[@"coupon_id"] forKey:@"coupon_id"];
    
    NSLog(@"------%@",params);
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        NSLog(@"%@",result);
        if ([result[@"result_code"] integerValue]==1) {
            
            [self showHint:@"领取成功"];
            
            
            [self postRequestWholeInfo];
        }else if([result[@"result_code"] integerValue]==1062){
            [self showHint:@"限领1份"];

          
        }else if([result[@"result_code"] integerValue]==0){
            
            [self showHint:@"已被领取完了!"];

                   }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==1) {
        
        AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        if (!appdelegate.IsLogin) {
            LandingController *landVc = [[LandingController alloc]init];
            [self.navigationController pushViewController:landVc animated:YES];
        }else
        {
            if (self.card_arr.count>0) {

                [self postGetAuthStateindex:indexPath.row];
            }else{
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;

                hud.label.text = NSLocalizedString(@"本店暂无卡出售", @"HUD message title");
                hud.label.font = [UIFont systemFontOfSize:13];
                hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
                [hud hideAnimated:YES afterDelay:2.f];
            }
            
        }

        
    }else if (indexPath.section==2){
        if ([_foldMuta_dia[@"1"] intValue]==0) {
            [self.foldMuta_dia setValue:@"1" forKey:@"1"];
            
        }else{
            [self.foldMuta_dia setValue:@"0" forKey:@"1"];
            
        }
        
//        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:1];
//        
//        [_shopTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];

        [_shopTableView reloadData];
        if ([_foldMuta_dia[@"1"] intValue]==0) {
            
            NSIndexPath *index_p = [NSIndexPath indexPathForRow:0 inSection:0];
            
            [_shopTableView scrollToRowAtIndexPath:index_p atScrollPosition:UITableViewScrollPositionTop animated:NO];
            
        }
        
        NSLog(@"self.foldMuta_dia=%@",self.foldMuta_dia);
       
        
    }else if (indexPath.section==3){
        
        
        
    }else if (indexPath.section==4){
        
        [self getTheCoupons:indexPath];
        
    }else if (indexPath.section==5){
        
        [self productClick];
        
    }else if (indexPath.section==6){
        
    }else if (indexPath.section==7){
        
        if (title_old_btn.tag==0) {
           
            
            PUSH(PictureAndTextVC)
            vc.infoDic= wholeInfoDic;
            vc.picAndText_A = self.pictureAndTextArray;
            
        }
        
        if (title_old_btn.tag==2) {
            PUSH(InsureVC)
            vc.insure_A = self.insureImage_A;
            
        }
        
        
    }else if (indexPath.section==8){
        
        [self scanMoreInfo];
        
    }else if (indexPath.section==9){
        
    }
    
    
    
    


}

-(void)postGetAuthStateindex:(NSInteger)selectRow{
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/info/getAuthResult",BASEURL];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[appdelegate.userInfoDic objectForKey:@"uuid"] forKey:@"uuid"];
    
    NSLog(@"paramer ==%@url==%@",params,url);
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         NSLog(@"result====%@", result);
         NSDictionary *dic = [result copy];
         if ([dic[@"state"] isEqualToString:@"access"]) {
             
             NewBuyCardViewController *buyVC=[[NewBuyCardViewController alloc]init];
             buyVC.cardListArray=self.card_arr;
             
             
             buyVC.shop_name =[wholeInfoDic objectForKey:@"store"];
             buyVC.selectRow=selectRow;
             [self.navigationController pushViewController:buyVC animated:YES];
             

         }else if ([dic[@"state"] isEqualToString:@"fail"]||[dic[@"state"] isEqualToString:@"not_auth"]) {

             NSString *mes =@"实名认证失败,是否重新认证?";
             
             if ([dic[@"state"] isEqualToString:@"not_auth"]){
                 
                 mes =@"尚未实名认证,是否去认证?";
             }
             
             UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:mes preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                 
             }];
             UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"去认证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                 
                 
                 RailNameConfirmVC *VC = [[RailNameConfirmVC alloc]init];
                 [self.navigationController pushViewController:VC animated:YES];
                 
             }];
             
             [alert addAction:cancelAction];
             [alert addAction:sureAction];
             
             [self presentViewController:alert animated:YES completion:nil];
             
         }else if ([dic[@"state"] isEqualToString:@"auditing"]) {
             
             UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"实名认证,正在审核中" preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                 
             }];
             [alert addAction:cancelAction];
             
             [self presentViewController:alert animated:YES completion:nil];

             
         }else{
             
             [self showHint:@"未知错误!"];
             
         }
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         //         [self noIntenet];
         NSLog(@"%@", error);
     }];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    
//    scrollViewOffSet = scrollView.contentOffset.x;
}


#pragma mark 懒加载

-(NSMutableDictionary *)foldMuta_dia{
    if (!_foldMuta_dia) {
        _foldMuta_dia = [NSMutableDictionary dictionary];
    }
    return _foldMuta_dia;
}
-(NSDictionary *)deadLine_dic{
    if (!_deadLine_dic) {
        _deadLine_dic = @{@"0.5":@"半年",@"1":@"一年",@"2":@"两年",@"3":@"三年",@"0":@"无限期"};
    }
    
    return _deadLine_dic;
}
-(NSArray *)pictureAndTextArray{
    if (!_pictureAndTextArray) {
        _pictureAndTextArray = [NSArray array];
    }
    return _pictureAndTextArray;
}

-(NSMutableArray *)card_arr{
    if (!_card_arr) {
        _card_arr = [NSMutableArray array];
    }
    return _card_arr;
}
-(NSArray *)insureImage_A{
    if (!_insureImage_A) {
        
        _insureImage_A = [NSArray array];
    }
    return _insureImage_A;
}
@end
