# UIKitDemo



这是看《精通iOS框架》这本的Demo，用来记录学习的东西。

## UIKit Dynamics

1. 重力效果
1. 碰撞效果
1. 附着效果
1. 捕获效果
1. 推力效果

## LocationAndMap

### Location

简单的获取用户位置，及反地理编码获取地址，暂时用的原生的解码，因为某些墙的原因，经常解码失败

### Map

1. 显示用户所在的地图的位置，根据用户的移动更新地图位置。
1. 获取用户周边的一些地点。
1. 点击周边地点添加大头针。
1. 拖动大头针。
1. 自定义大头针。
1. 点击大头针可以添加遮盖。

### 路径规划

简单的获取两个地点之间的路径（步行、驾驶、公交）。

没有过滤地点，可以在获取到地理编码后的地址中筛选正确的地址然后再进行路线规划。

在下面的方法中获取解析出来的地理编码，返回的数组中筛选。

```objective-c
- (void)geocodeAddressString:(NSString *)addressString completionHandler:(CLGeocodeCompletionHandler)completionHandler;
```



