//
//  LWImageBrowserManager.m
//  LWImageBrowser
//
//  Created by leven on 2017/3/29.
//  Copyright © 2017年 leven. All rights reserved.
//

#import "LWImageBrowserManager.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "LWImageBrowserViewController.h"
@interface LWImageBrowserManager()
@property (nonatomic, strong) UIViewController *currentViewController;
@property (nonatomic, strong) NSArray<NSString *> *imagesArr;
@property (nonatomic, strong) NSArray<NSString *> *framesArr;

@property (nonatomic, assign) LWImageBrowserStyle showStyle;
@property (nonatomic, strong) id placeHolderImage;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) UIView *superView;
@property (nonatomic, copy) void(^didmissBlock)(NSInteger index);
@property (nonatomic, copy) void(^willDismissBlock)(NSInteger index);

@end

@implementation LWImageBrowserManager
+ (void)browserImages: (NSArray<NSString*> *) imagesArr
currentViewController: (UIViewController *) currentViewController
       originalFrames: (NSArray<NSString*> *) framesArr
         currentIndex: (NSInteger) currentIndex
            superView: (UIView *) superView{
    [self browserImages:imagesArr
       placeHolderImage:nil
  currentViewController:currentViewController
              showStyle:LWImageBrowserStylePop
         originalFrames:framesArr
           currentIndex:currentIndex
              superView:superView
                willDismiss:nil];

}


+ (void)browserImages:(NSArray<NSString*> *)imagesArr
currentViewController:(UIViewController *)currentViewController
       originalFrames:(NSArray<NSString *> *)framesArr
         currentIndex: (NSInteger) currentIndex
            superView: (UIView *) superView
              willDismiss:(void (^)(NSInteger))willDismissBlock{
    [self browserImages:imagesArr
       placeHolderImage:nil
  currentViewController:currentViewController
              showStyle:LWImageBrowserStylePop
         originalFrames:framesArr
           currentIndex:currentIndex
              superView:superView
                willDismiss:willDismissBlock];
}

+ (void)browserImages:(NSArray<NSString*> *)imagesArr
     placeHolderImage:(id)placeHolderImage
currentViewController:(UIViewController *)currentViewController
            showStyle:(LWImageBrowserStyle)showStyle
       originalFrames:(NSArray<NSString *> *)framesArr
         currentIndex: (NSInteger) currentIndex
            superView: (UIView *) superView
              willDismiss:(void (^)(NSInteger))willDismissBlock{
    LWImageBrowserManager *manager = [LWImageBrowserManager new];
    manager.imagesArr = imagesArr;
    manager.currentViewController = currentViewController;
    manager.placeHolderImage = placeHolderImage;
    manager.showStyle = showStyle;
    manager.currentIndex = currentIndex;
    manager.framesArr = framesArr;
    manager.superView = superView;
    manager.willDismissBlock =willDismissBlock;
    [manager checkPlaceHolderImage];
    [manager prepareDownLoad];
    [manager showBrowser];
}



- (void)showBrowser{
    LWImageBrowserViewController *vc = [[LWImageBrowserViewController alloc] init];
    vc.currentIndex = self.currentIndex;
    vc.imagesArr = self.imagesArr;
    vc.currentViewController = self.currentViewController;
    vc.showStyle = self.showStyle;
    vc.didmissBlock = self.didmissBlock;
    vc.willDismissBlock = self.willDismissBlock;
    switch (self.showStyle) {
        case LWImageBrowserStylePop:
            vc.shouldPop = YES;
            vc.framesArr = self.framesArr;
            vc.superView = self.superView;
        case LWImageBrowserStyleNone:
            vc.screenImage = [self getScreentImage];
            [self.currentViewController presentViewController:vc animated:NO completion:nil];
            break;
        case LWImageBrowserStylePush:
            if (self.currentViewController.navigationController) {
                [self.currentViewController.navigationController pushViewController:vc animated:YES];
            }
            break;
        case LWImageBrowserStylePresent:
            [self.currentViewController presentViewController:vc animated:YES completion:nil];
            break;
        default:
            break;
    }
}
- (void)prepareDownLoad{
    NSMutableArray *prepareDownLoadImages = [NSMutableArray new];
    [prepareDownLoadImages addObject:self.imagesArr[_currentIndex]];
    if (self.imagesArr.count > _currentIndex + 1  ) {
            [prepareDownLoadImages addObject:self.imagesArr[_currentIndex + 1]];
    }
    if (_currentIndex - 1 >= 0) {
        [prepareDownLoadImages addObject:self.imagesArr[_currentIndex - 1]];
    }
    
    for (NSString *imageString in self.imagesArr) {
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:imageString] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:nil];
    }
    
}

- (void)checkPlaceHolderImage{
    if ([self.placeHolderImage isKindOfClass:[NSArray class]]) {
       
    }
}

- (UIImage *)getScreentImage{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(CGRectGetWidth(self.currentViewController.view.frame), CGRectGetHeight(self.currentViewController.view.frame)), NO, 1);
    [self.currentViewController.view
    drawViewHierarchyInRect:CGRectMake(0, 0,CGRectGetWidth(self.currentViewController.view.frame), CGRectGetHeight(self.currentViewController.view.frame))
     afterScreenUpdates:NO];
    UIImage*snapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snapshot;
}

@end
