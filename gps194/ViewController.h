//
//  ViewController.h
//  gps194
//
//  Created by MacServer on 2015/08/27.
//  Copyright (c) 2015年 Mobile Innovation, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking/AFNetworking.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "VerticallyAlignedLabel.h"
#import "SqlManager.h"

@interface ViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    
    __weak IBOutlet UIImageView *img_photoBack;
    __weak IBOutlet UIImageView *img_deleteBack;
    
    __weak IBOutlet UITableView *Table_View;
    
    __weak IBOutlet UIView *view_idokeido;
    __weak IBOutlet UIView *view_comment;
    __weak IBOutlet UIView *view_commentButton;
    
    __weak IBOutlet UITextView *txt_idokeido;
    __weak IBOutlet UITextView *txt_comment;
    __weak IBOutlet UILabel *lbl_comment;
    
    
}

- (IBAction)btn_camera:(id)sender;
- (IBAction)btn_delete:(id)sender;

- (IBAction)btn_googlemap:(id)sender;

- (IBAction)btn_comment:(id)sender;
- (IBAction)btn_photoplus:(id)sender;

- (IBAction)brn_cellsort:(id)sender;

@end

