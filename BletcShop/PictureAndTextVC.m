//
//  PictureAndTextVC.m
//  BletcShop
//
//  Created by Bletc on 2017/7/10.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "PictureAndTextVC.h"
#import "UIImageView+WebCache.h"
@interface PictureAndTextVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableVIew;

@end

@implementation PictureAndTextVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"图文详情";
    LEFTBACK
    NSLog(@"----%@",self.picAndText_A);

}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.picAndText_A.count+1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row==0) {
        return SCREENWIDTH*2/3;

    }else{
        
        NSString *str = self.picAndText_A[indexPath.row-1][@"type"];
        if ([str isEqualToString:@"1"]) {
            return SCREENWIDTH*2/3;
        }else if([str isEqualToString:@"0"]||[str isEqualToString:@"2"]){
            return (SCREENWIDTH/2-10)*2/3+10;
        }
        return SCREENWIDTH*2/3;
 
    }
   
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 5, SCREENWIDTH, SCREENWIDTH*2/3-10)];
        imageView.tag=100;
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
        if (indexPath.row==0) {
            label.hidden=NO;
            imgView2.hidden=YES;
            imgView.hidden=NO;
            imgView.contentMode =  UIViewContentModeScaleToFill;
            imgView.image=[UIImage imageNamed:@"icon3"];
            NSURL * nurl1=[[NSURL alloc] initWithString:[[SHOPIMAGE_ADDIMAGE stringByAppendingString:[self.infoDic objectForKey:@"image_url"]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
            [imgView sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"icon3.png"] options:SDWebImageRetryFailed];
            NSString *newStr=[self.infoDic objectForKey:@"store"];
            CGFloat lableHeight=[newStr getTextHeightWithShowWidth:SCREENWIDTH AndTextFont:[UIFont systemFontOfSize:13.0f] AndInsets:5];
            label.text=newStr;
            label.frame=CGRectMake(0, SCREENWIDTH*2/3-lableHeight-5, SCREENWIDTH, lableHeight);
        }
    
        else{
    NSDictionary *dic = self.picAndText_A[indexPath.row-1];
    
    
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
        }
    return cell;
}



@end
