//
//  NSString+UUID.h
//  IOS-Categories
//
//  Created by Jakey on 14/12/30.
//  Copyright (c) 2014年 xor-media. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (UUID)
+ (NSString *)UUID;
+(NSString*)randomString:(int)size;
//+(NSString*)randomChsString:(int)size;

@end
