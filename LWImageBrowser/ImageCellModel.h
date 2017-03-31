//
//  ImageCellModel.h
//  LWImageBrowser
//
//  Created by leven on 2017/3/29.
//  Copyright © 2017年 leven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ImageCellModel : NSObject
@property (nonatomic, strong) NSArray *imgsArr;
@property (nonatomic, assign) CGFloat imgWidth;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, strong) NSArray *framesArr;
@end
