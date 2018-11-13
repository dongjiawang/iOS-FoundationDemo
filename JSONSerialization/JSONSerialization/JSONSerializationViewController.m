//
//  JSONSerializationViewController.m
//  JSONSerialization
//
//  Created by dongjiawang on 2018/11/7.
//  Copyright © 2018 io.github.dongjiawang. All rights reserved.
//

#import "JSONSerializationViewController.h"

@interface JSONSerializationViewController ()<UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UIView *tableView;
    
@end

@implementation JSONSerializationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSString *messageUrl = @"http://www.msece.com/waether/src/areaDate/101010100.json";
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionTask *messgeTask = [session dataTaskWithURL:[NSURL URLWithString:messageUrl]
                                          completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                              NSString *jsonString = [NSString stringWithUTF8String:[data bytes]];
                                              NSLog(@"%@", jsonString);
                                          }];
    [messgeTask resume];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}



@end
