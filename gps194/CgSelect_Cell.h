//
//  CgSelect_Cell.h
//  gps194
//
//  Created by MacServer on 2015/08/28.
//  Copyright (c) 2015年 Mobile Innovation, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CgSelect_Cell : UITableViewCell
{
    __weak IBOutlet UILabel *txt_comment;
}

@property (weak, nonatomic) IBOutlet UIImageView *img_select;
@property (weak, nonatomic) IBOutlet UIImageView *img_image;

@property (nonatomic) long lng_serviceId;
@property (weak, nonatomic) NSString *str_comment;
@property (nonatomic) long lng_sortId;
@property (nonatomic) long lng_deleteId;

@end