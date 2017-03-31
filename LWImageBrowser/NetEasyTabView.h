//
//  NetEasyTabView.h
//  NetEasyTabView
//
//  Created by mac on 17/3/21.
//  Copyright © 2017年 Leven. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^TabItemClickHandle)(NSInteger index,NSString *title);

@interface NetEasyTabView : UIView
@property (nonatomic, strong) NSArray *titlesArray;
@property (nonatomic ,copy) TabItemClickHandle handle;
@property (nonatomic, assign) NSInteger currentIndex;
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titlesArray bgColor:(UIColor*)bgColor sliderColor:(UIColor *)sliderColor clickBlock:(TabItemClickHandle)handle;
@end
