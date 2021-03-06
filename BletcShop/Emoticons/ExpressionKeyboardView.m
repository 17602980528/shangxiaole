//
//  ExpressionKeyboardView.m
//  ExpressionCS
//
//  Created by yiliu on 16/1/14.
//  Copyright © 2016年 mushoom. All rights reserved.
//

#import "ExpressionKeyboardView.h"
#import "ExpressionCL.h"
#import "ConvertToCommonEmoticonsHelper.h"
#define WIDE [[UIScreen mainScreen] bounds].size.width       //屏幕宽
#define HIGH [[UIScreen mainScreen] bounds].size.height      //屏幕高

@implementation ExpressionKeyboardView

- (instancetype)init
{
    float wid = 35;
    float jianju = (WIDE - 35 * 7) / 8;
    float gao = wid*3+jianju*3+30+40;
    self = [super initWithFrame:CGRectMake(0, HIGH-gao, WIDE, gao)];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1];
        
//        _emojiArry = [ExpressionCL ObtainAllEmojiExpression];
//        
//        
//        _emojinum = _emojiArry.count % 20 > 0 ? _emojiArry.count / 20 + 1 : _emojiArry.count / 20;
        
        
        
        _defaultArry = [ExpressionCL ObtainAllAndroidDefaultExpression];
        _defaultnum = _defaultArry.count % 20 > 0 ? _defaultArry.count / 20 + 1 : _defaultArry.count / 20;
//
//        _lxhArry = [ExpressionCL ObtainAllSinaLxhExpression];
//        _lxhnum = _lxhArry.count % 20 > 0 ? _lxhArry.count / 20 + 1 : _lxhArry.count / 20;
        
//        [self addEmojiView:_emojiArry andNum:_emojinum andBegin:0];
        [self addDefaultView:_defaultArry andNum:_defaultnum andBegin:_emojinum];
//        [self addLxhView:_lxhArry andNum:_lxhnum andBegin:_defaultnum+_emojinum];
        
        self.defaultPage.numberOfPages = _emojinum;//总的图片页数
        self.defaultPage.currentPage = 0; //当前页
        
        _defaultView.contentSize = CGSizeMake(WIDE*(_emojinum+_defaultnum+_lxhnum), wid*3+jianju*4);
        
        _selectIndex = 0;
        [self addbottomView];
        [self setUpBtnSelect];
    }
    return self;
}


- (void)addbottomView
{
    float y = self.bounds.size.height - 39.6;

    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, y, SCREENWIDTH, 39.6)];
    bottomView.backgroundColor = [UIColor clearColor];
    [self addSubview:bottomView];
    
    UIView *topLine =[[UIView alloc] initWithFrame:CGRectMake(0, 0, bottomView.width, 0.5)];
    topLine.backgroundColor = [UIColor grayColor];
    [bottomView addSubview:topLine];
    
    
    for (int i =0; i <1; i ++) {
        UIButton *smallemoBtn = [[UIButton alloc] initWithFrame:CGRectMake((bottomView.height+2)*i, 0, bottomView.height, bottomView.height)];
        smallemoBtn.backgroundColor = [UIColor clearColor];
        [smallemoBtn setImage:[UIImage imageNamed:@"emotion"] forState:UIControlStateNormal];
        smallemoBtn.tag = i;
        [smallemoBtn addTarget:self action:@selector(changeForEmotion:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:smallemoBtn];
        if (i==1) {
            [smallemoBtn setImage:[UIImage imageNamed:@"d_aini@2x"] forState:UIControlStateNormal];

        }
        
        if (i==2) {
            [smallemoBtn setImage:[UIImage imageNamed:@"lxh_beicui"] forState:UIControlStateNormal];
            
        }
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(smallemoBtn.right+2, 3, 1, smallemoBtn.height-6)];
        lineView.backgroundColor = [UIColor grayColor];
        [bottomView addSubview:lineView];

    }

    
    
    UIButton *sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(kWeChatScreenWidth-60, 0, 60, bottomView.height)];
    sendBtn.backgroundColor = RGB(0, 122, 255);
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(sendBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:sendBtn];
}

- (void)sendBtnClick
{
    if (_sendBlock) {
        _sendBlock();
    }
}
//emoji表情
- (void)addEmojiView:(NSArray *)defaultArry andNum:(NSInteger)ynum andBegin:(NSInteger)beginNum{
    //表情大小
    float wid = 35;
    float hig = 35;
    //间距
    float jianju = (WIDE - 35 * 7) / 8;
    
    NSInteger index = 0;
    
    for (int i=0; i<ynum; i++) {
        
        for (int y=0; y<3; y++) {
            
            for (int u=0; u<7; u++) {
                
                if(y == 2 && u == 6){
                    
                    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(beginNum*WIDE+jianju+(jianju+wid)*u+i*WIDE, (jianju+hig)*y+15, wid, hig-10)];
                    [btn setBackgroundImage:[ExpressionCL ObtainBtnImage] forState:UIControlStateNormal];
                    [btn addTarget:self action:@selector(deleteLxh:) forControlEvents:UIControlEventTouchUpInside];
                    [self.defaultView addSubview:btn];
                    
                }else if(index < defaultArry.count){
                    
                    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(beginNum*WIDE+jianju+(jianju+wid)*u+i*WIDE, (jianju+hig)*y+10, wid, hig)];
                    btn.tag = 10000+index;
                    btn.titleLabel.font = [UIFont systemFontOfSize:25];
                    [btn setTitle:defaultArry[index] forState:UIControlStateNormal];
                    [btn addTarget:self action:@selector(tapLxhView:) forControlEvents:UIControlEventTouchUpInside];
                    [self.defaultView addSubview:btn];
                    
                    index++;
                    
                }
            }
        }
    }
}

//默认表情
- (void)addDefaultView:(NSArray *)defaultArry andNum:(NSInteger)ynum andBegin:(NSInteger)beginNum{
    //表情大小
    float wid = 35;
    float hig = 35;
    //间距
    float jianju = (WIDE - 35 * 7) / 8;
    
    NSInteger index = 0;
    
    for (int i=0; i<ynum; i++) {
        
        for (int y=0; y<3; y++) {
            
            for (int u=0; u<7; u++) {
                
                if(y == 2 && u == 6){
                    
                    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(beginNum*WIDE+jianju+(jianju+wid)*u+i*WIDE, (jianju+hig)*y+15, wid, hig-10)];
                    [btn setBackgroundImage:[ExpressionCL ObtainBtnImage] forState:UIControlStateNormal];
                    [btn addTarget:self action:@selector(deleteLxh:) forControlEvents:UIControlEventTouchUpInside];
                    [self.defaultView addSubview:btn];
                    
                }else if(index < defaultArry.count){
                    
                    NSDictionary *dict = defaultArry[index];
                    NSString *strName = dict[@"chs"];
//                    UIImage *image = [ExpressionCL ObtainPictureDefault:strName];
                    
                    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(beginNum*WIDE+jianju+(jianju+wid)*u+i*WIDE, (jianju+hig)*y+10, wid, hig)];
                    btn.tag = 20000+index;
                    NSString *ss = [ConvertToCommonEmoticonsHelper convertToSystemEmoticons:strName];
                    [btn setTitle:ss forState:0];
//                    [btn setBackgroundImage:image forState:UIControlStateNormal];
                    [btn addTarget:self action:@selector(tapLxhView:) forControlEvents:UIControlEventTouchUpInside];
                    [self.defaultView addSubview:btn];
                    
                    index++;
                    
                }
            }
        }
    }
}

//浪小花表情
- (void)addLxhView:(NSArray *)defaultArry andNum:(NSInteger)ynum andBegin:(NSInteger)beginNum{
    //表情大小
    float wid = 35;
    float hig = 35;
    //间距
    float jianju = (WIDE - 35 * 7) / 8;
    
    NSInteger index = 0;
    
    for (int i=0; i<ynum; i++) {
        
        for (int y=0; y<3; y++) {
            
            for (int u=0; u<7; u++) {
                
                if(y == 2 && u == 6){
                    
                    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(beginNum*WIDE+jianju+(jianju+wid)*u+i*WIDE, (jianju+hig)*y+15, wid, hig-10)];
                    [btn setBackgroundImage:[ExpressionCL ObtainBtnImage] forState:UIControlStateNormal];
                    [btn addTarget:self action:@selector(deleteLxh:) forControlEvents:UIControlEventTouchUpInside];
                    [self.defaultView addSubview:btn];
                    
                }else if(index < defaultArry.count){
                    
                    NSDictionary *dict = defaultArry[index];
                    NSString *strName = dict[@"png"];
                    UIImage *image = [ExpressionCL ObtainPictureLxh:strName];
                    
                    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(beginNum*WIDE+jianju+(jianju+wid)*u+i*WIDE, (jianju+hig)*y+10, wid, hig)];
                    btn.tag = 30000+index;
                    [btn setBackgroundImage:image forState:UIControlStateNormal];
                    [btn addTarget:self action:@selector(tapLxhView:) forControlEvents:UIControlEventTouchUpInside];
                    [self.defaultView addSubview:btn];
                    
                    index++;
                    
                }
            }
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //更新UIPageControl的当前页
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.frame;
    NSInteger page = offset.x / bounds.size.width;
    
    if(page == _emojinum-1){
        
        self.defaultPage.numberOfPages = _emojinum;//总的图片页数
        
    }else if(page == _emojinum){
        
        self.defaultPage.numberOfPages = _defaultnum;//总的图片页数
        
    }else if(page == _emojinum+_defaultnum-1){
        
        self.defaultPage.numberOfPages = _defaultnum;//总的图片页数
        
    }else if(page == _emojinum+_defaultnum){
        
        self.defaultPage.numberOfPages = _lxhnum;//总的图片页数
        
    }else if(page == _emojinum+_defaultnum+_lxhnum-1){
        
        self.defaultPage.numberOfPages = _lxhnum;//总的图片页数
        
    }
    
    NSInteger index = page;
    if(page >= _emojinum && page < _emojinum+_defaultnum){
        index = page-_emojinum;
    }else if(page >= _emojinum+_defaultnum && page < _emojinum+_defaultnum+_lxhnum){
        index = page-_emojinum-_defaultnum;
    }
    
    [_defaultPage setCurrentPage:index];
}

- (void)selectEmojiBtn{
    if(_selectIndex != 0){
        _selectIndex = 0;
        self.defaultPage.numberOfPages = _emojinum;
        [_defaultPage setCurrentPage:0];
        self.defaultView.contentOffset = CGPointMake(0, 0);
        [self setUpBtnSelect];
    }
}

- (void)selectDefaultBtn{
    if(_selectIndex != 1){
        _selectIndex = 1;
        self.defaultPage.numberOfPages = _defaultnum;
        [_defaultPage setCurrentPage:0];
        self.defaultView.contentOffset = CGPointMake(_emojinum*WIDE, 0);
        [self setUpBtnSelect];
    }
}

- (void)selectLxhBtn{
    if(_selectIndex != 2){
        _selectIndex = 2;
        self.defaultPage.numberOfPages = _lxhnum;
        [_defaultPage setCurrentPage:0];
        self.defaultView.contentOffset = CGPointMake((_emojinum+_defaultnum)*WIDE, 0);
        [self setUpBtnSelect];
    }
}

//设置选中的按钮
- (void)setUpBtnSelect{
    switch (_selectIndex) {
        case 0:
            [_emojiBtn setBackgroundColor:[UIColor colorWithRed:220.0/255 green:220.0/255 blue:220.0/255 alpha:1]];
            [_defaultBtn setBackgroundColor:[UIColor clearColor]];
            [_lxhBtn setBackgroundColor:[UIColor clearColor]];
            break;
        case 1:
            [_emojiBtn setBackgroundColor:[UIColor clearColor]];
            [_defaultBtn setBackgroundColor:[UIColor colorWithRed:220.0/255 green:220.0/255 blue:220.0/255 alpha:1]];
            [_lxhBtn setBackgroundColor:[UIColor clearColor]];
            break;
        case 2:
            [_emojiBtn setBackgroundColor:[UIColor clearColor]];
            [_defaultBtn setBackgroundColor:[UIColor clearColor]];
            [_lxhBtn setBackgroundColor:[UIColor colorWithRed:220.0/255 green:220.0/255 blue:220.0/255 alpha:1]];
            break;
        default:
            break;
    }
}

//选择表情(返回文字)
- (void)tapLxhView:(UIButton *)btn{
    NSInteger num = btn.tag / 10000;
    NSInteger numTag = btn.tag % 10000;
    
    switch (num) {
        case 1:
            [self.delegate ExpressionSelect:_emojiArry[numTag]];
            break;
        case 2:
            [self.delegate ExpressionSelect:_defaultArry[numTag][@"chs"]];
            break;
        case 3:
            [self.delegate ExpressionSelect:_lxhArry[numTag][@"chs"]];
            break;
        default:
            break;
    }
}

//删除表情
- (void)deleteLxh:(UIButton *)btn{
    [self.delegate ExpressionDelete];
}

- (UIScrollView *)defaultView{
    if(!_defaultView){
        float wid = 35;
        float jianju = (WIDE - 35 * 7) / 8;
        _defaultView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDE, wid*3+jianju*3+30)];
        _defaultView.delegate = self;
        _defaultView.pagingEnabled = YES;
        _defaultView.showsVerticalScrollIndicator = FALSE;
        _defaultView.showsHorizontalScrollIndicator = FALSE;
        [self addSubview:_defaultView];
    }
    return _defaultView;
}

- (UIPageControl *)defaultPage{
    if(!_defaultPage){
        float wid = 35;
        float jianju = (WIDE - 35 * 7) / 8;
        _defaultPage = [[UIPageControl alloc] initWithFrame:CGRectMake(0, wid*3+jianju*3+10, WIDE, 20)];
        _defaultPage.currentPageIndicatorTintColor = [UIColor orangeColor];
        _defaultPage.pageIndicatorTintColor = [UIColor lightGrayColor];
        [self addSubview:_defaultPage];
    }
    return _defaultPage;
}

-(void)changeForEmotion:(UIButton*)button{
    
    if (button.tag==0) {
        _defaultView.contentOffset = CGPointMake(0, 0);
    }

    if (button.tag==1) {
        _defaultView.contentOffset = CGPointMake(WIDE*_emojinum, 0);
    }
    
    if (button.tag==2) {
        _defaultView.contentOffset = CGPointMake(WIDE*(_defaultnum+_emojinum), 0);
    }

}

@end
