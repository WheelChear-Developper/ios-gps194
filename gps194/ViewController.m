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
    NSMutableArray *_TotalDataBox;
    NSArray *sections;
    
    // 選択行
    long lng_selectRow;
    
    NSString* str_Latitude;
    NSString* str_Longitude;
    
    BOOL bln_cellsort;
    BOOL bln_celldelete;
    
    //セルの編集方法設定（0:移動 1:削除）
    long lng_Editmode;
    
    //ボタン設定(0:Photo画面 1:Delte画面)
    long bln_tableButtonSetting;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //ボタンバック
    img_photoBack.hidden = NO;
    img_deleteBack.hidden = YES;
    bln_tableButtonSetting = 0;
    
    //ソート初期フラグ設定
    bln_cellsort = false;
    bln_celldelete = false;
    
    //コメントヒント表示
    lbl_comment.hidden = NO;
    
    //セルの編集方法設定
    lng_Editmode = 0;
    
    //情報ボックス非表示
    view_idokeido.hidden = YES;
    view_comment.hidden = YES;
    view_commentButton.hidden = YES;
    
    //カスタムセル設定
    UINib *nib = [UINib nibWithNibName:@"CgSelect_Cell" bundle:nil];
    CgSelect_Cell *cell = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    Table_View.rowHeight = cell.frame.size.height;
    
    
    // Register CustomCell
    [Table_View registerNib:nib forCellReuseIdentifier:@"CgSelect_Cell"];
}

#pragma mark 起動・再開の時に起動するメソッド
- (void)viewWillAppear:(BOOL)animated
{
    // リストデータの読み込み
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Progress_Reading",@"")];
    [self readListData];
    
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
        
        CgSelect_Model *listDataModel = _TotalDataBox[lng_selectRow];
        [SqlManager Update_comment:listDataModel.service_id comment:txt_comment.text];
        
        [textView resignFirstResponder];
        
        [self readListData];
        
        return NO;
    }
    return YES;
}
/////////////// ↑　入力系用メソッド　↑ ////////////////////

#pragma mark SQLからリストデータ取得
- (void)readListData
{
    // リストデータの初期化
    _TotalDataBox = [[NSMutableArray alloc] init];
    
    //アプリ内のデータ取得
    NSMutableArray *RecordDataBox = [SqlManager Get_List];

    //アプリ内データのセット
    _TotalDataBox = RecordDataBox;
    //テーブルデータの再構築
    [Table_View reloadData];
    
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
    return [_TotalDataBox count];
}

#pragma mark １行ごとのセル生成（表示時）
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"CgSelect_Cell";
    CgSelect_Cell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    // セルが作成されていないか?
    if (!cell) { // yes
        // セルを作成
        cell = [[CgSelect_Cell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    // Set contents
    NSUInteger row = (NSUInteger)indexPath.row;
    CgSelect_Model *listDataModel = _TotalDataBox[row];
    
    if(indexPath.row == lng_selectRow){
        cell.img_select.image = [UIImage imageNamed:@"select-yes.png"];
    }else{
        cell.img_select.image = [UIImage imageNamed:@"select-no.png"];
    }
    cell.txt_comment.text = listDataModel.comment;
    cell.img_image.image = [[UIImage alloc] initWithData:listDataModel.image];

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
    //情報ボックス表示
    view_idokeido.hidden = NO;
    view_comment.hidden = NO;
    view_commentButton.hidden = YES;
    
    lng_selectRow = indexPath.row;

    //テーブルデータの再構築
    [Table_View reloadData];
    
    CgSelect_Model *listDataModel = _TotalDataBox[indexPath.row];
    
    if([listDataModel.Latitude isEqualToString:@"(null)"]) {
        txt_idokeido.text = [NSString stringWithFormat:@"位置情報が無いようです。"];
    }else{
        txt_idokeido.text = [NSString stringWithFormat:@"緯度:%@\n経度:%@", listDataModel.Latitude, listDataModel.Longitude];
    }
    
    txt_comment.text = listDataModel.comment;
    
    if(txt_comment.text.length == 0){
        lbl_comment.hidden = NO;
    }else{
        lbl_comment.hidden = YES;
    }
}

- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // セルが編集可能だと左側に削除アイコンが出るけど、それを表示させない
    //削除用
    //UITableViewCellEditingStyleDelete
    //移動用
    //UITableViewCellEditingStyleNone
    
    switch (lng_Editmode) {
        case 0:
            return UITableViewCellEditingStyleNone;
            break;
        case 1:
            return UITableViewCellEditingStyleDelete;
            break;
        default:
            return UITableViewCellEditingStyleNone;
            break;
    }
}

-(BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    // editingStyleForRowAtIndexPath()でアイコン表示を無くしたけど、アイコン分の空白が残っているので左寄せする
    return NO;
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // セルの移動を許可
    switch (lng_Editmode) {
        case 0:
            return YES;
            break;
        case 1:
            return NO;
            break;
        default:
            return YES;
            break;
    }
}

#pragma mark セル移動処理
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    if(fromIndexPath.section == toIndexPath.section) { // 移動元と移動先は同じセクションです。
        if(_TotalDataBox && toIndexPath.row < [_TotalDataBox count]) {
            
            NSLog(@"from %li", (long)fromIndexPath.row);
            NSLog(@"to %li", (long)toIndexPath.row);
            
            id item = [_TotalDataBox objectAtIndex:fromIndexPath.row]; // 移動対象を保持します。
            [_TotalDataBox removeObject:item]; // 配列から一度消します。
            [_TotalDataBox insertObject:item atIndex:toIndexPath.row]; // 保持しておいた対象を挿入します。
            
            for(int row_count = 0;row_count < _TotalDataBox.count; row_count++){
                CgSelect_Model *listDataModel = _TotalDataBox[row_count];
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
    
    //ボタンバック
    img_photoBack.hidden = NO;
    img_deleteBack.hidden = YES;
    bln_tableButtonSetting = 0;
    
}

- (IBAction)btn_delete:(id)sender {
    
    //ボタンバック
    img_photoBack.hidden = YES;
    img_deleteBack.hidden = NO;
    bln_tableButtonSetting = 1;
    
}

- (IBAction)btn_googlemap:(id)sender {
    //http://maps.apple.com/?ll=35.664487,139.708028&q=loc:35.664487,139.708028
    
    //http://www18.atwiki.jp/iphone-urlscheme/pages/23.html
    //prefs:root=General&path=ManagedConfigurationList
    
    if(lng_selectRow >= 0){
        CgSelect_Model *listDataModel = _TotalDataBox[lng_selectRow];
        
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
        
        CgSelect_Model *listDataModel = _TotalDataBox[lng_selectRow];
        [SqlManager Update_comment:listDataModel.service_id comment:txt_comment.text];
        [self readListData];
    }
}

#pragma mark　プラスボタン
- (IBAction)btn_photoplus:(id)sender {
    
    //ソート初期フラグ設定
    bln_celldelete = NO;
    bln_cellsort = NO;
    [Table_View setEditing:NO animated:YES];

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
    
    lng_Editmode = 0;
    
    if(bln_cellsort == NO){
        // セルの移動するためにsetEditingにYESを渡して編集状態にする
        [Table_View setEditing:YES animated:YES];
        //ソート初期フラグ設定
        bln_cellsort = YES;
        bln_celldelete = NO;
    }else{
        // セルの移動するためにsetEditingにYESを渡して編集状態にする
        [Table_View setEditing:NO animated:YES];
        //ソート初期フラグ設定
        bln_cellsort = NO;
        bln_celldelete = NO;
    }
}

- (IBAction)btn_celldelete:(id)sender {
    
    lng_Editmode = 1;
    
    if(bln_celldelete == NO){
        // セルの移動するためにsetEditingにYESを渡して編集状態にする
        [Table_View setEditing:YES animated:YES];
        //ソート初期フラグ設定
        bln_celldelete = YES;
        bln_cellsort = NO;
    }else{
        // セルの移動するためにsetEditingにYESを渡して編集状態にする
        [Table_View setEditing:NO animated:YES];
        //ソート初期フラグ設定
        bln_celldelete = NO;
        bln_cellsort = NO;
    }
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
                txt_idokeido.text = [NSString stringWithFormat:@"緯度:%@\n経度:%@", str_Latitude, str_Longitude];
            }

            txt_comment.text = @"";
            
            // 画像を書き直す
            UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
            UIGraphicsBeginImageContext(image.size);
            [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
            image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            NSData* pngData = [[NSData alloc] initWithData:UIImagePNGRepresentation(image)];
            [SqlManager Set_List:_TotalDataBox.count img:pngData Latitude:str_Latitude Longitude:str_Longitude comment:@"" delete:0];
            
            lng_selectRow = _TotalDataBox.count;
            
            [self readListData];
            
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
