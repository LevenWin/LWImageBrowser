//
//  BXLBrowserImageManager.m
//  iOSClient
//
//  Created by leven on 2017/11/9.
//  Copyright © 2017年 borderxlab. All rights reserved.
//

#import "BXLBrowserImageManager.h"
#import "BXLBrowserImageViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation BXLBrowserImageManager

+ (instancetype)managerInstance{
    return [[self class] new];
}

- (void)show{
    
    if (![self checkIfHasCacheCurrentImage]) {
        return;
    }
    
    [self setDefaultSelected];
    BXLBrowserImageViewController *vc = [[BXLBrowserImageViewController alloc] init];
    vc.dataArr = self.images;
    vc.screenImage = [self screenshot];
    
    [self.inViewController presentViewController:vc animated:NO completion:nil];
}

// 如果没有设定选定的imageModel,则默认第一个
- (void)setDefaultSelected {
    BXLBrowserImageCellModel *selectedModel = nil;
    for (BXLBrowserImageCellModel *item in _images) {
        if (item.isSelected) {
            selectedModel = item;
            break;
        }
    }
    if (!selectedModel) {
        selectedModel = _images.firstObject;
        selectedModel.isSelected = YES;
    }
}

- (BOOL)checkIfHasCacheCurrentImage{
    BXLBrowserImageCellModel *selectedModel = nil;
    for (BXLBrowserImageCellModel *model in self.images) {
        if (model.isSelected) {
            selectedModel = model;
            break;
        }
    }
    
    if (!selectedModel) {
        selectedModel = self.images.firstObject;
    }
    
    if (selectedModel.image
        || [[SDImageCache sharedImageCache] imageFromCacheForKey:selectedModel.thumbImageUrl]
        ||  [[SDImageCache sharedImageCache] imageFromCacheForKey:selectedModel.originalImageUrl]) {
        return YES;
    }else{
        return NO;
    }
}


// 截屏包括 statusbar
- (UIImage *)screenshot
{
    UIImage * image[2];
    UIView * view;
    UIApplication * app = [UIApplication sharedApplication];
    for(int i =0 ;i<2;i++)
    {
        if(i==0)
        {
            view = [app valueForKey:@"_statusBar"];
        }
        else
        {
            view =[app keyWindow];
        }
        UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, [UIScreen mainScreen].scale);
        [view.layer renderInContext:UIGraphicsGetCurrentContext()];
        image[i] = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    UIGraphicsBeginImageContextWithOptions(image[1].size, NO, [UIScreen mainScreen].scale);
    [image[1] drawInRect:CGRectMake(0,0, image[1].size.width, image[1].size.height)];
    [image[0] drawInRect:CGRectMake(0,0, image[0].size.width, image[0].size.height)];
    UIImage *resultingImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
   
    return resultingImage;
}
@end
