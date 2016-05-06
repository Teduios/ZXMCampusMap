//
//  TYCircleView.m
//  TYCircleMenu
//
//  Created by Yeekyo on 16/3/24.
//  Copyright © 2016年 Yeekyo. All rights reserved.
//

#import "TYCircleView.h"
#import "TYCircleMacros.h"

@implementation TYCircleView


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef con = UIGraphicsGetCurrentContext();
    CGFloat radius = self.bounds.size.width/2;
    CGContextAddArc(con, radius, radius, radius, 0, 2*M_PI, NO);
    CGContextAddArc(con, radius, radius, radius-TYCircleCellSize.height-2*TYDefaultItemPadding, 2*M_PI, 0, YES);
    //圈的背景颜色
    CGContextSetFillColorWithColor(con, [UIColor colorWithRed:244/255.0 green:228/255.0 blue:182/255.0 alpha:1.0].CGColor);//244 228 182
    //colorWithRed:0 green:52/255.0 blue:118/255.0 alpha:1.0
    CGContextFillPath(con);
}

    
@end
