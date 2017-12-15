//
//  IGPhotoBrowerController.m
//  照片选择和拍照Demo
//
//  Created by ideago on 15/10/31.
//  Copyright © 2015年 ideago. All rights reserved.
//

#import "IGPhotoBrowerController.h"
#import "IGPhotoAssetManager.h"
#import "IGPhotoModel.h"
#import "IGFullScreenPhotoViewCell.h"

@interface IGPhotoBrowerController()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic,weak) UICollectionView *photoContentView;

@property (nonatomic,weak) UIView *topBarView;

@property (nonatomic,weak) UIView *footBarView;


// 用来标记当前已经选中的图片数量
@property (nonatomic,weak) UILabel *countLabel;


// 用来标记当前页面的照片是否已经被用户选择
@property (nonatomic,weak) UIButton *selectedButton;



/**
 
 当这个页面被push出来的时候 IGPhotoAssetManager 肯定是已经执行过loadPhotos了
 
 此时它的单例实例 sharedManager的 photos属性肯定是保存了所有图片
 
 selectedPhotos保存了上一个页面选择的图片
 
 */

@property (nonatomic,strong) IGPhotoAssetManager *photoManager;


@end

@implementation IGPhotoBrowerController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.photoContentView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    
    [self topBarView];
    
    self.selectedButton.selected = [self.photoManager.photos[_currentIndex] isSelected];
    [self footBarView];
    
}



#pragma mark - UICollectionView datasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photoManager.photos.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    IGFullScreenPhotoViewCell *cell = [IGFullScreenPhotoViewCell fullScreenPhotoViewCellWithCollectionView:collectionView forIndexPath:indexPath];
    
    cell.asset = [self.photoManager.photos[indexPath.row] asset];
    
    return cell;
}


#pragma mark - UICollectionView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _currentIndex = ( scrollView.contentOffset.x + self.view.bounds.size.width*0.3) / self.view.bounds.size.width;
    self.selectedButton.selected = [_photoManager.photos[_currentIndex] isSelected];
}


#pragma mark - 懒加载创建

- (IGPhotoAssetManager *)photoManager
{
    if (_photoManager == nil) {
        _photoManager = [IGPhotoAssetManager sharedManager];
    }
    
    return _photoManager ;
}

- (UIView *)topBarView
{
    if (_topBarView == nil) {
        UIView *topBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 60)];
        
        topBarView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        
        
        /**
         返回按钮
         */
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame  = CGRectMake(15, 18, 24, 24);
        [backBtn setBackgroundImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(tapBackBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:topBarView];
        [topBarView addSubview:backBtn];
        _topBarView = topBarView;
        
        
        /**
         选择按钮
         */
        [self selectedButton];
    }
    return _topBarView ;
}

- (UIButton *)selectedButton
{
    if (_selectedButton == nil) {
        UIButton *selectedbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        selectedbutton.frame  = CGRectMake(self.view.bounds.size.width-50, 15, 30, 30);
        [selectedbutton setBackgroundImage:[UIImage imageNamed:@"unselected_flag"] forState:UIControlStateNormal];
        
        [selectedbutton setBackgroundImage:[UIImage imageNamed:@"selected_flag"] forState:UIControlStateSelected];
        [selectedbutton addTarget:self action:@selector(tapSelectedBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_topBarView addSubview:selectedbutton];
        _selectedButton = selectedbutton;
    }
    
    return _selectedButton ;
}


- (UIView *)footBarView
{
    if (_footBarView == nil) {
        UIView *footBarView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height-40, self.view.bounds.size.width, 40)];
        
        footBarView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        
        
        
        /**
         完成按钮
         */
        UIButton *finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        finishBtn.frame  = CGRectMake(self.view.bounds.size.width-60, 5, 50, 30);
        
        [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
        
        finishBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
        finishBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [finishBtn setTitleColor:Tint_COLOR forState:UIControlStateNormal];
        [finishBtn addTarget:self action:@selector(tapFinishBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:footBarView];
        [footBarView addSubview:finishBtn];
        
        _footBarView = footBarView;
        
        
        /**
         已选择图片个数的指示器label
         */
        [self countLabel];
        
    }
    return _footBarView ;
}


- (UILabel *)countLabel
{
    if (_countLabel == nil) {
        UILabel *countLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width - 80, 8, 24, 24)];
        countLabel.font = [UIFont boldSystemFontOfSize:14.0];
        countLabel.layer.cornerRadius = 12.0;
        countLabel.backgroundColor = Tint_COLOR;
        countLabel.textColor = [UIColor whiteColor];
        countLabel.textAlignment = NSTextAlignmentCenter;
        countLabel.clipsToBounds = YES;
        [_footBarView addSubview:countLabel];
        countLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)[[[IGPhotoAssetManager sharedManager] selectedPhotos] count]];
        _countLabel = countLabel;
    }
    
    return _countLabel ;
}


- (UICollectionView *)photoContentView
{
    if (_photoContentView == nil) {
        
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = self.view.bounds.size;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        
        
        UICollectionView *photoContentView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
        photoContentView.pagingEnabled = YES;
        photoContentView.showsHorizontalScrollIndicator = NO;
        photoContentView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:photoContentView];
        
        photoContentView.delegate = self;
        photoContentView.dataSource = self;
        photoContentView.bounces = NO;
        
        _photoContentView = photoContentView;
    }
    
    return _photoContentView;
}

#pragma  mark - 事件处理

- (void)tapBackBtn:(UIButton *)button
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)tapSelectedBtn:(UIButton *)button
{
    button.selected = !button.selected;
    
    NSMutableOrderedSet *selectedPhotos = [[IGPhotoAssetManager sharedManager] selectedPhotos];
    
    NSMutableArray *photos = [[IGPhotoAssetManager sharedManager] photos];
    
    if (button.selected) {
        [photos[_currentIndex] setSelected:YES];
        [selectedPhotos addObject:photos[_currentIndex]];
    }else{
        [photos[_currentIndex] setSelected:NO];
        [selectedPhotos removeObject:photos[_currentIndex]];
    }
    
    _countLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)_photoManager.selectedPhotos.count];
}

- (void)tapFinishBtn:(UIButton *)button
{
   [[NSNotificationCenter defaultCenter] postNotificationName:@"CompletePickingPhotosNotification" object:nil userInfo:@{@"selectedPhotos" : self.photoManager.selectedPhotos}];
}


@end
