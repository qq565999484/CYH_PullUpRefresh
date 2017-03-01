//
//  ViewController.m
//  CYHPullUpRefreshDemo
//
//  Created by chenyihang on 2017/3/1.
//  Copyright © 2017年 chenyihang. All rights reserved.
//

#import "ViewController.h"
#import "UIScrollView+PullUP.h"

@interface ViewController ()

@property (nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    for (NSInteger i = 0; i<12; i++) {
        [self.dataArray addObject:@"一直穿云箭"];
    }
    [self.tableView reloadData];
    
    __weak typeof(self) weakSelf = self;
    
    
     [self.tableView.refreshView setRefreshByUpPush:^{
      
        dispatch_after( dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.tableView.refreshView endRefresh];
        });
        
    }];
    [self.tableView.refreshView setTopOffSet:20];
   
    
    self.tableView.tableFooterView = [UIView new];
}


- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray  = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count > 0 ? self.dataArray.count : 0;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *staticCELL = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:staticCELL];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:staticCELL];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"我是第%d行",indexPath.row];
    
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
