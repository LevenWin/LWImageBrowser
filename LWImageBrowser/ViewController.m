//
//  ViewController.m
//  LWImageBrowser
//
//  Created by leven on 2017/3/27.
//  Copyright © 2017年 leven. All rights reserved.
//

#import "ViewController.h"

#import "BXLImageCollectionView.h"
#import "BXLBrowserImageManager.h"
#import "BXLBrowserHeader.h"

@interface ViewController ()<BXLImageCollectionViewDelegate>

@property (nonatomic, strong) BXLImageCollectionView *collevtionView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self processData];
}

- (void)processData{
    
    NSArray *imgsArr =
    @[@"http://pic01.bdatu.com/Upload/appsimg/1490001389.jpg",
        @"http://pic01.bdatu.com/Upload/appsimg/1490000769.jpg",
        @"http://pic01.bdatu.com/Upload/appsimg/1489999226.jpg",
        @"http://pic01.bdatu.com/Upload/appsimg/1489718048.jpg",
        @"http://pic01.bdatu.com/Upload/appsimg/1489717741.jpg",
        @"http://pic01.bdatu.com/Upload/appsimg/1489716720.jpg",
        @"http://pic01.bdatu.com/Upload/appsimg/1389605192.jpg",
        @"http://pic01.bdatu.com/Upload/appsimg/1386219491.jpg",
        @"http://pic01.bdatu.com/Upload/appsimg/1388657430.jpg",
        @"http://pic01.bdatu.com/Upload/appsimg/1488963922.jpg",
        @"http://pic01.bdatu.com/Upload/appsimg/1488963192.jpg",
        @"http://pic01.bdatu.com/Upload/appsimg/1488962883.jpg",
        @"http://pic01.bdatu.com/Upload/appsimg/1488962318.jpg",
        @"http://pic01.bdatu.com/Upload/appsimg/1488961661.jpg",
        @"http://pic01.bdatu.com/Upload/appsimg/1488960853.jpg"
      ];

    self.dataArr = [NSMutableArray new];
    
    for (NSString *string in imgsArr) {
        BXLImageCollectionCellModel *model = [BXLImageCollectionCellModel new];
        model.imageUrl = string;
        [self.dataArr addObject:model];
    }
    self.collevtionView.dataArray = self.dataArr;
    [self.collevtionView.collectView reloadData];
}

- (void)initUI{
    self.collevtionView = [[BXLImageCollectionView alloc] initWithFrame:CGRectZero];
    self.collevtionView.viewWidth = kBXLScreenWidth;
    self.collevtionView.imageCollectionDelegate = self;
    self.collevtionView.cellRowCount = 4;
    self.collevtionView.minimumLineSpacing = 1;
    self.collevtionView.minimumInteritemSpacing = 1;
    self.collevtionView.insetForSection = UIEdgeInsetsMake(0, 0, 0 ,0);
    [self.view addSubview:self.collevtionView];
    [self.collevtionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

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

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
@end
