//
//  CompusNaviViewController.m
//  CampusMap
//
//  Created by Tarena on 16/4/14.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import "CompusNaviViewController.h"
#import <AMapNaviKit/MAMapKit.h>
#import "TYCircleCell.h"
#import "TYCircleMenu.h"


@interface CompusNaviViewController ()<TYCircleMenuDelegate>
/** 返回按钮 */
- (IBAction)backBtnClick:(id)sender;
/** 大头针模型 */
@property (nonatomic, strong) AnnotationModel *annotation;


@end

@implementation CompusNaviViewController
- (AnnotationModel *)annotation {
    if (!_annotation) {
        _annotation = [[AnnotationModel alloc]init];
    }
    return _annotation;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self configCycleMenu];

}
/** 配置循环菜单*/
- (void)configCycleMenu {
    //圆盘的图标和名称
    self.items = @[@"MultiBuild",@"Library",@"Classroom",@"Actions",@"Sports",@"Hotel",@"WCanteen",@"SClass",
                   @"Museum",@"SCanteen"];
    TYCircleMenu *menu = [[TYCircleMenu alloc]initWithRadious:220 itemOffset:0 imageArray:self.items titleArray:self.items cycle:NO menuDelegate:self];
    menu.isDismissWhenSelected = YES; //点击菜单项，隐藏菜单
    [self.view addSubview:menu];
}


/** 选中菜单的按钮 */
- (void)selectMenuAtIndex:(NSInteger)index {
    switch (index) {
        case 0:
            self.annotation.titleName = @"综合楼";
            self.annotation.subTitleName = @"很多业务都在这里噢";
            self.annotation.imageName = [UIImage imageNamed:@"MultiBuild1"];
            self.annotation.coordinate = CLLocationCoordinate2DMake(34.62047, 113.69644);//正确
            self.addPoin(self.annotation);//Block
            break;
        case 1:
            self.annotation.titleName = @"图书馆";
            self.annotation.subTitleName = @"好好学习天天向上";
            self.annotation.imageName = [UIImage imageNamed:@"Library1"];
            self.annotation.coordinate = CLLocationCoordinate2DMake(34.62247, 113.6918);//正确的经纬度
            self.addPoin(self.annotation);
            break;
        case 2:
            self.annotation.titleName = @"本部教学楼";
            self.annotation.subTitleName = @"按时上课哟";
            self.annotation.imageName = [UIImage imageNamed:@"Classroom1"];
            self.annotation.coordinate = CLLocationCoordinate2DMake(34.62337, 113.6902);//正确
            self.addPoin(self.annotation);
            break;
        case 3:
            self.annotation.titleName = @"学生活动中心";
            self.annotation.subTitleName = @"大礼堂又有活动啦";
            self.annotation.imageName = [UIImage imageNamed:@"Actioncenter1"];
            self.annotation.coordinate = CLLocationCoordinate2DMake(34.62467, 113.69319);//正确
            self.addPoin(self.annotation);
            break;
        case 4:
            self.annotation.titleName = @"体育馆";
            self.annotation.subTitleName = @"每天运动一小时";
            self.annotation.imageName = [UIImage imageNamed:@"SportsCenter1"];
            self.annotation.coordinate = CLLocationCoordinate2DMake(34.62490, 113.6918);//正确
            self.addPoin(self.annotation);
            break;
        case 5:
            self.annotation.titleName = @"南苑宾馆";
            self.annotation.subTitleName = @"这里是接待客人的";
            self.annotation.imageName = [UIImage imageNamed:@"Hotel1"];
            self.annotation.coordinate = CLLocationCoordinate2DMake(34.61979, 113.6921);//正确
            self.addPoin(self.annotation);
            break;
        case 6:
            self.annotation.titleName = @"西校区圣源餐厅";
            self.annotation.subTitleName = @"吃饭时间又到啦";
            self.annotation.imageName = [UIImage imageNamed:@"WestCanteen1"];
            self.annotation.coordinate = CLLocationCoordinate2DMake(34.62672, 113.6936);//正确
            self.addPoin(self.annotation);
            break;
        case 7:
            self.annotation.titleName = @"南区教学楼";
            self.annotation.subTitleName = @"别忘了带上课本";
            self.annotation.imageName = [UIImage imageNamed:@"SouthClassroom1"];
            self.annotation.coordinate = CLLocationCoordinate2DMake(34.61554, 113.6982);//正确
            self.addPoin(self.annotation);
            break;
        case 8:
            self.annotation.titleName = @"服装博物馆";
            self.annotation.subTitleName = @"这里有很多衣服哟";
            self.annotation.imageName = [UIImage imageNamed:@"ClothMuseum1"];
            self.annotation.coordinate = CLLocationCoordinate2DMake(34.61034, 113.7021);//正确
            self.addPoin(self.annotation);
            break;
        case 9:
            self.annotation.titleName = @"南校区龙源餐厅";
            self.annotation.subTitleName = @"这是吃饭的地方啦";
            self.annotation.imageName = [UIImage imageNamed:@"WestCanteen1"];
            self.annotation.coordinate = CLLocationCoordinate2DMake(34.61714, 113.6995);//正确
            self.addPoin(self.annotation);
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)backBtnClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
