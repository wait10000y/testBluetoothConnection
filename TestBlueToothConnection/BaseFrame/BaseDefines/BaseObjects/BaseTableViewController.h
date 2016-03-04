//
//  BaseTableViewController.h
//  SiChuanOTT
//
//  Created by wsliang on 15/11/25.
//  Copyright © 2015年 xor-media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseDefine.h"

@protocol BaseTableViewControllerDelegate;
@interface BaseTableViewController : UITableViewController

@property (nonatomic) id baseCacheData;
@property (weak, nonatomic) id baseCacheDataWeak;
@property (weak, nonatomic) id<BaseTableViewControllerDelegate> baseDelegate;
@property (nonatomic) NSString *tableViewCellId;

-(void)showNoContentTips:(BOOL)isShow;

-(IBAction)actionBackLastView:(id)sender;
-(IBAction)actionOperations:(id)sender;

@end

@protocol BaseTableViewControllerDelegate <NSObject>

@optional
-(void)baseViewControllerDelegateCall:(id)sender data:(id)theData;

@end
