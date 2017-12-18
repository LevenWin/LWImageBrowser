//
//  BXLBrowserImageManager.h
//  iOSClient
//
//  Created by leven on 2017/11/9.
//  Copyright © 2017年 borderxlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BXLBrowserImageCellModel.h"

@interface BXLBrowserImageManager : NSObject

@property (nonatomic, strong) NSArray <BXLBrowserImageCellModel *>* images;
@property (nonatomic, weak) UIViewController *inViewController;

+ (instancetype)managerInstance;

- (void)show;

@end
