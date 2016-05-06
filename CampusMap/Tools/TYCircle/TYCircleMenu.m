//
//  TYCircleMenu.m
//  TYCircleMenu
//
//  Created by Yeekyo on 16/3/24.
//  Copyright © 2016年 Yeekyo. All rights reserved.
//

#import "TYCircleMenu.h"
#import "TYCircleView.h"
#import "TYCircleMacros.h"
#import "TYCircleCollectionViewLayout.h"


@implementation TYCircleMenu
{
    TYCircleView *circleView;
    TYCircleCollectionView *circleCollectionView;
    //菜单半径
    CGFloat menuRadious;
    //背景圆环的半径
    CGFloat circleRadious;
}

- (id)initWithRadious:(CGFloat)radious itemOffset:(CGFloat)itemOffset imageArray:(NSArray *)images titleArray:(NSArray *)titles cycle:(BOOL)isCycle menuDelegate:(id<TYCircleMenuDelegate>)menudelegate {
    
    menuRadious = radious;
    return [self initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - menuRadious, menuRadious, menuRadious) itemOffset:itemOffset imageArray:images titleArray:titles cycle:isCycle menuDelegate:menudelegate];
}

- (id)initWithFrame:(CGRect)frame itemOffset:(CGFloat)itemOffset imageArray:(NSArray *)images titleArray:(NSArray *)titles cycle:(BOOL)isCycle menuDelegate:(id<TYCircleMenuDelegate>)menudelegate {
    
    if ((self = [super initWithFrame:frame])) {
        circleRadious = menuRadious-(itemOffset+TYCircleCellSize.height/2)-TYCircleViewMargin-TYCircleViewMargin;
        
        circleView = [[TYCircleView alloc]initWithFrame:CGRectMake(-circleRadious+(itemOffset+TYCircleCellSize.height/2)-TYDefaultItemPadding, TYCircleViewMargin+TYCircleViewMargin-TYDefaultItemPadding, (circleRadious+TYDefaultItemPadding)*2, (circleRadious+TYDefaultItemPadding)*2)];
        
        if (isCycle) {
            NSAssert(images.count>=4, @"option'count must big than 4");
            images = [self cycleArrayWithArray:[NSMutableArray arrayWithArray:images]];
            
            titles = [self cycleArrayWithArray:[NSMutableArray arrayWithArray:titles]];
            circleCollectionView = [[TYCircleCollectionView alloc] initWithFrame:self.bounds itemOffset:itemOffset cycle:isCycle imageArray:images titleArray:titles];
            [circleCollectionView setContentOffset:CGPointMake(0, ([UIScreen mainScreen].bounds.size.height/TYDefaultVisibleNum)*3)];
        } else {
            circleCollectionView = [[TYCircleCollectionView alloc] initWithFrame:self.bounds itemOffset:itemOffset cycle:isCycle imageArray:images titleArray:titles];
        }

        circleCollectionView.menuDelegate = menudelegate;
        
        __weak TYCircleMenu *weakSelf = self;
        circleCollectionView.selecteBlock = ^() {
            [weakSelf setCircleMenuHidden:YES animated:YES];
        };
        
        UIButton *centerButton = [[UIButton alloc]initWithFrame:CGRectMake(20, self.bounds.size.height-70, 50, 50)];
        [centerButton setImage:[UIImage imageNamed:@"navi_center"] forState:UIControlStateNormal];
        [centerButton addTarget:self action:@selector(onCenterButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:circleView];
        [self addSubview:circleCollectionView];
        [self addSubview:centerButton];
        
        [self setCircleMenuHidden:YES animated:NO];
    }
    return self;
}

- (void)onCenterButtonClick:(UIButton *)sender {
    
    [self setCircleMenuHidden:!self.isHideMenu animated:YES];
}


#pragma mark - 显示和隐藏菜单

- (void)setCircleMenuHidden:(BOOL)hidden animated:(BOOL)animated {
    
    if (hidden) {
        [self hideCircleMenuWithAnimation:animated];
    } else {
        [self showCircleMenuWithAnimation:animated];
    }
}

- (void)showCircleMenuWithAnimation:(BOOL)animated {
    
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            circleCollectionView.transform = CGAffineTransformIdentity;
            circleCollectionView.alpha = 1.f;
            circleView.transform = CGAffineTransformIdentity;
            circleView.alpha = 1.f;
        }];
    } else {
        circleCollectionView.alpha = 1.f;
        circleView.alpha = 1.f;
    }
    self.hideMenu = NO;
}

- (void)hideCircleMenuWithAnimation:(BOOL)animated {
    
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            [self hideCircleMenu];
        }];
    } else {
        [self hideCircleMenu];
    }
    self.hideMenu = YES;
}

- (void)hideCircleMenu {
    
    CGAffineTransform translation = CGAffineTransformMakeTranslation(-30, 30);
    CGAffineTransform scale = CGAffineTransformMakeScale(0.5, 0.5);
    circleCollectionView.transform = CGAffineTransformConcat(scale, translation);
    circleCollectionView.alpha = 0.f;
    circleView.transform = CGAffineTransformMakeScale(0.6, 0.6);
    circleView.alpha = 0.f;
}

#pragma mark -setter

- (void)setVisibleNum:(unsigned int)visibleNum {
    circleCollectionView.circleLayout.visibleNum = visibleNum;
}

- (void)setIsDismissWhenSelected:(BOOL)isDismissWhenSelected {
    circleCollectionView.isDismissWhenSelected = isDismissWhenSelected;
}

#pragma mark 

- (NSArray*)cycleArrayWithArray:(NSMutableArray *)originArray {
    
    NSArray *beginArray = [originArray subarrayWithRange:NSMakeRange(originArray.count-3, 3)];
    NSArray *tailArray = [originArray subarrayWithRange:NSMakeRange(0, 3)];
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 3)];
    
    [originArray insertObjects:beginArray atIndexes:indexSet];
    [originArray addObjectsFromArray:tailArray];
    return [originArray copy];
}


@end
