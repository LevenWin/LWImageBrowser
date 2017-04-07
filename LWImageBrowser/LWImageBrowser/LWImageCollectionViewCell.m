//
//  LWImageCollectionViewCell.m
//  LWImageBrowser
//
//  Created by leven on 2017/3/29.
//  Copyright © 2017年 leven. All rights reserved.
//

#import "LWImageCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#define kLWScreenWidth [UIScreen mainScreen].bounds.size.width
#define kLWScreenHeight [UIScreen mainScreen].bounds.size.height
@interface LWImageCollectionViewCell()<UIScrollViewDelegate>{
    
}
@property (nonatomic, assign) CGSize imageSize;
@property (strong, nonatomic) IBOutlet UIScrollView *scr;
@property (strong, nonatomic) IBOutlet UIImageView *contentImage;

@property (nonatomic, assign) CGPoint imgCenterWhenPanBegin;

@end

@implementation LWImageCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.scr.minimumZoomScale=1;
    self.scr.maximumZoomScale=3;
    self.scr.clipsToBounds=YES;
    self.scr.delegate=self;
    self.scr.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0];;
    self.contentImage.contentMode=UIViewContentModeScaleAspectFit;
    ;
    self.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0];
    self.contentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.scr.frame = CGRectMake(0, 0, kLWScreenWidth, kLWScreenHeight);
        self.contentImage.frame = CGRectMake(0, 0, kLWScreenWidth, kLWScreenHeight);
        self.scr.contentSize = CGSizeZero;
    });
    _imageSize = CGSizeZero;
    _model = nil;
    [self.scr setZoomScale:1.0 animated:NO]; //还原
    
    UITapGestureRecognizer *doubleTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapAction:)];
    UITapGestureRecognizer *singleTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapAction:)];
    doubleTap.numberOfTapsRequired=2;
    singleTap.numberOfTapsRequired=1;
    [singleTap requireGestureRecognizerToFail:doubleTap];
    [self addGestureRecognizer:singleTap];
    [self addGestureRecognizer:doubleTap];
    
//    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
//    pan.delegate = self;
//    [self addGestureRecognizer:pan];
//    [pan requireGestureRecognizerToFail:self.scr.panGestureRecognizer];
//    self.scr.panGestureRecognizer.delegate = self;

}

- (void)setModel:(LWBrowerItemModel *)model{
    _model = model;
    self.imageSize = CGSizeZero;
    self.scr.zoomScale=1;
    self.userInteractionEnabled=NO;
    if (self.model.isSelected) {
        self.contentImage.hidden = YES;
        [self showAnimation];
        self.model.isSelected = NO;
    }else{
        self.contentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:1];
    }
    [self.contentImage sd_setImageWithURL:[NSURL URLWithString:self.model.highImage]  placeholderImage:nil options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            self.userInteractionEnabled=YES;
            [self adjusContentSize:image.size];
        }
        
    }];
}

- (void)showAnimation{
    UIImageView *image = [[UIImageView alloc] init];
    image.contentMode = UIViewContentModeScaleAspectFit;
    image.layer.masksToBounds = YES;
    [image sd_setImageWithURL:[NSURL URLWithString:self.model.highImage]];
    if (self.model.showStyle == LWImageBrowserStylePop) {
        image.frame = self.model.newFrame;
        [self.contentView addSubview:image];
        
        !_willPopCell ? :_willPopCell(self.model);
        
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            image.frame = CGRectMake(0, 0, kLWScreenWidth, kLWScreenHeight);
            self.contentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:1];
        } completion:^(BOOL finished) {
            self.contentImage.hidden = NO;
            [image removeFromSuperview];
        }];
        
    }else if (self.model.showStyle == LWImageBrowserStyleNone){
        image.frame = CGRectMake(0, 0, kLWScreenWidth, kLWScreenHeight);
        image.alpha = 0;
        [self.contentView addSubview:image];
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.contentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:1];
            image.alpha = 1;
        } completion:^(BOOL finished) {
            self.contentImage.hidden = NO;
            [image removeFromSuperview];
        }];
    }
}
-(void)adjusContentSize:(CGSize)size{
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat scale = screenW / size.width;
    CGFloat height = scale * size.height;
    size = CGSizeMake(screenW, height);
    if (!CGSizeEqualToSize(self.imageSize, CGSizeZero)) {
        return;
    }else{
        self.imageSize = size;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        self.contentImage.frame = [self getImageActualFrame:size];
        self.scr.contentSize = self.contentImage.frame.size;
    });
    NSLog(@"%@",NSStringFromCGSize(self.contentImage.frame.size));
    NSLog(@"%@",NSStringFromCGSize(self.scr.contentSize));

}
- (CGRect)getImageActualFrame:(CGSize)imageSize {
    CGFloat x = 0;
    CGFloat y = 0;
    
    if (imageSize.height < [UIScreen mainScreen].bounds.size.height) {
        y = ([UIScreen mainScreen].bounds.size.height - imageSize.height) / 2;
    }
    return CGRectMake(x, y, imageSize.width, imageSize.height);
}
-(void)singleTapAction:(UIGestureRecognizer*)gesture{
        [self.scr setZoomScale:1 animated:NO];
    
        [self dismiss];

}
- (void)dismiss{

    !_willDismiss ? : _willDismiss(self.model);
    
//    CGFloat height=(kLWScreenWidth/self.contentImage.image.size.width)*self.contentImage.image.size.height;
   
    UIImageView *image = [[UIImageView alloc] initWithFrame: self.contentImage.frame];
    image.image = self.contentImage.image;
    CGRect frame = [self.scr convertRect:self.contentImage.frame toView:self.contentView];
    image.frame = frame;
    [self.contentView addSubview:image];
    image.layer.masksToBounds = YES;
    image.layer.contentsGravity = kCAGravityResizeAspectFill;
    self.contentImage.hidden = YES;
    if (self.model.showStyle == LWImageBrowserStylePop && !CGRectEqualToRect(self.model.newFrame, CGRectZero)) {
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            image.frame = self.model.newFrame;
            self.contentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        } completion:^(BOOL finished) {
            if (self.didDismiss) {
                self.didDismiss(self.model);
            }
//            [image removeFromSuperview];

        }];

    }else if (self.model.showStyle == LWImageBrowserStyleNone){
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            image.alpha = 0;
            self.contentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        } completion:^(BOOL finished) {
            if (self.didDismiss) {
                self.didDismiss(self.model);
            }
//            [image removeFromSuperview];

        }];

    }else{
        if (self.didDismiss) {
            self.didDismiss(self.model);
        }
    }
   
}

-(void)doubleTapAction:(UIGestureRecognizer*)gesture{
        CGPoint touchPoint = [gesture locationInView:self.scr];
        if (self.scr.zoomScale <= 1.0) {
            float newscale=2;
            if (self.contentImage.frame.size.height * 2 >= kLWScreenHeight) {
                newscale = kLWScreenHeight / self.scr.contentSize.height ;
            }
            CGRect zoomRect = [self zoomRectForScale:newscale withCenter:touchPoint];
            NSLog(@"zoomRect:%@",NSStringFromCGRect(zoomRect));
            [self.scr zoomToRect:zoomRect animated:YES];//重新定义其cgrect的x和y值
        } else {
            [self.scr setZoomScale:1.0 animated:YES]; //还原
        }
    
}

- (void)processPanGesture:(UIGestureRecognizer *)gesture{
    [self panAction:gesture];
}

- (void)panAction:(UIGestureRecognizer *)pan{
    static CGPoint panGestureBeginPoint;
    static CGFloat scale = 1;
    CGPoint point = [pan locationInView:pan.view];
    if (pan.state == UIGestureRecognizerStateBegan) {
        panGestureBeginPoint = point;
        self.imgCenterWhenPanBegin = self.scr.center;
        self.scr.layer.masksToBounds = NO;
        self.scr.userInteractionEnabled = NO;
    }else if (pan.state == UIGestureRecognizerStateChanged){
        CGFloat offsetY = (point.y - panGestureBeginPoint.y);
        offsetY = offsetY > 0 ? offsetY : -offsetY;
        scale = 1.0 - offsetY / kLWScreenWidth * 0.8;
        self.contentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:scale*1.2];
        self.scr.center = CGPointMake(self.imgCenterWhenPanBegin.x + (point.x - panGestureBeginPoint.x), self.imgCenterWhenPanBegin.y + (point.y - panGestureBeginPoint.y));
        if (scale >= 0.4) {
            self.scr.transform = CGAffineTransformMakeScale(scale, scale );
        }else{
            self.scr.transform = CGAffineTransformMakeScale(0.4, 0.4);

        }
    }else if (pan.state == UIGestureRecognizerStateEnded){
        [self didEndPanGesture:scale];
    }
    
}
- (void)didEndPanGesture:(CGFloat)scale{
    if (scale <= 0.7) {
        [self dismiss];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            self.contentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:1.0 ];
            self.scr.center = self.imgCenterWhenPanBegin;
            self.scr.transform = CGAffineTransformMakeScale(1, 1);
        }completion:^(BOOL finished) {
            self.scr.layer.masksToBounds = YES;
            self.scr.userInteractionEnabled = YES;
        }];
    }
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
    return self.contentImage;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    self.contentImage.center = [self centerOfScrollViewContent:scrollView];
}
- (CGRect)zoomRectForScale:(CGFloat)scale withCenter:(CGPoint)center{
    CGRect zoomRect;
    zoomRect.size.height = [self.scr frame].size.height / scale;
    zoomRect.size.width = [self.scr frame].size.width / scale;
    zoomRect.origin.x = center.x - zoomRect.size.width / 2;
    zoomRect.origin.y = center.y - zoomRect.size.height / 2;
    return zoomRect;
}

#pragma mark  gesture delegate 


@end
