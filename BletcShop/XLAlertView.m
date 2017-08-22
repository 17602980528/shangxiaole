//
//  XLAlertView.m
//  EsayCall
//
//  Created by apple on 2017/7/5.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "XLAlertView.h"

///alertView 宽
#define AlertW 280
///各个栏目之间的距离
#define XLSpace 25.0

@interface XLAlertView()

//弹窗
@property (nonatomic,retain) UIView *alertView;
//title
@property (nonatomic,retain) UILabel *titleLbl;
//内容
@property (nonatomic,retain) UILabel *msgLbl;
//确认按钮
@property (nonatomic,retain) UIButton *sureBtn;
//取消按钮
@property (nonatomic,retain) UIButton *cancleBtn;
//横线线
@property (nonatomic,retain) UIView *lineView;
//竖线
@property (nonatomic,retain) UIView *verLineView;
//logo
@property (nonatomic,retain)UIImageView *logoImageView;
//红色波浪背景图
@property (nonatomic,retain)UIImageView *bgImageView;

@end

@implementation XLAlertView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message sureBtn:(NSString *)sureTitle cancleBtn:(NSString *)cancleTitle logo:(NSString *)imageName bgImageView:(NSString *)bgName;
{
    if (self == [super init]) {
        
        self.frame = [UIScreen mainScreen].bounds;
        
        self.backgroundColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:0.3];
        
        self.alertView = [[UIView alloc] init];
        self.alertView.backgroundColor = [UIColor whiteColor];
        self.alertView.layer.cornerRadius = 12.0;
        
        self.alertView.frame = CGRectMake(0, 0, AlertW, 100);
        self.alertView.layer.position = self.center;
        
        if (bgName) {
            self.bgImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, AlertW, 112)];
            self.bgImageView.image=[UIImage imageNamed:bgName];
            [self.alertView addSubview:self.bgImageView];
        }
        
        if (imageName) {
            self.logoImageView=[[UIImageView alloc]initWithFrame:CGRectMake((AlertW-60)/2, -30, 60, 60)];
            self.logoImageView.image=[UIImage imageNamed:imageName];
            [self.alertView addSubview:self.logoImageView];
        }
        
        if (title) {
            
            self.titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.logoImageView.frame)+15, AlertW, 15)];
            self.titleLbl.text=title;
            self.titleLbl.textAlignment = NSTextAlignmentCenter;
            self.titleLbl.textColor=[UIColor whiteColor];
            self.titleLbl.font=[UIFont systemFontOfSize:20.0f];
            [self.alertView addSubview:self.titleLbl];
            
        }
        if (message) {
            
            self.msgLbl =[[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.bgImageView.frame)+30, AlertW-40, 20)];
            self.msgLbl.numberOfLines=0;
            self.msgLbl.font=[UIFont systemFontOfSize:15.0f];
            self.msgLbl.text=message;
            [self.alertView addSubview:self.msgLbl];
            
            CGFloat hh = [message boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.msgLbl.font} context:nil].size.height;
            
            self.msgLbl.frame=CGRectMake(20, CGRectGetMaxY(self.bgImageView.frame)+15, AlertW-40, hh);
        }
        
        //两个按钮
        if (cancleTitle && sureTitle&&![cancleTitle isEqualToString:@""]) {
            
            self.cancleBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            self.cancleBtn.frame = CGRectMake(AlertW/2-105, CGRectGetMaxY(self.msgLbl.frame)+30, 90, 25);
            self.cancleBtn.backgroundColor=[UIColor whiteColor];
            self.cancleBtn.layer.borderColor=[[UIColor lightGrayColor]CGColor];
            self.cancleBtn.layer.borderWidth=1.0f;
            self.cancleBtn.layer.cornerRadius=5.0f;
            self.cancleBtn.clipsToBounds=YES;
            [self.cancleBtn setTitle:cancleTitle forState:UIControlStateNormal];
            self.cancleBtn.tag = 1;
            [self.cancleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.cancleBtn addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
            [self.alertView addSubview:self.cancleBtn];
            
            
            self.sureBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            self.sureBtn.frame = CGRectMake(AlertW/2+15,CGRectGetMaxY(self.msgLbl.frame)+30,90,25);
            self.sureBtn.backgroundColor=[UIColor colorWithRed:237/255.0f green:72/255.0f blue:77/255.0f alpha:1.0f];
            [self.sureBtn setTitle:sureTitle forState:UIControlStateNormal];
            [self.sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.sureBtn.tag = 2;
            [self.sureBtn addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
            self.sureBtn.layer.cornerRadius=5.0f;
            self.sureBtn.clipsToBounds=YES;
            [self.alertView addSubview:self.sureBtn];
            
            
            //计算高度
            CGFloat alertHeight =CGRectGetMaxY(self.cancleBtn.frame)+35;
            self.alertView.frame = CGRectMake(0, 0, AlertW, alertHeight);
            self.alertView.layer.position = self.center;
            
            [self addSubview:self.alertView];
            
        }else if(sureTitle){
            
            self.sureBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            self.sureBtn.frame = CGRectMake(AlertW/2-45,CGRectGetMaxY(self.msgLbl.frame)+30,90,25);
            self.sureBtn.backgroundColor=[UIColor colorWithRed:237/255.0f green:72/255.0f blue:77/255.0f alpha:1.0f];
            [self.sureBtn setTitle:sureTitle forState:UIControlStateNormal];
            [self.sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.sureBtn.tag = 2;
            [self.sureBtn addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
            self.sureBtn.layer.cornerRadius=5.0f;
            self.sureBtn.clipsToBounds=YES;
            
            [self.alertView addSubview:self.sureBtn];
            
            
            
            //计算高度
            CGFloat alertHeight =CGRectGetMaxY(self.sureBtn.frame)+35;
            self.alertView.frame = CGRectMake(0, 0, AlertW, alertHeight);
            self.alertView.layer.position = self.center;
            
            [self addSubview:self.alertView];
        }
        
       
    }
    
    return self;
}

#pragma mark - 弹出 -
- (void)showXLAlertView
{
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
    [self creatShowAnimation];
}

- (void)creatShowAnimation
{
    self.alertView.layer.position = self.center;
    self.alertView.transform = CGAffineTransformMakeScale(0.90, 0.90);
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
        self.alertView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - 回调 -设置只有2 -- > 确定才回调
- (void)buttonEvent:(UIButton *)sender
{
    if (sender.tag == 2) {
        if (self.resultIndex) {
            self.resultIndex(sender.tag);
        }
    }
    [self removeFromSuperview];
}
-(UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
