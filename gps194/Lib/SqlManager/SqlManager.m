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
    NSString* tbl1_sql2 = @" service_id  INTEGER UNIQUE PRIMARY KEY,";
    NSString* tbl1_sql3 = @" sort_id     INTEGER,";
    NSString* tbl1_sql4 = @" image       BLOB,";
    NSString* tbl1_sql5 = @" mini_image  BLOB,";
    NSString* tbl1_sql6 = @" Latitude    TEXT,";
    NSString* tbl1_sql7 = @" Longitude   TEXT,";
    NSString* tbl1_sql8 = @" comment     TEXT,";
    NSString* tbl1_sql9 = @" delete_flg  INTEGER);";
    NSString* tbl1_MakeSQL = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@", tbl1_sql1, tbl1_sql2, tbl1_sql3, tbl1_sql4, tbl1_sql5, tbl1_sql6, tbl1_sql7, tbl1_sql8, tbl1_sql9];
    if (![DbAccess executeUpdate:tbl1_MakeSQL]) {
        NSLog(@"ERROR: %d: %@", [DbAccess lastErrorCode], [DbAccess lastErrorMessage]);
    }
    
    //データベースクローズ
    [DbAccess close];
    
}

// リストデータ取得処理
+ (NSMutableArray*)Get_List
{
    //データベース接続
    FMDatabase* DbAccess = [self _getDB:DBFILE];
    
    //管理データ取得
    NSString* Sql1 = @"SELECT";
    NSString* Sql2 = @" service_id,";
    NSString* Sql3 = @" sort_id,";
    NSString* Sql4 = @" mini_image,";
    NSString* Sql5 = @" Latitude,";
    NSString* Sql6 = @" Longitude,";
    NSString* Sql7 = @" comment,";
    NSString* Sql8 = @" delete_flg";
    NSString* Sql9 = @" FROM tbl_photo_record";
    NSString* Sql10 = @" WHERE delete_flg = 0";
    NSString* Sql11 = @" ORDER BY sort_id DESC;";
    NSString* MakeSQL = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@",Sql1,Sql2,Sql3,Sql4,Sql5,Sql6,Sql7,Sql8,Sql9,Sql10,Sql11];
    FMResultSet* results = [DbAccess executeQuery:MakeSQL];
    if (!results) {
        NSLog(@"ERROR: %d: %@", [DbAccess lastErrorCode], [DbAccess lastErrorMessage]);
    }
    
    //データ格納
    NSMutableArray *dbBox = [NSMutableArray array];
    while( [results next] )
    {
        CgSelect_Model *listDataModel = [[CgSelect_Model alloc] init];
        listDataModel.service_id = [results longForColumn:@"service_id"];
        listDataModel.sort_id = [results longForColumn:@"sort_id"];
        listDataModel.comment = [results stringForColumn:@"comment"];
        listDataModel.delete_flg = [results longForColumn:@"delete_flg"];
        listDataModel.mini_image = [[NSData alloc] initWithBase64EncodedString:[results stringForColumn:@"mini_image"] options:NSDataBase64DecodingIgnoreUnknownCharacters];
        listDataModel.Latitude = [results stringForColumn:@"Latitude"];
        listDataModel.Longitude = [results stringForColumn:@"Longitude"];
        
        NSLog(@"service_id %lu",listDataModel.service_id);
        NSLog(@"sort_id %lu",listDataModel.sort_id);
        
        [dbBox addObject:listDataModel];
    }
    
    //データベースクローズ
    [DbAccess close];
    
    return dbBox;
}

// イメージデータ取得処理
+ (NSMutableArray*)Get_image:(long)service_id
{
    //データベース接続
    FMDatabase* DbAccess = [self _getDB:DBFILE];
    
    //管理データ取得
    NSString* Sql1 = @"SELECT";
    NSString* Sql2 = @" image";
    NSString* Sql3 = @" FROM tbl_photo_record";
    NSString* Sql4 = [NSString stringWithFormat:@" WHERE service_id = %lu;", service_id];
    NSString* MakeSQL = [NSString stringWithFormat:@"%@%@%@%@",Sql1,Sql2,Sql3,Sql4];
    FMResultSet* results = [DbAccess executeQuery:MakeSQL];
    if (!results) {
        NSLog(@"ERROR: %d: %@", [DbAccess lastErrorCode], [DbAccess lastErrorMessage]);
    }
    
    //データ格納
    NSMutableArray *dbBox = [NSMutableArray array];
    while( [results next] )
    {
        CgSelect_image_Model *listDataModel = [[CgSelect_image_Model alloc] init];
        listDataModel.image = [[NSData alloc] initWithBase64EncodedString:[results stringForColumn:@"image"] options:NSDataBase64DecodingIgnoreUnknownCharacters];
        
        [dbBox addObject:listDataModel];
    }
    
    //データベースクローズ
    [DbAccess close];
    
    return dbBox;
}

// リストデータ更新処理
+ (void)Set_List:(long)sort_id
             img:(NSData*)image
        mini_img:(NSData*)mini_image
        Latitude:(NSString*)Latitude
       Longitude:(NSString*)Longitude
         comment:(NSString*)comment
          delete:(long)delete_flg
{
    //データベース接続
    FMDatabase* DbAccess = [self _getDB:DBFILE];
    
    NSString *imgString = [image base64EncodedStringWithOptions:NSDataBase64Encoding76CharacterLineLength];
    NSString *mini_imgString = [mini_image base64EncodedStringWithOptions:NSDataBase64Encoding76CharacterLineLength];
    
    //データ保存
    NSString* sql1 = @"INSERT INTO tbl_photo_record";
    NSString* sql2 = @" (sort_id, image, mini_image, Latitude, Longitude, comment, delete_flg) VALUES ";
    NSString* sql3 = [NSString stringWithFormat:@"(%lu, '%@', '%@', '%@', '%@', '%@', %lu);",
                      sort_id,
                      imgString,
                      mini_imgString,
                      Latitude,
                      Longitude,
                      comment,
                      delete_flg];
    NSString* MakeSQL = [NSString stringWithFormat:@"%@%@%@",sql1, sql2, sql3];
    if (![DbAccess executeUpdate:MakeSQL]) {
        NSLog(@"ERROR: %d: %@", [DbAccess lastErrorCode], [DbAccess lastErrorMessage]);
    }
    
    //データベースクローズ
    [DbAccess close];
}

// 順位更新処理
+ (void)Update_List:(long)service_id
             sortid:(long)sort_id
{
    //データベース接続
    FMDatabase* DbAccess = [self _getDB:DBFILE];
    
    //データ保存
    NSString* sql1 = @"UPDATE tbl_photo_record SET";
    NSString* sql2 = [NSString stringWithFormat:@" sort_id = %lu WHERE service_id = %lu;", sort_id, service_id];
    NSString* MakeSQL = [NSString stringWithFormat:@"%@%@",sql1, sql2];
    if (![DbAccess executeUpdate:MakeSQL]) {
        NSLog(@"ERROR: %d: %@", [DbAccess lastErrorCode], [DbAccess lastErrorMessage]);
    }
    
    //データベースクローズ
    [DbAccess close];
}

// コメント更新処理
+ (void)Update_comment:(long)service_id
               comment:(NSString*)comment
{
    //データベース接続
    FMDatabase* DbAccess = [self _getDB:DBFILE];
    
    //データ保存
    NSString* sql1 = @"UPDATE tbl_photo_record SET";
    NSString* sql2 = [NSString stringWithFormat:@" comment = '%@' WHERE service_id = %lu;", comment, service_id];
    NSString* MakeSQL = [NSString stringWithFormat:@"%@%@",sql1, sql2];
    if (![DbAccess executeUpdate:MakeSQL]) {
        NSLog(@"ERROR: %d: %@", [DbAccess lastErrorCode], [DbAccess lastErrorMessage]);
    }
    
    //データベースクローズ
    [DbAccess close];
}

// コメント更新処理
+ (void)Delete_List:(long)service_id
{
    //データベース接続
    FMDatabase* DbAccess = [self _getDB:DBFILE];
    
    //データ保存
    NSString* sql1 = @"UPDATE tbl_photo_record SET";
    NSString* sql2 = [NSString stringWithFormat:@" delete_flg = 1 WHERE service_id = %lu;", service_id];
    NSString* MakeSQL = [NSString stringWithFormat:@"%@%@",sql1, sql2];
    if (![DbAccess executeUpdate:MakeSQL]) {
        NSLog(@"ERROR: %d: %@", [DbAccess lastErrorCode], [DbAccess lastErrorMessage]);
    }
    
    //データベースクローズ
    [DbAccess close];
}

@end