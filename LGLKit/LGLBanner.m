//
//  LGLBanner.m
//  LGLKit
//
//  Created by luoguilin on 16/6/20.
//  Copyright © 2016年 luoguilin. All rights reserved.
//

#import "LGLBanner.h"
#import "UIImageView+WebCache.h"

#define LGLBannerWidth  self.frame.size.width
#define LGLBannerHeight self.frame.size.height

@interface LGLBanner ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIPageControl *pageControl;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) LGLBannerMode mode;
@property (nonatomic,assign) CGRect textViewFrame;
@property (nonatomic,assign) NSInteger currentItemIndex;

@end

@implementation LGLBanner

- (instancetype)initWithFrame:(CGRect)frame mode:(LGLBannerMode)mode {
    self = [super initWithFrame:frame];
    if (self) {
        self.mode = mode;
        [self setDefaultData];
        [self initializeUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame textViewFrame:(CGRect)textViewFrame mode:(LGLBannerMode)mode {
    self = [super initWithFrame:frame];
    if (self) {
        self.mode = mode;
        self.textViewFrame = CGRectMake(0, frame.size.height-textViewFrame.size.height, frame.size.width, textViewFrame.size.height);
        [self setDefaultData];
        [self initializeUI];
    }
    return self;
}

- (void)setDefaultData {
    self.currentItemIndex = 0;
    self.duration = 3.0;
    self.scrollDirection = LGLBannerScrollHorizontal;
    self.showPageControl = YES;
    self.scrollEnabled = YES;
    self.pageIndicatorColor = [UIColor whiteColor];
    self.currentPageIndicatorColor = [UIColor blackColor];
}

- (void)initializeUI {
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.scrollView.delegate = self;
    self.scrollView.bounces = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(LGLBannerWidth*3, LGLBannerHeight);
    self.scrollView.contentOffset = CGPointMake(LGLBannerWidth, 0);
    [self addSubview:self.scrollView];
}

#pragma mark - Setter

- (void)setItemDataList:(NSArray *)itemDataList {
    if (itemDataList==nil||itemDataList.count==0) {
        return;
    }
    _itemDataList = itemDataList;
    
    if (self.itemDataList.count==1) {
        self.showPageControl = NO;
        self.scrollEnabled = NO;
    }
    
    [self.timer invalidate];
    if (self.scrollEnabled) {
        [self setupTimer];
    }
}

- (void)setPageIndicatorColor:(UIColor *)pageIndicatorColor {
    self.pageIndicatorColor = pageIndicatorColor;
}

- (void)setCurrentPageIndicatorColor:(UIColor *)currentPageIndicatorColor {
    self.currentPageIndicatorColor = currentPageIndicatorColor;
}

- (void)setDuration:(CGFloat)duration {
    self.duration = duration;
}

- (void)setScrollDirection:(LGLBannerScrollDirection *)scrollDirection {
    self.scrollDirection = scrollDirection;
}

- (void)setPageControlFrame:(CGRect)pageControlFrame {
    self.pageControlFrame = pageControlFrame;
}

- (void)setShowPageControl:(BOOL)showPageControl {
    self.showPageControl = showPageControl;
}

- (void)setScrollEnabled:(BOOL)scrollEnabled {
    self.scrollEnabled = scrollEnabled;
}

#pragma mark - CreateBannerSubviews

- (void)createBannerSubviews {
    switch (self.mode) {
        case LGLBannerImageMode:
            [self createSubviewsForImageMode];
            break;
            
        case LGLBannerTextMode:
            [self createSubviewsForTextMode];
            break;
    }
    
    self.pageControl = [[UIPageControl alloc] init];
    self.pageControl.currentPage = self.currentItemIndex;
    self.pageControl.pageIndicatorTintColor = self.pageIndicatorColor;
    self.pageControl.currentPageIndicatorTintColor = self.currentPageIndicatorColor;
    [self.pageControl addTarget:self action:@selector(changePage) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.pageControl];
}

- (void)createSubviewsForImageMode {
    for (int i = 0; i < 3; i ++) {
        UIImageView *bannerImageView = [[UIImageView alloc] initWithFrame:CGRectMake([self originForItemAtIndex:i].x, [self originForItemAtIndex:i].y, LGLBannerWidth, LGLBannerHeight)];
        bannerImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectedBannerItem:)];
        [bannerImageView addGestureRecognizer:gesture];
        [self.scrollView addSubview:bannerImageView];
    }
}

- (void)createSubviewsForTextMode {
    for (int i = 0; i < 3; i ++) {
        UILabel *bannerTextView = [[UILabel alloc] initWithFrame:CGRectMake([self originForItemAtIndex:i].x, [self originForItemAtIndex:i].y, LGLBannerWidth, LGLBannerHeight)];
        bannerTextView.userInteractionEnabled = YES;
        bannerTextView.numberOfLines = 0;
        bannerTextView.lineBreakMode = NSLineBreakByWordWrapping;
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectedBannerItem:)];
        [bannerTextView addGestureRecognizer:gesture];
        [self.scrollView addSubview:bannerTextView];
    }
}

#pragma mark - Tool

- (CGPoint)originForItemAtIndex:(NSInteger)index {
    CGFloat itemOriginX,itemOriginY;
    if (self.scrollDirection==LGLBannerScrollHorizontal) {
        itemOriginX = LGLBannerWidth * index;
        itemOriginY = 0;
    } else {
        itemOriginX = 0;
        itemOriginY = LGLBannerHeight * index;
    }
    return CGPointMake(itemOriginX, itemOriginY);
}

#pragma mark - Action

- (void)showCurrentItem {
    NSUInteger leftItemIndex,rightItemIndex;
    CGPoint offset = self.scrollView.contentOffset;
    
    if (offset.x==0) {
        self.currentItemIndex-=1;
    } else if (offset.x==self.frame.size.width*2) {
        self.currentItemIndex+=1;
    }
    
    if (self.currentItemIndex==self.itemDataList.count) {
        self.currentItemIndex = 0;
    } else if (self.currentItemIndex==-1) {
        self.currentItemIndex = self.itemDataList.count-1;
    }
    
    leftItemIndex = self.currentItemIndex-1;
    if (leftItemIndex==-1) {
        leftItemIndex = self.itemDataList.count-1;
    }
    
    rightItemIndex = self.currentItemIndex+1;
    if (rightItemIndex==self.itemDataList.count) {
        rightItemIndex = 0;
    }
    
    self.pageControl.currentPage = self.currentItemIndex;
    
    [self.scrollView.subviews enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIImageView class]]) {
            UIImageView *imageView = (UIImageView *)obj;
            [imageView sd_setImageWithURL:[NSURL URLWithString:self.itemDataList[idx]] placeholderImage:nil];
        } else if ([obj isKindOfClass:[UILabel class]]) {
            UILabel *labelView = (UILabel *)obj;
            labelView.text = self.itemDataList[idx];
        }
    }];
}

- (void)changePage {
    
    [self.scrollView setContentOffset:CGPointMake(LGLBannerWidth*2, 0) animated:YES];
    
}

- (void)setupTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.duration target:self selector:@selector(changePage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)stopTimer {
    [self.timer invalidate];
}

- (void)selectedBannerItem:(UIGestureRecognizer *)gesture {
    if ([self.delegate respondsToSelector:@selector(banner:didSelectItemAtIndex:)]) {
        [self.delegate banner:self didSelectItemAtIndex:self.currentItemIndex];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.timer invalidate];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self setupTimer];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self showCurrentItem];
    [self.scrollView setContentOffset:CGPointMake(LGLBannerWidth, 0) animated:NO];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self showCurrentItem];
    [self.scrollView setContentOffset:CGPointMake(LGLBannerWidth, 0) animated:NO];
}



@end
