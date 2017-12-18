# LWImageBrowser

## 动态图

![](https://github.com/LevenWin/LWImageBrowser/blob/master/screen.gif)

## 使用方式
```
  - (void)BXLImageCollectionViewDidClickCellAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *arr = @[].mutableCopy;
    for (BXLImageCollectionCellModel *model in self.dataArr) {
        NSUInteger index = [self.dataArr indexOfObject:model];
        BXLBrowserImageCellModel *item  = [BXLBrowserImageCellModel new];
        item.originalImageUrl = model.imageUrl;
        item.thumbImageUrl = model.imageUrl;
        item.isSelected = indexPath.row == index;
        
        UICollectionViewCell *cell = [self.collevtionView.collectView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
        CGRect frame = [cell.superview convertRect:cell.frame toView:[UIApplication sharedApplication].delegate.window];
        item.smallFrame = frame;
        [arr addObject:item];
    }
    BXLBrowserImageManager *instance = [BXLBrowserImageManager managerInstance];
    instance.images = arr;
    instance.inViewController = self;
    [instance show];
}

```

## 主要方法
```
@interface BXLBrowserImageManager : NSObject

@property (nonatomic, strong) NSArray <BXLBrowserImageCellModel *>* images;
@property (nonatomic, weak) UIViewController *inViewController;

+ (instancetype)managerInstance;

- (void)show;

@end
```
