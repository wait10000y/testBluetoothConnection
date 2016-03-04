//
//  DataUtils.h
//  TestBlueToothConnection
//
//  Created by wsliang on 16/2/22.
//  Copyright © 2016年 xor-systems. All rights reserved.
//

#import "BaseObject.h"
#import "CoreBluetooth/CoreBluetooth.h"

@protocol DeviceManagerDelegate <NSObject>

@optional
/*
 是否可用
 */
-(void)blueToothStatusChanged:(BOOL)enabled;
-(void)deviceManager:(id)sender updateDeviceList:(NSArray *)deviceList;

/*
 状态改变通知
 deviceManager
 */
-(void)deviceManager:(id)sender didConnectDevice:(CBPeripheral *)device;
-(void)deviceManager:(id)sender didDisconnectDevice:(CBPeripheral *)device;
-(void)deviceManager:(id)sender didFailToConnectDevice:(CBPeripheral *)device;

@end


@interface DeviceManager : BaseObject
@property (nonatomic,weak) id<DeviceManagerDelegate>delegate;
@property (nonatomic) CBCentralManager *blueToothManager;
@property (nonatomic,readonly) NSMutableArray *deviceList; // CBPeripheral list

+(instancetype)sharedObject;


/*
 检查蓝牙是否开启
 */
- (BOOL)checkBluetoothServices;

// 扫描蓝牙设备
-(void)scanPeripherals;
-(void)stopScanPeripherals;

// 连接蓝牙设备
-(void)connectPeripheral:(CBPeripheral *)peripheral;
-(void)disConnectPeripheral:(CBPeripheral *)peripheral;

-(void)connectPeripherals:(NSArray<NSUUID *> *)identifiers;
-(void)connectPeripheralsWithServices:(NSArray<CBUUID *> *)serviceUUIDs;



@end
