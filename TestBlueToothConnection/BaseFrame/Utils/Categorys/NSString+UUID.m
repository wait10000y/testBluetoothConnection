//
//  NSString+UUID.m
//  IOS-Categories
//
//  Created by Jakey on 14/12/30.
//  Copyright (c) 2014年 xor-media. All rights reserved.
//

#import "NSString+UUID.h"

@implementation NSString (UUID)
+ (NSString *)UUID
{
  CFUUIDRef   uuid_ref        = CFUUIDCreate(NULL);
  CFStringRef uuid_string_ref = CFUUIDCreateString(NULL, uuid_ref);
  CFRelease(uuid_ref);
  NSString *uuid = [NSString stringWithString:(__bridge NSString*)uuid_string_ref];
  CFRelease(uuid_string_ref);
  return [uuid stringByReplacingOccurrencesOfString:@"-" withString:@""];
}

+(NSString*)randomString:(int)size
{
  if (size <=0) {
    return @"";
  }
  
  char data[size];
  for (int x=0;x<size;data[x++] = (char)('A' + (arc4random_uniform(26))));
  return [[NSString alloc] initWithBytes:data length:size encoding:NSUTF8StringEncoding];
}

// TODO: 未完成
+(NSString*)randomChsString:(int)size
{
  int dist = 0x9fff - 0x4e00-1;
  char data[size];
  for (int x=0;x<size;data[x++] = (char)(0x4e00 + (arc4random_uniform(dist))+1));
  return [[NSString alloc] initWithBytes:data length:size encoding:NSUTF8StringEncoding];

}

-(BOOL)IsChinese:(NSString *)str
{
  for(int i=0; i< [str length];i++){
    int a = [str characterAtIndex:i];
    if( a > 0x4e00 && a < 0x9fff){
      return YES;
    }
  }
  return NO;
}

@end
