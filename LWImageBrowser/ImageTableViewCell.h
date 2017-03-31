//
//  ImageTableViewCell.h
//  LWImageBrowser
//
//  Created by leven on 2017/3/27.
//  Copyright © 2017年 leven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageCellModel.h"
#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height

static  CGFloat margin = 2;
@interface ImageTableViewCell : UITableViewCell
@property (nonatomic, copy) void (^tapActionBlock) (ImageCellModel* model,NSInteger index,UIView *tapView);
@property (nonatomic, strong) ImageCellModel *model;
- (void)didDisappear;
- (void)willShow;
@end
