//
//  BaiduMapC.h
//  闲么
//
//  Created by 邹应天 on 16/3/22.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import <BaiduMapAPI_Search/BMKGeocodeSearch.h>
@interface BaiduMapC : BMKMapManager<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>

//定位服务
@property (strong,nonatomic) BMKLocationService *locService;
//当前坐标
@property(assign,nonatomic) CLLocationCoordinate2D currentCoordinate;
//具体位置
@property (strong,nonatomic) NSString *address;

/// 街道号码
@property (nonatomic, strong) NSString* streetNumber;
/// 街道名称
@property (nonatomic, strong) NSString* streetName;
/// 区县名称
@property (nonatomic, strong) NSString* district;
/// 城市名称
@property (nonatomic, strong) NSString* city;
/// 省份名称
@property (nonatomic, strong) NSString* province;

+ (BaiduMapC*)getTheBDMManager;

- (void)startLocationServer;
//关闭定位
- (void)stopLocation;

- (void)locationWithAddress;
@end
