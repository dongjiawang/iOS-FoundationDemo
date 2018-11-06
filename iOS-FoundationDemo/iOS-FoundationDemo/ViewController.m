//
//  ViewController.m
//  iOS-FoundationDemo
//
//  Created by dongjiawang on 2018/11/2.
//  Copyright © 2018 io.github.dongjiawang. All rights reserved.
//

#import "ViewController.h"
#import <UIKitDynamic/UIKitDynamicsViewController.h>
#import <LocationAndMap/LocationAndMapViewController.h>

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tableArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.tableArray = [NSMutableArray arrayWithObjects:@"UIKit Dynamics", @"Core Location",nil];
    [self.tableView registerNib:[UINib nibWithNibName:@"CommonTableViewCell" bundle:nil] forCellReuseIdentifier:@"CommonTableViewCell"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
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
    switch (indexPath.row) {
        case 0:
        {            
            NSBundle *resourceBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"UIKitDynamic"ofType:@"bundle"]];
            UIKitDynamicsViewController *dynamicsVC = [[UIKitDynamicsViewController alloc] initWithNibName:@"UIKitDynamicsViewController" bundle:resourceBundle];
            dynamicsVC.title = self.tableArray[indexPath.row];
            [self.navigationController pushViewController:dynamicsVC animated:YES];
        }
            break;
        case 1:
        {
            NSBundle *resourceBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"LocationAndMap"ofType:@"bundle"]];
            LocationAndMapViewController *locationVC = [[LocationAndMapViewController alloc] initWithNibName:@"LocationAndMapViewController" bundle:resourceBundle];
            locationVC.title = self.tableArray[indexPath.row];
            [self.navigationController pushViewController:locationVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}


@end
