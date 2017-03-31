//
//  LWImageCollectionViewCell.h
//  LWImageBrowser
//
//  Created by leven on 2017/3/29.
//  Copyright © 2017年 leven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LWBrowerItemModel.h"

@interface LWImageCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) LWBrowerItemModel *model;
@property (nonatomic,copy)void(^willDismiss)(LWBrowerItemModel * model);
@property (nonatomic,copy)void(^didDismiss)(LWBrowerItemModel * model);
@property (nonatomic,copy)void(^imgDidDownload)(UIImage* ,LWBrowerItemModel *model);
@property (nonatomic,copy)void(^willPopCell)(LWBrowerItemModel * model);

- (void)processPanGesture:(UIGestureRecognizer *)gesture;

@end

