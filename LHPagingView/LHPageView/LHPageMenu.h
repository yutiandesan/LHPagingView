//
//  LHPageMenu.h
//  LHPagingView
//
//  Created by bosheng on 2017/1/22.
//  Copyright © 2017年 liuhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, WidthType) {
    NormalWidth = 0,//普通宽度，依次累加
    FirmWidth,//固定屏幕宽度
};

@interface LHPageMenu : UIView

@property (nonatomic,assign)WidthType type;//!<宽度类型

@property (nonatomic,strong)NSArray * scrollTitleArr;//!<顶部滑块数组
@property (nonatomic,strong)UIScrollView * contentScrollView;//!<内容切换scrollView


/**
 *标题指示改变
 */
- (void)titleScrollToLabel:(NSInteger)index;

@end
