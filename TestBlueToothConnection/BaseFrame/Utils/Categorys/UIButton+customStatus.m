//
//  UIButton+customStatus.m
//  xor-media
//
//  Created by wsliang on 15/11/18.
//  Copyright © 2015年 xor-media. All rights reserved.
//

#import "UIButton+customStatus.h"

@implementation UIButton (customStatus)

+(UIButton*)customWithFrame:(CGRect)theFrame
{
  return [self customWithFrame:theFrame action:nil forTarget:nil];
}

+(UIButton*)customWithFrame:(CGRect)theFrame action:(SEL)action forTarget:(id)target
{
  UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
  btn.frame = theFrame;
  if (target && action) {
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
  }
  return btn;
}

-(NSString*)titleNormal
{
  return [self titleForState:UIControlStateNormal];
}

-(void)setTitleNormal:(NSString*)thetitle
{
  [self setTitle:thetitle forState:UIControlStateNormal];
}
-(void)setImageNormal:(UIImage*)theImage
{
  [self setImage:theImage forState:UIControlStateNormal];
}
-(void)setImageBgNormal:(UIImage*)theImage
{
  [self setBackgroundImage:theImage forState:UIControlStateNormal];
}
-(UIImage*)imageNormal
{
  return [self imageForState:UIControlStateNormal];
}
-(UIImage*)imageBgNormal
{
  return [self backgroundImageForState:UIControlStateNormal];
}

@end
