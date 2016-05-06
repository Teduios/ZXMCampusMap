//
//  TYCircleCollectionViewLayout.h
//  TYCircleMenu
//
//  Created by Yeekyo on 16/3/24.
//  Copyright © 2016年 Yeekyo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYCircleProtocol.h"

@interface TYCircleCollectionViewLayout : UICollectionViewLayout<TYCircleProtocol>

//菜单item的总数
@property (nonatomic, assign) NSInteger cellCount;

//itemHeight
@property (nonatomic, assign) CGFloat itemHeight;

//半径
@property (nonatomic, assign) CGFloat circleRadius;

/**
 *  第一个元素距离左边界的距离
 */
@property (nonatomic, assign) CGFloat itemOffset;

/**
 *  滚动的偏移
 */
@property (nonatomic, assign) CGFloat offset;


-(id)initWithRadius:(CGFloat)radius itemOffset:(CGFloat)itemOffset;

@end
