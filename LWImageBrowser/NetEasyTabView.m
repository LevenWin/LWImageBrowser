//
//  NetEasyTabView.m
//  NetEasyTabView
//
//  Created by mac on 17/3/21.
//  Copyright © 2017年 Leven. All rights reserved.
//

#import "NetEasyTabView.h"

#define NetEasyTabItemHeight (self.frame.size.height - NetEasyTabTopMargin * 2)
#define NetEasyTabItemWidth 65
#define NetEasyTabItemMargin 4
#define NetEasyTabTopMargin 5

#define SCREEN_WIDTH     [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT    [UIScreen mainScreen].bounds.size.height
@interface TabContainerView : UIView <CAAnimationDelegate>
{
    CGPoint _beginPoint;
    CGPoint _lastPoint;
    CGPoint _endPoint;
    BOOL _beginIn;
    BOOL _isAnimation;
    BOOL _isEndTouch;
    NSInteger _currentIndex;
    CGFloat _animationOffset;
    CGFloat _lastOffset;
    BOOL _isInBeginAnimation;
    NSInteger _touchTapIndex;
}
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, copy) TabItemClickHandle handle;
@property (nonatomic ,strong) UIColor *bgColor;
@property (nonatomic ,strong) UIColor *slideColor;

@property (nonatomic, strong) UIFont *defaultFont;
@property (nonatomic, strong) UIView *midlleView;
@property (nonatomic, strong) CALayer *sliderLayer;
@property (nonatomic, strong) NSArray *titlesArray;
@end

@implementation TabContainerView
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titlesArray bgColor:(UIColor*)bgColor sliderColor:(UIColor *)sliderColor clickBlock:(TabItemClickHandle)handle{
    if (self = [super initWithFrame:frame]) {
        self.bgColor =bgColor;
        self.slideColor = sliderColor;
        self.handle = handle;
        self.titlesArray = titlesArray;
    }
    return self;
}

- (void)setTitlesArray:(NSArray *)titlesArray {
    _titlesArray = titlesArray;
    [self setupUI];
}

- (void)setupUI{

    self.backgroundColor = self.slideColor;
    self.layer.borderColor = self.slideColor.CGColor;
    for (NSString *str in self.titlesArray) {
        NSAssert([str isKindOfClass:[NSString class]], @"title must be NSString!");
        UILabel *bottomLab = [UILabel new];
        bottomLab.text = str;
        bottomLab.textColor = self.bgColor;
        bottomLab.font = self.defaultFont;
        bottomLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:bottomLab];
        bottomLab.frame = [self setTabFrameWithIndex:[self.titlesArray indexOfObject:str]];
    }
    self.midlleView = [[UIView alloc] initWithFrame:self.bounds];
    self.midlleView.userInteractionEnabled = NO;
    self.midlleView.layer.masksToBounds = YES;
    self.midlleView.backgroundColor = self.bgColor;
    
    [self addSubview:self.midlleView];
    for (NSString *str in self.titlesArray) {
        UILabel *topLab = [UILabel new];
        topLab.text = str;
        topLab.textColor = self.slideColor;
        topLab.font = self.defaultFont;
        topLab.textAlignment = NSTextAlignmentCenter;
        [self.midlleView addSubview:topLab];
        topLab.frame = [self setTabFrameWithIndex:[self.titlesArray indexOfObject:str]];
    }
   
    _currentIndex = 0;
    [self sliderMaskLayerWithOffset:0 antimation:NO];
}

- (CGRect )setTabFrameWithIndex:(NSInteger)index{
    CGFloat coorDinateX = (NetEasyTabItemWidth + NetEasyTabItemMargin) * index;
    return  CGRectMake(coorDinateX, 0, NetEasyTabItemWidth, self.frame.size.height);
}

-(void )sliderMaskLayerWithOffset:(CGFloat)offset antimation:(BOOL) animation{

    CGFloat height = self.frame.size.height;
    
    CGFloat radius = height/2;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, (NetEasyTabItemWidth +NetEasyTabItemMargin) * self.titlesArray.count - NetEasyTabItemMargin, height)];
    [path appendPath:[UIBezierPath bezierPathWithArcCenter:CGPointMake(NetEasyTabItemWidth - radius+offset, radius) radius:radius startAngle:M_PI/2 endAngle:M_PI/2*3 clockwise:NO]];
    [path addLineToPoint:CGPointMake(radius+offset, height)];
    [path appendPath:[UIBezierPath bezierPathWithArcCenter:CGPointMake(radius +offset, radius) radius:radius startAngle:M_PI/2*3 endAngle:2.5*M_PI clockwise:NO]];
    [path addLineToPoint:CGPointMake(NetEasyTabItemWidth - radius +offset, 0)];
    [path closePath];
    
    NSLog(@"draw offset  %lf",offset);
    _lastOffset = offset;
    CAShapeLayer *shapeLayer = (CAShapeLayer *)self.midlleView.layer.mask;
    if (!shapeLayer) {
        shapeLayer = [CAShapeLayer layer];
        
    }
    if (animation) {
        if (_isAnimation) {
            return;
        }
        if (_beginIn) {
            _isInBeginAnimation = YES;
        }
        self.midlleView.layer.mask = shapeLayer;
        
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
        pathAnimation.toValue = (id)path.CGPath;
        pathAnimation.duration = 0.15;
        pathAnimation.removedOnCompletion = NO;
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathAnimation.fillMode = kCAFillModeForwards;
        pathAnimation.delegate = self;
        _isAnimation = YES;
        [shapeLayer addAnimation:pathAnimation forKey:@"moveAntimation"];
        _animationOffset = offset;
    }else{
        shapeLayer.path = path.CGPath;
        self.midlleView.layer.mask = shapeLayer;
    }
}


- (NSInteger)getIndexWithPoint:(CGPoint) point{
    return  point.x / (NetEasyTabItemWidth + NetEasyTabItemMargin);
}

- (void)didBeginTouchWithPoint:(CGPoint )point{
    _beginPoint = point;
    NSLog( @"touch begin");
    if (!CGRectContainsPoint(self.bounds, point) ) {
        return ;
    }
    NSInteger touchIndex = [self getIndexWithPoint:point];
    if (touchIndex != _touchTapIndex) {
        _touchTapIndex = touchIndex;
        CGFloat offset = touchIndex * (NetEasyTabItemWidth + NetEasyTabItemMargin);
        [self sliderMaskLayerWithOffset: offset antimation:YES];
    }else{
        
    }
}

- (void)disEndTouchWithPoint: (CGPoint )point{
    
    NSInteger tmp = point.x / (self.frame.size.width / self.titlesArray.count);
    if (tmp > self.titlesArray.count -1) {
        tmp = self.titlesArray.count -1;
    }else if(tmp <= 0){
        tmp = 0;
    }
    CGFloat coorDinateX = tmp * (NetEasyTabItemWidth+NetEasyTabItemMargin);
    [self sliderMaskLayerWithOffset:coorDinateX antimation:YES];
    if (_currentIndex != tmp) {
        !_handle ? :_handle(tmp,self.titlesArray[tmp]);
    }
    _currentIndex = tmp;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    _beginIn = YES;
    _isEndTouch = NO;
    [self didBeginTouchWithPoint:[[touches anyObject] locationInView:self]];
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint point = [touches.anyObject locationInView:self];
    [self disEndTouchWithPoint:point];
    _isEndTouch = YES;
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    CGPoint point = [touches.anyObject locationInView:self];

    CGFloat offset = point.x - _beginPoint.x + (NetEasyTabItemWidth + NetEasyTabItemMargin) * _touchTapIndex;
    
    if (offset + NetEasyTabItemWidth >= self.frame.size.width) {
        offset = self.frame.size.width - NetEasyTabItemWidth;
    }else if(offset <= 0) {
        offset = 0;
    }

    NSLog( @"touch move  %@ offset %lf",NSStringFromCGPoint(point),offset);

    
    if (!_isInBeginAnimation) {
        [self sliderMaskLayerWithOffset:offset antimation:_beginIn];
    }
    _beginIn = NO;
}
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint point = [touches.anyObject locationInView:self];
    [self disEndTouchWithPoint:point];
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (flag) {
        _isAnimation = NO;
        _isInBeginAnimation = NO;
        if (!_isEndTouch) {
            [self sliderMaskLayerWithOffset:_animationOffset antimation:NO];
        }else{
            [self sliderMaskLayerWithOffset:_currentIndex * (NetEasyTabItemWidth + NetEasyTabItemMargin) antimation:NO];
        }
        [self.midlleView.layer.mask removeAnimationForKey:@"moveAntimation"];
    }
    
}

@end

@interface NetEasyTabView ()
@property (nonatomic, strong) TabContainerView *containerView;
@property (nonatomic ,strong) UIColor *bgColor;
@property (nonatomic ,strong) UIColor *slideColor;
@end
@implementation NetEasyTabView

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titlesArray bgColor:(UIColor*)bgColor sliderColor:(UIColor *)sliderColor clickBlock:(TabItemClickHandle)handle{
    if (self= [super initWithFrame:frame]) {
        self.handle = handle;
        self.slideColor = sliderColor;
        self.bgColor = bgColor;
        self.titlesArray = titlesArray;
        
    }
    return self;
}

- (void)setTitlesArray:(NSArray *)titlesArray {
    _titlesArray = titlesArray;
    [self setupUI];
}
- (void)setupUI{
    CGFloat width = (NetEasyTabItemWidth + NetEasyTabItemMargin) * self.titlesArray.count - NetEasyTabItemMargin;
    CGRect frame = CGRectMake((self.frame.size.width - width)/2, NetEasyTabTopMargin, width,  NetEasyTabItemHeight);
    
    self.containerView = [[TabContainerView alloc] initWithFrame:frame titles:self.titlesArray bgColor:self.bgColor sliderColor:self.slideColor clickBlock:self.handle];
    self.containerView.layer.masksToBounds = YES;
    self.containerView.layer.cornerRadius = NetEasyTabItemHeight / 2.0;
    self.containerView.layer.borderWidth = 0.7;
    [self addSubview:self.containerView];
}

- (void)setCurrentIndex:(NSInteger )currentIndex{
    _currentIndex = currentIndex;
    self.containerView.currentIndex = currentIndex;
    [self.containerView sliderMaskLayerWithOffset:(NetEasyTabItemWidth + NetEasyTabItemMargin ) * currentIndex antimation:YES];
}

@end
