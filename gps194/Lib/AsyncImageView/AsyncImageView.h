//
//  AsyncImageView.h
//  inui
//
//  Created by Mobile-innovation, LLC. on 2014/07/01.
//  Copyright (c) 2014年 akafune, inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AsyncImageView : UIImageView {
@private
    NSURLConnection *conn;
    NSMutableData *data;
}
-(void)loadImage:(NSString *)url;
-(void)abort;
@end