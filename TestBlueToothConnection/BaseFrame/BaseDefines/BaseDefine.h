//
//  BaseDefine.h
//  TestBlueToothConnection
//
//  Created by wsliang on 16/2/26.
//  Copyright © 2016年 xor-systems. All rights reserved.
//

#ifndef BaseDefine_h
#define BaseDefine_h



/*
 是否使用测试代码
 */
//#define loadDemoTestData 1








#ifdef DEBUG
#ifndef DLog
#   define DLog(fmt, ...) {NSLog((@"[%s %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);}
#endif
#ifndef ELog
#   define ELog(err) {if(err) DLog(@"Error: %@", err)}
#endif
#else
#ifndef DLog
#   define DLog(...)
#endif
#ifndef ELog
#   define ELog(err)
#endif
#endif

// 一直显示的日志
#ifndef ALog
#define ALog(fmt, ...) {NSLog((@"[%s %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);};
#endif


#define LocalString(t_name) NSLocalizedString(t_name, nil)



















#endif /* BaseDefine_h */
