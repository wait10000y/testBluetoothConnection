//
//  ViewController.h
//  TestBlueToothConnection
//
//  Created by wsliang on 16/2/22.
//  Copyright © 2016年 xor-systems. All rights reserved.
//

#import "BaseViewController.h"

@class CBPeripheral;
@interface DeviceInfoViewController : BaseViewController

@property (nonatomic) CBPeripheral *dataItem;


@end

