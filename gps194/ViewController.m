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
    
    BOOL bln_sort;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //ソート初期フラグ設定
    bln_sort = false;
    
    //カスタムセル設定
    UINib *nib = [UINib nibWithNibName:@"CgSelect_Cell" bundle:nil];
    CgSelect_Cell *cell = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    Table_View.rowHeight = cell.frame.size.height;
    
    
    // Register CustomCell
    [Table_View registerNib:nib forCellReuseIdentifier:@"CgSelect_Cell"];
}

// 起動・再開の時に起動するメソッド
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

/////////////// ↓　通信用メソッド　↓　////////////////////
// Webからのリストデータ取得
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
/////////////// ↑　通信用メソッド　↑　////////////////////

/////////////// ↓　テーブル用メソッド　↓ ////////////////////
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_TotalDataBox count];
}

// １行ごとのセル生成（表示時）
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Instantiate or reuse cell
    CgSelect_Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"CgSelect_Cell"];
    
    // Set contents
    NSUInteger row = (NSUInteger)indexPath.row;
    CgSelect_Model *listDataModel = _TotalDataBox[row];
    
    cell.lng_serviceId = listDataModel.service_id;
    cell.str_comment = listDataModel.comment;
    cell.lng_sortId = listDataModel.sort_id;
    cell.lng_deleteId = listDataModel.delete_flg;
    
    cell.img_image.image = [[UIImage alloc] initWithData:listDataModel.image];
    
    if(indexPath.row == lng_selectRow){
        cell.img_select.image = [UIImage imageNamed:@"select-yes.png"];
    }else{
        cell.img_select.image = [UIImage imageNamed:@"select-no.png"];
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

//セルの選択時イベントメソッド
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
}

- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // セルが編集可能だと左側に削除アイコンが出るけど、それを表示させない
    return UITableViewCellEditingStyleNone;
}

-(BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    // editingStyleForRowAtIndexPath()でアイコン表示を無くしたけど、アイコン分の空白が残っているので左寄せする
    return NO;
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // セルの移動を許可
    return YES;
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    if(fromIndexPath.section == toIndexPath.section) { // 移動元と移動先は同じセクションです。
        if(_TotalDataBox && toIndexPath.row < [_TotalDataBox count]) {
            id item = [_TotalDataBox objectAtIndex:fromIndexPath.row]; // 移動対象を保持します。
            [_TotalDataBox removeObject:item]; // 配列から一度消します。
            [_TotalDataBox insertObject:item atIndex:toIndexPath.row]; // 保持しておいた対象を挿入します。
        }
    }

    
}

// テーブルのスクロール時のイベントメソッド
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

}
/////////////// ↑　テーブル用メソッド　↑ ////////////////////

- (IBAction)btn_camera:(id)sender {
}

- (IBAction)btn_delete:(id)sender {
}

- (IBAction)btn_googlemap:(id)sender {
    //http://maps.apple.com/?ll=35.664487,139.708028&q=loc:35.664487,139.708028
    
    if(lng_selectRow >= 0){
        CgSelect_Model *listDataModel = _TotalDataBox[lng_selectRow];
        
        if(![listDataModel.Latitude isEqualToString:@"(null)"]) {
            NSString* url = [NSString stringWithFormat:@"http://maps.apple.com/?ll=%@,%@&q=loc:%@,%@", listDataModel.Latitude,listDataModel.Longitude, listDataModel.Latitude,listDataModel.Longitude];
            NSURL* skimeUrl = [NSURL URLWithString:url];
            if ([[UIApplication sharedApplication] canOpenURL:skimeUrl]) {
                [[UIApplication sharedApplication] openURL:skimeUrl];
            }
        }
    }
}

- (IBAction)btn_comment:(id)sender {
}

- (IBAction)btn_photoplus:(id)sender {

    if([UIImagePickerController
        isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

- (IBAction)brn_sort:(id)sender {
    
    if(bln_sort == false){
        // セルの移動するためにsetEditingにYESを渡して編集状態にする
        [Table_View setEditing:YES animated:YES];
        //ソート初期フラグ設定
        bln_sort = true;
    }else{
        // セルの移動するためにsetEditingにYESを渡して編集状態にする
        [Table_View setEditing:NO animated:YES];
        //ソート初期フラグ設定
        bln_sort = false;
    }
}

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
            
            // 画像を書き直す
            UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
            UIGraphicsBeginImageContext(image.size);
            [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
            image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            NSData* pngData = [[NSData alloc] initWithData:UIImagePNGRepresentation(image)];
            [SqlManager Set_List:_TotalDataBox.count sortid:0 img:pngData Latitude:str_Latitude Longitude:str_Longitude comment:@"" delete:0];
            
            lng_selectRow = _TotalDataBox.count;
            
            [self readListData];
            
        } failureBlock:^(NSError *error) {
            NSLog(@"%@",error);
            
            // 読み込み中の表示削除
            [SVProgressHUD dismiss];
        }];
        

    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}




@end
