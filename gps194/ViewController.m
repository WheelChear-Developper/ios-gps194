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
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //カスタムセル設定
    UINib *nib = [UINib nibWithNibName:@"CgSelect_Cell" bundle:nil];
    CgSelect_Cell *cell = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    Table_View.rowHeight = cell.frame.size.height;
    
    // Register CustomCell
    [Table_View registerNib:nib forCellReuseIdentifier:@"CgSelect_Cell"];
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
    return 1;//[_TotalDataBox count];
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
    cell.img_Photo = listDataModel.image;
    
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
//    CgSelect_Model *listDataModel = _TotalDataBox[indexPath.row];

    // 画面遷移
    UIViewController *initialViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"comments"];
    [self.navigationController pushViewController:initialViewController animated:YES];
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //Latitude  緯度
    //Longitude 経度
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    // アルバムから
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        
        // PhotoAlbumの場合
        NSURL *assetURL = [info objectForKey:UIImagePickerControllerReferenceURL];
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library assetForURL:assetURL resultBlock:^(ALAsset *asset) {
            ALAssetRepresentation *representation = [asset defaultRepresentation];
            NSDictionary *metadataDict = [representation metadata]; // ←ここにExifとかGPSの情報が入ってる
//            NSLog(@"%@", metadataDict);
//            NSLog(@"%@", [metadataDict objectForKey:@"{GPS}"]);
            NSDictionary *metadataDictGps = [metadataDict objectForKey:@"{GPS}"];
            NSString* str_Latitude = [metadataDictGps objectForKey:@"Latitude"];
            NSString* str_Longitude = [metadataDictGps objectForKey:@"Longitude"];
            NSLog(@"緯度:%@", str_Latitude);
            NSLog(@"経度:%@", str_Longitude);

            if(str_Latitude == nil) {
                txt_idokeido.text = [NSString stringWithFormat:@"位置情報が無いようです。"];
            }else{
                txt_idokeido.text = [NSString stringWithFormat:@"緯度:%@\n経度:%@", str_Latitude, str_Longitude];
            }
            
        } failureBlock:^(NSError *error) {
            NSLog(@"%@",error);
        }];
        
        // 画像を書き直す
        UIGraphicsBeginImageContext(image.size);
        [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
//        self.imageView.image = image;
        
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)imagePickerController :(UIImagePickerController *)picker
        didFinishPickingImage :(UIImage *)image editingInfo :(NSDictionary *)editingInfo {
    
    
    

    
    
    
    
    
    NSLog(@"selected");
//    [self.imageView setImage:image];
    
    NSURL* imageurl = [editingInfo objectForKey:UIImagePickerControllerReferenceURL];
    
    NSString *imgPath = editingInfo[@"UIImagePickerControllerReferenceURL"];
    CGImageSourceRef source = CGImageSourceCreateWithURL((CFURLRef)CFBridgingRetain(imageurl), nil);
    NSDictionary *metadata = (NSDictionary *) CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(source, 0, NULL));
    NSDictionary *GPSDictionary = [metadata objectForKey:(NSString *)kCGImagePropertyGPSDictionary];
    
    NSData* pngData = [[NSData alloc] initWithData:UIImagePNGRepresentation( image )];
    
    [SqlManager Set_List:1 sortid:1 img:pngData comment:@"test" delete:0];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}




@end
