//
//  BXLImageCollectionViewCell.h
//  iOSClient
//
//  Created by leven on 2017/11/8.
//  Copyright © 2017年 borderxlab. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BXLImageCollectionViewCell, BXLImageCollectionCellModel;

@protocol BXLImageCollectionViewCellDelegate<NSObject>

@optional
- (void)BXLImageCollectionViewCellDidClickSelectButton:(BXLImageCollectionViewCell *)cell;

- (void)BXLImageCollectionViewCellDidClickDelectButton:(BXLImageCollectionViewCell *)cell;


@end


@interface BXLImageCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *contenImageView;

@property (nonatomic, strong) BXLImageCollectionCellModel *model;
@property (nonatomic, weak) id<BXLImageCollectionViewCellDelegate>delegate;
@end
