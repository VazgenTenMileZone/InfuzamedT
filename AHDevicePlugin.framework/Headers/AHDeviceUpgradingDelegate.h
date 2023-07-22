//
//  LSDeviceUpgradingDelegate.h
//  LSDeviceBluetooth-Library
//
//  Created by caichixiang on 2017/3/17.
//  Copyright © 2017年 sky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTDeviceInfo.h"

@protocol AHDeviceUpgradingDelegate <NSObject>

/**
 * 设备升级状态改变的回调
 */
-(void)bleDevice:(BTDeviceInfo *)lsDevice didOtaStateChanged:(BTUpgradeState)state
           error:(BTErrorCode)code;

/**
 * 设备升级进度回调
 */
-(void)bleDevice:(BTDeviceInfo *)lsDevice didOtaProgressUpdate:(NSUInteger)value;
@end
