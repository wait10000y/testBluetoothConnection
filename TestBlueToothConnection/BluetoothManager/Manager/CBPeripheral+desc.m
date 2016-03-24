//
//  CBPeripheral+desc.m
//  TestBlueToothConnection
//
//  Created by wsliang on 16/3/2.
//  Copyright © 2016年 xor-systems. All rights reserved.
//

#import "CBPeripheral+desc.h"
#import <objc/runtime.h>

@implementation CBPeripheral (desc)

-(void)setAdvertisementData:(NSDictionary *)advertisementData
{
  objc_setAssociatedObject(self, @selector(advertisementData), advertisementData, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSDictionary *)advertisementData
{
  return objc_getAssociatedObject(self, @selector(advertisementData));
}

-(void)setRssi:(NSNumber *)rssi
{
  objc_setAssociatedObject(self, @selector(rssi), rssi, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSNumber *)rssi
{
  return objc_getAssociatedObject(self, @selector(rssi));
}


/*
 - (NSObject *)property {
 return objc_getAssociatedObject(self, @selector(property));
 }
 
 - (void)setProperty:(NSObject *)value {
 objc_setAssociatedObject(self, @selector(property), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
 }
 */

/*
 static const void *tagKey = &tagKey;

 - (NSString *)tag {
 return objc_getAssociatedObject(self, tagKey);
 }
 
 - (void)setTag:(NSString *)tag {
 objc_setAssociatedObject(self, tagKey, tag, OBJC_ASSOCIATION_COPY_NONATOMIC);
 }
 */

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
  
}

- (NSString *)allInfo
{
  NSMutableString * ms = [[NSMutableString alloc] init];
  [ms appendString:@"\r########################################"];
  [ms appendFormat:@"\r<%@ %lx>",NSStringFromClass(self.class), (unsigned long)self.hash];
  [NSObject enumeratePropertiesWithClassType:[self class] usingBlick:^(BOOL read, NSString *name, NSString *type, NSArray *attrs) {
    [ms appendFormat:@"\r[%@]=%@", name, [self valueForKeyPath:name]];
  }];
  [ms appendString:@"\r########################################\r"];
  return ms;
}

-(NSString *)connectionStatus
{
  switch (self.state) {
    case CBPeripheralStateDisconnected: {
      return @"未连接";
      break;
    }
    case CBPeripheralStateConnecting: {
      return @"连接中..";
      break;
    }
    case CBPeripheralStateConnected: {
      return @"已连接";
      break;
    }
    case CBPeripheralStateDisconnecting: {
      return @"正在断开";
      break;
    }
  }
  return @"未知状态";
}

-(NSString *)stateString
{
  return [self connectionStatus];
}

-(NSString *)connectionDesc
{
//  NSString *title = item.advertisementData[@"kCBAdvDataManufacturerData"]?:(item.advertisementData[@"kCBAdvDataLocalName"]?:(item.name?:@"未命名"));
  
  NSString *desc = [NSString stringWithFormat:@"可连接:%@,状态:%@,rssi:%@ \n%@",[((NSString *)self.advertisementData[@"kCBAdvDataIsConnectable"]) boolValue]?@"是":@"否",[self connectionStatus],self.rssi,self.identifier.UUIDString];
  return desc;
}

-(NSString *)showInfo
{
  return [NSString stringWithFormat:@"[CBPeripheral:%lx ,UUID:%@]",self.hash,self.identifier.UUIDString];
}

-(NSString *)showTitle
{
  NSString *name = self.name?:self.advertisementData[@"kCBAdvDataLocalName"];
  NSData *data = self.advertisementData[@"kCBAdvDataManufacturerData"];
  NSString *desc;
//  if(data){
//    const char *valueString = [[data description] cStringUsingEncoding: NSUTF8StringEncoding];
//    desc = [NSString stringWithCString:valueString encoding:NSUTF8StringEncoding];
//  }
//  NSString *desc = data?[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]:nil;
  NSLog(@"==== showTitle:name:%@,desc:%@,data:%@ =====",name,desc,data);
  if (!name && !desc) {
    return @"未命名";
  }else if (!name){
    return desc;
  }else if (!desc){
    return name;
  }else{
    return [NSString stringWithFormat:@"%@(%@)",name,desc];
  }

}

/*
 [advertisementData]={
 kCBAdvDataIsConnectable = 1;
 kCBAdvDataLocalName = MI;
 kCBAdvDataManufacturerData = <570100c4 bfab8244 409a7d3a a3cf0b87 68e03401 880f10a7 54c9>;(NSData)
 kCBAdvDataServiceData =     {
 FEE0 = <00000000>;(CBUUID)=(NSData)
 };
 kCBAdvDataServiceUUIDs =     (
 FEE0,(CBUUID)
 FEE7(CBUUID)
 );
 }
 */
-(NSString *)showAdvertisementInfo
{
  NSMutableString *showStr = [NSMutableString new];
  [showStr appendFormat:@"可连接:%d",[self getAdvertisementConnectable]];
  
  NSArray *sUUIDs = [self getAdvertisementServiceUUIDs];
  if (sUUIDs.count) {
    [showStr appendString:@" , 服务UUID列表:["];
    for (int it=0; it<sUUIDs.count;it++) {
      CBUUID *cuid = sUUIDs[it];
      [showStr appendFormat:@"%@,",[cuid UUIDString]];
    }
    [showStr appendString:@"]"];
  }
  
  NSDictionary *services = [self getAdvertisementServices];
  if (services.count) {
    [showStr appendString:@" , 服务列表:{"];
    for (int it=0; it<services.allKeys.count;it++) {
      CBUUID *cuid = services.allKeys[it];
      NSData *cData = services[cuid];
      NSString *desc=@"nil";
      if (cData) {
        desc = [[NSString alloc] initWithData:cData encoding:NSUTF8StringEncoding];
        NSLog(@"===== service value:%@ ,str:%@ ======",cData,desc);
      }
      [showStr appendFormat:@"%@:%@,",[cuid UUIDString],desc];
    }
    [showStr appendString:@"}"];
  }
  
  NSString *smft = [self getAdvertisementManufacturerData];
  if (smft) {
    [showStr appendFormat:@" , 制造商:%@ ",smft];
  }
  
  return showStr;
}

-(BOOL)getAdvertisementConnectable
{
  return ((NSNumber *)self.advertisementData[@"kCBAdvDataIsConnectable"]).boolValue;
}

-(NSString *)getAdvertisementManufacturerData
{
  NSData *data = self.advertisementData[@"kCBAdvDataManufacturerData"];
  if (data) {
    const char *valueString = [[data description] cStringUsingEncoding: NSUTF8StringEncoding];
    return [NSString stringWithCString:valueString encoding:NSUTF8StringEncoding];
//    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
  }
  return nil;
}
// key:CBUUID,value:NSData
-(NSDictionary *)getAdvertisementServices
{
  return self.advertisementData[@"kCBAdvDataServiceData"];
}
// CBUUID list
-(NSArray *)getAdvertisementServiceUUIDs
{
  return self.advertisementData[@"kCBAdvDataServiceUUIDs"];
}


@end
