//
//  UserGuideVC.m
//  闲么
//
//  Created by 邹应天 on 16/3/3.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import "UserGuideVC.h"
@interface UserGuideVC()
@property UIScrollView *scrollV;
@property UIPageControl *pageControl;
@end
@implementation UserGuideVC
-(void)viewDidLoad{
    
}
-(void)createScrollView{
    self.scrollV = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    self.scrollV.pagingEnabled = YES;
    [self.view addSubview:self.scrollV];
    
}
-(void)createPageControl{
    _pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 10)];
    [self.view addSubview:_pageControl];
    
}
@end
