//
//  LocationNavitionViewController.m
//  LocationAndMap
//
//  Created by dongjiawang on 2018/11/7.
//  Copyright © 2018 io.github.dongjiawang. All rights reserved.
//

#import "LocationNavitionViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationNavitionViewController ()<MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITextField *beginField;
@property (weak, nonatomic) IBOutlet UITextField *endField;
@property (nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic, assign) NSUInteger navType;
@property (nonatomic, assign) BOOL firstNav;


@end

@implementation LocationNavitionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 判断是否k打开定位
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"未打开定位服务");
    }
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        NSString *message = @"您的手机目前未开启定位服务，如欲开启定位服务，请至设定开启定位服务功能";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"无法定位" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }
    
    [CLLocationManager headingAvailable];
    
    // 设置为用户跟踪模式
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    /*
     MKMapTypeStandard  标准地图
     MKMapTypeSatellite    卫星地图
     MKMapTypeHybrid      鸟瞰地图
     MKMapTypeSatelliteFlyover
     MKMapTypeHybridFlyover
     */
    self.mapView.mapType = MKMapTypeStandard;
    //实时显示交通路况
    self.mapView.showsTraffic = YES;
    // 显示罗盘
    self.mapView.showsCompass = YES;
    // 比例尺
    self.mapView.showsScale = YES;
    // 显示用户位置
    self.mapView.showsUserLocation = YES;
    // 禁止旋转
    self.mapView.rotateEnabled = NO;
    // 显示建筑物
    self.mapView.showsBuildings = YES;
    self.mapView.delegate = self;
    
    self.geocoder = [[CLGeocoder alloc] init];
    
    self.firstNav = YES;
}
- (IBAction)segmentCtrlValueChanged:(UISegmentedControl *)sender {
    self.navType = sender.selectedSegmentIndex;
    
}
- (IBAction)fetchRounter:(UIButton *)sender {
    
    if (self.beginField.text.length == 0 || self.endField.text.length == 0) {
        NSLog(@"没有输入起点或终点");
        return;
    }
    
    [self.view endEditing:YES];
    
    [self.geocoder geocodeAddressString:self.beginField.text completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        __block CLPlacemark *beginMark = placemarks.lastObject;
       
        [self.geocoder geocodeAddressString:self.endField.text completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            CLPlacemark *endMark = placemarks.lastObject;
            if (!error) {
                MKMapItem *beginItem = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithPlacemark:beginMark]];
                MKMapItem *endItem = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithPlacemark:endMark]];
                /*
                 使用map.app 进行路线规划和导航
                 NSString * directionsMode;
                 
                 switch (self.navType) {
                 case 0:
                 directionsMode = MKLaunchOptionsDirectionsModeWalking;
                 break;
                 case 1:
                 directionsMode = MKLaunchOptionsDirectionsModeDriving;
                 break;
                 case 2:
                 directionsMode = MKLaunchOptionsDirectionsModeTransit;
                 break;
                 default:
                 directionsMode = MKLaunchOptionsDirectionsModeWalking;
                 break;
                 }
                 NSDictionary *launchDic = @{//范围
                 MKLaunchOptionsMapSpanKey : @(50000),
                 // 设置导航模式参数
                 MKLaunchOptionsDirectionsModeKey : directionsMode,
                 // 设置地图类型
                 MKLaunchOptionsMapTypeKey : @(MKMapTypeStandard),
                 // 设置是否显示交通
                 MKLaunchOptionsShowsTrafficKey : @(YES),};
                 [MKMapItem openMapsWithItems:@[beginItem, endItem] launchOptions:launchDic];
                 */
               
                [self findDirectionsFrom:beginItem to:endItem];                
            }
        }];
    }];
}

- (void)findDirectionsFrom:(MKMapItem *)from to:(MKMapItem *)to{
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    request.source = from;
    request.destination = to;
    switch (self.navType) {
        case 0:
            // 步行
            request.transportType = MKDirectionsTransportTypeWalking;
            break;
        case 1:
            // 驾驶
            request.transportType = MKDirectionsTransportTypeAutomobile;
            break;
        case 2:
            // 公交
            request.transportType = MKDirectionsTransportTypeAny;
            break;
        default:
            request.transportType = MKDirectionsTransportTypeWalking;
            break;
    }
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Error info:%@", error.userInfo[@"NSLocalizedFailureReason"]);
        }
        else {
            for (MKRoute *route in response.routes) {
                for(id<MKOverlay> overLay in self.mapView.overlays) {
                    [self.mapView removeOverlay:overLay];
                }
                [self.mapView addOverlay:route.polyline level:0];
                [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(from.placemark.location.coordinate, 1000, 1000)
                               animated:YES];
            }
            
        }
    }];
}

- (MKOverlayRenderer*)mapView:(MKMapView*)mapView rendererForOverlay:(id)overlay {
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.lineWidth = 5;
    renderer.strokeColor = [UIColor redColor];
    return renderer;
}

@end
