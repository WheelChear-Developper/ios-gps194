//
//  ViewController.m
//  gps194
//
//  Created by MacServer on 2015/08/27.
//  Copyright (c) 2015年 Mobile Innovation, LLC. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    // リスト用データ格納用
    NSMutableArray *_TotalDataBox;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/////////////// ↓　テーブル用メソッド　↓ ////////////////////
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_TotalDataBox count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // セルごとの大きさ調整
    if(_TotalDataBox.count > 0){
        NSUInteger row = (NSUInteger)indexPath.row;
        NewsView_ListDataModel *listDataModel = _TotalDataBox[row];
        
        // ラベルの高さ取得
        CGFloat flt_height = [UILabel xx_estimatedHeight:[UIFont systemFontOfSize:13]
                                                    text:listDataModel.service_body size:CGSizeMake(255, MAXFLOAT)];
        flt_height += 15 * 2;
        
        // 行数によるポジションセット
        CGFloat photo_potision = [listDataModel.service_body lengthOfBytesUsingEncoding:NSShiftJISStringEncoding]/19;
        if(photo_potision > 6){
            photo_potision = 6;
        }
        
        if([listDataModel.service_imageUrl isEqual:@"<null>"]){
            return 55 + flt_height + 15 + 33;
        }else if([listDataModel.service_imageUrl isEqual:[NSNull null]]){
            return 55 + flt_height + 15 + 33;
        }else{
            return 55 + flt_height + 200 + 15 + 33 + 5;
        }
    }
    return 0;
}

// １行ごとのセル生成（表示時）
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Instantiate or reuse cell
    News_Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"News_Cell"];
    
    // セル枠線削除
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // 背景色
    cell.backgroundColor = [SetColor setBackGroundColor];
    // Set contents
    NSUInteger row = (NSUInteger)indexPath.row;
    NewsView_ListDataModel *listDataModel = _TotalDataBox[row];
    cell.int_commentCount = listDataModel.service_id;
    cell.lbl_hyoudai.text = listDataModel.service_title;
    cell.lbl_date.text = listDataModel.service_retime;
    cell.str_comment = listDataModel.service_body;
    cell.str_imageurl = listDataModel.service_imageUrl;
    cell.lbl_comment.text = @"";
    
    return cell;
}

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

//セルの選択時イベントメソッド
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsView_ListDataModel *listDataModel = _TotalDataBox[indexPath.row];
    // 選択リスト設定
    [Configuration setListID:listDataModel.service_id];
    // 画面遷移
    UIViewController *initialViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"comments"];
    [self.navigationController pushViewController:initialViewController animated:YES];
}

// テーブルのスクロール時のイベントメソッド
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // テーブルビュー用
    if(Table_View){
        CGFloat table_positionY = [Table_View contentOffset].y;
        if(table_positionY < -100){
            bln_TableReLoad = YES;
        }else if(table_positionY == 0){
            if(bln_TableReLoad == YES){
                // リストデータの読み込み
                [SVProgressHUD showWithStatus:NSLocalizedString(@"Progress_ReReading",@"")];
                [self readWebData];
                
                bln_TableReLoad = NO;
            }
        }
    }
}
/////////////// ↑　テーブル用メソッド　↑ ////////////////////

@end
