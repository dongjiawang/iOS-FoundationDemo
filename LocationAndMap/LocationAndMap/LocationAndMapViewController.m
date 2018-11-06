//
//  LocationAndMapViewController.m
//  LocationAndMap
//
//  Created by dongjiawang on 2018/11/6.
//  Copyright © 2018 io.github.dongjiawang. All rights reserved.
//

#import "LocationAndMapViewController.h"
#import "LocationPointViewController.h"
#import "LocationMapViewController.h"

@interface LocationAndMapViewController ()<UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *tableArray;

@end

@implementation LocationAndMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.tableArray = [NSMutableArray arrayWithObjects:@"获取位置", @"显示地图", nil];
    [self.tableView registerNib:[UINib nibWithNibName:@"CommonTableViewCell" bundle:nil] forCellReuseIdentifier:@"CommonTableViewCell"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonTableViewCell"];
    cell.textLabel.text = self.tableArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSBundle *resourceBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle]pathForResource:@"LocationAndMap"ofType:@"bundle"]];
    switch (indexPath.row) {
        case 0:
        {
            LocationPointViewController *pointVC = [[LocationPointViewController alloc] initWithNibName:@"LocationPointViewController" bundle:resourceBundle];
            pointVC.title = self.tableArray[indexPath.row];
            [self.navigationController pushViewController:pointVC animated:YES];
        }
            break;
        case 1:
        {
            LocationMapViewController *mapVC = [[LocationMapViewController alloc] initWithNibName:@"LocationMapViewController" bundle:resourceBundle];
            mapVC.title = self.tableArray[indexPath.row];
            [self.navigationController pushViewController:mapVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}

@end
