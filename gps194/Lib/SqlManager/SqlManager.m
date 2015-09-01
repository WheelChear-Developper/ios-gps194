//
//  SqlManager.m
//  gps194
//
//  Created by MacServer on 2015/09/01.
//  Copyright (c) 2015年 Mobile Innovation, LLC. All rights reserved.
//

#import "SqlManager.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "CZDateFormatterCache.h"

#define DBFILE @"service.db"

@implementation SqlManager

// NSDATEから日付型文字列変換
+ (NSString*)get_DateToSting:(NSDate*)dt
{
    [CZDateFormatterCache mainQueueCache].currentLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"];
    NSString* setDt = [[CZDateFormatterCache mainQueueCache] localizedStringFromDate:dt dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterMediumStyle];
    setDt = [setDt stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
    return setDt;
}

// 日付型文字列からNSDATE変換
+(NSDate*)get_StringToDate:(NSString*)dt
{
    dt = [dt stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"]];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* setDt = [formatter dateFromString:dt];
    return setDt;
}

// データベースインスタンスを返す
+(FMDatabase*)_getDB:(NSString*)dbName
{
    NSArray*  pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* docdir = [pathArray objectAtIndex:0];
    NSString* dbpath = [docdir stringByAppendingPathComponent:dbName];
    FMDatabase* db = [FMDatabase databaseWithPath:dbpath];
    if (![db open]) {
        @throw [NSException exceptionWithName:@"DBOpenException" reason:@"couldn't open specified db file" userInfo:nil];
    }
    return db;
}

+ (void)InitialSql
{
    //データベース接続
    FMDatabase* DbAccess = [self _getDB:DBFILE];
    
    //ニューステーブル作成
    NSString* tbl1_sql1 = @"CREATE TABLE IF NOT EXISTS tbl_photo_record (";
    NSString* tbl1_sql2 = @" service_id  INTEGER,";
    NSString* tbl1_sql3 = @" sort_id     INTEGER,";
    NSString* tbl1_sql4 = @" image       TEXT,";
    NSString* tbl1_sql5 = @" comment     TEXT,";
    NSString* tbl1_sql6 = @" delete_flg  TEXT);";
    NSString* tbl1_MakeSQL = [NSString stringWithFormat:@"%@%@%@%@%@%@", tbl1_sql1, tbl1_sql2, tbl1_sql3, tbl1_sql4, tbl1_sql5, tbl1_sql6];
    if (![DbAccess executeUpdate:tbl1_MakeSQL]) {
        NSLog(@"ERROR: %d: %@", [DbAccess lastErrorCode], [DbAccess lastErrorMessage]);
    }
    
    //データベースクローズ
    [DbAccess close];
    
}

// サービスリストデータ取得処理
+ (NSMutableArray*)Get_ServiceList
{
    //データベース接続
    FMDatabase* DbAccess = [self _getDB:DBFILE];
    
    //管理データ取得
    NSString* Sql1 = @"SELECT";
    NSString* Sql2 = @" service_id,";
    NSString* Sql3 = @" sort_id,";
    NSString* Sql4 = @" image,";
    NSString* Sql5 = @" comment,";
    NSString* Sql6 = @" delete_flg";
    NSString* Sql7 = @" FROM tbl_photo_record";
    NSString* Sql8 = @" ORDER BY sort_id ASC;";
    NSString* MakeSQL = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",Sql1,Sql2,Sql3,Sql4,Sql5,Sql6,Sql7,Sql8];
    FMResultSet* results = [DbAccess executeQuery:MakeSQL];
    if (!results) {
        NSLog(@"ERROR: %d: %@", [DbAccess lastErrorCode], [DbAccess lastErrorMessage]);
    }
    
    //データ格納
    NSMutableArray *dbBox = [NSMutableArray array];
    while( [results next] )
    {
        CgSelect_Model *listDataModel = [[CgSelect_Model alloc] init];
        listDataModel.service_id = [results longForColumn:@"list_id"];
        listDataModel.sort_id = [results longForColumn:@"list_time"];
        listDataModel.image = [results stringForColumn:@"list_retime"];
        listDataModel.comment = [results stringForColumn:@"list_title"];
        listDataModel.delete_flg = [results stringForColumn:@"list_imageUrl"];
        [dbBox addObject:listDataModel];
    }
    
    //データベースクローズ
    [DbAccess close];
    
    return dbBox;
}

// サービスリストデータ更新保存処理
+ (void)Set_ServiceList_Insert_listid:(long)list_id
                             listtime:(long)list_time
                           listretime:(NSString*)list_retime
                                title:(NSString*)list_title
                             imageUrl:(NSString*)list_imageUrl
                                 body:(NSString*)list_body
{
    //データベース接続
    FMDatabase* DbAccess = [self _getDB:DBFILE];
    
    //データ保存
    NSString* sql1 = @"INSERT INTO tbl_list_record";
    NSString* sql2 = @" (list_id, list_time, list_retime, list_title, list_imageUrl, list_body) VALUES ";
    NSString* sql3 = [NSString stringWithFormat:@"(%lu, %lu, '%@', '%@', '%@', '%@');",
                      list_id,
                      list_time,
                      list_retime,
                      list_title,
                      list_imageUrl,
                      list_body];
    NSString* MakeSQL = [NSString stringWithFormat:@"%@%@%@",sql1, sql2, sql3];
    if (![DbAccess executeUpdate:MakeSQL]) {
        NSLog(@"ERROR: %d: %@", [DbAccess lastErrorCode], [DbAccess lastErrorMessage]);
    }
    
    //データベースクローズ
    [DbAccess close];
}

// サービスリスト一括削除処理
+ (void)AllDel_ServiceList_listid
{
    //データベース接続
    FMDatabase* DbAccess = [self _getDB:DBFILE];
    
    //データ保存前データ削除
    NSString* MakeSQL = [NSString stringWithFormat:@"DELETE FROM tbl_list_record"];
    [DbAccess executeUpdate:MakeSQL];
    
    //データベースクローズ
    [DbAccess close];
}



@end