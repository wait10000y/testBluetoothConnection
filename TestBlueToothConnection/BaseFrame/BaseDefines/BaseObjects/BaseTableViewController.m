//
//  BaseTableViewController.m
//  SiChuanOTT
//
//  Created by wsliang on 15/11/25.
//  Copyright © 2015年 xor-media. All rights reserved.
//

#import "BaseTableViewController.h"

@interface BaseTipsLabel : UILabel

@end

@implementation BaseTipsLabel

@end

@implementation BaseTableViewController
{
  BaseTipsLabel *mNoContentTips;
}

-(void)viewDidLoad
{
  [super viewDidLoad];
  
  self.tableViewCellId = @"tableViewCellId";
  self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
  UIBarButtonItem *backBar = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
  self.navigationItem.backBarButtonItem = backBar;
}


-(void)showNoContentTips:(BOOL)isShow
{
  if (isShow) {
    if (!mNoContentTips) {
      mNoContentTips = [[BaseTipsLabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 40)];
      mNoContentTips.textAlignment = NSTextAlignmentCenter;
      mNoContentTips.textColor = [UIColor grayColor];
      mNoContentTips.font = [UIFont systemFontOfSize:16];
      mNoContentTips.text = @"暂无数据";
    }
    UIView *headerView = self.tableView.tableHeaderView;
    if(headerView && ![headerView isKindOfClass:[BaseTipsLabel class]]){
      [headerView addSubview:mNoContentTips];
    }else{
      self.tableView.tableHeaderView = mNoContentTips;
    }
  }else{
    UIView *headerView = self.tableView.tableHeaderView;
    if(headerView && ![headerView isKindOfClass:[BaseTipsLabel class]]){
      [mNoContentTips removeFromSuperview];
    }else{
      self.tableView.tableHeaderView = nil;
    }
  }
}

// default implement

-(IBAction)actionBackLastView:(id)sender
{
  if (self.navigationController) {
    [self.navigationController popViewControllerAnimated:YES];
  }else{
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"--- actionBackLastView method empty ---");
  }
}

-(IBAction)actionOperations:(id)sender
{
  NSLog(@"--- actionOperations method empty ---");
}


@end
