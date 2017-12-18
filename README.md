# LWImageBrowser

动态图
![](https://github.com/LevenWin/LWImageBrowser/blob/master/screen.gif)
## 使用方式
```
   [LWImageBrowserManager browserImages:self.dataArr[indexPath.row].imgsArr
                                placeHolderImage:nil
                           currentViewController:self
                                       showStyle:LWImageBrowserStylePop
                                  originalFrames:self.dataArr[indexPath.row].framesArr
                                    currentIndex:index
                                       superView:cell.contentView
                                     willDismiss:^(NSInteger index) {
                                         NSLog(@"dismiss");
            }];

```

## 主要方法
```
//
//  LWImageBrowserManager.h
//  LWImageBrowser
//
//  Created by leven on 2017/3/29.
//  Copyright © 2017年 leven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, LWImageBrowserStyle) {
    LWImageBrowserStylePush   = 1,
    LWImageBrowserStylePop,
    LWImageBrowserStylePresent,
    LWImageBrowserStyleNone,
};


@interface LWImageBrowserManager : NSObject

+ (void)browserImages: (NSArray<NSString*> *) imagesArr
currentViewController: (UIViewController *) currentViewController
       originalFrames: (NSArray<NSString*> *) framesArr
         currentIndex: (NSInteger) currentIndex
            superView: (UIView *) superView;


+ (void)browserImages: (NSArray<NSString*> *) imagesArr
     placeHolderImage: (id)placeHolderImage
currentViewController: (UIViewController *) currentViewController
            showStyle: (LWImageBrowserStyle) showStyle
       originalFrames: (NSArray<NSString*> *) framesArr
         currentIndex: (NSInteger) currentIndex
            superView: (UIView *) superView
              willDismiss: (void(^)(NSInteger)) willDismissBlock;


+ (void)browserImages: (NSArray<NSString*> *) imagesArr
currentViewController: (UIViewController *) currentViewController
       originalFrames: (NSArray<NSString*> *) framesArr
         currentIndex: (NSInteger) currentIndex
            superView: (UIView *) superView
              willDismiss: (void(^)(NSInteger)) willDismissBlock;





@end
```
