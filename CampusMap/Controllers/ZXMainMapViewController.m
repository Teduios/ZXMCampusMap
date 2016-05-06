//
//  ZXMainMapViewController.m
//  CampusMap
//
//  Created by 周信明 on 16/4/13.
//  Copyright © 2016年 周信明. All rights reserved.
//

#import "ZXMainMapViewController.h"
#import <AMapNaviKit/MAMapKit.h>
#import "AnnotationModel.h"
#import "CompusNaviViewController.h"
#import <AMapNaviKit/AMapNaviKit.h>
#import <AMapNaviKit/AMapNaviRoute.h>
#import "LrdOutputView.h"
#import "UIView+HUD.h"



@interface ZXMainMapViewController ()<MAMapViewDelegate, AMapNaviManagerDelegate, LrdOutputViewDelegate>
/** 地图对象 */
@property (nonatomic, strong) MAMapView *mapView;
/** 存储用户定位信息 */
@property (nonatomic, strong) MAUserLocation *userLocation;
/** 存储大头针对象模型 */
@property (nonatomic, strong) AnnotationModel *annotationModel;
/** 存储大头针视图上的图片 */
@property (nonatomic, strong) UIImageView *pointImageView;
/** 点击图片会弹出的视图 */
@property (weak, nonatomic) IBOutlet UIView *pointImageBlackView;
/** 放大的视图 */
@property (weak, nonatomic) IBOutlet UIImageView *pointBigImageView;
/** 判断是不是当前大头针 */
@property (nonatomic, assign) BOOL isCurrentPointAnnotation;

/** 导航对象管理器 */
@property (nonatomic, strong) AMapNaviManager *naviManager;

/** 左侧导航菜单数组 */
@property (nonatomic, strong) NSArray *dataArr;
/** 弹出框视图对象 */
@property (nonatomic, strong) LrdOutputView *outputView;
/** 清理button */
@property (weak, nonatomic) IBOutlet UIButton *clearMarkBtn;

@end          

@implementation ZXMainMapViewController
#pragma mark - Lazy Load懒加载
- (AMapNaviManager *)naviManager {
    if (_naviManager == nil)
    {
        _naviManager = [[AMapNaviManager alloc] init];
        [_naviManager setDelegate:self];
    }
    return _naviManager;
}

#pragma mark - Life Circle 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //配置地图视图
    [self configMapView];
    //配置导航key
    [AMapNaviServices sharedServices].apiKey = APIKEY;
    //配置导航栏左侧的菜单按钮
    [self configLeftMenuBtn];
}

#pragma mark - 配置导航栏左侧的菜单按钮
/** 配置导航栏左侧的菜单按钮 */
- (void)configLeftMenuBtn {
    //几个model
    LrdCellModel *one = [[LrdCellModel alloc] initWithTitle:@"卫星地图"];
    LrdCellModel *two = [[LrdCellModel alloc] initWithTitle:@"3D地图" ];
    LrdCellModel *three = [[LrdCellModel alloc] initWithTitle:@"交通路况"];
    LrdCellModel *four = [[LrdCellModel alloc] initWithTitle:@"移除标注"];
    LrdCellModel *five = [[LrdCellModel alloc] initWithTitle:@"更多导航"];
    self.dataArr = @[one, two, three, four, five];
}
- (IBAction)leftMenuBtnClick:(UIButton *)sender {
    CGFloat x = 5;
    CGFloat y = 64;
    _outputView = [[LrdOutputView alloc] initWithDataArray:self.dataArr origin:CGPointMake(x, y) width:100 height:44 direction:kLrdOutputViewDirectionLeft];
    _outputView.delegate = self;
    _outputView.dismissOperation = ^(){
        //设置成nil，以防内存泄露
        _outputView = nil;
    };
    [_outputView pop];
}

/** 选中弹出菜单的方法 */
- (void)didSelectedAtIndexPath:(NSIndexPath *)indexPath {

    switch (indexPath.row) {
        case 0://卫星地图样式
            self.mapView.mapType = MAMapTypeSatellite;
            break;
        case 1://3D地图
            self.mapView.mapType = MAMapTypeStandard;
            break;
        case 2://是否显示城市交通
            self.mapView.showTraffic = !self.mapView.showTraffic;
            break;
        case 3://清除标记
            [self.mapView removeAnnotations:self.mapView.annotations];
            [self.mapView removeOverlays:self.mapView.overlays];
            self.clearMarkBtn.hidden = YES;
            break;
        case 4://唤起高德
            [self gotoGaoDeMap];
            
            break;
        default:
            break;
    }
}
//跳转到高德
-(void)gotoGaoDeMap {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://maps.apple.com/?slat,slng"]];
    UIApplication *app = [UIApplication sharedApplication];
    if ([app canOpenURL:url]) {
        [app openURL:url];
    }else {
        NSLog(@"打开应用程序失败");
    }
}

#pragma mark - 配置地图数据
- (void) configMapView {
    //地图对象
    [MAMapServices sharedServices].apiKey = APIKEY;
    self.mapView = [[MAMapView alloc]init];
    self.mapView.frame = self.view.frame;
    [self.view insertSubview:self.mapView atIndex:0];
    
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    [self.mapView setUserTrackingMode:MAUserTrackingModeFollowWithHeading animated:YES];
    
    self.mapView.scaleOrigin = CGPointMake(20, 74);
    [self.mapView setCompassOrigin:CGPointMake(self.mapView.bounds.size.width-50, 72)];
    
    [self.mapView setCompassImage:[UIImage imageNamed:@"compass"]];
}


#pragma mark - Methods 方法
/** 左下角定位按钮 */
- (IBAction)leftBarbuttonClick:(id)sender {
    [self.mapView setUserTrackingMode:MAUserTrackingModeFollowWithHeading animated:YES];
}

/** 截取的跳转方法 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController *navi = segue.destinationViewController;
    CompusNaviViewController *CNVC = [navi.viewControllers firstObject];
    CNVC.addPoin = ^(AnnotationModel *model){
        self.annotationModel = model;
        //    添加大头针
        MAPointAnnotation *point = [[MAPointAnnotation alloc]init];
        point.coordinate = CLLocationCoordinate2DMake(model.coordinate.latitude, model.coordinate.longitude);
        point.title = model.titleName;
        point.subtitle = model.subTitleName;
        [self.mapView addAnnotation:point];
        self.mapView.centerCoordinate = point.coordinate;
    };
    //跳转时也隐藏弹出的视图
    self.pointImageBlackView.hidden = YES;
    
}

/** 大头针的相关设置 */
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView *PinAnnotationView = (MAPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (PinAnnotationView == nil)
        {
            PinAnnotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        PinAnnotationView.canShowCallout= YES;
        PinAnnotationView.animatesDrop = YES;
        PinAnnotationView.draggable = YES;
        PinAnnotationView.pinColor = MAPinAnnotationColorGreen;
        
        UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
        [leftBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [leftBtn setImage:self.annotationModel.imageName forState:UIControlStateNormal];
        PinAnnotationView.leftCalloutAccessoryView = leftBtn;
        
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        rightBtn.frame = CGRectMake(0, 0, 30, 30);
        PinAnnotationView.rightCalloutAccessoryView = rightBtn;
        
        return PinAnnotationView;
    }
    return nil;
}
/** 点击了大头针左侧视图 */
- (void)leftBtnClick:(UIButton *)sender {
    self.pointImageBlackView.hidden = NO;
    self.pointBigImageView.image = sender.imageView.image;
}

/** 点击屏幕隐藏大头针弹出的图片 */
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.pointImageBlackView.hidden = YES;
    
}

/** 点击大头针视图右侧的信息 */
- (void)rightBtnClick:(UIButton *)sender {
    //弹出一个视图 一个导航按钮 一个详情按钮 一个取消按钮
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"小明为你提供导航" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"到这儿去" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //添加导航方法
        [self routeCalculate];
        [self.view showBusyHUD];
        
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:action1];
//    [alert addAction:action2];
    [alert addAction:action3];
    [self presentViewController:alert animated:YES completion:nil];
}

/** 定位回调，通过回调函数，能获取到定位点的经纬度坐标 */
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    self.userLocation = userLocation;
    if(updatingLocation)
    {
        userLocation.title = @"当前位置";
        userLocation.subtitle = @"I'm here~";
    }
    
}
/** 清除标记大头针 */
- (IBAction)cleanMarkPoint:(id)sender {
    //清除所有大头针
    [self.mapView removeAnnotations:self.mapView.annotations];
    // 清除旧的overlays
    [self.mapView removeOverlays:self.mapView.overlays];
    self.clearMarkBtn.hidden = YES;
}

/** 路径规划方法 */
- (void)routeCalculate
{
    AMapNaviPoint *startPoint = [AMapNaviPoint locationWithLatitude:self.userLocation.coordinate.latitude longitude:self.userLocation.coordinate.longitude];
    AMapNaviPoint *endPoint = [AMapNaviPoint locationWithLatitude:self.annotationModel.coordinate.latitude longitude:self.annotationModel.coordinate.longitude];
    NSArray *startPoints = @[startPoint];
    NSArray *endPoints   = @[endPoint];
    
    //步行路径规划
    [self.naviManager calculateWalkRouteWithStartPoints:startPoints endPoints:endPoints];
}

/** 规划成功回调方法 */
- (void)naviManagerOnCalculateRouteSuccess:(AMapNaviManager *)naviManager {
    [self showRouteWithNaviRoute:naviManager.naviRoute];
    [self.view hideBusyHUD];
}
/**绘制路径*/
- (void)showRouteWithNaviRoute:(AMapNaviRoute *)naviRoute
{
    if (naviRoute == nil) return;
    // 清除旧的overlays
    [self.mapView removeOverlays:self.mapView.overlays];
    NSUInteger coordianteCount = [naviRoute.routeCoordinates count];
    //声明一个C语言的结构体数组
    CLLocationCoordinate2D coordinates[coordianteCount];
    for (int i = 0; i < coordianteCount; i++)
    {
        AMapNaviPoint *aCoordinate = [naviRoute.routeCoordinates objectAtIndex:i];
        coordinates[i] = CLLocationCoordinate2DMake(aCoordinate.latitude, aCoordinate.longitude);
    }

    MAPolyline *polyline = [MAPolyline polylineWithCoordinates:coordinates count:coordianteCount];
    [self.mapView addOverlay:polyline];
    
    //显示清除按钮
    self.clearMarkBtn.hidden = NO;
    //调整地图显示范围
    [self fitMapViewForPolyLine:polyline];

}
/**调整地图显示算法*/
- (void)fitMapViewForPolyLine:(MAPolyline *)polyLine{
    CGFloat ltX, ltY, maxX, maxY;
    if (polyLine.pointCount < 2)  return;
    MAMapPoint pt = polyLine.points[0];
    ltX = pt.x; ltY = pt.y;
    maxX = pt.x; maxY = pt.y;
    for (int i = 1; i < polyLine.pointCount; i++) {
        MAMapPoint innerPt = polyLine.points[i];
        if (innerPt.x < ltX) {
            ltX = innerPt.x;
        }
        if (innerPt.y < ltY) {
            ltY = innerPt.y;
        }
        if (innerPt.x > maxX) {
            maxX = innerPt.x;
        }
        if (innerPt.y > maxY) {
            maxY = innerPt.y;
        }
    }
    CGFloat sizeWH = (maxX - ltX) > (maxY - ltY) ? (maxX - ltX) : (maxY - ltY);
    MAMapRect  rect  = MAMapRectMake(ltX - 40, ltY - 60, sizeWH + 200, sizeWH + 200);
    [self.mapView setVisibleMapRect:rect edgePadding:UIEdgeInsetsMake(50, 50, 50, 50) animated:YES];
}

/**设置路线样式*/
-(MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id<MAOverlay>)overlay{
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineView *polylineView = [[MAPolylineView alloc] initWithPolyline:overlay];
        polylineView.lineWidth   = 8.0f;
        polylineView.strokeColor = [UIColor greenColor];
        return polylineView;
    }
    return nil;
}
/** 导航出错的回调方法 */
- (void)naviManager:(AMapNaviManager *)naviManager error:(NSError *)error {
    [self.view showWarning:@"导航出错啦"];
}

@end
