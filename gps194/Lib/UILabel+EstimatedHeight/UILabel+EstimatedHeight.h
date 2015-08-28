//
//  UILabel+EstimatedHeight.h
//  inui
//
//  Created by Mobile-innovation, LLC. on 2014/07/01.
//  Copyright (c) 2014年 akafune, inc. All rights reserved.
//

@interface UILabel (EstimatedHeight)

+ (CGFloat)xx_estimatedHeight:(UIFont *)font text:(NSString *)text size:(CGSize)size;

@end