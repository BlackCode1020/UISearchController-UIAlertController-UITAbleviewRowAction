//
//  RootTableViewController.m
//  UISearchController_Demo
//
//  Created by 李大泽 on 14/10/17.
//  Copyright (c) 2014年 蓝鸥科技. All rights reserved.
//

#import "RootTableViewController.h"
#import "Student.h"

@interface RootTableViewController () <UISearchResultsUpdating>

@property (nonatomic, retain) NSMutableArray *allDataArray;                     // 存放所有数据的数组
@property (nonatomic, retain) NSMutableArray *searchResultDataArray;            // 存放搜索出结果的数组

@property (nonatomic, retain) UISearchController *searchController;             // 搜索控制器
@property (nonatomic, retain) UITableViewController *searchTVC;                 // 搜索使用的表示图控制器

@end

@implementation RootTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadViews];
    [self loadData];
}


#pragma mark - ~~
#pragma mark 加载视图
- (void)loadViews
{
    // 设置标题
    self.title = @"败家孩子们..";
    
    // 搜索按钮
    self.navigationItem.leftBarButtonItem = ({
        UIBarButtonItem *searchBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchBarButtonItemAction:)];
        searchBarButtonItem;
    });
    
    // 编辑按钮
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark 加载数据
- (void)loadData
{
    // 如果是大批量的数据，最好是放在子线程中
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
#warning 测试数据
        // 添加测试数据
        Student *stu1 = [[Student alloc] initWithName:@"铜耗子"
                                          phoneNumber:@"13838384388"
                                               gender:@"死变态"];
        Student *stu2 = [[Student alloc] initWithName:@"摇一摇 啊 免费"
                                          phoneNumber:@"18931399882"
                                               gender:@"汉子"];
        Student *stu3 = [[Student alloc] initWithName:@"超超，超屁"
                                          phoneNumber:@"13838384388"
                                               gender:@"变态死"];
        Student *stu4 = [[Student alloc] initWithName:@"黄梨 强，还甜"
                                          phoneNumber:@"18932378726"
                                               gender:@"小闷骚"];
        Student *stu5 = [[Student alloc] initWithName:@"钢芯冥"
                                          phoneNumber:@"18888888888"
                                               gender:@"男 胖子"];
        Student *stu6 = [[Student alloc] initWithName:@"遛 璞丰"
                                          phoneNumber:@"13787847888"
                                               gender:@"男胖子，小。。"];
        Student *stu7 = [[Student alloc] initWithName:@"违心生 活,,"
                                          phoneNumber:@"12345678829"
                                               gender:@"男瘦子"];
        Student *stu8 = [[Student alloc] initWithName:@"操 咚~~"
                                          phoneNumber:@"16543896487"
                                               gender:@"女胖子"];
        self.allDataArray = [NSMutableArray arrayWithObjects:stu1, stu2, stu3, stu4, stu5, stu6, stu7, stu8, nil];
        
        // 返回主线程更新页面
        __weak RootTableViewController *weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            // 刷新数据
            [weakSelf.tableView reloadData];
        });
    });
    
}

#pragma mark 搜索按钮事件（点击搜索按钮，推出搜索控制器）
- (void)searchBarButtonItemAction:(UIBarButtonItem *)sender
{
    // 创建出搜索使用的表示图控制器
    self.searchTVC = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
    _searchTVC.tableView.dataSource = self;
    _searchTVC.tableView.delegate = self;
    
    // 使用表示图控制器创建出搜索控制器
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:_searchTVC];
    
    // 搜索框检测代理
    //（这个需要遵守的协议是 <UISearchResultsUpdating> ，这个协议中只有一个方法，当搜索框中的值发生变化的时候，代理方法就会被调用）
    _searchController.searchResultsUpdater = self;
    _searchController.searchBar.placeholder = @"姓名 | 电话 | 性别";
    _searchController.searchBar.prompt = @"输入要查找的混蛋";
    
    // 因为搜索是控制器，所以要使用模态推出（必须是模态，不可是push）
    [self presentViewController:_searchController animated:YES completion:nil];
}







#pragma mark - UITableViewDataSource Methods
#pragma mark 设置分组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark 设置分组中的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (tableView == self.tableView ? _allDataArray.count : _searchResultDataArray.count);
}

#pragma mark 设置每个cell上显示的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1. 声明重用标示符
    static NSString *cellIdentifier = @"cellIdentifier";
    // 2. 去重用队列中查找
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    // 3. 如果没用可重用的cell，则自己创建
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        // 随机背景色
        cell.backgroundColor = [UIColor colorWithRed:arc4random() % 256 / 255.0
                                               green:arc4random() % 256 / 255.0
                                                blue:arc4random() % 256 / 255.0
                                               alpha:0.5f];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:35.0f];
        cell.textLabel.textColor = [UIColor blueColor];
        cell.detailTextLabel.font = [UIFont italicSystemFontOfSize:19.0f];
        cell.detailTextLabel.textColor = [UIColor brownColor];
    }
    
    // 4. 设置cell要显示的信息
    Student *stu = (tableView == self.tableView ? _allDataArray[indexPath.row] : _searchResultDataArray[indexPath.row]);
    cell.imageView.image = [UIImage imageNamed:@"3"];
    cell.textLabel.text = stu.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@  %@", stu.phoneNumber, stu.gender];
    
    // 5. 返回
    return cell;
}

#pragma mark 设置cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110.0f;
}

#pragma mark - UITableViewDelegate Methods
#pragma mark 处理cell的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 获取到点击的模型
    Student *stu = (tableView == self.tableView ? _allDataArray[indexPath.row] : _searchResultDataArray[indexPath.row]);
    
    // 弹出AlertView显示
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"谁点了这个混蛋！" message:[NSString stringWithFormat:@"姓名：%@ \n电话：%@ \n性别：%@", stu.name, stu.phoneNumber, stu.gender] preferredStyle:UIAlertControllerStyleAlert];
    
    // 添加关闭按钮
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    [alertController addAction:cancelAction];
    
    // 在搜索结果的tableView中，需要使用_searchTVC来推出提示框，否则使用self即可
    UIViewController *currentVC = tableView == self.tableView ? self : _searchTVC;
    
    // 推出提示框
    [currentVC presentViewController:alertController animated:YES completion:nil];
}


#pragma mark 设置是否可以编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
#pragma mark 设置编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
#pragma mark 处理编辑情况
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark 设置滑动显示出的按钮
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 置顶按钮
    UITableViewRowAction *layTopRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"置顶" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        NSLog(@"点击了置顶");
        
        [tableView setEditing:NO animated:YES];
    }];
    layTopRowAction.backgroundColor = [UIColor redColor];
    
    // 标记
    UITableViewRowAction *markRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"标记混蛋" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        NSLog(@"标记了这个混蛋");
        
        [tableView setEditing:NO animated:YES];
    }];
    markRowAction.backgroundColor = [UIColor greenColor];
    
    
    // 更多按钮
    UITableViewRowAction *moreRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"更多" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        NSLog(@"点击更多");
        
        [tableView setEditing:NO animated:YES];
    }];
    moreRowAction.backgroundColor = [UIColor darkGrayColor];
    
    // 返回编辑按钮
    return @[layTopRowAction, markRowAction, moreRowAction];
}






#pragma mark - UISearchResultsUpdating Method
#pragma mark 监听者搜索框中的值的变化
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    // 1. 获取输入的值
    NSString *conditionStr = searchController.searchBar.text;
    
    // 2. 创建谓词，准备进行判断的工具
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.phoneNumber CONTAINS [CD] %@ OR self.name CONTAINS [CD] %@ OR self.gender CONTAINS [CD] %@", conditionStr, conditionStr, conditionStr];
    
    // 3. 使用工具获取匹配出的结果
    self.searchResultDataArray = [NSMutableArray arrayWithArray:[_allDataArray filteredArrayUsingPredicate:predicate]];
    
    // 4. 刷新页面，将结果显示出来
    [_searchTVC.tableView reloadData];
}


@end
