//
//  OfficeListViewController.m
//  TestBlueToothConnection
//
//  Created by wsliang on 16/2/22.
//  Copyright © 2016年 xor-systems. All rights reserved.
//

#import "OfficeListViewController.h"
#import "DeviceManager.h"
#import "UIView+Toast.h"

@interface OfficeListViewController()<DeviceManagerDelegate>

@property (nonatomic) CBCentralManager *blueToothManager;


@end

@implementation OfficeListViewController
{
  NSArray *mTitleList;
  NSArray *mDetailList;
}
- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.tableView.estimatedRowHeight = 60;
  
  // 配置数据
  mTitleList = @[
                @"蓝牙状态",
                @"蓝牙设备",
                @"蓝牙通讯",
                @"其他配置",
                ];
  
  mDetailList = @[
                  @"查看蓝牙是否可用",
                  @"查看蓝牙设备",
                  @"蓝牙通讯测试",
                  @"",
                  ];
}

-(void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  [DeviceManager sharedObject].delegate = self;
  [[DeviceManager sharedObject] checkBluetoothServices];
}

- (void)didReceiveMemoryWarning {
  DLog(@"---- didReceiveMemoryWarning -----");
  [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return mTitleList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.tableViewCellId forIndexPath:indexPath];
  
  NSString *title = mTitleList[indexPath.row];
  NSString *detail = mDetailList.count>indexPath.row?mDetailList[indexPath.row]:@"";
  
  cell.textLabel.text = title;
  cell.detailTextLabel.text = detail;
  
  return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
  switch (indexPath.row) {
    case 0: // 检查蓝牙开启
    {
      [[DeviceManager sharedObject] checkBluetoothServices];
    } break;
    case 1: // 查看蓝牙列表
    {
      [self performSegueWithIdentifier:@"DeviceListViewController" sender:nil];
    } break;
    case 2: // 测试 蓝牙设备通讯
    {
      
    } break;
    case 3:
    {
      
    } break;
      
    default:
      break;
  }
  
}


-(void)blueToothStatusChanged:(BOOL)enabled
{
  NSString *msg = enabled?@"蓝牙功能可用":@"蓝牙功能不可用";
  UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
  cell.detailTextLabel.text = msg;
  // 提示
  [self.view makeToast:msg duration:2 position:nil];
}

-(void)deviceManager:(id)sender updateDeviceList:(NSArray *)deviceList
{
  NSInteger row = 1;
  UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
  if(cell){
    NSString *detail = [NSString stringWithFormat:@"%@(%ld)",mDetailList.count>row?mDetailList[row]:@"蓝牙设备",deviceList.count];
    cell.detailTextLabel.text = detail;
  }
  
  DLog(@"---- 蓝牙设备列表:%@ ----",deviceList);
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
