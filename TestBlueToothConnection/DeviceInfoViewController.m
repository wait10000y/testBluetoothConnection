//
//  ViewController.m
//  TestBlueToothConnection
//
//  Created by wsliang on 16/2/22.
//  Copyright © 2016年 xor-systems. All rights reserved.
//

#import "DeviceInfoViewController.h"

#import "DeviceManager.h"
#import "CBPeripheral+desc.h"


@interface DeviceInfoViewController ()<DeviceManagerDelegate,CBPeripheralDelegate,UIPickerViewDelegate,UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *statusTitle;
@property (weak, nonatomic) IBOutlet UITextView *message;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerServices;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerCharacteristics;
@property (weak, nonatomic) IBOutlet UITextField *textInput;

- (IBAction)actionOperations:(UIButton *)sender;


@property (nonatomic) NSArray *mServiceList; // 蓝牙服务列表
@property (nonatomic) CBService *mSelectedServie; // 选中的服务

@property (nonatomic) NSArray *mCharacteristics; // charact 列表
@property (nonatomic) CBCharacteristic *mSelectedCharacteristic; // 选中的 charact


@end

@implementation DeviceInfoViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"蓝牙设备详情";
  
  self.statusTitle.text = self.dataItem.connectionDesc;

}

-(void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  // 停止扫描
  [[DeviceManager sharedObject] stopScanPeripherals];
  
  [DeviceManager sharedObject].delegate = self;
  
  self.dataItem.delegate = self;
  
  [self.dataItem readRSSI];
  [self.dataItem discoverServices:nil];
  
  self.mServiceList = [self.dataItem.services copy];
  self.mSelectedServie = [self.mServiceList firstObject];
  [self.pickerServices reloadAllComponents];
  [self.pickerCharacteristics reloadAllComponents];
}

-(void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  self.dataItem.delegate = nil;
  
}


#pragma mark --- UIPickerViewDelegate ---
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
  return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
  if (pickerView == self.pickerServices) {
    return self.mServiceList.count?:1;
  }else{
    return self.mCharacteristics.count?:1;
  }
  
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
  NSString *title = @"no Service";
  if (pickerView == self.pickerServices) {
    if(self.mServiceList.count>row){
      CBService *service = self.mServiceList[row];
      //  service.UUID;
     title = service.UUID.UUIDString;
    }
  }else{
    title = @"no Characteristic";
    if (self.mCharacteristics.count>row) {
      CBCharacteristic *chart = self.mCharacteristics[row];
      title = chart.UUID.UUIDString;
    }
  }
  return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
  if (pickerView == self.pickerServices) {
    if (self.mServiceList.count>row) {
      self.mSelectedServie = self.mServiceList[row];
    }
  }else{
    if (self.mCharacteristics.count>row) {
      self.mSelectedCharacteristic = self.mCharacteristics[row];
    }
  }
}



#pragma mark ----- DataUtilBlueToothStatusDelegate -----
-(void)deviceManager:(id)sender didConnectDevice:(CBPeripheral *)device
{
  DLog(@"--- 连接成功:%@ ---",device.showInfo);
  [self.dataItem discoverServices:nil];
}

-(void)deviceManager:(id)sender didDisconnectDevice:(CBPeripheral *)device
{
  DLog(@"--- 断开连接:%@ ---",device.showInfo);
  self.mServiceList = nil;
  self.mCharacteristics = nil;
  [self.pickerServices reloadAllComponents];
  [self.pickerCharacteristics reloadAllComponents];
}

-(void)deviceManager:(id)sender didFailToConnectDevice:(CBPeripheral *)device
{
  DLog(@"--- 连接失败:%@ ---",device.showInfo);
}


#pragma mark --- CBPeripheralDelegate ---
- (void)peripheralDidUpdateName:(CBPeripheral *)peripheral
{
  DLog(@"---- peripheral:%@ ----",peripheral);
//  [self.pickerServices reloadComponent:0];
}

- (void)peripheral:(CBPeripheral *)peripheral didModifyServices:(NSArray<CBService *> *)invalidatedServices
{
  DLog(@"---- invalidatedServices:%@ ----",invalidatedServices);
}

- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(nullable NSError *)error
{
  DLog(@"---- error:%@ ----",error);
}

- (void)peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(nullable NSError *)error
{
  DLog(@"---- RSSI:%@ error:%@ ----",RSSI,error);
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(nullable NSError *)error
{
  DLog(@"---- error:%@ ----",error);
  if (error==nil) {
    //在这个方法中我们要查找到我们需要的服务  然后调用discoverCharacteristics方法查找我们需要的特性
    //该discoverCharacteristics方法调用完后会调用代理CBPeripheralDelegate的
    //- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
    self.mServiceList = [peripheral.services copy];
    [self.pickerServices reloadAllComponents];
    self.mCharacteristics = nil;
    [self.pickerCharacteristics reloadAllComponents];
//    for (CBService *service in peripheral.services) {
//      if ([service.UUID isEqual:self.mSelectedServie.UUID]) {
////        [peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:@"kCharacteristicUUID"]] forService:service];
//        [peripheral discoverCharacteristics:nil forService:service];
//      }
//    }
  }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverIncludedServicesForService:(CBService *)service error:(nullable NSError *)error
{
  DLog(@"---- service:%@ , error:%@ ----",service,error);
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(nullable NSError *)error
{
  DLog(@"---- service:%@ , error:%@ ----",service,error);
  if (error==nil) {
    self.mCharacteristics = [service.characteristics copy];
    [self.pickerCharacteristics reloadAllComponents];
    
//    //在这个方法中我们要找到我们所需的服务的特性 然后调用setNotifyValue方法告知我们要监测这个服务特性的状态变化
//    //当setNotifyValue方法调用后调用代理CBPeripheralDelegate的- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
//    for (CBCharacteristic *characteristic in service.characteristics) {
//      if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"kCharacteristicUUID"]]) {
//        [peripheral setNotifyValue:YES forCharacteristic:characteristic];
//      }
//    }
  }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error
{
  // TODO: 读取 蓝牙设备发送过来的信息
  DLog(@"---- didUpdateValueForCharacteristic characteristic:%@ , error:%@ ----",characteristic,error);
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error
{
  DLog(@"---- didWriteValueForCharacteristic characteristic:%@ , error:%@ ----",characteristic,error);
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error
{
  DLog(@"---- didUpdateNotificationStateForCharacteristic characteristic:%@ , error:%@ ----",characteristic,error);
  if (error==nil) {
    //调用下面的方法后 会调用到代理的- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
    [peripheral readValueForCharacteristic:characteristic];
  }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error
{
  DLog(@"---- didDiscoverDescriptorsForCharacteristic characteristic:%@ , error:%@ ----",characteristic,error);
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(nullable NSError *)error
{
  DLog(@"---- didUpdateValueForDescriptor descriptor:%@ , error:%@ ----",descriptor,error);
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForDescriptor:(CBDescriptor *)descriptor error:(nullable NSError *)error
{
  DLog(@"---- didWriteValueForDescriptor descriptor:%@ , error:%@ ----",descriptor,error);
}





- (IBAction)actionOperations:(UIButton *)sender {
  switch (sender.tag) {
    case 101: // 刷新
    {
      self.message.text = nil;
    } break;
    case 102: // 连接
    {
      if (self.dataItem.state == CBPeripheralStateDisconnected) {
        [[DeviceManager sharedObject] connectPeripheral:self.dataItem];
      }else{
        DLog(@"--- 已经连接:%@ ---",self.dataItem.connectionStatus);
      }
    } break;
    case 103: // 断开连接
    {
      if (self.dataItem.state != CBPeripheralStateDisconnected) {
        [[DeviceManager sharedObject] disConnectPeripheral:self.dataItem];
      }else{
        DLog(@"--- 已经断开连接:%@ ---",self.dataItem.connectionStatus);
      }
    } break;
    case 104: // 连接service,查找service服务特性
    {
      DLog(@"--- 开始连接 service:%@ ---",self.mSelectedServie);
      [self.dataItem discoverCharacteristics:nil forService:self.mSelectedServie];
//      [self.dataItem discoverServices:@[self.mSelectedServie.UUID]];
    } break;
    case 105: // 连接 characteristic/ 读取服务特性内容
    {
      [self showMessage:@"监听消息" isAppend:YES];
      DLog(@"--- 开始监听 characteristic:%@ ---",self.mSelectedCharacteristic);
      //在这个方法中我们要找到我们所需的服务的特性 然后调用setNotifyValue方法告知我们要监测这个服务特性的状态变化
      //当setNotifyValue方法调用后调用代理CBPeripheralDelegate的- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
//      for (CBCharacteristic *characteristic in service.characteristics) {
//        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"kCharacteristicUUID"]]) {
//          [peripheral setNotifyValue:YES forCharacteristic:characteristic];
//        }
//      }
      NSLog(@"Reading value for characteristic %@",self.mSelectedCharacteristic);
      [self.dataItem readValueForCharacteristic:self.mSelectedCharacteristic];
      
      [self.dataItem setNotifyValue:YES forCharacteristic:self.mSelectedCharacteristic];
    } break;
    case 106: // 发消息
    {
      NSString *text = self.textInput.text;
      [self showMessage:@"发送消息:" isAppend:YES];
      if(text.length>0){
        [self showMessage:text isAppend:YES];
        NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
        [self.dataItem writeValue:data forCharacteristic:self.mSelectedCharacteristic type:CBCharacteristicWriteWithResponse];
      }
    } break;
    case 107: //
    {
      
    } break;
    default:
      break;
  }
}

static int lineIndex = 1;
-(void)showMessage:(id)theData isAppend:(BOOL)isAppend
{
  if (isAppend) {
    self.message.text = [NSString stringWithFormat:@"[>%0.4d] %@\r\n%@",lineIndex++,theData?[theData description]:@"",self.message.text];
  }else{
    self.message.text = theData?[theData description]:@"";
  }
  self.statusTitle.text = self.dataItem.connectionDesc;
}








@end
