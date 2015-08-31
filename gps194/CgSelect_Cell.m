//
//  CgSelect_Cell.m
//  gps194
//
//  Created by MacServer on 2015/08/28.
//  Copyright (c) 2015年 Mobile Innovation, LLC. All rights reserved.
//

#import "CgSelect_Cell.h"
#import "UILabel+EstimatedHeight.h"

@implementation CgSelect_Cell
{
    VerticallyAlignedLabel *Comment;
    AsyncImageView *ai;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    int int_PosisonHeight = 0;
    
    // ラベルの高さ取得
    CGFloat flt_height = [UILabel xx_estimatedHeight:[UIFont systemFontOfSize:13]
                                                text:self.str_comment size:CGSizeMake(255, MAXFLOAT)];
    flt_height += 15 * 2;
    
    // コメント（１９文字X６行）
    if(self.str_comment.length >0){
        [Comment removeFromSuperview];
        Comment = [[VerticallyAlignedLabel alloc] init];
        Comment.frame = CGRectMake(35, 55  , 255, flt_height);
        Comment.verticalAlignment = VerticalAlignmentTop;
        Comment.numberOfLines = 50;
        [Comment setFont:[UIFont systemFontOfSize:13]];
        Comment.textColor = [UIColor darkGrayColor];
        Comment.text = self.str_comment;
        [self addSubview:Comment];
    }
    int_PosisonHeight = 55 + flt_height;
    
    //画像の非同期セット
    [ai removeFromSuperview];
    if([_str_imageurl isEqual:@"<null>"]){
    }else if([_str_imageurl isEqual:[NSNull null]]){
    }else{
        ai = [[AsyncImageView alloc] initWithFrame:CGRectMake(30, int_PosisonHeight, 260, 200)];
        [ai loadImage:_str_imageurl];
        [self addSubview:ai];
        
        int_PosisonHeight += 200;
    }
    
    // コメント取得
    self.lbl_comment.text = @"コメント";
    NSString *URL = [NSString stringWithFormat:@"%@%@%ld%@",NSLocalizedString(@"Service_DomainURL",@""), NSLocalizedString(@"Service_CommentGet1URL",@""), self.lng_newsId, NSLocalizedString(@"Service_CommentGet2URL",@"")];
    
    NSURL *URL_STRING = [NSURL URLWithString:URL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL_STRING];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

@end


