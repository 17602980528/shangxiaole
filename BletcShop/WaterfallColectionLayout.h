//
//  WaterfallColectionLayout.h
//  WaterfallCollectionLayout
//
//  Created by ci123 on 16/1/26.
//  Copyright © 2016年 tanhui. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef  CGFloat(^itemHeightBlock)(NSIndexPath* index);
@interface WaterfallColectionLayout : UICollectionViewLayout
@property(nonatomic,assign) NSInteger colMargin;//列间距
@property(nonatomic,assign) NSInteger rolMargin;//行间距

@property(nonatomic,assign) NSInteger colCount;//列数
@property(nonatomic,strong )itemHeightBlock heightBlock ;

@property (nonatomic , assign) CGFloat itemHeight;// <#Description#>

@property(nonatomic,assign) CGFloat header_height;
-(instancetype)initWithItemsHeightBlock:(itemHeightBlock)block;
@end
