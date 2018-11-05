//
//  PushViewController.m
//  UIKitDynamic
//
//  Created by dongjiawang on 2018/11/5.
//  Copyright © 2018 io.github.dongjiawang. All rights reserved.
//

#import "PushViewController.h"

@interface PushViewController ()
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (weak, nonatomic) IBOutlet UIView *animationView1;

@end

@implementation PushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
}

- (IBAction)startAnimation:(id)sender {
    
    /*
     // 连续的推动
     UIPushBehaviorModeContinuous,
     // 瞬间的推动
     UIPushBehaviorModeInstantaneous
     */
    
    UIPushBehavior *behavior = [[UIPushBehavior alloc] initWithItems:@[self.animationView1] mode:UIPushBehaviorModeContinuous];
    [behavior setPushDirection:CGVectorMake(0.5, 0.5)];
    [behavior setMagnitude:1];
    [_animator addBehavior:behavior];
}

@end
