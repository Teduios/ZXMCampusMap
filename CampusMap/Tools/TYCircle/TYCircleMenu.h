//
//  TYCircleMenu.h
//  TYCircleMenu
//
//  Created by Yeekyo on 16/3/24.
//  Copyright © 2016年 Yeekyo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYCircleCollectionView.h"
#import "TYCircleProtocol.h"

@interface TYCircleMenu : UIView<TYCircleProtocol>

/**
 *  隐藏菜单
 */
@property (nonatomic,getter=isHideMenu) BOOL hideMenu;

@property (nonatomic,weak) id<TYCircleMenuDelegate> menuDelegate;

/**
 *  初始化Menu
 *
 *  @param radious      菜单半径
 *  @param itemOffset   菜单的第一个item距离左边界的距离
 *  @param images       菜单元素的图片数组
 *  @param titles       菜单元素的标题数组
 *  @param isCycle      是否循环滚动
 *  @param menudelegate 点击菜单的事件代理
 *
 *  @return Menu
 */
- (id)initWithRadious:(CGFloat)radious
           itemOffset:(CGFloat)itemOffset
           imageArray:(NSArray *)images
           titleArray:(NSArray *)titles
                cycle:(BOOL)isCycle
         menuDelegate:(id<TYCircleMenuDelegate>)menudelegate;

@end
