//
//  BaseViewController.m
//  MySpace
//
//  Created by wsliang on 15/9/18.
//  Copyright (c) 2015年 wsliang. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


// default implement

-(IBAction)actionBackLastView:(UIButton*)sender
{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
      [self dismissViewControllerAnimated:YES completion:nil];
        NSLog(@"--- actionBackLastView method empty ---");
    }
}

-(IBAction)actionOperations:(UIButton*)sender
{
  NSLog(@"--- actionOperations method empty ---");
}

@end
