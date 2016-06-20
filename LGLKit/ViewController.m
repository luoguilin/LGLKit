//
//  ViewController.m
//  LGLKit
//
//  Created by luoguilin on 16/6/20.
//  Copyright © 2016年 luoguilin. All rights reserved.
//

#import "ViewController.h"
#import "LGLBanner.h"

@interface ViewController ()<LGLBannerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    LGLBanner *banner = [[LGLBanner alloc] initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, 200) mode:LGLBannerImageMode];
    banner.itemDataList = @[@"http://download.17dfs.com/homepage/b1.jpg",@"http://download.17dfs.com/homepage/lunbotu2/po72ah4w76.jpg"];
    banner.delegate = self;
    [self.view addSubview:banner];
}

- (void)banner:(LGLBanner *)banner didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"selectedindex:%ld",index);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
