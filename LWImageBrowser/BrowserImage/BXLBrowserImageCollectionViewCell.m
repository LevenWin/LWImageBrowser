//
//  BXLBrowserImageCollectionViewCell.m
//  iOSClient
//
//  Created by leven on 2017/11/9.
//  Copyright © 2017年 borderxlab. All rights reserved.
//

#import "BXLBrowserImageCollectionViewCell.h"
#import "BXLBrowserHeader.h"

@interface BXLBrowserImageCollectionViewCell()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) UIImageView *contentImageView;
@property (nonatomic, strong) UIActivityIndicatorView *progressView;
@property (nonatomic, assign) CGFloat originalScale; // image 放大的 scale
@property (nonatomic, assign) CGPoint originalCenter;
@property (nonatomic, assign) BOOL isAnimating;
@end

@implementation BXLBrowserImageCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    self.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0];
    self.contentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:1];
    [self.contentView addSubview:self.mainScrollView];
    [self.mainScrollView addSubview:self.contentImageView];
    [self.contentView addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
    }];
}

- (void)setModel:(BXLBrowserImageCellModel *)model{
    _model = model;
    [self.mainScrollView setZoomScale:1.0 animated:YES];
    
    if (_model.image) {
        _contentImageView.image = _model.image;
        [self imageHasDownload];
    }else{
        [_progressView startAnimating];
        UIImage *placeholderImage = [self getPlaceholderImage];
        
        if (placeholderImage) {
            self.contentImageView.image = placeholderImage;
            [self imageHasDownload];
        }
        
        [_contentImageView sd_setImageWithURL:[NSURL URLWithString:_model.originalImageUrl]
                             placeholderImage:placeholderImage
                                      options:SDWebImageRetryFailed
                                     progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            
            
        } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            _contentImageView.image = image;
            [_progressView stopAnimating];
            [self imageHasDownload];
        }];
    }
}

- (void)imageHasDownload{
    if (_model.isSelected && !_model.hasAnimatedToShow) {
        [self animateToShow];
    }else{
        [self resetContentSizeAndFrame];
    }
}

- (void)resetContentSizeAndFrame{
    CGSize imageSize = [self getFitImageSize];

    if (CGSizeEqualToSize(imageSize, CGSizeZero)) return;
    
    self.contentImageView.size = imageSize;
    self.contentImageView.center = self.contentView.center;
    self.mainScrollView.contentSize = imageSize;
    
}

- (CGSize)getFitImageSize{
    CGSize imageSize = self.contentImageView.image.size;
    if (CGSizeEqualToSize(imageSize, CGSizeZero)){
        return imageSize;
    }
    CGFloat height = imageSize.height / ( imageSize.width / kBXLScreenWidth) ;
    return CGSizeMake(kBXLScreenWidth, height);
}

- (UIImage *)getPlaceholderImage{
   UIImage *image = [[SDImageCache sharedImageCache] imageFromCacheForKey:_model.thumbImageUrl];
    if (image) {
        return image;
    }else{
        return nil;
    }
}

- (void)animateToShow{
    
     _model.hasAnimatedToShow = YES;

    if ([_delegate respondsToSelector:@selector(BXLBrowserImageCollectionViewCellWillAnimatedToShow:)]) {
        [_delegate BXLBrowserImageCollectionViewCellWillAnimatedToShow:self];
    }
    
    self.contentImageView.frame = _model.smallFrame;
    CGSize imageSize = [self getFitImageSize];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.contentImageView.size = imageSize;
        self.contentImageView.center = self.contentView.center;
    }completion:^(BOOL finished) {
        [self resetContentSizeAndFrame];
        if ([_delegate respondsToSelector:@selector(BXLBrowserImageCollectionViewCellDidAnimatedToShow:)]) {
            [_delegate BXLBrowserImageCollectionViewCellDidAnimatedToShow:self];
        }
    }];
}

- (void)animateToDismss{
    
    if ([_delegate respondsToSelector:@selector(BXLBrowserImageCollectionViewCellWillAnimatedToDismss:)]) {
        [_delegate BXLBrowserImageCollectionViewCellWillAnimatedToDismss:self];
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self.contentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    }];
    
    self.contentImageView.layer.contentsGravity = kCAGravityResizeAspectFill;

    _model.smallFrame = [[UIApplication sharedApplication].delegate.window convertRect:_model.smallFrame toView:_mainScrollView];
    
    [UIView animateWithDuration:0.30 animations:^{
        self.contentImageView.transform = CGAffineTransformMakeScale(1, 1);
        self.contentImageView.frame = _model.smallFrame;
    }completion:^(BOOL finished) {
        if ([_delegate respondsToSelector:@selector(BXLBrowserImageCollectionViewCellDidAnimatedToDismss:)]) {
            [_delegate BXLBrowserImageCollectionViewCellDidAnimatedToDismss:self];
        }
    }];
}

- (void)handlePanGestureAnimation:(UIGestureRecognizer *)panGesture{
    
    static CGPoint panGestureBeginPoint;
    static CGFloat scale = 1;
    
    CGPoint point = [panGesture locationInView:self.mainScrollView];
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        panGestureBeginPoint = point;
        self.originalScale = self.mainScrollView.zoomScale;
        self.originalCenter = self.contentImageView.center;
    }else if (panGesture.state == UIGestureRecognizerStateChanged){
        CGFloat offsetY = (point.y - panGestureBeginPoint.y);
        offsetY = fabs(offsetY);
        scale = self.originalScale - offsetY / kBXLScreenWidth * 0.8 ;
        self.contentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:1 - (self.originalScale - scale)];
       
        scale = scale <= 0.4 ? 0.4 : scale;
        
        CGFloat centerOffsetX = self.originalCenter.x - panGestureBeginPoint.x;
        CGFloat centerOffsetY = self.originalCenter.y - panGestureBeginPoint.y;
        
        centerOffsetX *= (scale / self.originalScale);
        centerOffsetY *= (scale / self.originalScale);

        CGPoint imageNewCenter = CGPointMake(centerOffsetX + point.x, centerOffsetY+point.y);
        
        self.contentImageView.transform = CGAffineTransformMakeScale(scale, scale);
        self.contentImageView.center = imageNewCenter;

    }else if (panGesture.state == UIGestureRecognizerStateEnded
              || panGesture.state == UIGestureRecognizerStateCancelled){
        
        [self didEndPanGesture:scale gesture:(id)panGesture];
    }
}

- (CGFloat)getPanMoveSpeed:(UIPanGestureRecognizer *)panGesture {
    CGPoint point = [panGesture velocityInView:self.mainScrollView];
    return  sqrt(point.x * point.x + point.y * point.y);
}

- (void)didEndPanGesture:(CGFloat)scale gesture:(UIPanGestureRecognizer *)panGesture{
    
    if (scale <= 0.7
        || [self getPanMoveSpeed:panGesture] > 1500) {
        [self animateToDismss];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            self.contentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:1.0 ];
            self.contentImageView.center = self.originalCenter;
            self.contentImageView.transform = CGAffineTransformMakeScale(self.originalScale, self.originalScale);
        }completion:^(BOOL finished) {
            
            if ([_delegate respondsToSelector:@selector(BXLBrowserImageCollectionViewCellDidEndHandlePanGesture:)]) {
                [_delegate BXLBrowserImageCollectionViewCellDidEndHandlePanGesture:self];
            }
            
        }];
    }
}

- (void)doubleTapAction:(UIGestureRecognizer *)doubleTap{
    CGPoint touchPoint = [doubleTap locationInView:self.mainScrollView];
    if (self.mainScrollView.zoomScale <= 1.0) {
        float newscale=2;
        if (self.contentImageView.frame.size.height * 2 <= kBXLScreenHeight) {
            newscale = kBXLScreenHeight / self.mainScrollView.contentSize.height ;
        }
        CGRect zoomRect = [self zoomRectForScale:newscale withCenter:touchPoint];
        [self.mainScrollView zoomToRect:zoomRect animated:YES];
    } else {
        [self.mainScrollView setZoomScale:1.0 animated:YES];
    }
}

- (void)singleTapAction:(UIGestureRecognizer *)singleTap{
    [self.mainScrollView setZoomScale:1.0 animated:YES];
    [self animateToDismss];
}


- (CGPoint)centerOfScrollViewContent:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    CGPoint actualCenter = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                       scrollView.contentSize.height * 0.5 + offsetY);
    return actualCenter;
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.contentImageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    self.contentImageView.center = [self centerOfScrollViewContent:scrollView];
}

- (CGRect)zoomRectForScale:(CGFloat)scale withCenter:(CGPoint)center{
    CGRect zoomRect;
    zoomRect.size.height = [self.mainScrollView frame].size.height / scale;
    zoomRect.size.width = [self.mainScrollView frame].size.width / scale;
    zoomRect.origin.x = center.x - zoomRect.size.width / 2;
    zoomRect.origin.y = center.y - zoomRect.size.height / 2;
    return zoomRect;
}

- (UIScrollView *)mainScrollView{
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kBXLScreenWidth, kBXLScreenHeight)];
        _mainScrollView.minimumZoomScale=1;
        _mainScrollView.maximumZoomScale=3;
        _mainScrollView.clipsToBounds=YES;
        _mainScrollView.delegate=self;
        _mainScrollView.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0];
        UITapGestureRecognizer *doubleTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapAction:)];
        UITapGestureRecognizer *singleTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapAction:)];
        doubleTap.numberOfTapsRequired=2;
        singleTap.numberOfTapsRequired=1;
        [singleTap requireGestureRecognizerToFail:doubleTap];
        [_mainScrollView addGestureRecognizer:singleTap];
        [_mainScrollView addGestureRecognizer:doubleTap];
    
    }
    return _mainScrollView;
}

- (UIActivityIndicatorView *)progressView{
    if (!_progressView) {
        _progressView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _progressView.hidesWhenStopped = YES;
    }
    return _progressView;
}

- (UIImageView *)contentImageView{
    if (!_contentImageView) {
        _contentImageView = [UIImageView new];
        _contentImageView.layer.masksToBounds = YES;
    }
    return _contentImageView;
}

@end
