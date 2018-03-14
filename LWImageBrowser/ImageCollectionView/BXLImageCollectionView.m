//
//  BXLImageCollectionView.m
//  iOSClient
//
//  Created by leven on 2017/11/8.
//  Copyright © 2017年 borderxlab. All rights reserved.
//

#import "BXLImageCollectionView.h"
#import "BXLImageCollectionViewCell.h"
#import "Masonry.h"

@interface BXLImageCollectionView()<
BXLImageCollectionViewCellDelegate,
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout>


@property (nonatomic, strong) UICollectionView *collectView;

@end
@implementation BXLImageCollectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self ps_initUI];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self ps_initUI];
}

- (CGFloat)getContainerHeight{
    NSUInteger lineCount = _dataArray.count /_cellRowCount;
    lineCount += (_dataArray.count % _cellRowCount) ? 1 : 0;
    
    CGFloat height = _insetForSection.top + _insetForSection.bottom + lineCount * _cellSize.height + (lineCount - 1) * _minimumLineSpacing;
    return height;
}

#pragma - mark UI
- (void)ps_initUI{
    
    _viewWidth = kScreenWidth;
    _cellRowCount = 4;
    _minimumLineSpacing = 2;
    _minimumInteritemSpacing = 10;
    _insetForSection = UIEdgeInsetsMake(0, 2, 0, 10);
    _cellSize = [self generateCellSize];
    
    [self addSubview:self.collectView];
    [self.collectView reloadData];
    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints{
    [super updateConstraints];
    
    [self.collectView setNeedsLayout];
    [self.collectView layoutIfNeeded];

   
    [_collectView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
        make.height.mas_equalTo([self getContainerHeight]);
        make.height.priorityHigh();
    }];
}



#pragma - mark Data
- (void)setDataArray:(NSArray<BXLImageCollectionCellModel *> *)dataArray{
    _dataArray = dataArray;
    [self.collectView reloadData];
}

- (CGSize)generateCellSize{
    
    CGFloat width = (_viewWidth- (_insetForSection.left + _insetForSection.right) - (_cellRowCount - 1) * _minimumInteritemSpacing) / _cellRowCount;
    if (width < 0) {
        width = 0;
    }
    return CGSizeMake(width, width);
}

- (void)setMinimumLineSpacing:(CGFloat)minimumLineSpacing{
    _minimumLineSpacing = minimumLineSpacing;
    _cellSize = [self generateCellSize];
}

- (void)setMinimumInteritemSpacing:(CGFloat)minimumInteritemSpacing{
    _minimumInteritemSpacing = minimumInteritemSpacing;
    _cellSize = [self generateCellSize];
}

- (void)setInsetForSection:(UIEdgeInsets)insetForSection{
    _insetForSection = insetForSection;
    _cellSize = [self generateCellSize];
}

#pragma - mark Action

#pragma - mark Delegate
- (void)BXLImageCollectionViewCellDidClickDelectButton:(BXLImageCollectionViewCell *)cell{
    NSIndexPath *indexPath = [self.collectView indexPathForCell:cell];
    if ([_imageCollectionDelegate respondsToSelector:@selector(BXLImageCollectionViewDidClickDeleteButton:)]) {
        [_imageCollectionDelegate BXLImageCollectionViewDidClickDeleteButton:self.dataArray[indexPath.row]];
    }
}
#pragma - CollectionView Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BXLImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([BXLImageCollectionViewCell class]) forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if ([_imageCollectionDelegate respondsToSelector:@selector(BXLImageCollectionViewDidClickCellAtIndexPath:)]) {
        [_imageCollectionDelegate BXLImageCollectionViewDidClickCellAtIndexPath:indexPath];
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return _minimumLineSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return _minimumInteritemSpacing;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return self.insetForSection;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.cellSize;
}

#pragma -mark Other
- (UICollectionView *)collectView{
    if (!_collectView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _collectView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectView.delegate = self;
        _collectView.dataSource = self;
        _collectView.scrollEnabled = NO;
        _collectView.backgroundColor = [UIColor whiteColor];
        [_collectView registerNib:[UINib nibWithNibName:@"BXLImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([BXLImageCollectionViewCell class])];
        [self addSubview:_collectView];
    }
    return _collectView;
}

+ (BOOL)requiresConstraintBasedLayout{
    return YES ; //重写这个方法 若视图基于自动布局的
}
@end
