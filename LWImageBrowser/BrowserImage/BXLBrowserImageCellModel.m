//
//  BXLBrowserImageCellModel.m
//  iOSClient
//
//  Created by leven on 2017/11/9.
//  Copyright © 2017年 borderxlab. All rights reserved.
//

#import "BXLBrowserImageCellModel.h"

@implementation BXLBrowserImageCellModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        _dragToDismiss = YES;
    }
    return self;
}
@end
