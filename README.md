# LiveForest 活力森林

这是创业项目的第二个版本，在第一个版本的基础上修改和增加功能。

除了平板，所有的手机型号都适配了。

界面绝大部分是用 Storyboard 或者 xib 做的。

主要有4个部分：约伴和挑战、运动社、电商、个人主页：

![界面展示](https://github.com/YuChao529258668/resource-for-readme.md/blob/master/LiveForest-iOS-V2/界面展示.png)

其他设计图已经上传了。

这是优酷的运行效果视频：

http://v.youku.com/v_show/id_XMjc1OTc3NTAyNA==.html?spm=a2h3j.8428770.3416059.1

或者从 github 下载视频：

https://github.com/YuChao529258668/resource-for-readme.md/blob/master/LiveForest-iOS-V2/身动-演示.mov

这是目录结构：

![目录结构](https://github.com/YuChao529258668/resource-for-readme.md/blob/master/LiveForest-iOS-V2/项目结构.png)

这是某个控制器的代码组织：

![代码组织](https://github.com/YuChao529258668/resource-for-readme.md/blob/master/LiveForest-iOS-V2/方法组织.png)

某个函数的讲解：

```
#pragma mark - DataSource
- (void)loadNewData {
    NSString *urlstr = [NSString stringWithFormat:@"http://api.liveforest.com/user/%@/goods_theme", [HSHttpRequestTool userToken]];
    NSDictionary *para = @{};
    
    [HSHttpRequestTool GET:urlstr parameters:para success:^(id responseObject) {
        NSDictionary *goods_theme = [responseObject valueForKey:@"goods_themes"];
        self.goodsThemes = [HSShopTheme mj_objectArrayWithKeyValuesArray:goods_theme];
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSString *error) {
        [self.tableView.mj_header endRefreshing];
        HSLog(@"%s,%@",__func__, error);
    }];
}
```

HSHttpRequestTool 是对 AFNetWorking 的封装。字典转模型用的 MJExtension，tableView 下拉刷新用的 MJRefresh。

