//
//  LWPagerView.h
//  CacheWebImage
//
//  Created by leven on 2017/4/10.
//  Copyright © 2017年 leven. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LWPagerViewDelegate <NSObject>
- (void)pagerDidClickAtIndex:(NSInteger)currentIndex;
@end
@interface LWPagerView : UIView
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, weak) id<LWPagerViewDelegate> delegate;
@end
