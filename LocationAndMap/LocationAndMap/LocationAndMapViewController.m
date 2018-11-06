//
//  LocationAndMapViewController.m
//  LocationAndMap
//
//  Created by dongjiawang on 2018/11/6.
//  Copyright © 2018 io.github.dongjiawang. All rights reserved.
//

#import "LocationAndMapViewController.h"

@interface LocationAndMapViewController ()
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

@end
