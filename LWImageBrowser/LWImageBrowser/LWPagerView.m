//
//  LWPagerView.m
//  CacheWebImage
//
//  Created by leven on 2017/4/10.
//  Copyright © 2017年 leven. All rights reserved.
//

#import "LWPagerView.h"
static const CGFloat maxCount = 7;
@interface LWPagerView ()
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UILabel *pageLab;
@end
@implementation LWPagerView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}
- (void)setTotalCount:(NSInteger)totalCount{
    _totalCount = totalCount;
    if (_totalCount > maxCount) {
        [self.pageControl removeFromSuperview];
        [self addSubview:self.pageLab];
    }else{
        [self.pageLab removeFromSuperview];
        [self addSubview:self.pageControl];
    }
    self.pageControl.numberOfPages = totalCount;
}

- (void)setCurrentPage:(NSInteger)currentPage{
    _currentPage = currentPage;
    self.pageControl.currentPage = _currentPage;
    self.pageLab.text = [NSString stringWithFormat:@"%ld/%ld",_currentPage + 1,_totalCount];
    
}
- (UILabel *)pageLab{
    if (!_pageLab) {
        _pageLab = [[UILabel alloc] initWithFrame:self.bounds];
        _pageLab.textAlignment = NSTextAlignmentCenter;
        _pageLab.font = [UIFont systemFontOfSize:17];
        _pageLab.textColor = [UIColor whiteColor];
        _pageLab.userInteractionEnabled = NO;
    }
    return _pageLab;
}
- (UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:self.bounds];
        [_pageControl addTarget:self action:@selector(pageDidClick:) forControlEvents:UIControlEventValueChanged];
        _pageControl.pageIndicatorTintColor = [UIColor darkGrayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    }
    return _pageControl;
}
- (void)pageDidClick:(UIPageControl*)pager{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pagerDidClickAtIndex:)]) {
        [self.delegate pagerDidClickAtIndex:pager.currentPage];
    }
}

- (void)initUI{
    [self addSubview:self.pageLab];
    [self addSubview:self.pageControl];
}

@end
