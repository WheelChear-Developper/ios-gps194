//
//  SqlManager.h
//  gps194
//
//  Created by MacServer on 2015/09/01.
//  Copyright (c) 2015年 Mobile Innovation, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "CgSelect_Model.h"

@interface SqlManager : NSObject

//初期設定
+ (void)InitialSql;

////////////////////////////////////　サービス登録データ関連　//////////////////////////////////////////

//サービスリストデータ取得処理
+ (NSMutableArray*)Get_List;

// サービスリストデータ更新保存処理
+ (void)Set_List:(long)service_id
         sortid:(long)sort_id
            img:(NSData*)image
        comment:(NSString*)comment
         delete:(long)delete_flg;

//サービスリスト一括削除処理
+ (void)AllDel_ServiceList_listid;


@end