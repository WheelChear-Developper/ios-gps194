//
//  ViewController.m
//  gps194
//
//  Created by MacServer on 2015/08/27.
//  Copyright (c) 2015年 Mobile Innovation, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ImageIO/ImageIO.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "ViewController.h"
#import "CgSelect_Cell.h"
#import "CgSelect_Model.h"

@interface ViewController ()
{
    // リスト用データ格納用
    NSMutableArray *_TotalSelectDataBox;
    
    // 選択行
    long lng_selectRow;
    
    NSString* str_Latitude;
    NSString* str_Longitude;
    
    //ソートの状態
    BOOL bln_cellsort;
    
    //ボタン設定(0:Photo画面 1:Delte画面)
    long bln_tableButtonSetting;
    
    //削除設定
    NSMutableArray *DeleteSelectlist;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //ボタンバック
    img_photoBack.hidden = NO;
    img_deleteBack.hidden = YES;
    bln_tableButtonSetting = 0;
    
    //表示テーブル設定
    Table_SelectView.hidden = NO;
    Table_DeleteView.hidden = YES;
    
    //ソート初期フラグ設定
    bln_cellsort = false;
    
    //コメントヒント表示
    lbl_comment.hidden = NO;
    
    //情報ボックス非表示
    view_idokeido.hidden = YES;
    view_comment.hidden = YES;
    view_commentButton.hidden = YES;
    view_dell.hidden = YES;
    
    //カスタムセル設定
    UINib *select_nib = [UINib nibWithNibName:@"CgSelect_Cell" bundle:nil];
    CgSelect_Cell *select_cell = [[select_nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    Table_SelectView.rowHeight = select_cell.frame.size.height;
    // Register CustomCell
    [Table_SelectView registerNib:select_nib forCellReuseIdentifier:@"CgSelect_Cell"];
    
    //カスタムセル設定
    UINib *delete_nib = [UINib nibWithNibName:@"CgSelect_Cell" bundle:nil];
    CgSelect_Cell *delete_cell = [[delete_nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    Table_DeleteView.rowHeight = delete_cell.frame.size.height;
    // Register CustomCell
    [Table_DeleteView registerNib:delete_nib forCellReuseIdentifier:@"CgSelect_Cell"];
}

#pragma mark 起動・再開の時に起動するメソッド
- (void)viewWillAppear:(BOOL)animated
{
    // リストデータの読み込み
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Progress_Reading",@"")];
    [self readSelectData];
    
    [super viewWillAppear:animated];
    
    //初期行設定
    lng_selectRow = -1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/////////////// ↓　入力系用メソッド　↓ ////////////////////
-(BOOL)textViewShouldBeginEditing:(UITextView*)textView
{
    // ホント表示を消す
    lbl_comment.hidden = YES;
    return YES;
}

-(BOOL)textViewShouldEndEditing:(UITextView*)textView
{
    if(txt_comment.text.length == 0){
        // ヒント表示表示
        lbl_comment.hidden = NO;
    }
    // キーボード隠す
    [textView resignFirstResponder];
    return YES;
}

#pragma mark Doneでキーボードを閉じる
- (BOOL) textView: (UITextView*) textView shouldChangeTextInRange: (NSRange) range replacementText: (NSString*) text {
    if ([text isEqualToString:@"\n"]) {
        
        CgSelect_Model *listDataModel = _TotalSelectDataBox[lng_selectRow];
        [SqlManager Update_comment:listDataModel.service_id comment:txt_comment.text];
        
        [textView resignFirstResponder];
        
        [self readSelectData];
        
        return NO;
    }
    return YES;
}
/////////////// ↑　入力系用メソッド　↑ ////////////////////

#pragma mark SQLからリストデータ取得
- (void)readSelectData
{
    // リストデータの初期化
    _TotalSelectDataBox = [[NSMutableArray alloc] init];
    
    //アプリ内のデータ取得
    NSMutableArray *RecordDataBox = [SqlManager Get_List];

    //アプリ内データのセット
    _TotalSelectDataBox = RecordDataBox;
    
    //テーブルデータの再構築
    [Table_SelectView reloadData];
    
    //表示テーブル設定
    Table_SelectView.hidden = NO;
    Table_DeleteView.hidden = YES;
    
    // 読み込み中の表示削除
    [SVProgressHUD dismiss];
}

/////////////// ↓　テーブル用メソッド　↓ ////////////////////
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_TotalSelectDataBox count];
}

#pragma mark １行ごとのセル生成（表示時）
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"CgSelect_Cell";
    CgSelect_Cell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(tableView == Table_SelectView){
        // セルが作成されていないか?
        if (!cell) { // yes
            // セルを作成
            cell = [[CgSelect_Cell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        // Set contents
        NSUInteger row = (NSUInteger)indexPath.row;
        CgSelect_Model *listDataModel = _TotalSelectDataBox[row];
        
        if(row == lng_selectRow){
            cell.img_select.image = [UIImage imageNamed:@"select-yes.png"];
        }else{
            cell.img_select.image = [UIImage imageNamed:@"select-no.png"];
        }
        
        cell.txt_comment.text = listDataModel.comment;
        cell.img_image.image = [[UIImage alloc] initWithData:listDataModel.image];
    }
    
    if(tableView == Table_DeleteView){
        // セルが作成されていないか?
        if (!cell) { // yes
            // セルを作成
            cell = [[CgSelect_Cell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        // Set contents
        NSUInteger row = (NSUInteger)indexPath.row;
        CgSelect_Model *listDataModel = _TotalSelectDataBox[row];
        
        NSLog(@"%ld",row);
        NSLog(@"%@",[DeleteSelectlist objectAtIndex:row]);
        if([[DeleteSelectlist objectAtIndex:row] isEqualToString:@"YES"]){
            cell.img_select.image = [UIImage imageNamed:@"select-yes.png"];
        }else{
            cell.img_select.image = [UIImage imageNamed:@"select-no.png"];
        }
        
        cell.txt_comment.text = listDataModel.comment;
        cell.img_image.image = [[UIImage alloc] initWithData:listDataModel.image];
    }

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

#pragma mark セルの選択時イベントメソッド
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == Table_SelectView){
        //情報ボックス表示
        view_idokeido.hidden = NO;
        view_comment.hidden = NO;
        view_commentButton.hidden = YES;
        
        lng_selectRow = indexPath.row;
        
        //テーブルデータの再構築
        [Table_SelectView reloadData];
        
        CgSelect_Model *listDataModel = _TotalSelectDataBox[indexPath.row];
        
        if([listDataModel.Latitude isEqualToString:@"(null)"]) {
            txt_idokeido.text = [NSString stringWithFormat:@"位置情報が無いようです。"];
        }else{
            txt_idokeido.text = [NSString stringWithFormat:@"%@,%@", listDataModel.Latitude, listDataModel.Longitude];
        }
        
        txt_comment.text = listDataModel.comment;
        
        if(txt_comment.text.length == 0){
            lbl_comment.hidden = NO;
        }else{
            lbl_comment.hidden = YES;
        }
    }

    if(tableView == Table_DeleteView){
        //情報ボックス表示
        view_idokeido.hidden = YES;
        view_comment.hidden = YES;
        view_commentButton.hidden = YES;

        NSString* str_moto = [DeleteSelectlist objectAtIndex:indexPath.row];
        if([str_moto isEqualToString:@"YES"]){
            [DeleteSelectlist replaceObjectAtIndex:indexPath.row withObject:@"NO"];
        }else if([str_moto isEqualToString:@"NO"]){
            [DeleteSelectlist replaceObjectAtIndex:indexPath.row withObject:@"YES"];
        }
        
        //テーブルデータの再構築
        [Table_DeleteView reloadData];
    }
}

- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // セルが編集可能だと左側に削除アイコンが出るけど、それを表示させない
    //削除用
    //UITableViewCellEditingStyleDelete
    //移動用
    //UITableViewCellEditingStyleNone

    return UITableViewCellEditingStyleNone;
}

-(BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    // editingStyleForRowAtIndexPath()でアイコン表示を無くしたけど、アイコン分の空白が残っているので左寄せする
    return NO;
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark セル移動処理
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    if(fromIndexPath.section == toIndexPath.section) { // 移動元と移動先は同じセクションです。
        if(_TotalSelectDataBox && toIndexPath.row < [_TotalSelectDataBox count]) {
            
            NSLog(@"from %li", (long)fromIndexPath.row);
            NSLog(@"to %li", (long)toIndexPath.row);
            
            id item = [_TotalSelectDataBox objectAtIndex:fromIndexPath.row]; // 移動対象を保持します。
            [_TotalSelectDataBox removeObject:item]; // 配列から一度消します。
            [_TotalSelectDataBox insertObject:item atIndex:toIndexPath.row]; // 保持しておいた対象を挿入します。
            
            for(int row_count = 0;row_count < _TotalSelectDataBox.count; row_count++){
                CgSelect_Model *listDataModel = _TotalSelectDataBox[row_count];
                [SqlManager Update_List:listDataModel.service_id sortid:row_count];
            }
        }
    }
}

#pragma mark テーブルのスクロール時のイベントメソッド
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

}
/////////////// ↑　テーブル用メソッド　↑ ////////////////////

- (IBAction)btn_camera:(id)sender {
    
    // セルの移動するためにsetEditingにNOを渡して編集終了
    [Table_SelectView setEditing:NO animated:YES];
    
    //表示テーブル設定
    Table_SelectView.hidden = NO;
    Table_DeleteView.hidden = YES;
    
    //ボタンバック
    img_photoBack.hidden = NO;
    img_deleteBack.hidden = YES;
    bln_tableButtonSetting = 0;
    
    view_idokeido.hidden = YES;
    view_comment.hidden = YES;
    view_commentButton.hidden = YES;
    
    btn_cellsort.hidden = NO;
    btn_photoplus.hidden = NO;
    
    view_dell.hidden = YES;
    
    //選択行初期化
    lng_selectRow = -1;
    
    //テーブルデータの再構築
    [Table_SelectView reloadData];
}

- (IBAction)btn_delete:(id)sender {
    
    // セルの移動するためにsetEditingにNOを渡して編集終了
    [Table_SelectView setEditing:NO animated:YES];
    
    //表示テーブル設定
    Table_SelectView.hidden = YES;
    Table_DeleteView.hidden = NO;
    
    //ボタンバック
    img_photoBack.hidden = YES;
    img_deleteBack.hidden = NO;
    bln_tableButtonSetting = 1;
    
    view_idokeido.hidden = YES;
    view_comment.hidden = YES;
    view_commentButton.hidden = YES;
    
    btn_cellsort.hidden = YES;
    btn_photoplus.hidden = YES;
    
    view_dell.hidden = NO;
    
    txt_idokeido.text = @"";
    txt_comment.text = @"";
    
    //選択行初期化
    lng_selectRow = -1;
    
    //テーブルデータの再構築
    [Table_DeleteView reloadData];
    
    //削除初期化
    DeleteSelectlist = [NSMutableArray array];
    for(int a=0;a<_TotalSelectDataBox.count;a++){
        [DeleteSelectlist insertObject:@"NO" atIndex:a];
        
        NSLog(@"%@",[DeleteSelectlist objectAtIndex:a]);
    }
}

- (IBAction)btn_googlemap:(id)sender {
    //http://maps.apple.com/?ll=35.664487,139.708028&q=loc:35.664487,139.708028
    
    //http://www18.atwiki.jp/iphone-urlscheme/pages/23.html
    //prefs:root=General&path=ManagedConfigurationList
    
    if(lng_selectRow >= 0){
        CgSelect_Model *listDataModel = _TotalSelectDataBox[lng_selectRow];
        
        if(![listDataModel.Latitude isEqualToString:@"(null)"]) {
//            NSString* url = [NSString stringWithFormat:@"http://maps.apple.com/?ll=%@,%@&q=loc:%@,%@", listDataModel.Latitude,listDataModel.Longitude, listDataModel.Latitude,listDataModel.Longitude];
            NSString* url = [NSString stringWithFormat:@"http://maps.google.com/maps?q=%@,%@&zoom=14", listDataModel.Latitude,listDataModel.Longitude];
            NSURL* skimeUrl = [NSURL URLWithString:url];
            if ([[UIApplication sharedApplication] canOpenURL:skimeUrl]) {
                [[UIApplication sharedApplication] openURL:skimeUrl];
            }
        }
    }
}

#pragma mark　コメントボタン
- (IBAction)btn_comment:(id)sender {
    
    if(lng_selectRow >= 0){
        [SVProgressHUD showWithStatus:@"Loading..."];
        
        CgSelect_Model *listDataModel = _TotalSelectDataBox[lng_selectRow];
        [SqlManager Update_comment:listDataModel.service_id comment:txt_comment.text];
        [self readSelectData];
    }
}

#pragma mark　プラスボタン
- (IBAction)btn_photoplus:(id)sender {
    
    //ソート初期フラグ設定
    bln_cellsort = NO;
    [Table_SelectView setEditing:NO animated:YES];

    if([UIImagePickerController
        isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

#pragma mark　ソートボタン
- (IBAction)brn_cellsort:(id)sender {
    
    if(bln_cellsort == NO){
        // セルの移動するためにsetEditingにYESを渡して編集状態にする
        [Table_SelectView setEditing:YES animated:YES];
        //ソート初期フラグ設定
        bln_cellsort = YES;
    }else{
        // セルの移動するためにsetEditingにNOを渡して編集終了
        [Table_SelectView setEditing:NO animated:YES];
        //ソート初期フラグ設定
        bln_cellsort = NO;
    }
}

- (IBAction)btn_cellAllSelect:(id)sender {
}

- (IBAction)btn_cellDell:(id)sender {
}

#pragma mark 写真選択時の処理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //Latitude  緯度
    //Longitude 経度
    
    [SVProgressHUD showWithStatus:@"Loading..."];
    
    // アルバムから
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        
        str_Latitude = @"";
        str_Longitude = @"";
        
        // PhotoAlbumの場合
        NSURL *assetURL = [info objectForKey:UIImagePickerControllerReferenceURL];
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library assetForURL:assetURL resultBlock:^(ALAsset *asset) {
            ALAssetRepresentation *representation = [asset defaultRepresentation];
            NSDictionary *metadataDict = [representation metadata]; // ←ここにExifとかGPSの情報が入ってる
//            NSLog(@"%@", metadataDict);
//            NSLog(@"%@", [metadataDict objectForKey:@"{GPS}"]);
            NSDictionary *metadataDictGps = [metadataDict objectForKey:@"{GPS}"];
            str_Latitude = [metadataDictGps objectForKey:@"Latitude"];
            str_Longitude = [metadataDictGps objectForKey:@"Longitude"];
            NSLog(@"緯度:%@", str_Latitude);
            NSLog(@"経度:%@", str_Longitude);

            if(str_Latitude == nil) {
                txt_idokeido.text = [NSString stringWithFormat:@"位置情報が無いようです。"];
            }else{
                txt_idokeido.text = [NSString stringWithFormat:@"%@,%@", str_Latitude, str_Longitude];
            }

            txt_comment.text = @"";
            
            // 画像を書き直す
            UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
            UIGraphicsBeginImageContext(image.size);
            [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
            image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            NSData* pngData = [[NSData alloc] initWithData:UIImagePNGRepresentation(image)];
            [SqlManager Set_List:_TotalSelectDataBox.count img:pngData Latitude:str_Latitude Longitude:str_Longitude comment:@"" delete:0];
            
            lng_selectRow = _TotalSelectDataBox.count;
            
            [self readSelectData];
            
            //情報ボックス表示
            view_idokeido.hidden = NO;
            view_comment.hidden = NO;
            view_commentButton.hidden = YES;
            
        } failureBlock:^(NSError *error) {
            NSLog(@"%@",error);
            
            // 読み込み中の表示削除
            [SVProgressHUD dismiss];
        }];
        
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
