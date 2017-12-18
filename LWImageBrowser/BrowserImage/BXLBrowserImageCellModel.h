//
//  BXLBrowserImageCellModel.h
//  iOSClient
//
//  Created by leven on 2017/11/9.
//  Copyright © 2017年 borderxlab. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface BXLBrowserImageCellModel : NSObject

@property (nonatomic, copy) NSString *originalImageUrl;
@property (nonatomic, copy) NSString *thumbImageUrl;
@property (nonatomic, strong) UIImage *image; // 本地image

@property (nonatomic, assign) CGRect smallFrame;

@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) BOOL hasAnimatedToShow;

@end
