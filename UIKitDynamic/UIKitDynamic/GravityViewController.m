//
//  GravityViewController.m
//  UIKitDynamic
//
//  Created by dongjiawang on 2018/11/5.
//  Copyright © 2018 io.github.dongjiawang. All rights reserved.
//

#import "GravityViewController.h"

@interface GravityViewController ()
@property (weak, nonatomic) IBOutlet UIView *animationView;

@end

@implementation GravityViewController {
    UIDynamicAnimator *animator;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

- (IBAction)startAnimation:(UIButton *)sender {
    animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    UIGravityBehavior *behavior = [[UIGravityBehavior alloc] initWithItems:@[self.animationView]];
    // 重力向量
    // 默认值为(0.0,1.0)，表示以（1000点/s²）的重力加速度向下运动
    // 构建：CGVector gravityDircetion = {0,1};
    // {dx, dy}  dx、dy分别表示重力向量的x轴、y轴坐标
    //    behavior.gravityDirection = CGVectorMake(0, 0.5);
    // 施加外力
    // angle： 力的角度
    // magnitude： 力的大小
    [behavior setAngle:M_PI_2 magnitude:2];
    [animator addBehavior:behavior];
}

@end
