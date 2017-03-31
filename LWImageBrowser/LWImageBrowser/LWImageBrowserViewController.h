//
//  LWImageBrowserViewController.h
//  LWImageBrowser
//
//  Created by leven on 2017/3/29.
//  Copyright © 2017年 leven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LWImageBrowserManager.h"
@protocol LWImageBrowserViewControllerDelegate <NSObject>

- (NSInteger)numberOfImages;

@end


@interface LWImageBrowserViewController : UIViewController
@property (nonatomic, assign) BOOL shouldPop;
@property (nonatomic, strong) UIImage *screenImage;
@property (nonatomic, strong) UIViewController *currentViewController;
@property (nonatomic, strong) NSArray<NSString *> *imagesArr;
@property (nonatomic, strong) NSArray<NSString *> *framesArr;
@property (nonatomic, strong) id placeHolderImage;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) UIView *superView;
@property (nonatomic, assign) LWImageBrowserStyle showStyle;

@property (nonatomic, copy) void(^didmissBlock)(NSInteger index);
@property (nonatomic, copy) void(^willDismissBlock)(NSInteger index);

@end
