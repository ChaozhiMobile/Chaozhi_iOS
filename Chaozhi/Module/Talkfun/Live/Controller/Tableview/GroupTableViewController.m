//
//  GroupTableViewController.m
//  TalkfunSDKDemo
//
//  Created by talk－fun on 16/3/7.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import "GroupTableViewController.h"
#import "GroupChatTableViewController.h"

@interface GroupTableViewController ()

@property (nonatomic,strong) GroupChatTableViewController * gcTVC;
@property (nonatomic,strong) NSMutableArray * messageMark;

@end

@implementation GroupTableViewController

- (GroupChatTableViewController *)gcTVC
{
    @synchronized(self) {
        if (!_gcTVC) {
            _gcTVC = [[GroupChatTableViewController alloc] initWithStyle:UITableViewStylePlain];
        }
    }
    return _gcTVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource               = [NSMutableArray new];
    self.groupDict                = [NSMutableDictionary new];
    self.messageMark              = [NSMutableArray new];

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight      = 50;

    self.gcTVC.heightArray        = [NSMutableArray new];
    
}

- (void)viewWillAppear:(BOOL)animated
{
//    self.view.backgroundColor = [UIColor orangeColor];
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.gcTVC.groupid = nil;
    [self.tableView reloadData];
    
    //NSLog(@"~~~~~%lf ~~~~~%lf ~~~~~%lf ~~~~~%lf ",self.navigationController.view.frame.origin.x,self.navigationController.view.frame.origin.y,self.navigationController.view.frame.size.width,self.navigationController.view.frame.size.height);
    
}

//清除数据
- (void)clearData:(NSNotification *)notification
{
    
}

//重新计算高度
- (void)recalculateCellHeight
{
    
}

- (void)addObj:(id)obj
{
    [self.groupDict setObject:[NSMutableArray new] forKey:obj[@"groupid"]];
    [self.dataSource addObject:obj];
    [self.messageMark addObject:@(0)];
}

- (void)addMessage:(id)obj
{
    NSMutableArray * arr = self.groupDict[obj[@"groupid"]];
    [arr addObject:obj];
    [self.groupDict setObject:arr forKey:obj[@"groupid"]];
    int i = 0;
    for (NSDictionary * dict in self.dataSource) {
        if ([dict[@"groupid"] isEqualToString:obj[@"groupid"]]) {
            [self.messageMark replaceObjectAtIndex:i withObject:@(1)];
            break;
        }
        i ++;
    }
    
    if ([self.gcTVC.groupid isEqualToString:obj[@"groupid"]]) {
        [self.gcTVC addObj:obj];
        [self.messageMark replaceObjectAtIndex:i withObject:@(0)];
    }
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.groupDict.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"groupCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"groupCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSDictionary * params = self.dataSource[indexPath.row];
    NSArray * arr         = params[@"members"];
    NSString * nickname;
    NSString * headImageStr;
    for (NSDictionary * dict in arr) {
        if ([params[@"ownerid"] isEqualToNumber:dict[@"xid"]]) {
            nickname = dict[@"nickname"];
            headImageStr = dict[@"avatar"];
            break;
        }
    }
    cell.imageView.image = [UIImage imageNamed:@"default_avatar"];
    dispatch_queue_t queue = dispatch_queue_create("group", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        
        NSData * data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:headImageStr]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            cell.imageView.image = [UIImage imageWithData:data];
            UIImageView * rcircleImage = [[UIImageView alloc] initWithFrame:CGRectMake(cell.imageView.frame.size.width + 8, 8, 8, 8)];
            rcircleImage.image = [UIImage imageNamed:@"rcircle"];
            rcircleImage.tag = 322 + indexPath.row;
            if ([self.messageMark[indexPath.row] isEqualToNumber:@(0)]) {
                rcircleImage.hidden = YES;
            }else
            {
                rcircleImage.hidden = NO;
            }
            
            [cell.contentView addSubview:rcircleImage];
            
        });
        
    });
    cell.textLabel.text = nickname;
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.messageMark replaceObjectAtIndex:indexPath.row withObject:@(0)];
    NSDictionary * params = self.dataSource[indexPath.row];
    NSMutableArray * arr  = self.groupDict[params[@"groupid"]];
    NSArray * members     = params[@"members"];
    for (NSDictionary * dict in members) {
        if ([params[@"ownerid"] isEqualToNumber:dict[@"xid"]]) {
            self.gcTVC.nickname = dict[@"nickname"];
            break;
        }
    }
    self.gcTVC.groupid                    = params[@"groupid"];
    self.groupid                          = self.gcTVC.groupid;
    self.gcTVC.dataSource                 = arr;
    UIBarButtonItem * item                = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    [self.navigationController pushViewController:self.gcTVC animated:YES];
}

@end
