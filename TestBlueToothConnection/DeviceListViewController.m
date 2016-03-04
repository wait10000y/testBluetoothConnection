//
//  DeviceListViewController.m
//  TestBlueToothConnection
//
//  Created by wsliang on 16/2/22.
//  Copyright © 2016年 xor-systems. All rights reserved.
//

#import "DeviceListViewController.h"
#import "DeviceManager.h"
#import "DeviceInfoViewController.h"
#import "CBPeripheral+desc.h"
#import "UIView+Toast.h"

@interface DeviceListViewController()<DeviceManagerDelegate>

//@property (nonatomic) NSMutableArray *mDataList;
@property (nonatomic ,weak) CBPeripheral *mSelectedItem;
@end

@implementation DeviceListViewController

-(void)viewDidLoad
{
  [super viewDidLoad];
self.title = @"蓝牙设备列表";
}

-(void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  [DeviceManager sharedObject].delegate = self;
  [[DeviceManager sharedObject] checkBluetoothServices];
}


// DeviceInfoViewController

#pragma mark ----- TableViewDelegate -----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [DeviceManager sharedObject].deviceList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.tableViewCellId forIndexPath:indexPath];
  
  CBPeripheral *item = [DeviceManager sharedObject].deviceList[indexPath.row];
  cell.textLabel.text = [item showTitle];
  cell.detailTextLabel.text = [item connectionDesc];
  DLog(@"--- 显示设备cell:%@ ---",[item allInfo]);
  return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  self.mSelectedItem = [DeviceManager sharedObject].deviceList[indexPath.row];
  [self performSegueWithIdentifier:@"DeviceInfoViewController" sender:nil];
  
}


#pragma mark ----- DataUtilBlueToothStatusDelegate -----
-(void)deviceManager:(id)sender updateDeviceList:(NSArray *)deviceList
{
  [self.tableView reloadData];
}

-(void)blueToothStatusChanged:(BOOL)enabled
{
  [self.view makeToast:enabled?@"蓝牙可用状态":@"蓝牙不可用状态" duration:2 position:nil];
}






- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  DeviceInfoViewController *infovc = [segue destinationViewController];
  infovc.dataItem = self.mSelectedItem;
}

@end
