//
//  BXLBrowserImageViewController.h
//  
//
//  Created by leven on 2017/11/9.
//

#import <UIKit/UIKit.h>
@class BXLBrowserImageCellModel;
@interface BXLBrowserImageViewController : UIViewController

@property (nonatomic, strong) NSArray <BXLBrowserImageCellModel *>*dataArr;
@property (nonatomic, strong) UIImage *screenImage;
@end
