//
//  imageScroll.h
//  scrollView
//
//  Created by MonkKou on 12-10-24.
//  Copyright (c) 2012年 MonkKou. All rights reserved.
//

#import <UIKit/UIKit.h>

//使用说明
/*
 初始化时传入一组图片并设置控件大小
 即可使图片滚动显示，但不能循环
 可以设置自动播放，并设置播放间隔
 自动播放时为从第一张开始播放，至最后一张时倒序播放，
 再至第一张时正序播放，如此往复。
 在自动播放过程中，若用户拖动图片，向前拖动则自动向前播放，
 向后拖动则自动向后播放。
 */


@interface ImageScroll : UIView <UIScrollViewDelegate>
{
    CGRect _frame;
    //定时器，用于自动播放
    NSTimer *_timer;
    //是否自动播放
    BOOL _autoPlay;
    //向前播放还是向后播放
    BOOL _playNext;
    //播放间隔
    float _playDuration;
    //偏移量，用于判定拖动方向
    float _oldX;
    float _newX;
}


@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;

//初始化
- (id) initWithFrame:(CGRect)frame withImages:(NSMutableArray *)imagesArray;

//此处仅为减少初始化函数长度，将图片填充过程另写为一个函数
- (void) setImages:(NSMutableArray *)imagesArray;

//是否自动播放，默认不自动播放，
//若需使用，请设置
- (void) setAutoPlay:(BOOL) autoPlay duration:(float) playDuration;

@end
