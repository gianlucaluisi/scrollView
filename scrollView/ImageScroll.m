//
//  imageScroll.m
//  scrollView
//
//  Created by MonkKou on 12-10-24.
//  Copyright (c) 2012年 MonkKou. All rights reserved.
//

#import "ImageScroll.h"

@implementation ImageScroll

@synthesize scrollView = _scrollView;
@synthesize pageControl = _pageControl;

//初始化，设置frame和图片组
- (id)initWithFrame:(CGRect)frame withImages:(NSMutableArray *)imagesArray
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        if (imagesArray  == nil) {
            NSLog(@"警告：图片组为空！");
        }
        
        //设置默认值
        _frame = frame;
        _timer = nil;
        _autoPlay = NO;
        _playNext = YES;
        _playDuration = 0;
        _oldX = 0;
        _newX = 0;
        
        //初始化scrollView
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        //设置可滑动
        _scrollView.pagingEnabled = YES;
        //不显示水平滑动栏
        _scrollView.showsHorizontalScrollIndicator = NO;
        //设置代理
        _scrollView.delegate = self;
        
        
        
        //初始化pageContol
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, frame.size.height - 30, frame.size.width, 30)];
        _pageControl.enabled = YES;
        
        //点击响应
        [_pageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
        
        //注意逻辑顺序，先将两个控件都初始化，然后才可填充控件
        //填充scrollView
        [self setImages:imagesArray];
        
        [self addSubview:_scrollView];
        [self addSubview:_pageControl];
    }
    return self;
}

//设置图片，并填充控件
- (void) setImages:(NSMutableArray *)imagesArray
{
    if (imagesArray == nil) {
        NSLog(@"警告：图片组为空");
    }
    
    //设置内容大小
    _scrollView.contentSize = CGSizeMake(_frame.size.width * imagesArray.count,
                                         _frame.size.height);
    //填充scorllView
    for (int i = 0; i<imagesArray.count; i++) {
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(_frame.size.width * i, 0, _frame.size.width, _frame.size.height)];
        image.image = [UIImage imageNamed:[imagesArray objectAtIndex:i]];
        [_scrollView addSubview:image];
    }
    
    //设置pageControll
    _pageControl.numberOfPages = imagesArray.count;
    _pageControl.currentPage = 0;
}


//是否自动播放
- (void) setAutoPlay:(BOOL)autoPlay duration:(float)playDuration
{
    if (playDuration <= 0) {
        NSLog(@"警告：未设置播放间隔");
    }
    _autoPlay = autoPlay;
    _playDuration = playDuration;
    if (_autoPlay) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:_playDuration target:self selector:@selector(playImage) userInfo:self repeats:YES];
    } else {
        [_timer invalidate];
    }
}

//播放图片
- (void) playImage
{
    //获取控件大小
    CGSize viewSize = _scrollView.frame.size;
    
    //已至最后一页
    if (_pageControl.currentPage + 1 == _pageControl.numberOfPages) {
        _playNext = NO;
    } else
        //以至最前一页
        if (_pageControl.currentPage == 0) {
            _playNext = YES;
        }
    
    if (_playNext) {
        //向后播放
        CGRect rect = CGRectMake(viewSize.width * (_pageControl.currentPage + 1), 0, viewSize.width, viewSize.height);
        [_scrollView scrollRectToVisible:rect animated:YES];
        [_pageControl setCurrentPage:_pageControl.currentPage + 1];
    } else {
        //向前播放
        CGRect rect = CGRectMake(viewSize.width * (_pageControl.currentPage - 1), 0, viewSize.width, viewSize.height);
        [_scrollView scrollRectToVisible:rect animated:YES];
        [_pageControl setCurrentPage:_pageControl.currentPage - 1];
    }
    
}

#pragma UIScrollView delegate

//响应拖动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //更新UIPageControl的当前页
    CGPoint offset = _scrollView.contentOffset;
    CGRect bounds = _scrollView.frame;
    [_pageControl setCurrentPage:offset.x / bounds.size.width];
}

//拖动开始响应
- (void) scrollViewWillBeginDragging:(UIScrollView *) scrollView
{
    //结束计时
    [_timer invalidate];
    _oldX = _scrollView.contentOffset.x;
}

//拖动结束响应
- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    _newX = _scrollView.contentOffset.x;
    if (_autoPlay) {
        //判断拖动方向
        if (_newX > _oldX && (_newX-_oldX)>_frame.size.width/2) {
            NSLog(@"right");
            if (_pageControl.currentPage != _pageControl.numberOfPages -1) {
                _playNext = YES;
            }
        } else if (_newX < _oldX && (_oldX-_newX)>_frame.size.width/2) {
            NSLog(@"left");
            if (_pageControl.currentPage != 0) {
                _playNext = NO;
            }
        }
        //重新计时
        _timer = [NSTimer scheduledTimerWithTimeInterval:_playDuration target:self selector:@selector(playImage) userInfo:self repeats:YES];
    }
}

//响应pageControll的点击
- (void) pageTurn:(UIPageControl*)sender
{
    //令UIScrollView做出相应的滑动显示
    
    CGSize viewSize = _scrollView.frame.size;
    CGRect rect = CGRectMake(sender.currentPage * viewSize.width, 0, viewSize.width, viewSize.height);
    [_scrollView scrollRectToVisible:rect animated:YES];
}

@end
