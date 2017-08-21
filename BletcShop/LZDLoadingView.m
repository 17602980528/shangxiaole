//
//  LZDLoadingView.m
//  BletcShop
//
//  Created by Bletc on 2017/8/9.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "LZDLoadingView.h"
#import "UIImage+GIF.h"
@interface LZDLoadingView ()
{
    UIImageView *_trasfrom_img;
    UIImageView *_trasfrom_img1;
}
@end
@implementation LZDLoadingView



-(instancetype)init{
    
    if (self = [super initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)]) {
        
        
        self.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = YES;
        [self initSubViews];
        
    }
    
    return self;
    
}

-(void)initSubViews{
    
    UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(13, 31, 10, 20)];
    imgV.image =[UIImage imageNamed:@"返回箭头"];
    imgV.userInteractionEnabled = YES;
    [self addSubview:imgV];
    
    
    LZDButton *back =[LZDButton creatLZDButton];
    back.frame = CGRectMake(0, 0, 50, 64);
    [self addSubview:back];
    back.block = ^(LZDButton *sender) {
        
        [self removeSelfFromSupView];
    };
    
    
    
   
    
    
    UIImageView *trasfrom_img = [[UIImageView alloc]init];
//    trasfrom_img.image = [UIImage imageNamed:@"ddd"];

    [self addSubview:trasfrom_img];
    trasfrom_img.bounds = CGRectMake(0, 0, 21*2, 21*2);
    trasfrom_img.center = self.center;

    trasfrom_img.image = [UIImage sd_animatedGIFNamed:@"aep_dx"];
    
    _trasfrom_img= trasfrom_img;
    
//    UIImageView *trasfrom_img1 = [[UIImageView alloc]init];
//    trasfrom_img1.image = [UIImage imageNamed:@"刷新——logo"];
//    [self addSubview:trasfrom_img1];
//    trasfrom_img1.bounds = CGRectMake(0, 0, 9*2, 13*2);
//    trasfrom_img1.center = self.center;
//
//    _trasfrom_img1= trasfrom_img1;
//
//    [self startAnimation];
    
    UILabel *lab = [[UILabel alloc]init];
    lab.center = CGPointMake(self.center.x+3, trasfrom_img.bottom+15);
    lab.bounds = CGRectMake(0, 0, 100, 13);
    lab.textAlignment=  NSTextAlignmentCenter;
    lab.font = [UIFont systemFontOfSize:13];
    lab.text = @"加载中...";
    lab.textColor = RGB(51, 51, 51);
    [self addSubview:lab];
    
}

- (void)startAnimation
{
    
    CABasicAnimation *animation =  [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
    animation.fromValue = [NSNumber numberWithFloat:0.f];
    animation.toValue =  [NSNumber numberWithFloat: M_PI *2];
    animation.duration  = 0.7;
    animation.autoreverses = NO;
    animation.fillMode =kCAFillModeForwards;
    animation.repeatCount = MAXFLOAT; //如果这里想设置成一直自旋转，可以设置为MAXFLOAT，否则设置具体的数值则代表执行多少次
    [_trasfrom_img.layer addAnimation:animation forKey:nil];
    
    //    CGAffineTransform endAngle = CGAffineTransformMakeRotation(angle * (M_PI / 180.0f));
    //
    //    [UIView animateWithDuration:0.01 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
    //        _trasfrom_img.transform = endAngle;
    //    } completion:^(BOOL finished) {
    //        angle += 10;
    //        [self startAnimation];
    //    }];
}


/**弹出视图*/
- (void)show
{
    [[[UIApplication sharedApplication].delegate window] addSubview:self];
    
    //动画出现
   
}

/**移除视图*/
- (void)removeSelfFromSupView
{
   
    
            [self removeFromSuperview];
 
    
}


@end
