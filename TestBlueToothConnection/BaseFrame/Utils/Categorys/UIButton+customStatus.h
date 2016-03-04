//
//  UIButton+customStatus.h
//  xor-media
//
//  Created by wsliang on 15/11/18.
//  Copyright © 2015年 xor-media. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (customStatus)

+(UIButton*)customWithFrame:(CGRect)theFrame;
+(UIButton*)customWithFrame:(CGRect)theFrame action:(SEL)action forTarget:(id)target;

-(NSString*)titleNormal;
-(void)setTitleNormal:(NSString*)thetitle;
-(void)setImageNormal:(UIImage*)theImage;
-(void)setImageBgNormal:(UIImage*)theImage;
-(UIImage*)imageNormal;
-(UIImage*)imageBgNormal;

@end
