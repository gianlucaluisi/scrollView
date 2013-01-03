//
//  ViewController.m
//  scrollView
//
//  Created by MonkKou on 12-10-23.
//  Copyright (c) 2012年 MonkKou. All rights reserved.
//

#import "ViewController.h"
#import "ImageScroll.h"

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //隐藏状态栏
    self.navigationController.navigationBarHidden = YES;
    
    //获取frame
    CGRect bounds = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    //图片数组
    NSMutableArray *imagesArray = [[NSMutableArray alloc] initWithObjects:@"image0.jpg", @"image1.jpg", @"image2.jpg", @"image3.jpg", @"image4.jpg", nil];
    
    ImageScroll *imageScroll = [[ImageScroll alloc] initWithFrame:bounds withImages:imagesArray];
    
    [imageScroll setAutoPlay:YES duration:3.0];
    
    [self.view addSubview:imageScroll];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
