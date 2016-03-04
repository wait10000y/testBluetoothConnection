//
//  BaseObject.h
//  MySpace
//
//  Created by wsliang on 15/10/21.
//  Copyright © 2015年 wsliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseDefine.h"

@interface BaseObject : NSObject

@property (nonatomic) id baseCacheData;
@property (weak, nonatomic) id baseCacheDataWeak;


@end
