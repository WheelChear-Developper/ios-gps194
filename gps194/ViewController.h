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
#import "DeleteSelect_Model.h"

@interface ViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    
    __weak IBOutlet UIImageView *img_photoBack;
    __weak IBOutlet UIImageView *img_deleteBack;
    
    __weak IBOutlet UITableView *Table_SelectView;
    __weak IBOutlet UITableView *Table_DeleteView;
    
    __weak IBOutlet UIView *view_idokeido;
    __weak IBOutlet UIView *view_comment;
    __weak IBOutlet UIView *view_commentButton;
    
    __weak IBOutlet UITextView *txt_idokeido;
    __weak IBOutlet UITextView *txt_comment;
    __weak IBOutlet UILabel *lbl_comment;
    
    __weak IBOutlet UIButton *btn_cellsort;
    __weak IBOutlet UIButton *btn_photoplus;
    __weak IBOutlet UIButton *btn_shaer;
    
    __weak IBOutlet UIView *view_dell;
}

- (IBAction)btn_camera:(id)sender;
- (IBAction)btn_delete:(id)sender;

- (IBAction)btn_googlemap:(id)sender;

- (IBAction)btn_comment:(id)sender;
- (IBAction)btn_photoplus:(id)sender;

- (IBAction)brn_cellsort:(id)sender;

- (IBAction)btn_cellAllSelect:(id)sender;
- (IBAction)btn_cellDell:(id)sender;

- (IBAction)btn_shaer:(id)sender;

@end

