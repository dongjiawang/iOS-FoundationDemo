//
//  LocationMapViewController.m
//  LocationAndMap
//
//  Created by dongjiawang on 2018/11/6.
//  Copyright © 2018 io.github.dongjiawang. All rights reserved.
//

#import "LocationMapViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationMapViewController ()<MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tableArray;

@end

@implementation LocationMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.tableArray = [NSMutableArray array];
    
    // 判断是否k打开定位
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"未打开定位服务");
    }
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        NSString *message = @"您的手机目前未开启定位服务，如欲开启定位服务，请至设定开启定位服务功能";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"无法定位" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }
    
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
    //设置代理
    self.mapView.delegate = self;
    // 显示罗盘
    self.mapView.showsCompass = YES;
    // 比例尺
    self.mapView.showsScale = YES;
    // 显示s用户位置
    self.mapView.showsUserLocation = YES;
    // 禁止旋转
    self.mapView.rotateEnabled = NO;
    // 显示建筑物
    self.mapView.showsBuildings = YES;
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CommonTableViewCell" bundle:nil] forCellReuseIdentifier:@"CommonTableViewCell"];
}


- (IBAction)mapTypesSelectionChanged:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:
        {
            [self.mapView setMapType:MKMapTypeStandard];
        }
            break;
        case 1:
        {
            [self.mapView setMapType:MKMapTypeSatellite];
        }
            break;
        case 2:
        {
            [self.mapView setMapType:MKMapTypeHybrid];
        }
            break;
            
        default:
            break;
    }
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    [mapView setCenterCoordinate:userLocation.coordinate animated:YES];
    [self fetchNearByLocation:userLocation.coordinate];
}

// 点击大头针，在大头针上覆盖遮盖
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    NSLog(@"%@", view.annotation.title);
    
    [self.mapView removeOverlays:self.mapView.overlays];
    
    MKCircle *circle = [MKCircle circleWithCenterCoordinate:view.annotation.coordinate radius:300];
    /*
     MKOverlayLevelAboveRoads = 0, // 覆盖物位于道路之上
     
     MKOverlayLevelAboveLabels//覆盖物位于标签之上
     */
    [self.mapView addOverlay:circle level:MKOverlayLevelAboveRoads];
}

//修改覆盖的样式
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    MKCircleRenderer * render=[[MKCircleRenderer alloc] initWithCircle:overlay];
    render.lineWidth = 2;
    render.fillColor = [UIColor lightGrayColor];
    render.strokeColor = [UIColor redColor];
    
    return render;
}

- (void)fetchNearByLocation:(CLLocationCoordinate2D)coordinate {
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 2, 2);
    
    [self.mapView setRegion:region animated:YES];
    
    MKLocalSearchRequest *requst = [[MKLocalSearchRequest alloc] init];
    requst.region = region;
    requst.naturalLanguageQuery = @"place"; //想要的信息
    MKLocalSearch *localSearch = [[MKLocalSearch alloc] initWithRequest:requst];
    [self.tableArray removeAllObjects];
    [localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error){
        if (!error){
            for (MKMapItem *map in response.mapItems) {
                NSLog(@"%@",map.name);
            }
            [self.tableArray addObjectsFromArray:response.mapItems];
            [self.tableView reloadData];
        }
    }];
}

#pragma mark ----Annotation----
// 可以简单的自定义大头针的样式
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKAnnotationView *view = (MKAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"view"];
    if (view == nil) {
        view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"view"];
        [view setCanShowCallout:YES];
        [view setDraggable:YES];
    }
    
    UIView *colorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [view setLeftCalloutAccessoryView:colorView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [view setRightCalloutAccessoryView:button];
    return view;
}
// 拖动大头针的回调
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState {
    if (newState == MKAnnotationViewDragStateEnding) {
        [self.mapView setCenterCoordinate:view.annotation.coordinate animated:YES];
        [self fetchNearByLocation:view.annotation.coordinate];
    }
}

#pragma mark ----UITableView----

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonTableViewCell"];
    MKMapItem *map = self.tableArray[indexPath.row];
    cell.textLabel.text = map.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MKMapItem *map = self.tableArray[indexPath.row];
    
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = map.placemark.location.coordinate;
    annotation.title = map.name;
    for (MKPointAnnotation *tempAnnotation in self.mapView.annotations) {
        if (annotation.coordinate.latitude == tempAnnotation.coordinate.latitude && annotation.coordinate.longitude == tempAnnotation.coordinate.longitude) {
            [self.mapView removeAnnotation:tempAnnotation];
            return;
        }
    }
    [self.mapView addAnnotation:annotation];
    [self.mapView setCenterCoordinate:map.placemark.location.coordinate animated:YES];
}

@end
