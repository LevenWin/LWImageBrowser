//
//  BXLImageCollectionView.h
//  iOSClient
//
//  Created by leven on 2017/11/8.
//  Copyright © 2017年 borderxlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXLImageCollectionCellModel.h"

@protocol BXLImageCollectionViewDelegate<NSObject>

@optional
- (void)BXLImageCollectionViewDidClickCellAtIndexPath:(NSIndexPath *)indexPath;
- (void)BXLImageCollectionViewDidClickDeleteButton:(BXLImageCollectionCellModel *)model;

@end

@interface BXLImageCollectionView : UIView

@property (nonatomic, strong, readonly) UICollectionView *collectView;
@property (nonatomic, weak) id<BXLImageCollectionViewDelegate> imageCollectionDelegate;
@property (nonatomic, strong) NSArray <BXLImageCollectionCellModel *>*dataArray;

@property (nonatomic, assign) CGFloat viewWidth;

@property (nonatomic, assign) NSUInteger cellRowCount;
@property (nonatomic, assign) CGFloat minimumInteritemSpacing;
@property (nonatomic, assign) CGFloat minimumLineSpacing;
@property (nonatomic, assign) UIEdgeInsets insetForSection;

@property (nonatomic, assign) CGSize cellSize; //如果设置了 cellRowCount，此值可以不设置。但是cellRowCount可以很大，需设定此值

- (CGFloat)getContainerHeight;

@end
