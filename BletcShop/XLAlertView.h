//
//  XLAlertView.h
//  EsayCall
//
//  Created by apple on 2017/7/5.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AlertResult)(NSInteger index);

@interface XLAlertView : UIView

@property (nonatomic,copy) AlertResult resultIndex;

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message sureBtn:(NSString *)sureTitle cancleBtn:(NSString *)cancleTitle logo:(NSString *)imageName bgImageView:(NSString *)bgName;

- (void)showXLAlertView;

@end
