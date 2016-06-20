//
//  LGLBanner.h
//  LGLKit
//
//  Created by luoguilin on 16/6/20.
//  Copyright © 2016年 luoguilin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LGLBanner;

typedef NS_ENUM(NSInteger,LGLBannerMode){
    LGLBannerImageMode,
    LGLBannerTextMode
};

typedef NS_ENUM(NSInteger,LGLBannerScrollDirection) {
    LGLBannerScrollHorizontal,
    LGLBannerScrollVertical
};

@protocol LGLBannerDelegate <NSObject>

- (void)banner:(LGLBanner *)banner didSelectItemAtIndex:(NSInteger)index;

@end

@interface LGLBanner : UIView

@property (nonatomic,weak) id<LGLBannerDelegate> delegate;

@property (nonatomic,strong) NSArray *itemDataList;
@property (nonatomic,strong) UIColor *pageIndicatorColor;               // default is whitecolor
@property (nonatomic,strong) UIColor *currentPageIndicatorColor;        // default is blackcolor
@property (nonatomic,assign) CGFloat duration;                          // default is 3s
@property (nonatomic,assign) LGLBannerScrollDirection *scrollDirection;
@property (nonatomic,assign) CGRect pageControlFrame;                   // default is horizontal center layout
@property (nonatomic,assign) BOOL showPageControl;                      // default is YES
@property (nonatomic,assign) BOOL scrollEnabled;                        // default is enabled

- (instancetype)initWithFrame:(CGRect)frame mode:(LGLBannerMode)mode;
- (void)stopTimer;

@end
