//
//  BXLImageCollectionViewCell.m
//  iOSClient
//
//  Created by leven on 2017/11/8.
//  Copyright © 2017年 borderxlab. All rights reserved.
//

#import "BXLImageCollectionViewCell.h"
#import "BXLImageCollectionCellModel.h"
#import "BXLBrowserHeader.h"

@interface BXLImageCollectionViewCell()
@property (strong, nonatomic) IBOutlet UIButton *selecteButton;
@end

@implementation BXLImageCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _contenImageView.layer.contentsGravity = kCAGravityResizeAspectFill;
    _contenImageView.layer.masksToBounds = YES;
    [_contenImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).mas_equalTo(UIEdgeInsetsMake(8, 8, 1, 1));
    }];
}

- (void)setModel:(BXLImageCollectionCellModel *)model{
    _model = model;
    [self refreshUI];
}

- (void)refreshUI{
    if (self.model.image) {
        _contenImageView.image = self.model.image;
    }else if (self.model.imageUrl){
        [_contenImageView sd_setImageWithURL:[NSURL URLWithString:self.model.imageUrl] placeholderImage:(@"placeholder_img")];
    }
    if (self.model.ifShowDeleteButton
        || self.model.ifShowSelectButton) {
        self.selecteButton.hidden = NO;
        
        if (self.model.ifShowSelectButton) {
            [self.selecteButton setImage:BXLImage(@"image_unselect") forState:UIControlStateNormal];
            [self.selecteButton setImage:BXLImage(@"new_selected") forState:UIControlStateSelected];

            self.selecteButton.selected = self.model.ifSelected;

        }else{
            [self.selecteButton setImage:BXLImage(@"delete_pic") forState:UIControlStateNormal];
            [self.selecteButton setImage:BXLImage(@"delete_pic") forState:UIControlStateSelected];
        }
        [_contenImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).mas_equalTo(UIEdgeInsetsMake(8, 8, 1, 1));
        }];
       
    }else{
        self.selecteButton.hidden = YES;
        [_contenImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
}

- (IBAction)selectBtnClick:(id)sender {
    
    if (self.model.ifShowSelectButton) {
        _selecteButton.selected = !_selecteButton.selected;

        if ([_delegate respondsToSelector:@selector(BXLImageCollectionViewCellDidClickSelectButton:)]) {
            [_delegate BXLImageCollectionViewCellDidClickSelectButton:self];
        }
    }else{
        if ([_delegate respondsToSelector:@selector(BXLImageCollectionViewCellDidClickDelectButton:)]) {
            [_delegate BXLImageCollectionViewCellDidClickDelectButton:self];
        }
    }
}

@end
