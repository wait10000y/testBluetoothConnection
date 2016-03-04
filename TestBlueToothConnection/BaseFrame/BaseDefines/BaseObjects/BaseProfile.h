//
//  PSProfile.h
//  PaaS
//
//  Created by shiliang.wang on 14-1-17.
//  Copyright (c) 2014年 All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseObject.h"

@interface BaseProfile : BaseObject
@property (nonatomic,readonly) NSUserDefaults *uData;

@property (nonatomic) NSString *old_version; // 检查更新使用

//@property (nonatomic) NSString *aqua_host;
//@property (nonatomic) NSString *aqua_path;


+(BaseProfile*)shareObject;

/**
 修改属性值的时候需要调用下面的方法
 */
-(void)setStringValue:(NSString *)theVaule forKey:(NSString*)theKey;
-(void)setIntegerValue:(NSInteger)theVaule forKey:(NSString *)theKey;
-(void)setBoolValue:(BOOL)theVaule forKey:(NSString *)theKey;
  // get stringValue
-(NSString *)stringValueForKey:(NSString *)theKey;
-(BOOL)boolValueForKey:(NSString*)theKey;
-(NSInteger)integerValueForKey:(NSString*)theKey;

/*----- base -------*/

-(void)synchronizeData;

-(void)setObject:(id)theObj forKey:(NSString*)theKey;

-(void)registerDefaults:(NSDictionary*)theVKs;

-(id)objectValueForKey:(NSString*)theKey;


@end
