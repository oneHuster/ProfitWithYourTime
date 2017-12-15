//
//  BaiduMapC.m
//  闲么
//
//  Created by 邹应天 on 16/3/22.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import "BaiduMapC.h"


@implementation BaiduMapC
+(BaiduMapC*)getTheBDMManager{
    static BaiduMapC *sharedCLDelegate=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCLDelegate =[[BaiduMapC alloc]init];
    });
    return sharedCLDelegate;
}

- (id)init{
    self = [super init];
    if (self) {
        _locService = [[BMKLocationService alloc]init];
        _locService.delegate = self;
        [self startLocationServer];
    }
    return self;
}

- (void)startLocationServer{
    [_locService startUserLocationService];
}

/**
 *  关闭定位服务
 */
-(void)stopLocation
{
    [_locService stopUserLocationService];
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
//    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    _currentCoordinate = userLocation.location.coordinate;
    [self locationWithAddress];
}

- (void)locationWithAddress{

    BMKGeoCodeSearch *search = [[BMKGeoCodeSearch alloc]init];
    search.delegate = self;
    BMKReverseGeoCodeOption *reverseOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseOption.reverseGeoPoint = _currentCoordinate;
    [search reverseGeoCode:reverseOption];
}

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    _address = result.address;
    _streetName = result.addressDetail.streetName;
    _city = result.addressDetail.city;
    _province = result.addressDetail.province;
    _streetNumber = result.addressDetail.streetNumber;
    _district = result.addressDetail.district;
   // NSLog(@" %@ ",result.address);
    
}

@end
