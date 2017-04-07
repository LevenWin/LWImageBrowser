//
//  ViewController.m
//  LWImageBrowser
//
//  Created by leven on 2017/3/27.
//  Copyright © 2017年 leven. All rights reserved.
//

#import "ViewController.h"
#import "NetEasyTabView.h"
#import <UIImageView+WebCache.h>
#import "ImageTableViewCell.h"
#import "ImageCellModel.h"
#import "LWImageBrowserManager.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong)NetEasyTabView *tabView;
@property (nonatomic, strong)UITableView *tbv;
@property (nonatomic, strong)UIScrollView *scr;
@property (nonatomic, strong)UIView *rightView;
@property (nonatomic, strong)NetEasyTabView *tab;

@property (nonatomic, strong)NSMutableArray<ImageCellModel *> *dataArr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    [self initUI];
    [self processData];
}

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
- (void)processData{
    
    NSArray *imgsArr =
    @[@[@"http://pic01.bdatu.com/Upload/appsimg/1490001389.jpg",
        @"http://pic01.bdatu.com/Upload/appsimg/1490000769.jpg",
        @"http://pic01.bdatu.com/Upload/appsimg/1489999226.jpg",
        @"http://pic01.bdatu.com/Upload/appsimg/1489718048.jpg",],
      @[ @"http://pic01.bdatu.com/Upload/appsimg/1489717741.jpg", @"http://pic01.bdatu.com/Upload/appsimg/1489716720.jpg", @"http://pic01.bdatu.com/Upload/appsimg/1389605192.jpg", @"http://pic01.bdatu.com/Upload/appsimg/1386219491.jpg", @"http://pic01.bdatu.com/Upload/appsimg/1388657430.jpg"],
      @[@"http://pic01.bdatu.com/Upload/appsimg/1488963922.jpg",@"http://pic01.bdatu.com/Upload/appsimg/1488963192.jpg",@"http://pic01.bdatu.com/Upload/appsimg/1488962883.jpg",@"http://pic01.bdatu.com/Upload/appsimg/1488962318.jpg"],
      @[ @"http://pic01.bdatu.com/Upload/appsimg/1488961661.jpg", @"http://pic01.bdatu.com/Upload/appsimg/1488960853.jpg"]];

    self.dataArr = [NSMutableArray new];
    
    for (NSArray *arr in imgsArr) {
        ImageCellModel *model = [ImageCellModel new];
        CGFloat width = 0;
        CGFloat cellHeight = 2 * margin;
        NSMutableArray *framesArr = [NSMutableArray new];
        if (arr.count == 2 || arr.count == 4) {
            width = (KScreenWidth - margin * 3) / 2;
            cellHeight += (width + margin ) * ((arr.count / 2)+(arr.count % 2 ? 1 : 0));
            framesArr = [self getFramesArrWithCount:2 arr:arr width:width];
            
        }else if (arr.count == 1){
            width = KScreenWidth;
            cellHeight += width;
            framesArr = [self getFramesArrWithCount:1 arr:arr width:width];

        }else{
            width = (KScreenWidth - margin * 4) / 3;
            cellHeight += (width + margin ) * ((arr.count / 3)+(arr.count % 3 ? 1 : 0));
            framesArr = [self getFramesArrWithCount:3 arr:arr width:width];
            
        }
        model.imgWidth = width;
        model.imgsArr = arr;
        model.cellHeight = cellHeight;
        model.framesArr = framesArr;
        [self.dataArr addObject:model];

    }
}

- (NSMutableArray *)getFramesArrWithCount:(NSInteger)count arr:(NSArray *)imgArr width:(CGFloat)widht{
    NSMutableArray *arr = [NSMutableArray array];
    for (NSInteger index = 0; index < imgArr.count; index++) {
        CGFloat offX = (index % count) * (widht + margin);
        CGFloat offY = (index / count) * (widht + margin);
        [arr addObject:NSStringFromCGRect(CGRectMake(offX, offY, widht, widht))];
                                    
    }
    return arr;
}

- (void)initUI{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.scr = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64+40, KScreenWidth, KScreenHeight - 104)];
    self.scr.contentSize = CGSizeMake(KScreenWidth * 2, KScreenHeight - 104);
    self.scr.pagingEnabled = YES;
    self.scr.delegate = self;
    [self.view addSubview:self.scr];
    self.scr.bounces = NO;
    self.tab = [[NetEasyTabView alloc] initWithFrame:CGRectMake(0, 64, KScreenWidth, 40) titles:@[@"tbv",@"view"] bgColor:[UIColor darkGrayColor] sliderColor:[UIColor whiteColor] clickBlock:^(NSInteger index, NSString *title) {
        [self.scr setContentOffset:CGPointMake(KScreenWidth * index, 0) animated:YES];
    }];
    self.tab.backgroundColor = [UIColor darkGrayColor];
    
    [self.view addSubview:_tab];
    
    self.tbv = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 104 ) style:UITableViewStylePlain];
    self.tbv.delegate = self;
    self.tbv.dataSource = self;
    [self.tbv registerNib:[UINib nibWithNibName:@"ImageTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
    [self.scr addSubview:self.tbv];
    
    self.rightView = [[UIView alloc] initWithFrame:CGRectMake(KScreenWidth, 0, KScreenWidth, KScreenHeight - 104)];
    UIImageView *image1 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, KScreenWidth - 40, 200)];
    image1.contentMode = UIViewContentModeScaleAspectFit;
    [image1 sd_setImageWithURL:[NSURL URLWithString:@"http://pic01.bdatu.com/Upload/appsimg/1490000769.jpg"]];
    UIImageView *image2 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20 + 240, KScreenWidth - 40, 200)];
    image2.contentMode = UIViewContentModeScaleAspectFit;
    [image2 sd_setImageWithURL:[NSURL URLWithString:@"http://pic01.bdatu.com/Upload/appsimg/1490000769.jpg"]];

    [self.rightView addSubview:image1];
    [self.rightView addSubview:image2];
    
    
    [self.scr addSubview:self.rightView];
    
    [self.tbv reloadData];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.dataArr[indexPath.row] cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.model = self.dataArr[indexPath.row];
    
    cell.tapActionBlock = ^(ImageCellModel *model,NSInteger index,UIView *tapView){
        index--;
//        [LWImageBrowserManager browserImages:self.dataArr[indexPath.row].imgsArr
//                       currentViewController:self
//                              originalFrames:self.dataArr[indexPath.row].framesArr
//                                currentIndex:index
//                                   superView:cell.contentView];
        NSInteger row = [self.dataArr indexOfObject:model];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:row inSection:0];
        ImageTableViewCell *cell = [self.tbv cellForRowAtIndexPath:indexPath];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [LWImageBrowserManager browserImages:self.dataArr[indexPath.row].imgsArr
                                placeHolderImage:nil
                           currentViewController:self
                                       showStyle:LWImageBrowserStylePop
                                  originalFrames:self.dataArr[indexPath.row].framesArr
                                    currentIndex:index
                                       superView:cell.contentView
                                     willDismiss:^(NSInteger index) {
                                         NSLog(@"dismiss");
            }];
//        });
        
    };
    [cell didDisappear];

    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    ImageTableViewCell *realCell = (id)cell;
    [realCell willShow];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x / KScreenWidth;
    self.tab.currentIndex = index;
}

@end
