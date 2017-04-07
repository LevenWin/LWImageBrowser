# LWImageBrowser

动态图
![](https://github.com/LevenWin/LWImageBrowser/blob/master/screen.gif)
## 使用方式
```
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

```




