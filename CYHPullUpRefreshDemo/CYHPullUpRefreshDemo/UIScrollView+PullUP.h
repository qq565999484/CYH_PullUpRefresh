//
//  UIScrollView+PullUP.h
//  CYHPullUpRefreshDemo
//
//  Created by chenyihang on 2017/3/1.
//  Copyright © 2017年 chenyihang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CYHPullUpRefreshView.h"

@interface UIScrollView (PullUP)

@property (nonatomic,strong)CYHPullUpRefreshView *refreshView;

@end
