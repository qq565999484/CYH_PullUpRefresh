//
//  CYHPullUpRefreshView.h
//  CYHPullUpRefreshDemo
//
//  Created by chenyihang on 2017/3/1.
//  Copyright © 2017年 chenyihang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CYHPullUpRefreshView : UIView
@property (nonatomic,copy) void (^refreshByUpPush)();
@property (nonatomic,assign)CGFloat topOffSet;

- (void)endRefresh;
@end
