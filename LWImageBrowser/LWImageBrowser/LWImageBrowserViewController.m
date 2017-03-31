//
//  LWImageBrowserViewController.m
//  LWImageBrowser
//
//  Created by leven on 2017/3/29.
//  Copyright © 2017年 leven. All rights reserved.
//

#import "LWImageBrowserViewController.h"
#import "LWImageCollectionViewCell.h"
#import "LWBrowerItemModel.h"
#define kLWScreenWidth [UIScreen mainScreen].bounds.size.width
#define kLWScreenHeight [UIScreen mainScreen].bounds.size.height

@interface LWImageBrowserViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UICollectionView *collectView;
@property (nonatomic, assign) BOOL shouldHideNavigationBarWhenDisappear;
@property (nonatomic, strong) UIPageControl *pager;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, copy) void(^panGestureBlock)(UIGestureRecognizer *);
@end
@implementation LWImageBrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self initData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.shouldHideNavigationBarWhenDisappear = self.navigationController.navigationBarHidden;
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation{
    return UIStatusBarAnimationFade;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = self.shouldHideNavigationBarWhenDisappear;
}

- (void)initData{
    for (NSString *imageUrl in self.imagesArr) {
        NSInteger index = [self.imagesArr indexOfObject:imageUrl];
        LWBrowerItemModel *model = [LWBrowerItemModel new];
        model.highImage = imageUrl;
        model.newFrame = [self getNewFrameFromOriginalFram:CGRectFromString(self.framesArr[index])];
        model.originalFrame = CGRectFromString(self.framesArr[index]);
        model.thumbnailImage = imageUrl;
        model.isSelected = (_currentIndex == index);
        model.showStyle = self.showStyle;
        [self.dataArray addObject:model];
    }
    [self.collectView reloadData];
    self.pager.numberOfPages = self.dataArray.count;
    self.pager.currentPage = self.currentIndex;
}

- (UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kLWScreenWidth, kLWScreenHeight)];
    }
    return _bgImageView;
}

- (UICollectionView *)collectView{
    if (!_collectView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kLWScreenWidth, kLWScreenHeight) collectionViewLayout:layout];
        _collectView.pagingEnabled = YES;
        _collectView.dataSource = self;
        _collectView.delegate = self;
        _collectView.bounces = NO;
        _collectView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        [_collectView registerNib:[UINib nibWithNibName:@"LWImageCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"cell"];
        [_collectView setContentOffset:CGPointMake(kLWScreenWidth * _currentIndex, 0)];
    }
    return _collectView;
}

- (UIPageControl *)pager{
    if (!_pager) {
        _pager = [[UIPageControl alloc] init];
        [_pager addTarget:self action:@selector(pageDidClick:) forControlEvents:UIControlEventValueChanged];
        _pager.pageIndicatorTintColor = [UIColor darkGrayColor];
        _pager.currentPageIndicatorTintColor = [UIColor whiteColor];
    }
    return _pager;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

- (void)addPlaceView{
    UIView *whiteView = [UIView new];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.frame = [self.superView convertRect:CGRectFromString(self.framesArr[self.currentIndex]) toView:self.view];
    [self.view insertSubview:whiteView aboveSubview:self.bgImageView];
    
}

- (void)setupUI{
    if (self.screenImage) {
        self.bgImageView.image = self.screenImage;
        [self.view addSubview:self.bgImageView];
    }
    self.pager.frame = CGRectMake(0,kLWScreenHeight - 40,kLWScreenWidth,30);
    
    [self.view addSubview:self.collectView];
    [self.view addSubview:self.pager];
    
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    self.panGesture.delegate = self;
    [self.view addGestureRecognizer:self.panGesture];
    self.panGesture.maximumNumberOfTouches = 1;
//    [self.panGesture requireGestureRecognizerToFail:self.collectView.panGestureRecognizer];
}

- (void)panAction:(UIGestureRecognizer *)gesture{
    NSLog(@"self.view  pan");
    LWImageCollectionViewCell *cell = [self.collectView.visibleCells firstObject];
    [cell processPanGesture:gesture];
    
}
- (void)pageDidClick:(UIPageControl*)pager{
    [self.collectView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:pager.currentPage inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}
- (CGRect )getNewFrameFromOriginalFram:(CGRect)originalFrame{
    if (self.shouldPop && self.framesArr) {
        CGRect newFrame = [self.superView convertRect:originalFrame toView:[[[UIApplication sharedApplication] delegate] window]];
        return newFrame;
    }else{
        return CGRectZero;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imagesArr.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LWImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.didDismiss = ^(LWBrowerItemModel *model){
        [self prepareDismissWithModel:model];
        !_didmissBlock ? : _didmissBlock(_currentIndex);

    };
    cell.willDismiss = ^(LWBrowerItemModel *model){
        self.pager.hidden = YES;
        !_willDismissBlock ? : _willDismissBlock(_currentIndex);

    };
    cell.willPopCell =^(LWBrowerItemModel *model){
//        [self addPlaceView];
    };
    cell.model = self.dataArray[indexPath.row];

    return cell;
}

- (void)prepareDismissWithModel:(LWBrowerItemModel *)model{
    [self dismissViewControllerAnimated:NO completion:nil];
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.pager.currentPage = scrollView.contentOffset.x / kLWScreenWidth;
}
#pragma --mark layout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(kLWScreenWidth, kLWScreenHeight);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0,0,0,0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}


@end
