//
//  BXLImageCollectionCellModel.h
//  iOSClient
//
//  Created by leven on 2017/11/8.
//  Copyright © 2017年 borderxlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface BXLImageCollectionCellModel : NSObject

@property (nonatomic, copy) NSString *imageUrl;

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) PHAsset *asset;

@property (nonatomic, assign) BOOL ifShowDeleteButton; // 删除按钮
@property (nonatomic, assign) BOOL ifShowSelectButton; //选中按钮

@property (nonatomic, assign) BOOL ifSelected;

@property (nonatomic, assign) BOOL isImageSelectorImage; // 选择照片的image
@end

