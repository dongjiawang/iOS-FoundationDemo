//
//  CollisionViewController.m
//  UIKitDynamic
//
//  Created by dongjiawang on 2018/11/5.
//  Copyright © 2018 io.github.dongjiawang. All rights reserved.
//

#import "CollisionViewController.h"

@interface CollisionViewController ()<UICollisionBehaviorDelegate, UIDynamicAnimatorDelegate>
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (weak, nonatomic) IBOutlet UIView *animation1;
@property (weak, nonatomic) IBOutlet UIView *animation2;
@property (nonatomic, assign) BOOL isOnlyBoundary;

@end

@implementation CollisionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    _animator.delegate = self;
    
    _isOnlyBoundary = YES;
}

- (IBAction)segmentValueChange:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        _isOnlyBoundary = YES;
        self.animation2.hidden = YES;
    }
    else {
        _isOnlyBoundary = NO;
        self.animation2.hidden = NO;
    }
}

- (IBAction)startAnimation:(id)sender {
    UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[self.animation1]];
    gravityBehavior.gravityDirection = CGVectorMake(0, 1);
    [_animator addBehavior:gravityBehavior];
    
    /*
     // 元素之间的碰撞
     UICollisionBehaviorModeItems        = 1 << 0,
     // 边界碰撞
     UICollisionBehaviorModeBoundaries   = 1 << 1,
     // 碰撞所有
     UICollisionBehaviorModeEverything   = NSUIntegerMax
     */
    UICollisionBehavior *collisionBehavior;
    if (_isOnlyBoundary) {
        collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.animation1]];
    }
    else {
        collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.animation1, self.animation2]];
    }
    // 检测是否碰撞边界
    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    collisionBehavior.collisionMode = UICollisionBehaviorModeEverything;
    
    collisionBehavior.collisionDelegate = self;
    [_animator addBehavior:collisionBehavior];
}

- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item1 withItem:(id<UIDynamicItem>)item2 atPoint:(CGPoint)p {
    NSLog(@"当一个两个动态元素之间发生碰撞时调用");
}

- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p {
    NSLog(@"当一个动态元素与边界发生碰撞时调用");
}

- (void)collisionBehavior:(UICollisionBehavior *)behavior endedContactForItem:(id<UIDynamicItem>)item1 withItem:(id<UIDynamicItem>)item2 {
    NSLog(@"当一个两个动态元素之间碰撞结束时调用");
}

- (void)collisionBehavior:(UICollisionBehavior *)behavior endedContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier {
    NSLog(@"当一个动态元素与边界碰撞结束时调用");
}


- (void)dynamicAnimatorWillResume:(UIDynamicAnimator *)animator {
    NSLog(@"动画开始");
}

- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator {
    NSLog(@"动画结束");
}

@end
