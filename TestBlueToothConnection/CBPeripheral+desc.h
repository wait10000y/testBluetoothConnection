//
//  CBPeripheral+desc.h
//  TestBlueToothConnection
//
//  Created by wsliang on 16/3/2.
//  Copyright © 2016年 xor-systems. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>
#import "NSObject+runtime.h"

@interface CBPeripheral (desc)

@property (nonatomic) NSDictionary *advertisementData;
@property (nonatomic) NSNumber *rssi;

-(NSString *)showInfo;
-(NSString *)showTitle;
-(NSString *)connectionDesc;
-(NSString *)connectionStatus;
-(NSString *)stateString;

-(NSString *)allInfo;

-(NSString *)showAdvertisementInfo;

-(BOOL)getAdvertisementConnectable;
-(NSString *)getAdvertisementManufacturerData;
// key:CBUUID,value:NSData
-(NSDictionary *)getAdvertisementServices;
// CBUUID list
-(NSArray *)getAdvertisementServiceUUIDs;


@end


