//
//  IGPhotoListViewController.m
//  照片选择和拍照Demo
//
//  Created by ideago on 15/10/31.
//  Copyright © 2015年 ideago. All rights reserved.
//

#import "IGPhotoListViewController.h"
#import "IGPhotoViewCell.h"
#import "IGPhotoAssetManager.h"
#import "IGPhotoBrowerController.h"

@interface IGPhotoListViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) NSMutableArray *photos;

@property (weak, nonatomic) IBOutlet UICollectionView *photoListView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *previewButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *finishButton;

@property (nonatomic,strong) IGPhotoAssetManager *photoManager;

@end

@implementation IGPhotoListViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_previewButton setTintColor:Tint_COLOR];
    [_finishButton setTintColor:Tint_COLOR];
    // 从全屏形式的选择页面返回时 应该重新刷新数据
    if (_photos.count > 0) {
        [self.photoListView reloadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationItem.title = @"照片选择";
    
    [self setupPhotoListView];
    
    _photos = self.photoManager.photos;
}

#pragma mark - 初始化

- (void)setupPhotoListView
{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    layout.minimumInteritemSpacing = 2.0;
    layout.minimumLineSpacing = 2.0;
    layout.itemSize = CGSizeMake(70,70);
    
    _photoListView.collectionViewLayout = layout;
    _photoListView.delegate = self;
    _photoListView.dataSource = self;

}


#pragma mark - CollectionView datasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    IGPhotoViewCell *cell = [IGPhotoViewCell photoViewCellWithCollectionView:collectionView forIndexPath:indexPath];
    
    cell.model = _photos[indexPath.row];
    
    
    [cell tapPhotoSelectedView:^(IGPhotoModel *model) {
        if (model.isSelected) {
            [_photoManager.selectedPhotos addObject:model];
        }else{
            [_photoManager.selectedPhotos removeObject:model];
        }
    }];
    
    return cell;
}

#pragma mark - CollectionView delegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    IGPhotoBrowerController * pbc = [[IGPhotoBrowerController alloc] init];
    pbc.currentIndex = indexPath.row;
    [self.navigationController pushViewController:pbc animated:YES];
}

#pragma mark - 懒加载

- (IGPhotoAssetManager *)photoManager
{
    if (_photoManager == nil) {
        _photoManager = [IGPhotoAssetManager sharedManager];
    }
    return _photoManager;
}


#pragma mark - 事件处理

- (IBAction)previewPhotos:(id)sender {
    NSLog(@"%@",self.photoManager.selectedPhotos);
}

- (IBAction)completePickPhoto:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CompletePickingPhotosNotification" object:nil userInfo:@{@"selectedPhotos" : self.photoManager.selectedPhotos}];
}



@end
