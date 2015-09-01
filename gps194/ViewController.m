//
//  ViewController.m
//  gps194
//
//  Created by MacServer on 2015/08/27.
//  Copyright (c) 2015年 Mobile Innovation, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
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

- (void)imagePickerController :(UIImagePickerController *)picker
        didFinishPickingImage :(UIImage *)image editingInfo :(NSDictionary *)editingInfo {
    NSLog(@"selected");
//    [self.imageView setImage:image];
    [self dismissViewControllerAnimated:YES completion:nil];
}




@end
