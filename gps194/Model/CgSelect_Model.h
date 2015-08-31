//
//  CgSelect_Model.h
//  gps194
//
//  Created by MacServer on 2015/08/28.
//  Copyright (c) 2015年 Mobile Innovation, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CgSelect_Model : NSObject

@property(nonatomic) long service_id;
@property(nonatomic) long service_time;
@property(nonatomic, copy) NSString *service_retime;
@property(nonatomic, copy) NSString *service_imageUrl;
@property(nonatomic, copy) UIImage *service_image;
@property(nonatomic, copy) NSString *service_title;
@property(nonatomic, copy) NSString *service_body;
@end
