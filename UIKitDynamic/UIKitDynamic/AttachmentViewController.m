//
//  AttachmentViewController.m
//  UIKitDynamic
//
//  Created by dongjiawang on 2018/11/5.
//  Copyright © 2018 io.github.dongjiawang. All rights reserved.
//

#import "AttachmentViewController.h"

@interface AttachmentViewController ()<UIDynamicAnimatorDelegate>
@property (weak, nonatomic) IBOutlet UIView *animationView1;
@property (weak, nonatomic) IBOutlet UIView *animationView2;
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, assign) BOOL isAttachItems;

@end

@implementation AttachmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    _animator.delegate = self;
    
    _isAttachItems = NO;
}

- (IBAction)segmentValueChanged:(UISegmentedControl *)sender {
    
    [_animator removeAllBehaviors];
    if (sender.selectedSegmentIndex == 0) {
        self.animationView2.hidden = YES;
        _isAttachItems = NO;
    }
    else {
        self.animationView2.hidden = NO;
        _isAttachItems = YES;
    }
}


- (IBAction)startAnimation:(id)sender {
    
    UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[self.animationView1]];
    gravityBehavior.gravityDirection = CGVectorMake(0, 1);
    [_animator addBehavior:gravityBehavior];
    
    UIAttachmentBehavior *attachBehavior;
    if (_isAttachItems) {
        
        UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.animationView1, self.animationView2]];
        collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
        collisionBehavior.collisionMode = UICollisionBehaviorModeItems;
        [_animator addBehavior:collisionBehavior];
        
        attachBehavior = [[UIAttachmentBehavior alloc] initWithItem:self.animationView1 attachedToItem:self.animationView2];
    }
    else {
        attachBehavior = [[UIAttachmentBehavior alloc] initWithItem:self.animationView1 attachedToAnchor:CGPointMake(200, self.animationView1.frame.origin.y - 100)];
    }
    attachBehavior.length = 100;
    // 弹性吸附时候的震动频率
    attachBehavior.frequency = 10;
    [_animator addBehavior:attachBehavior];
}

@end
