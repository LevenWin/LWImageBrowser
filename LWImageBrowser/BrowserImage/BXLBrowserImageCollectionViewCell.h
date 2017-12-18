//
//  BXLBrowserImageCollectionViewCell.h
//  iOSClient
//
//  Created by leven on 2017/11/9.
//  Copyright © 2017年 borderxlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXLBrowserImageCellModel.h"

@class BXLBrowserImageCollectionViewCell;

@protocol BXLBrowserImageCollectionViewCellDelegate <NSObject>

- (void)BXLBrowserImageCollectionViewCellDidAnimatedToShow:(BXLBrowserImageCollectionViewCell *)cell;

- (void)BXLBrowserImageCollectionViewCellWillAnimatedToShow:(BXLBrowserImageCollectionViewCell *)cell;


- (void)BXLBrowserImageCollectionViewCellWillAnimatedToDismss: (BXLBrowserImageCollectionViewCell *)cell;

- (void)BXLBrowserImageCollectionViewCellDidAnimatedToDismss: (BXLBrowserImageCollectionViewCell *)cell;


- (void)BXLBrowserImageCollectionViewCellDidEndHandlePanGesture: (BXLBrowserImageCollectionViewCell *)cell;

@end

@interface BXLBrowserImageCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) BXLBrowserImageCellModel *model;
@property (nonatomic, weak) id<BXLBrowserImageCollectionViewCellDelegate> delegate;

- (void)handlePanGestureAnimation:(UIGestureRecognizer *)panGesture;

@end
