//
//  DataUtils.m
//  TestBlueToothConnection
//
//  Created by wsliang on 16/2/22.
//  Copyright © 2016年 xor-systems. All rights reserved.
//

#import "DeviceManager.h"
#import "CBPeripheral+desc.h"

@interface DeviceManager()<CBCentralManagerDelegate,CBPeripheralDelegate>

@property (nonatomic) NSMutableDictionary *deviceDict; // key:id,value:device(CBPeripheral)

@end

@implementation DeviceManager

+(instancetype)sharedObject
{
  static DeviceManager *staticObject = nil;
  static dispatch_once_t onceTag;
  dispatch_once(&onceTag, ^{
    staticObject = [DeviceManager new];
  });
  return staticObject;
}

- (instancetype)init
{
  self = [super init];
  if (self) {
    _deviceList = [NSMutableArray new];
    self.deviceDict = [NSMutableDictionary new];
  }
  return self;
}


- (BOOL)checkBluetoothServices
{
  DLog(@"--- 检查蓝牙功能是否开启 ---");
  if (!self.blueToothManager) {
    self.blueToothManager = [[CBCentralManager alloc]initWithDelegate:self queue:nil];
  }
  BOOL isOpen = (self.blueToothManager.state == CBCentralManagerStatePoweredOn);
  if (isOpen) {
    [self scanPeripherals];
  }
  return isOpen;
}

// 扫描蓝牙设备
-(void)scanPeripherals
{
  DLog(@"--- 开始查找蓝牙设备 ---");
  if (!self.blueToothManager.isScanning) {
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:false],CBCentralManagerScanOptionAllowDuplicatesKey, nil];
//    NSArray *services = @[[CBUUID UUIDWithString:@"kServiceUUID"]];
    [self.blueToothManager scanForPeripheralsWithServices:nil options:dic];
  }
}

// 停止扫描蓝牙设备
-(void)stopScanPeripherals
{
  [self.blueToothManager stopScan];
}

//恢复设备连接 (NSArray<NSUUID *> *)identifiers
-(void)connectPeripherals:(NSArray<NSUUID *> *)identifiers
{
  [self.blueToothManager retrievePeripheralsWithIdentifiers:identifiers];
}

//恢复服务连接 (NSArray<CBUUID *> *)serviceUUIDs
-(void)connectPeripheralsWithServices:(NSArray<CBUUID *> *)serviceUUIDs
{
  [self.blueToothManager retrieveConnectedPeripheralsWithServices:serviceUUIDs];
}

//  连接 蓝牙设备
-(void)connectPeripheral:(CBPeripheral *)peripheral
{
  [self stopScanPeripherals];
  DLog(@"--- 连接一个蓝牙设备:%@ ---",peripheral);
  [self.blueToothManager connectPeripheral:peripheral options:@{CBConnectPeripheralOptionNotifyOnConnectionKey : @(YES)}];

}

// 断开连接 蓝牙设备
-(void)disConnectPeripheral:(CBPeripheral *)peripheral
{
  DLog(@"--- 断开蓝牙设备连接:%@ ---",peripheral);
  [self.blueToothManager cancelPeripheralConnection:peripheral];
  [self scanPeripherals];
}



#pragma mark ---- CBCentralManagerDelegate ----
-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
  DLog(@" ----- 蓝牙状态变更 :%ld ------ ",(long)central.state);
  BOOL isOK = central.state == CBCentralManagerStatePoweredOn;
  [self.deviceList removeAllObjects];
  if (isOK) {
    [self scanPeripherals];
  }
  if ([self.delegate respondsToSelector:@selector(blueToothStatusChanged:)]) {
    [self.delegate blueToothStatusChanged:isOK];
  }
  if ([self.delegate respondsToSelector:@selector(deviceManager:updateDeviceList:)]) {
    [self.delegate deviceManager:central updateDeviceList:self.deviceList];
  }
}

/*
 <CBPeripheral: 0x15f6b41d0, identifier = D47B3895-E70E-5594-F95D-A7716696149D, name = (null), state = disconnected> , 
 advertisementData:{
 kCBAdvDataIsConnectable = 1;
 } , 
 RSSI:-72
 */

/*
 advertisementData:{
 kCBAdvDataIsConnectable = 1;
 kCBAdvDataLocalName = MI;
 kCBAdvDataManufacturerData = <570100dd 30471721 dd1263d7 fb562517 46063001 880f10a7 54c9>;
 kCBAdvDataServiceData =     {
 FEE0 = <00000000>;
 };
 kCBAdvDataServiceUUIDs =     (
 FEE0,
 FEE7
 );
 } , RSSI:127
 
 advertisementData:{
 kCBAdvDataIsConnectable = 1;
 kCBAdvDataLocalName = MI;
 kCBAdvDataManufacturerData = <570100bb fab77d45 5e57c1ab e5c41b94 f71ec301 880f10a7 54c9>;
 kCBAdvDataServiceData =     {
 FEE0 = <00000000>;
 };
 kCBAdvDataServiceUUIDs =     (
 FEE0,
 FEE7
 );
 } , RSSI:-90
 */
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI
{  
  NSString *pId = [peripheral.identifier UUIDString];
  if (pId) {
    CBPeripheral *oldDevice = self.deviceDict[pId];
    NSString *disType = @"发现蓝牙设备";
    if (oldDevice) {
      disType = @"更新蓝牙设备";
      if (oldDevice.hash != peripheral.hash) {
        [self.deviceList replaceObjectAtIndex:[self.deviceList indexOfObject:oldDevice] withObject:peripheral];
      }
    }else{
      peripheral.advertisementData = advertisementData;
      peripheral.rssi = RSSI;
      [peripheral readRSSI];
      [self.deviceDict setObject:peripheral forKey:pId];
      [self.deviceList addObject:peripheral];
    }
    DLog(@" ----- %@ 详情%@ , 广播信息:%@------ ",disType,peripheral,[peripheral showAdvertisementInfo]);
  }else{
    DLog(@"--- 发现蓝牙设备 未有Id ---");
  }

  if ([self.delegate respondsToSelector:@selector(deviceManager:updateDeviceList:)]) {
    [self.delegate deviceManager:central updateDeviceList:self.deviceList];
  }
}

-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
  DLog(@" ----- 连接蓝牙设备 : %@ ------ ",peripheral);
  if ([self.delegate respondsToSelector:@selector(deviceManager:didConnectDevice:)]) {
    [self.delegate deviceManager:central didConnectDevice:peripheral];
  }
}

-(void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
  DLog(@" ----- 断开蓝牙设备 : %@ , error:%@ ------ ",peripheral,error);
//  [self.deviceList removeObject:peripheral];
//  if ([self.delegate respondsToSelector:@selector(deviceManager:updateDeviceList:)]) {
//    [self.delegate deviceManager:central updateDeviceList:self.deviceList];
//  }
  
  if ([self.delegate respondsToSelector:@selector(deviceManager:didDisconnectDevice:)]) {
    [self.delegate deviceManager:central didDisconnectDevice:peripheral];
  }
}

-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
  DLog(@" ----- 失败连接设备 : %@ , error:%@ ------ ",peripheral,error);
  if ([self.delegate respondsToSelector:@selector(deviceManager:didFailToConnectDevice:)]) {
    [self.delegate deviceManager:central didFailToConnectDevice:peripheral];
  }
}

-(void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary<NSString *,id> *)dict
{
  DLog(@" ----- 存储蓝牙设备 :%@ ------ ",dict);
//  [self.deviceList removeObject:nil];
  if ([self.delegate respondsToSelector:@selector(deviceManager:updateDeviceList:)]) {
    [self.delegate deviceManager:central updateDeviceList:self.deviceList];
  }
}


#pragma mark --- CBPeripheralDelegate ---
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
  if (error==nil) {
    //在这个方法中我们要查找到我们需要的服务  然后调用discoverCharacteristics方法查找我们需要的特性
    //该discoverCharacteristics方法调用完后会调用代理CBPeripheralDelegate的
    //- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
    for (CBService *service in peripheral.services) {
      if ([service.UUID isEqual:[CBUUID UUIDWithString:@"kServiceUUID"]]) {
        [peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:@"kCharacteristicUUID"]] forService:service];
      }
    }
  }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
  if (error==nil) {
    //在这个方法中我们要找到我们所需的服务的特性 然后调用setNotifyValue方法告知我们要监测这个服务特性的状态变化
    //当setNotifyValue方法调用后调用代理CBPeripheralDelegate的- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
    for (CBCharacteristic *characteristic in service.characteristics) {
      if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"kCharacteristicUUID"]]) {
        
        [peripheral setNotifyValue:YES forCharacteristic:characteristic];
      }
    }
  }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
  if (error==nil) {
    //调用下面的方法后 会调用到代理的- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
    [peripheral readValueForCharacteristic:characteristic];
  }
}


- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
  
}


@end
