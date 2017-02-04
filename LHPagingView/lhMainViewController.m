//
//  lhMainViewController.m
//  LHPagingView
//
//  Created by bosheng on 2017/1/22.
//  Copyright © 2017年 liuhuan. All rights reserved.
//

#import "lhMainViewController.h"
#import "LHPageMenu.h"
#import "lhFirstViewController.h"
#import "lhSecondViewController.h"
#import "lhThirdViewController.h"
#import "lhFifthViewController.h"

#import <WebKit/WebKit.h>

@interface lhMainViewController ()<UIScrollViewDelegate>
{
//    WKWebView * webView;
    
    LHPageMenu * pageMenu;
}

@end

@implementation lhMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"主页";
    self.view.backgroundColor = [UIColor orangeColor];
    
    pageMenu = [[LHPageMenu alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    pageMenu.type = FirmWidth;//类型
    pageMenu.scrollTitleArr = @[@"功能111",@"功能222",@"功能333",@"功能444",@"功能555"];
    pageMenu.contentScrollView.delegate = self;
    [self.view addSubview:pageMenu];
    
    // 1.添加所有子控制器
    [self setupChildViewController];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 添加所有子控制器
- (void)setupChildViewController
{
    lhFirstViewController * fVC = [[lhFirstViewController alloc]init];
    [self addChildViewController:fVC];
    
    lhSecondViewController * sVC = [[lhSecondViewController alloc]init];
    [self addChildViewController:sVC];
    
    lhThirdViewController * tVC = [[lhThirdViewController alloc]init];
    [self addChildViewController:tVC];
    
    lhFifthViewController * fiVC = [[lhFifthViewController alloc]init];
    [self addChildViewController:fiVC];
    
    //添加即载入，也可第一次滑动到页面再载入，可自行选择
    for (int i=1;i < self.childViewControllers.count+1;i++) {//当前VC作为第一个功能展示页
        CGFloat offsetX = i * self.view.frame.size.width;
        UIViewController *vc = self.childViewControllers[i-1];
        [pageMenu.contentScrollView addSubview:vc.view];
        vc.view.frame = CGRectMake(offsetX, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
    
}

//// 显示控制器的view
//- (void)showVc:(NSInteger)index {
//    
//    CGFloat offsetX = index * self.view.frame.size.width;
//    
//    UIViewController *vc = self.childViewControllers[index];
//    
//    // 判断控制器的view有没有加载过,如果已经加载过,就不需要加载
//    if (vc.isViewLoaded) return;
//    
//    [pageMenu.contentScrollView addSubview:vc.view];
//    vc.view.frame = CGRectMake(offsetX, 0, self.view.frame.size.width, self.view.frame.size.height);
//}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 计算滚动到哪一页
    NSInteger index = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
    
    [pageMenu titleScrollToLabel:index];
    
    
//    [self showVc:index];//滑动到时再添加
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
