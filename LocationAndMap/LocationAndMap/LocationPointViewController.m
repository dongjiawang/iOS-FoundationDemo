//
//  LocationPointViewController.m
//  LocationAndMap
//
//  Created by dongjiawang on 2018/11/6.
//  Copyright © 2018 io.github.dongjiawang. All rights reserved.
//

#import "LocationPointViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface LocationPointViewController ()<CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManger;
@property (weak, nonatomic) IBOutlet UILabel *longitude;
@property (weak, nonatomic) IBOutlet UILabel *latitude;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (nonatomic, strong) CLGeocoder *geocoder;

@end

@implementation LocationPointViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.longitude.layer.borderWidth = 0.5;
    self.longitude.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.longitude.layer.cornerRadius = 2;
    self.latitude.layer.borderWidth = 0.5;
    self.latitude.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.latitude.layer.cornerRadius = 2;
    self.address.layer.borderWidth = 0.5;
    self.address.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.address.layer.cornerRadius = 2;
    
    self.locationManger = [[CLLocationManager alloc] init];
    self.locationManger.delegate = self;
    // 每隔多少米定位一次
    self.locationManger.distanceFilter = 100;
    
    /*
     kCLLocationAccuracyBestForNavigation    最适合导航
     kCLLocationAccuracyBest 精度最好的
     kCLLocationAccuracyNearestTenMeters 附近10米
     kCLLocationAccuracyHundredMeters    附近100米
     kCLLocationAccuracyKilometer    附近1000米
     kCLLocationAccuracyThreeKilometers  附近3000米
     */
    self.locationManger.desiredAccuracy = kCLLocationAccuracyBest;
    
    
    self.geocoder = [[CLGeocoder alloc] init];
}


- (IBAction)getLocation:(UIButton *)sender {
    // 开始更新用户位置
    
    // 当用户使用的时候更新位置
    [self.locationManger requestWhenInUseAuthorization];
    
    /*
    // 后台定位
     需要在info.plist中申请权限
    [self.locationManger requestAlwaysAuthorization];
     
     // 开始获取用户位置
    [self.locationManger startUpdatingLocation];
    */
    // 单次获取用户位置
    [self.locationManger requestLocation];
}

- (void)reverseGeocodeLocation:(CLLocation *)location  {
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        // 包含区，街道等信息的地标对象
        if (error == nil) {
            CLPlacemark *placemark = [placemarks firstObject];
            self.address.text = [NSString stringWithFormat:@"地址：%@%@%@%@", placemark.addressDictionary[@"State"], placemark.addressDictionary[@"City"], placemark.addressDictionary[@"SubLocality"], placemark.addressDictionary[@"Name"]];
        }
        else {
            self.address.text = @"暂时还未解析出来地址";
        }
    }];
}

// 监听用户授权状态
/*
 kCLAuthorizationStatusNotDetermined // 用户还未决定
 kCLAuthorizationStatusRestricted // 访问受限（苹果的预留选项）
 kCLAuthorizationStatusDenied // 定位关闭或者没有授权
 kCLAuthorizationStatusAuthorizedAlways //获取后台定位权限
 kCLAuthorizationStatusAuthorizedWhenInUse //获取前台定位权限
 */
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
        {
            NSLog(@"用户还未决定");
        }
            break;
        case kCLAuthorizationStatusDenied:
        {
            if ([CLLocationManager locationServicesEnabled]) {
                NSLog(@"定位开启，但被拒");
                NSURL *settingUrl = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:settingUrl]) {
                    [[UIApplication sharedApplication] openURL:settingUrl options:@{} completionHandler:nil];
                }
            }
            else {
                NSLog(@"定位关闭，不可用");
            }
        }
            
        default:
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    /*
     > coordinate    : 当前位置所在的经纬度数据
     > altitude      : 海拔
     > speed         : 当前速度
     > course        : 航向(设备移动的方向, 值域范围:0.0 ~ 259.9, 正北方向为0.0)
     */
    // 最后一组数据是最新的位置
    CLLocation *location = locations.lastObject;
    [self reverseGeocodeLocation:location];
    CLLocationCoordinate2D coordinate = location.coordinate;
    self.longitude.text = [NSString stringWithFormat:@"经度：%f", coordinate.longitude];
    self.latitude.text = [NSString stringWithFormat:@"纬度：%f", coordinate.latitude];
}

// 获取位置失败
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [self.locationManger stopUpdatingLocation];
}

@end
