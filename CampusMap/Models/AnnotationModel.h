//
//  AnnotationModel.h
//  CampusMap
//
//  Created by Tarena on 16/4/19.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AMapNaviKit/MAMapKit.h>

@interface AnnotationModel : NSObject<MAAnnotation>
/** 标题 */
@property (nonatomic, copy) NSString *titleName;
/** 子标题 */
@property (nonatomic, copy) NSString *subTitleName;
/** 图片名 */
@property (nonatomic, copy) UIImage *imageName;
/** 经纬度 */
@property (nonatomic) CLLocationCoordinate2D coordinate;

@end
