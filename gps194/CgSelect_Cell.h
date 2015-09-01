//
//  CgSelect_Cell.h
//  gps194
//
//  Created by MacServer on 2015/08/28.
//  Copyright (c) 2015年 Mobile Innovation, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VerticallyAlignedLabel.h"
#import "AsyncImageView.h"

@interface CgSelect_Cell : UITableViewCell
{
    __weak IBOutlet UIButton *btn_select;
    __weak IBOutlet UIImageView *img_image;
    __weak IBOutlet UILabel *txt_comment;
    
}

@property (nonatomic) long lng_serviceId;
@property (weak, nonatomic) NSString *str_comment;
@property (nonatomic) long lng_sortId;
@property (nonatomic,retain)NSMutableData *img_Photo;
@property (nonatomic) long lng_deleteId;

- (IBAction)btn_select:(id)sender;

@end