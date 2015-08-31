//
//  VerticallyAlignedLabel.h
//  LunaNote_iPhone
//
//  Created by Mobile-innovation, LLC. on 2014/07/01.
//  Copyright (c) 2013年 SmartTecno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef enum VerticalAlignment
{
    VerticalAlignmentTop,
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
} VerticalAlignment;

@interface VerticallyAlignedLabel : UILabel
{
    @private VerticalAlignment verticalAlignment_;
}

@property (nonatomic, assign) VerticalAlignment verticalAlignment;

@end