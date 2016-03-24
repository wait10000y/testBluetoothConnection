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
  
  
  for (int it=0; it<mDetailList.count; it++) {
    NSString *key = mTitleList[it];
    NSString * rStr = [self HloveyRC4:mDetailList[it] key:key];
    
    NSLog(@"------ string:%@ ,key:%@ ,result:%@ --------",mDetailList[it],key,rStr);
    
  }
  
  NSString *key = @"test";
  NSString * rStr = [self HloveyRC4:@"sfdsdfsdf12343,sfff,哈哈!!~,中文,是的负担士大夫" key:key];
  
  NSLog(@"------ string:%@ ,key:%@ ,result:%@ --------",rStr,key,rStr);
  
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


-(void)blueToothStatusChanged:(int)type enabled:(BOOL)enabled
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

-(NSString*)HloveyRC4:(NSString*)aInput key:(NSString*)aKey
{
  
  NSMutableArray *iS = [[NSMutableArray alloc] initWithCapacity:256];
  NSMutableArray *iK = [[NSMutableArray alloc] initWithCapacity:256];
  
  for (int i= 0; i<256; i++) {
    [iS addObject:[NSNumber numberWithInt:i]];
  }
  
  int j=1;
  
  for (short i=0; i<256; i++) {
    
    UniChar c = [aKey characterAtIndex:i%aKey.length];
    
    [iK addObject:[NSNumber numberWithChar:c]];
  }
  
  j=0;
  
  for (int i=0; i<255; i++) {
    int is = [[iS objectAtIndex:i] intValue];
    UniChar ik = (UniChar)[[iK objectAtIndex:i] charValue];
    
    j = (j + is + ik)%256;
    NSNumber *temp = [iS objectAtIndex:i];
    [iS replaceObjectAtIndex:i withObject:[iS objectAtIndex:j]];
    [iS replaceObjectAtIndex:j withObject:temp];
    
  }
  
  int i=0;
  j=0;
  
  NSString *result = aInput;
  
  for (short x=0; x<[aInput length]; x++) {
    i = (i+1)%256;
    
    int is = [[iS objectAtIndex:i] intValue];
    j = (j+is)%256;
    
    int is_i = [[iS objectAtIndex:i] intValue];
    int is_j = [[iS objectAtIndex:j] intValue];
    
    int t = (is_i+is_j) % 256;
    int iY = [[iS objectAtIndex:t] intValue];
    
    UniChar ch = (UniChar)[aInput characterAtIndex:x];
    UniChar ch_y = ch^iY;
    
    result = [result stringByReplacingCharactersInRange:NSMakeRange(x, 1) withString:[NSString stringWithCharacters:&ch_y length:1]];
  }
  
  return result;
  
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
