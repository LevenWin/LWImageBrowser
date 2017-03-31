//
//  ImageTableViewCell.m
//  LWImageBrowser
//
//  Created by leven on 2017/3/27.
//  Copyright © 2017年 leven. All rights reserved.
//

#import "ImageTableViewCell.h"
#import <UIImageView+WebCache.h>

@implementation ImageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)tapAction:(UIGestureRecognizer*)gesture{
//    gesture.view.hidden = YES;
    !self.tapActionBlock ?:self.tapActionBlock(self.model,gesture.view.tag,gesture.view);
}

- (void)didDisappear{
    for (UIView *tempV in self.contentView.subviews) {
        [tempV removeFromSuperview];
    }
}
- (void)willShow{

    for (NSString *imgUrl in self.model.imgsArr) {
        NSInteger index = [self.model.imgsArr indexOfObject:imgUrl];
        UIImageView *img = [UIImageView new];
        [img sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
        [self.contentView addSubview:img];
        img.layer.contentsGravity = kCAGravityResizeAspectFill;
        img.layer.masksToBounds = YES;
        img.frame =CGRectFromString(self.model.framesArr[index]);
        img.tag = index+1;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        img.userInteractionEnabled = YES;
        [img addGestureRecognizer:tap];
    }
}

@end
