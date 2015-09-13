//
//  Denger-ViewController.m
//  gps194
//
//  Created by MacServer on 2015/09/13.
//  Copyright (c) 2015年 Mobile Innovation, LLC. All rights reserved.
//

#import "Denger-ViewController.h"

@interface Denger_ViewController ()

@end

@implementation Denger_ViewController

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

- (IBAction)btn_ok:(id)sender {
    
    [self dismissViewControllerAnimated:NO completion:nil];
}
@end
