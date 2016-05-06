//
//  CompusNaviViewController.h
//  CampusMap
//
//  Created by Tarena on 16/4/14.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnnotationModel.h"
#import "TYCircleCollectionView.h"


//添加一个block
typedef void(^ADDPOIN_BLOCK)(AnnotationModel *);


@interface CompusNaviViewController : UIViewController
/** BLOCK属性 */
@property (nonatomic, copy) ADDPOIN_BLOCK addPoin;

@property (nonatomic, strong) TYCircleCollectionView *collectionView;

@property (nonatomic, copy) NSArray *items;

@end
