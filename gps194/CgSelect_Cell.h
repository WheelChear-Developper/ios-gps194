//
//  CgSelect_Cell.h
//  gps194
//
//  Created by MacServer on 2015/08/28.
//  Copyright (c) 2015年 Mobile Innovation, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CgSelect_Cell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *img_select;
@property (weak, nonatomic) IBOutlet UIImageView *img_image;
@property (weak, nonatomic) IBOutlet UILabel *txt_comment;

@property (nonatomic) long lng_serviceId;
@property (nonatomic) long lng_sortId;
@property (nonatomic) long lng_deleteId;

@end