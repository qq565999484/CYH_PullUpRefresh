//
//  CYHPullUpRefreshView.m
//  CYHPullUpRefreshDemo
//
//  Created by chenyihang on 2017/3/1.
//  Copyright © 2017年 chenyihang. All rights reserved.
//

#import "CYHPullUpRefreshView.h"

#define CYHPullUpRefreshViewHeight  44
#define CYHPullUpRefreshViewDifferenceV  0

typedef enum
{
    CYHPullUpRefreshStatusNormal,
    CYHPullUpRefreshStatusPulling,
    CYHPullUpRefreshStatusRefreshing
}CYHPullUpRefreshStatus;

@interface CYHPullUpRefreshView ()

@property (nonatomic,strong)UIImageView *leftImg;
@property (nonatomic,strong)UILabel *statusLab;
//SELF的父类
@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,assign)CYHPullUpRefreshStatus refreshStatus;
@property (nonatomic,assign)NSInteger rotation;

@end

@implementation CYHPullUpRefreshView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (instancetype)initWithFrame:(CGRect)frame
{
    //如果在外部是初始化的话 这里需要给frame设置 宽高
    CGRect rect = frame;
    rect.size.height = CYHPullUpRefreshViewHeight;
    rect.size.width = [UIScreen mainScreen].bounds.size.width - 20;
    rect.origin.x = 10;
    
    self = [super initWithFrame:rect];
    
    if (self) {
        /**初始化控件
         左边IMG
         右边label
         */
        
        self.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        self.layer.borderWidth = 2;
        self.layer.cornerRadius = 8 ;
        
        _rotation = 0;
        
        [self addSubview:self.leftImg];
        [self addSubview:self.statusLab];
        
        //使用纯代码自动布局 需要将 Items的 translatesAutoresizingMaskIntoConstraints 关闭
        self.leftImg.translatesAutoresizingMaskIntoConstraints = NO;
        self.statusLab.translatesAutoresizingMaskIntoConstraints = NO;
        
        
        
        //先添加状态栏
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.statusLab attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        
        [self addConstraint: [NSLayoutConstraint constraintWithItem:self.statusLab attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        
        //添加图片的位置
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.leftImg attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.statusLab attribute:NSLayoutAttributeLeft multiplier:1 constant:- 8]];
        
        [self addConstraint: [NSLayoutConstraint constraintWithItem:self.leftImg attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickRefreshMoreData:)]];
    }
    return self;
    
}
- (void)clickRefreshMoreData:(UITapGestureRecognizer * )tapGesture
{
    if (self.refreshStatus == CYHPullUpRefreshStatusNormal) {
        self.refreshStatus = CYHPullUpRefreshStatusRefreshing;
        
    }
    
    
}


- (void)dealloc
{
    [self.scrollView removeObserver:self forKeyPath:@"contentSize"];
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
}


//这里需要监控一下 self.superView视图

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if ([newSuperview isKindOfClass:[UIScrollView class]]) {
        
        self.scrollView = (UIScrollView *)newSuperview;
        
        //监听contentSize 改变 self Y轴坐标
        
        [self.scrollView addObserver:self forKeyPath:@"contentSize" options:0 context:NULL];
        
        //监听 contentOffset 赋其状态
        [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:0 context:NULL];
        
        
    }
    
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"]) {
        
        //获取scrollView的contentSize
        CGRect frame = self.frame;
        frame.origin.y = self.scrollView.contentSize.height + self.topOffSet;
        self.frame = frame;
        
    }else if([keyPath isEqualToString:@"contentOffset"])
    {
        //判断是否正在拖动
        if (self.scrollView.dragging) {
            
            if ((self.scrollView.contentOffset.y + self.scrollView.bounds.size.height > CYHPullUpRefreshViewHeight + self.scrollView.contentSize.height + CYHPullUpRefreshViewDifferenceV + self.topOffSet)) {
                
                if (self.refreshStatus == CYHPullUpRefreshStatusNormal) {
                    
                    self.refreshStatus = CYHPullUpRefreshStatusPulling;
                    
                }
                
                CGFloat offset = (self.scrollView.contentOffset.y + self.scrollView.bounds.size.height - CYHPullUpRefreshViewHeight - self.scrollView.contentSize.height - CYHPullUpRefreshViewDifferenceV - self.topOffSet );
                [self setOffsetY: offset];
                
                
                NSLog(@"XXX%d",self.scrollView.isDecelerating);
                NSLog(@"XXXisTracking%d",self.scrollView.isTracking);
                
            }else if((self.scrollView.contentOffset.y + self.scrollView.bounds.size.height < CYHPullUpRefreshViewHeight + self.scrollView.contentSize.height + CYHPullUpRefreshViewDifferenceV + self.topOffSet)&& self.refreshStatus == CYHPullUpRefreshStatusPulling)
            {
                self.refreshStatus = CYHPullUpRefreshStatusNormal;
                
            }
            
        }else
        {
            //这块
            
            if (self.refreshStatus == CYHPullUpRefreshStatusPulling) {
                
                self.refreshStatus = CYHPullUpRefreshStatusRefreshing;
                
            }
            
        }
        
    }
    
}


- (void)setRefreshStatus:(CYHPullUpRefreshStatus)refreshStatus
{
    _refreshStatus = refreshStatus;
    
    switch (_refreshStatus) {
        case CYHPullUpRefreshStatusNormal:
        {
            //标准状态
            self.statusLab.text = @"上拉加载更多数据";
            self.leftImg.transform = CGAffineTransformIdentity;
            
            
        }
            break;
        case CYHPullUpRefreshStatusPulling:
        {
            //然后是pull状态
            self.statusLab.text = @"释放加载更多数据";
        }
            break;
        case CYHPullUpRefreshStatusRefreshing:
        {
            //正在刷线状态
            
            self.statusLab.text = @"正在刷新...";
            [self.leftImg.layer addAnimation:[self beginAnmiation] forKey:@"transformRotation"];
            
            UIEdgeInsets edgeInsets = self.scrollView.contentInset;
            edgeInsets.bottom += (CYHPullUpRefreshViewHeight + CYHPullUpRefreshViewDifferenceV + self.topOffSet);
            [UIView animateWithDuration:0.1 animations:^{
                self.scrollView.contentInset = edgeInsets;
            }];
            
            NSLog(@"%@",NSStringFromUIEdgeInsets(edgeInsets));
            
            if (self.refreshByUpPush) {
                self.refreshByUpPush();
            }
            
        }
            break;
            
    }
}
//MARK:懒加载

- (void)setTopOffSet:(CGFloat)topOffSet
{
    _topOffSet = topOffSet;
    
    CGRect frame = self.frame;
    frame.origin.y = _topOffSet;
    self.frame = frame;
    
    
}
- (UIImageView *)leftImg
{
    if (!_leftImg) {
        _leftImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loding@2x"]];
        
    }
    return _leftImg;
    
}

- (UILabel *)statusLab
{
    if (!_statusLab) {
        
        _statusLab = [[UILabel alloc] init];
        _statusLab.adjustsFontSizeToFitWidth = YES;
        [_statusLab sizeToFit];
        _statusLab.font = [UIFont systemFontOfSize:15];
        _statusLab.textAlignment = NSTextAlignmentLeft;
        _statusLab.textColor = [UIColor grayColor];
        _statusLab.text = @"上拉加载更多数据";
        
    }
    return _statusLab;
    
}

//标准状态+动画停止 旋转归位
- (void)endRefresh
{
    [self.leftImg.layer removeAnimationForKey:@"transformRotation"];
    self.refreshStatus = CYHPullUpRefreshStatusNormal;
    UIEdgeInsets edgeInsets = self.scrollView.contentInset;
    edgeInsets.bottom -= (CYHPullUpRefreshViewHeight + CYHPullUpRefreshViewDifferenceV + self.topOffSet);
    self.scrollView.contentInset = edgeInsets;
    
    
    
}

- (CAAnimation *)beginAnmiation
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    animation.toValue = [NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI_2, 0.0, 0.0, 1.0) ];
    animation.duration = 0.25;
    animation.cumulative = YES;
    animation.repeatCount = MAXFLOAT;
    return animation;
    
}

//根据偏移量 来旋转
- (void)setOffsetY:(CGFloat)offsetY
{
    
    _leftImg.transform = CGAffineTransformRotate(_leftImg.transform, offsetY / 1/5.0f / 180.0f * M_PI);
    _rotation = offsetY;
}
@end
