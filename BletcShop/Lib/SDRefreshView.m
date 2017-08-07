//
//  SDRefreshView.m
//  SDRefreshView
//
//  Created by aier on 15-2-22.
//  Copyright (c) 2015年 GSD. All rights reserved.
//

/**
 
 *******************************************************
 *                                                      *
 * 感谢您的支持， 如果下载的代码在使用过程中出现BUG或者其他问题    *
 * 您可以发邮件到gsdios@126.com 或者 到                       *
 * https://github.com/gsdios?tab=repositories 提交问题     *
 *                                                      *
 *******************************************************
 
 */
#import "SDRefreshView.h"
#import "UIView+SDExtension.h"
CGFloat const SDRefreshViewDefaultHeight = 70.0f;
CGFloat const SDActivityIndicatorViewMargin = 50.0f;
CGFloat const SDTextIndicatorMargin = 20.0f;
CGFloat const SDTimeIndicatorMargin = 10.0f;

@implementation SDRefreshView
{
    UIImageView *_stateIndicatorView;
    UILabel *_textIndicator;
    UILabel *_timeIndicator;
    UIActivityIndicatorView *_activityIndicatorView;
    NSString *_lastRefreshingTimeString;
    // 记录原始contentEdgeInsets
    UIEdgeInsets _originalEdgeInsets;
    UIImageView *_trasfrom_img;
    UIImageView *_trasfrom_img1;

     CGFloat angle;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] init];
        activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [activity startAnimating];
//        [self addSubview:activity];
        _activityIndicatorView = activity;
        
        // 状态提示图片
//        UIImageView *stateIndicator = [[UIImageView alloc] init];
//        stateIndicator.image = [UIImage imageNamed:@"sdRefeshView_arrow"];
//        [self addSubview:stateIndicator];
//        _stateIndicatorView = stateIndicator;
//        _stateIndicatorView.bounds = CGRectMake(0, 0, 15, 40);
        
        UIImageView *trasfrom_img = [[UIImageView alloc]init];
        trasfrom_img.image = [UIImage imageNamed:@"ddd"];
        [self addSubview:trasfrom_img];
        trasfrom_img.bounds = CGRectMake(0, 0, 21, 21);
        _trasfrom_img= trasfrom_img;
        
        UIImageView *trasfrom_img1 = [[UIImageView alloc]init];
        trasfrom_img1.image = [UIImage imageNamed:@"刷新——logo"];
        [self addSubview:trasfrom_img1];
        trasfrom_img1.bounds = CGRectMake(0, 0, 9, 13);
        _trasfrom_img1= trasfrom_img1;
        
        // 状态提示label
        UILabel *textIndicator = [[UILabel alloc] init];
        textIndicator.bounds = CGRectMake(0, 0, 300, 30);
        textIndicator.textAlignment = NSTextAlignmentCenter;
        textIndicator.backgroundColor = [UIColor clearColor];
        textIndicator.font = [UIFont systemFontOfSize:12];
        textIndicator.textColor = [UIColor lightGrayColor];
        [self addSubview:textIndicator];
        _textIndicator = textIndicator;
        

        // 更新时间提示label
//        UILabel *timeIndicator = [[UILabel alloc] init];
//        timeIndicator.bounds = CGRectMake(0, 0, 200, 16);;
//        timeIndicator.textAlignment = NSTextAlignmentCenter;
//        timeIndicator.textColor = [UIColor lightGrayColor];
//        timeIndicator.font = [UIFont systemFontOfSize:12];
//        [self addSubview:timeIndicator];
//        _timeIndicator = timeIndicator;
    }
    return self;
}

+ (instancetype)refreshView
{
    return [[self alloc] init];
}

- (void)didMoveToSuperview
{
    self.bounds = CGRectMake(0, 0, self.scrollView.frame.size.width, SDRefreshViewDefaultHeight);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _activityIndicatorView.hidden = YES;

//    _activityIndicatorView.hidden = !_isManuallyRefreshing;
    _activityIndicatorView.center = CGPointMake(SDActivityIndicatorViewMargin, self.sd_height * 0.5);
    _stateIndicatorView.center = _activityIndicatorView.center;
    
//    _textIndicator.center = CGPointMake(self.sd_width * 0.5, _activityIndicatorView.sd_height * 0.5 + SDTextIndicatorMargin);
//    _timeIndicator.center = CGPointMake(self.sd_width * 0.5, self.sd_height - _timeIndicator.sd_height * 0.5 - SDTimeIndicatorMargin);
    
    
   _textIndicator.center = CGPointMake(self.sd_width * 0.5, self.sd_height - 16 * 0.5 - SDTimeIndicatorMargin);
    
    _trasfrom_img.center = CGPointMake(self.sd_width * 0.5,_activityIndicatorView.sd_height * 0.5 + SDTextIndicatorMargin);
    _trasfrom_img1.center = _trasfrom_img.center;

}

- (NSString *)lastRefreshingTimeString
{
    if (_lastRefreshingTimeString == nil) {
        return [self refreshingTimeString];
    }
    return _lastRefreshingTimeString;
}

- (void)addToScrollView:(UIScrollView *)scrollView
{
    _scrollView = scrollView;
    
    [_scrollView addSubview:self];
    [_scrollView addObserver:self forKeyPath:SDRefreshViewObservingkeyPath options:NSKeyValueObservingOptionNew context:nil];
    
    // 默认是在NavigationController控制下，否则可以调用addToScrollView:isEffectedByNavigationController:(设值为NO) 即可
    _isEffectedByNavigationController = YES;
}

- (void)addToScrollView:(UIScrollView *)scrollView isEffectedByNavigationController:(BOOL)effectedByNavigationController
{
    [self addToScrollView:scrollView];
    _isEffectedByNavigationController = effectedByNavigationController;
    _originalEdgeInsets = scrollView.contentInset;
}

- (void)addTarget:(id)target refreshAction:(SEL)action
{
    _beginRefreshingTarget = target;
    _beginRefreshingAction = action;
}


// 获得在scrollView的contentInset原来基础上增加一定值之后的新contentInset
- (UIEdgeInsets)syntheticalEdgeInsetsWithEdgeInsets:(UIEdgeInsets)edgeInsets
{
    return UIEdgeInsetsMake(_originalEdgeInsets.top + edgeInsets.top, _originalEdgeInsets.left + edgeInsets.left, _originalEdgeInsets.bottom + edgeInsets.bottom, _originalEdgeInsets.right + edgeInsets.right);
}

- (void)setRefreshState:(SDRefreshViewState)refreshState
{
    _refreshState = refreshState;
    
    switch (refreshState) {
        // 进入刷新状态
        case SDRefreshViewStateRefreshing:
            {
                NSLog(@"--SDRefreshViewStateRefreshing-----");
                _originalEdgeInsets = self.scrollView.contentInset;

                _scrollView.contentInset = [self syntheticalEdgeInsetsWithEdgeInsets:self.scrollViewEdgeInsets];

                _stateIndicatorView.hidden = YES;
                _activityIndicatorView.hidden = NO;
                _lastRefreshingTimeString = [self refreshingTimeString];
                _textIndicator.text = SDRefreshViewRefreshingStateText;
                
                if (self.beginRefreshingOperation) {
                    self.beginRefreshingOperation();
                } else if (self.beginRefreshingTarget) {
                    if ([self.beginRefreshingTarget respondsToSelector:self.beginRefreshingAction]) {
                        
// 屏蔽performSelector-leak警告
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                        [self.beginRefreshingTarget performSelector:self.beginRefreshingAction];
                    }
                }
            }
            break;
            
        case SDRefreshViewStateWillRefresh:
            {
                NSLog(@"--SDRefreshViewStateWillRefresh-----");
                [self startAnimation];

                _textIndicator.text = SDRefreshViewWillRefreshStateText;
                [UIView animateWithDuration:0.5 animations:^{
                    _stateIndicatorView.transform = CGAffineTransformMakeRotation(self.stateIndicatorViewWillRefreshStateTransformAngle);
                }];
            }
            break;
            
        case SDRefreshViewStateNormal:
            NSLog(@"--SDRefreshViewStateNormal-----");
            [_trasfrom_img.layer removeAllAnimations];
            _textIndicator.text = self.textForNormalState;
            _stateIndicatorView.transform = CGAffineTransformMakeRotation(self.stateIndicatorViewNormalTransformAngle);
            _timeIndicator.text = [NSString stringWithFormat:@"最后更新：%@", [self lastRefreshingTimeString]];
            _stateIndicatorView.hidden = NO;
            _activityIndicatorView.hidden = YES;
            

            break;
            
        default:
            break;
    }
}


- (void)endRefreshing
{
    [UIView animateWithDuration:0.6 animations:^{
        _scrollView.contentInset = _originalEdgeInsets;
    } completion:^(BOOL finished) {
        
        NSLog(@"----------------------------");

        
        [self setRefreshState:SDRefreshViewStateNormal];
    }];
}

// 更新时间
- (NSString *)refreshingTimeString
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [formatter stringFromDate:date];
}

// 保留！
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    ;
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


- (void)dealloc
{
    [_scrollView removeObserver:self forKeyPath:SDRefreshViewObservingkeyPath];
}

@end
