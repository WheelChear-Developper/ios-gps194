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

@property (weak, nonatomic) IBOutlet UILabel *lbl_hyoudai;
@property (weak, nonatomic) IBOutlet UILabel *lbl_date;
@property (weak, nonatomic) IBOutlet UILabel *lbl_comment;
@property (weak, nonatomic) NSString *str_comment;
@property (weak, nonatomic) NSString *str_imageurl;
@property (nonatomic) long lng_newsId;

@property (nonatomic,retain)NSMutableData *mData;
@end