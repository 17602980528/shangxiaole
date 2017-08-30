//
//  WaterfallColectionLayout.m
//  WaterfallCollectionLayout
//
//  Created by ci123 on 16/1/26.
//  Copyright © 2016年 tanhui. All rights reserved.
//

#import "WaterfallColectionLayout.h"


@interface WaterfallColectionLayout ()
//数组存放每列的总高度
@property(nonatomic,strong)NSMutableArray* colsHeight;
//单元格宽度
@property(nonatomic,assign)CGFloat colWidth;
@end

@implementation WaterfallColectionLayout
-(instancetype)initWithItemsHeightBlock:(itemHeightBlock)block{
    if ([super init]) {
        self.heightBlock = block;
    }
    return self;
}
-(void)prepareLayout{
    [super prepareLayout];
    self.colWidth =( self.collectionView.frame.size.width - (self.colCount+1)*_colMargin )/_colCount;
    self.colsHeight = nil;
}
-(CGSize)collectionViewContentSize{
    NSNumber * longest = self.colsHeight[0];
    for (NSInteger i =0;i<self.colsHeight.count;i++) {
        NSNumber* rolHeight = self.colsHeight[i];
        if(longest.floatValue<rolHeight.floatValue){
            longest = rolHeight;
        }
    }
    return CGSizeMake(self.collectionView.frame.size.width, longest.floatValue+10);
}
-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes* attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    NSNumber * shortest = self.colsHeight[0];
    NSInteger  shortCol = 0;
    
    //找到最短的
    for (NSInteger i =0;i<self.colsHeight.count;i++) {
        NSNumber* rolHeight = self.colsHeight[i];
        if(shortest.floatValue>rolHeight.floatValue){
            shortest = rolHeight;
            shortCol=i;
        }
    }
    CGFloat x = (shortCol+1)*_colMargin+ shortCol * self.colWidth;
    CGFloat y = shortest.floatValue+_rolMargin;
    
    //获取cell高度
    CGFloat height=0;
    NSAssert(self.heightBlock!=nil, @"未实现计算高度的block ");
    if(self.itemHeight==0){
        height = self.heightBlock(indexPath);
    }else{
        height = self.itemHeight;
    }
    
    attr.frame= CGRectMake(x, y, self.colWidth, height);
    self.colsHeight[shortCol]=@(shortest.floatValue+_rolMargin+height);
   
    return attr;
}

-(void)setItemHeight:(CGFloat)itemHeight{
    _itemHeight = itemHeight;
}
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSMutableArray* array = [NSMutableArray array];
    NSInteger items = [self.collectionView numberOfItemsInSection:0];
    for (int i = 0; i<items;i++) {
        UICollectionViewLayoutAttributes* attr = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        [array addObject:attr];
    }
    return array;
}
-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

-(void)setHeader_height:(CGFloat)header_height{
    _header_height = header_height;
}
-(NSMutableArray *)colsHeight{
    if(!_colsHeight){
        NSMutableArray * array = [NSMutableArray array];
        for(int i =0;i<_colCount;i++){
            //这里可以设置初始高度
            [array addObject:@(self.header_height)];
        }
        _colsHeight = [array mutableCopy];
    }
    return _colsHeight;
}
@end
