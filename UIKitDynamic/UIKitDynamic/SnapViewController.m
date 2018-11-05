//
//  SnapViewController.m
//  UIKitDynamic
//
//  Created by dongjiawang on 2018/11/5.
//  Copyright © 2018 io.github.dongjiawang. All rights reserved.
//

#import "SnapViewController.h"

@interface SnapViewController ()
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (weak, nonatomic) IBOutlet UIView *animationView1;

@end

@implementation SnapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
}
- (IBAction)startAnimation:(id)sender {    
    UISnapBehavior *behavior = [[UISnapBehavior alloc] initWithItem:self.animationView1 snapToPoint:CGPointMake(100, 400)];
    behavior.damping = 10;
    [_animator addBehavior:behavior];
}

@end
