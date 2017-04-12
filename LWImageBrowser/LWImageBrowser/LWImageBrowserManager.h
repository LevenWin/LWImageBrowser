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
            superView: (UIView *) superView
    actionSelectClick:(void (^)(UIButton *btn ,NSInteger index))selectorClick;


+ (void)browserImages: (NSArray<NSString*> *) imagesArr
     placeHolderImage: (id)placeHolderImage
currentViewController: (UIViewController *) currentViewController
            showStyle: (LWImageBrowserStyle) showStyle
       originalFrames: (NSArray<NSString*> *) framesArr
         currentIndex: (NSInteger) currentIndex
            superView: (UIView *) superView
    actionSelectClick: (void (^)(UIButton *btn ,NSInteger index))selectorClick
          willDismiss: (void(^)(NSInteger)) willDismissBlock;


+ (void)browserImages: (NSArray<NSString*> *) imagesArr
currentViewController: (UIViewController *) currentViewController
       originalFrames: (NSArray<NSString*> *) framesArr
         currentIndex: (NSInteger) currentIndex
            superView: (UIView *) superView
    actionSelectClick: (void (^)(UIButton *btn ,NSInteger index))selectorClick
          willDismiss: (void(^)(NSInteger)) willDismissBlock;





@end
