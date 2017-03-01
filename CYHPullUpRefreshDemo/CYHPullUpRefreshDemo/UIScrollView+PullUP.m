
//
//  UIScrollView+PullUP.m
//  CYHPullUpRefreshDemo
//
//  Created by chenyihang on 2017/3/1.
//  Copyright © 2017年 chenyihang. All rights reserved.
//

#import "UIScrollView+PullUP.h"
#import <objc/runtime.h>

@implementation UIScrollView (PullUP)
static const char *refreshKey = "refreshKey";

- (void)setRefreshView:(CYHPullUpRefreshView *)refreshView
{
     objc_setAssociatedObject(self, refreshKey, refreshView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}
- (CYHPullUpRefreshView *)refreshView
{
    CYHPullUpRefreshView *refreshView =  objc_getAssociatedObject(self, refreshKey);
    
    if (refreshView == nil) {
        refreshView = [[CYHPullUpRefreshView alloc] init];
        [self addSubview:refreshView];
        //最后保存对象
        self.refreshView = refreshView;
    }
    return refreshView;
}



@end
