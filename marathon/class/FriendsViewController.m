//
//  FriendsViewController.m
//  marathon
//
//  Created by Ryan on 13-10-16.
//  Copyright (c) 2013年 Ryan. All rights reserved.
//

#import "FriendsViewController.h"

@interface FriendsViewController ()

@property (nonatomic, strong) UITableView *friendsTableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation FriendsViewController
@synthesize friendsTableView;
@synthesize dataArray;

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = BASE_PAGE_BG_COLOR;
    
    self.friendsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 190, VIEW_HEIGHT-34) style:UITableViewStylePlain];
    friendsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    friendsTableView.delegate = self;
    friendsTableView.dataSource = self;
    friendsTableView.backgroundColor = BASE_PAGE_BG_COLOR;
    [self.view addSubview:friendsTableView];
    
    NSDictionary *dic1 = @{@"code":@"12",
                          @"name":@"God!",
                          @"image":@"AVATAS1"};
    
    NSDictionary *dic2 = @{@"code":@"123",
                           @"name":@"小鱼",
                           @"image":@"AVATAS2"};
    
    NSDictionary *dic3 = @{@"code":@"1234",
                           @"name":@"雨欣",
                           @"image":@"AVATAS3"};
    
    NSDictionary *dic4 = @{@"code":@"12345",
                           @"name":@"Lulu",
                           @"image":@"AVATAS4"};
    
    NSDictionary *dic5 = @{@"code":@"123456",
                           @"name":@"Ryan",
                           @"image":@"AVATAS5"};
    
    self.dataArray = [NSMutableArray arrayWithObjects:dic1,dic2,dic3,dic4,dic5,nil];
    
    for (NSDictionary *item in dataArray) {
        if ([[item objectForKey:@"code"] isEqualToString:kCode]) {
            [dataArray removeObject:item];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *defaultCellIdentifier = @"defaultCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defaultCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:defaultCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = BASE_PAGE_BG_COLOR;
    }
    
    NSDictionary *dic = [dataArray objectAtIndex:indexPath.row];
    
    cell.imageView.image = [UIImage imageNamed:[dic objectForKey:@"image"]];
    cell.textLabel.text = [dic objectForKey:@"name"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    float height = 0.0;
    height = 30.0;
    
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView;
    
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    headerView.backgroundColor = BASE_PAGE_BG_COLOR;
    
//    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 4, 300, 26)];
//    titleLabel.backgroundColor = [UIColor clearColor];
//    titleLabel.font = HEI_(12);
//    titleLabel.textColor = BASE_LIGHTGREY_TEXT_COLOR;
//    [headerView addSubview:titleLabel];
//    
//    titleLabel.text = @"我的好友";
    
    return headerView;
}
@end
