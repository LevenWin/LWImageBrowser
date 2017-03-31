//
//  LWBrowerItemModel.h
//  LWImageBrowser
//
//  Created by leven on 2017/3/29.
//  Copyright © 2017年 leven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LWImageBrowserManager.h"
#import <UIKit/UIKit.h>

@interface LWBrowerItemModel : NSObject
@property (nonatomic, strong) NSString *highImage;
@property (nonatomic, strong) NSString *thumbnailImage;
@property (nonatomic, assign) CGRect originalFrame;
@property (nonatomic, assign) CGRect newFrame;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) LWImageBrowserStyle showStyle;
@end
