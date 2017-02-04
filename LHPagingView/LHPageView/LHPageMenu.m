//
//  LHPageMenu.m
//  LHPagingView
//
//  Created by bosheng on 2017/1/22.
//  Copyright © 2017年 liuhuan. All rights reserved.
//

#import "LHPageMenu.h"

@interface LHPageMenu(){
    UIScrollView * titleScrollView;
    UIView * indicatorView;//!<指示器
    UILabel * lastLabel;
    
    NSMutableArray * titleLabelArr;
    
}

@end

@implementation LHPageMenu

/** top title height */
static CGFloat const topTitleHeight = 44.0f;
/** label之间的间距 */
static CGFloat const labelMargin = 20.0f;
/** 字体大小 */
static CGFloat const fontSize = 15.0f;
/** 指示器的高度 */
static CGFloat const indicatorHeight = 3.0f;


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _type = NormalWidth;
        
        _contentScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, topTitleHeight, CGRectGetWidth(frame), CGRectGetHeight(frame)-topTitleHeight)];
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        _contentScrollView.pagingEnabled = YES;
        _contentScrollView.bounces = NO;
        [self addSubview:_contentScrollView];
        
        titleScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, CGRectGetWidth(frame), topTitleHeight)];
        titleScrollView.backgroundColor = [UIColor whiteColor];
        titleScrollView.showsHorizontalScrollIndicator = NO;
        titleScrollView.bounces = NO;
        [self addSubview:titleScrollView];
        
        indicatorView = [[UIView alloc]initWithFrame:CGRectMake(0, topTitleHeight-indicatorHeight, 0, indicatorHeight)];
        indicatorView.backgroundColor = [UIColor redColor];
        [titleScrollView addSubview:indicatorView];
        
        titleLabelArr = [NSMutableArray array];
    }
    
    return self;
}

- (void)setScrollTitleArr:(NSArray *)scrollTitleArr
{
    _scrollTitleArr = scrollTitleArr;
    
    _contentScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.frame)*scrollTitleArr.count, 0);
    
    __block CGFloat scrollTitleWidth = labelMargin;
    [scrollTitleArr enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGSize size = [obj sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]}];
        
        UILabel * tLabel = [[UILabel alloc]initWithFrame:CGRectMake(_type==FirmWidth?(CGRectGetWidth(self.frame)/scrollTitleArr.count*idx):scrollTitleWidth, 0, _type==FirmWidth?(CGRectGetWidth(self.frame)/scrollTitleArr.count):size.width, topTitleHeight)];
        tLabel.textAlignment = NSTextAlignmentCenter;
        tLabel.font = [UIFont systemFontOfSize:fontSize];
        tLabel.tag = idx;
        tLabel.text = obj;
        tLabel.textColor = [UIColor blackColor];
        tLabel.highlightedTextColor = [UIColor redColor];
        [titleScrollView addSubview:tLabel];
        
        scrollTitleWidth += labelMargin+CGRectGetWidth(tLabel.frame);
        
        tLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer * tapG = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGEvent:)];
        [tLabel addGestureRecognizer:tapG];
        if (idx == 0){
            tLabel.highlighted = YES;
            
            lastLabel = tLabel;
            
            CGRect rect = indicatorView.frame;
            rect.size.width = CGRectGetWidth(tLabel.frame);
            rect.origin.x = tLabel.frame.origin.x;
            indicatorView.frame = rect;
        }
        
        [titleLabelArr addObject:tLabel];
    }];
    
    if (_type == NormalWidth) {
        titleScrollView.contentSize = CGSizeMake(scrollTitleWidth, 0);
    }

}

#pragma mark - 点击
- (void)tapGEvent:(UITapGestureRecognizer *)tap_
{
    if (tap_.view.tag == lastLabel.tag){
        return;
    }
    
    [self titleScrollToLabel:tap_.view.tag];

    _contentScrollView.contentOffset = CGPointMake(CGRectGetWidth(_contentScrollView.frame)*tap_.view.tag, 0);
    
}

#pragma mark - 调整
- (void)titleScrollToLabel:(NSInteger)index
{
    lastLabel.highlighted = NO;
    lastLabel = (UILabel *)titleLabelArr[index];
    lastLabel.highlighted = YES;

    CGRect rect = indicatorView.frame;
    rect.size.width = CGRectGetWidth(lastLabel.frame);
    rect.origin.x = lastLabel.frame.origin.x;
    
    CGRect tRect = lastLabel.frame;
    CGFloat tX = CGRectGetMinX(tRect);
    CGFloat tW = CGRectGetWidth(tRect);
    CGFloat totalW = CGRectGetWidth(titleScrollView.frame);

    [UIView animateWithDuration:0.2 animations:^{
        indicatorView.frame = rect;
        
        if (titleScrollView.contentSize.width > totalW) {//scrollView内容宽度（contentSize）宽度大于frame宽度时，调整偏移量
            if(tX+tW/2-totalW/2 < 0){//调整后偏移量不能小于0
                titleScrollView.contentOffset = CGPointMake(0, 0);
            }
            else if(tX+tW/2-totalW/2 > (titleScrollView.contentSize.width-totalW)){//调整后偏移量不能大于（titleScrollView.contentSize.width-totalW）
                titleScrollView.contentOffset = CGPointMake(titleScrollView.contentSize.width-totalW, 0);
            }
            else{
                titleScrollView.contentOffset = CGPointMake(tX+tW/2-totalW/2, 0);
            }
        }
        
    }];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
