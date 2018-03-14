//
//  BXLBrowserImageViewController.m
//  
//
//  Created by leven on 2017/11/9.
//

#import "BXLBrowserImageViewController.h"
#import "BXLBrowserImageCollectionViewCell.h"
#import <SDWebImageDownloader.h>
#import "UIDeviceHardware.h"

static CGFloat kCellMinSpacing = 20;

@interface BXLBrowserImageViewController ()<UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
UIGestureRecognizerDelegate,
BXLBrowserImageCollectionViewCellDelegate,
UIScrollViewDelegate>

@property (nonatomic, strong) UICollectionView *collectView;
@property (nonatomic, strong) UIImageView *screenImageView;
@property (nonatomic, strong) UIPageControl *pageView;
@property (nonatomic, assign) NSUInteger currentIndex;

@property (nonatomic, assign) BOOL statusBarHiden;
@property (nonatomic, assign) BOOL backVCStatusBarHiden;

@property (nonatomic, assign) BOOL ifEndAnimatedToShow;

@end

@implementation BXLBrowserImageViewController

#pragma life Cycle
- (void)viewDidLoad{
    [super viewDidLoad];
    [self initUI];
}
- (BOOL)prefersStatusBarHidden{
    return self.statusBarHiden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation{
    return UIStatusBarAnimationFade;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIView animateWithDuration:0.2 animations:^{
        [self setNeedsStatusBarAppearanceUpdate];
    }];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.statusBarHiden = self.backVCStatusBarHiden;
    [UIView animateWithDuration:0.2 animations:^{
        [self setNeedsStatusBarAppearanceUpdate];
    }];
}

#pragma --mark UI
- (void)initUI{
    self.statusBarHiden = NO;
    self.backVCStatusBarHiden = self.prefersStatusBarHidden;
    
    [self.view addSubview:self.screenImageView];
  
    [self.view addSubview:self.collectView];
    [self.view addSubview:self.pageView];
    
    self.pageView.hidden = (self.dataArr.count == 1);
    
    [_collectView setContentOffset:CGPointMake(self.currentIndex*(kScreenWidth+kCellMinSpacing), 0)];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
    [self.view addGestureRecognizer:pan];

}
#pragma --mark data
- (void)setScreenImage:(UIImage *)screenImage{
    _screenImage = screenImage;
    self.screenImageView.image = self.screenImage;
}

- (void)setDataArr:(NSArray<BXLBrowserImageCellModel *> *)dataArr{
    _dataArr = dataArr;
    for (BXLBrowserImageCellModel *model in dataArr) {
        if (model.isSelected && !model.hasAnimatedToShow) {
            _currentIndex = [dataArr indexOfObject:model];
        }
    }
    [self.collectView setContentOffset:CGPointMake(self.collectView.frame.size.width * _currentIndex, 0) animated:NO];

    [self.collectView reloadData];
    
    
    self.pageView.numberOfPages = self.dataArr.count;
    self.pageView.currentPage = self.currentIndex;
}
#pragma --mark Action
- (void)pageDidChange{
    _currentIndex = _pageView.currentPage;
    [self.collectView setContentOffset:CGPointMake(self.collectView.frame.size.width * _currentIndex, 0) animated:NO];
}

- (void)panGestureAction:(UIGestureRecognizer *)panGesture{
    BXLBrowserImageCollectionViewCell *cell = self.collectView.visibleCells.lastObject;
    if (!cell.model.dragToDismiss) {
        return;
    }

    self.collectView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    [cell handlePanGestureAnimation:panGesture];
}

- (void)preLoadImage{
    BXLBrowserImageCellModel *previousModel = nil;
    BXLBrowserImageCellModel *nextModel = nil;
    
    if (_currentIndex > 0 && self.dataArr.count > 1 ) {
        previousModel = self.dataArr[_currentIndex-1];
    }
    if (_currentIndex + 1 < self.dataArr.count) {
        nextModel = self.dataArr[_currentIndex+1];
    }
    
    if (previousModel && previousModel.originalImageUrl) {
        [self preLoadImageWithUrl:previousModel.originalImageUrl];
    }
    if (nextModel && nextModel.originalImageUrl) {
        [self preLoadImageWithUrl:previousModel.originalImageUrl];
    }
}

- (void)preLoadImageWithUrl:(NSString *)url{
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:url] options:SDWebImageDownloaderLowPriority progress:nil completed:nil];
}
#pragma --mark delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.ifEndAnimatedToShow){
        self.pageView.currentPage = scrollView.contentOffset.x/self.collectView.frame.size.width;
        _currentIndex = self.pageView.currentPage;
    }
    [self preLoadImage];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BXLBrowserImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([BXLBrowserImageCollectionViewCell class]) forIndexPath:indexPath];
    cell.delegate = self;
    cell.model = self.dataArr[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(kScreenWidth, kScreenHeight);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0,0,0,kCellMinSpacing);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return kCellMinSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

#pragma --other
- (void)BXLBrowserImageCollectionViewCellDidEndHandlePanGesture: (BXLBrowserImageCollectionViewCell *)cell{
     self.collectView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:1];
}

- (void)BXLBrowserImageCollectionViewCellDidAnimatedToShow:(BXLBrowserImageCollectionViewCell *)cell{
    self.ifEndAnimatedToShow = YES;
   
}

- (void)BXLBrowserImageCollectionViewCellWillAnimatedToShow:(BXLBrowserImageCollectionViewCell *)cell{
    self.statusBarHiden = YES;
    [UIView animateWithDuration:0.2 animations:^{
        [self setNeedsStatusBarAppearanceUpdate];
    }];
}
- (void)BXLBrowserImageCollectionViewCellDidAnimatedToDismss: (BXLBrowserImageCollectionViewCell *)cell{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)BXLBrowserImageCollectionViewCellWillAnimatedToDismss: (BXLBrowserImageCollectionViewCell *)cell{
    self.collectView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
}


#pragma --mark lazyLoad
- (UIPageControl *)pageView{
    if (!_pageView) {
        _pageView = [[UIPageControl alloc] initWithFrame:CGRectMake(0, kScreenHeight - 50, kScreenWidth, 50)];
        
        if ([UIDeviceHardware isIphoneX]) {
            _pageView.top += 34;
        }
        [_pageView addTarget:self action:@selector(pageDidChange) forControlEvents:UIControlEventValueChanged];
    }
    return _pageView;
}

- (UIImageView *)screenImageView{
    if (!_screenImageView) {
        _screenImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _screenImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _screenImageView;
}

- (UICollectionView *)collectView{
    if (!_collectView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = kCellMinSpacing;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth+kCellMinSpacing, kScreenHeight) collectionViewLayout:layout];
        _collectView.pagingEnabled = YES;
        _collectView.dataSource = self;
        _collectView.delegate = self;
        _collectView.bounces = NO;
        _collectView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:1];
        [_collectView registerClass:[BXLBrowserImageCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([BXLBrowserImageCollectionViewCell class])];
    }
    return _collectView;
}


@end
