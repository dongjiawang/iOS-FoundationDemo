//
//  UIKitDynamicsViewController.m
//  UIKitDynamic
//
//  Created by dongjiawang on 2018/11/2.
//  Copyright © 2018 io.github.dongjiawang. All rights reserved.
//

#import "UIKitDynamicsViewController.h"
#import "GravityViewController.h"
#import "CollisionViewController.h"

@interface UIKitDynamicsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tableArray;

@end

@implementation UIKitDynamicsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableArray = [NSMutableArray arrayWithObjects:@"重力效果", @"碰撞效果", @"附着效果", @"捕获效果", @"推力效果", nil];
    
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
    switch (indexPath.row) {
        case 0:
        {            
            NSBundle *resourceBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle]pathForResource:@"UIKitDynamic"ofType:@"bundle"]];
            GravityViewController *gravityVC = [[GravityViewController alloc] initWithNibName:@"GravityViewController" bundle:resourceBundle];
            gravityVC.title = self.tableArray[indexPath.row];
            [self.navigationController pushViewController:gravityVC animated:YES];
        }
            break;
        case 1:
        {
            NSBundle *resourceBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle]pathForResource:@"UIKitDynamic"ofType:@"bundle"]];
            CollisionViewController *collisionVC = [[CollisionViewController alloc] initWithNibName:@"CollisionViewController" bundle:resourceBundle];
            collisionVC.title = self.tableArray[indexPath.row];
            [self.navigationController pushViewController:collisionVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}

@end
