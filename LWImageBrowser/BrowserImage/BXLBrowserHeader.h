//
//  BXLBrowserHeader.h
//  LWImageBrowser
//
//  Created by leven on 2018/3/14.
//  Copyright © 2018年 leven. All rights reserved.
//

#ifndef BXLBrowserHeader_h
#define BXLBrowserHeader_h

#define kBXLScreenWidth [UIScreen mainScreen].bounds.size.width
#define kBXLScreenHeight [UIScreen mainScreen].bounds.size.height
#define kBXLIsIphoneX  ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#endif /* BXLBrowserHeader_h */
