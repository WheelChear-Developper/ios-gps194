//
//  First-ViewController.m
//  gps194
//
//  Created by MacServer on 2015/09/11.
//  Copyright (c) 2015年 Mobile Innovation, LLC. All rights reserved.
//

#import "First-ViewController.h"

@interface First_ViewController ()

@end

@implementation First_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)Nextscreen:(id)sender {
    
    //初期起動の場合
    UIViewController* viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"main-ViewController"];
    [self presentViewController:viewController animated:NO completion:nil];
}
@end
