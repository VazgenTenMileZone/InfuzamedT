//
//  AHDevicePluginProfiles.h
//  AHDevicePlugin
//
//  Created by caichixiang on 2017/3/14.
//  Copyright © 2017年 sky. All rights reserved.
//

#ifndef AHDevicePluginProfiles_h
#define AHDevicePluginProfiles_h

@class BTDeviceInfo;

/**
 * 扫描结果回调代码块
 */
typedef void(^SearchResultsBlock)(BTDeviceInfo *lsDevice);


#pragma mark - BTManagerState 工作状态

/**
 * 管理器当前的工作状态
 */
typedef NS_ENUM(NSUInteger,BTManagerState)
{
    BTManagerStateFree=0,       //空闲
    BTManagerStateScaning=1,    //扫描状态
    BTManagerStatePairing=2,    //设备配对状态
    BTManagerStateSyncing=3,    //设备同步状态
    BTManagerStateUpgrading=4,  //设备升级状态
};

#pragma mark - BTScanMode 扫描模式

/**
 * 扫描模式
 */
typedef NS_ENUM(NSUInteger,BTScanMode)
{
    BTScanModeFree=0,     //空闲
    BTScanModeNormal=1,   //正常的扫描模式
    BTScanModeUpgrade=2,  //升级模式下的扫描
    BTScanModelSync=3,    //数据同步模式下的扫描
};

#pragma mark - BTDeviceType 设备类型

/**
 * 设备类型
 */
typedef NS_ENUM(NSUInteger,BTDeviceType)
{
    BTDeviceTypeUnknown=0x00,               //设备类型未知
    BTDeviceTypeThermometer=0x01,           //1 温度计
    BTDeviceTypeOximeter=0x02,              //2 血氧仪
    BTDeviceTypeBloodPressureMeter = 0x03,  //3 血压计
    BTDeviceTypeDigitalThermometer=0x04,    //4 电子体温计
};

#pragma mark - BTBroadcastType 广播类型

/**
 * 设备广播类型
 */
typedef NS_ENUM(NSUInteger,BTBroadcastType)
{
    BTBroadcastTypeNormal=1,      //设备的正常广播
    BTBroadcastTypePair=2,        //设备配对广播
    BTBroadcastTypeAll=3,         //设备的所有广播
};

#pragma mark - LSConnectionState 连接状态

/**
 * 设备的连接状态
 */
typedef NS_ENUM(NSUInteger,BTConnectState)
{
    BTConnectStateUnknown=0,             //未知
    BTConnectStateConnected=1,           //底层连接成功
    BTConnectStateFailure=2,             //连接失败
    BTConnectStateDisconnect=3,          //连接断开
    BTConnectStateConnecting=4,          //连接中
    BTConnectStateTimeout=5,             //连接超时
    BTConnectStateSuccess=6,             //协议层的连接成功
} ;

#pragma mark - LSPairedState 配对绑定状态

/**
 * 设备配对或绑定状态
 */
typedef NS_ENUM(NSUInteger,BTPairState)
{
    BTPairStateUnknown=0,    //未知
    BTPairStateSuccess=1,    //配对成功
    BTPairStateFailure=2,    //配对失败
};

#pragma mark - BTUpgradeState 设备升级状态

/**
 * 设备升级状态
 * 
 */
typedef NS_ENUM(NSUInteger,BTUpgradeState)
{
    BTUpgradeStateUnknown=0,                     //未知状态
    BTUpgradeStateUpgrading=0x01,                //正在升级
    BTUpgradeStateVerifyFailure=0x03,            //资源校验失败
    BTUpgradeStateSuccess=0x05,                  //升级成功
    BTUpgradeStateFailure=0x06,                  //升级失败
    
    BTUpgradeStateSearch=0x10,                    //扫描正常模式下的设备广播
    BTUpgradeStateSearchUpgradingDevice=0x11,     //扫描升级模式下的设备广播
    BTUpgradeStateConnect=0x12,                   //连接正常模式下的设备
    BTUpgradeStateConnectUpgradingDevice=0x13,    //连接升级模式下的设备
    BTUpgradeStateEnterUpgradeMode=0x14,          //进入升级模式
    BTUpgradeStateResetting=0x15,                 //设备重启中
};


/**
 * 性别类型，1表示男，2表示女
 */
typedef NS_ENUM(NSUInteger,BTUserGender)
{
    BTUserGenderMale=1,
    BTUserGenderFemale=2
};


#pragma mark - ErrorCode

/**
 * 错误码
 */
typedef NS_ENUM(NSUInteger,BTErrorCode)
{
    ECodeUnknown=0,
    ECodeParameterInvalid=1,                //接口参数错误
    ECodeUpgradeFileFormatInvalid=2,        //升级文件的格式错误
    ECodeUpgradeFileNameInvalid=3,          //文件名错误
    ECodeWorkingStatusError=5,              //蓝牙SDK工作状态错误
    ECodeDeviceNotConnected=7,              //设备未连接
    ECodeDeviceUnsupported=8,               //当前push信息的类型与设备实际支持的功能不相符
    ECodeUpgradeFileVerifyError=9,          //校验文件出错
    ECodeUpgradeFileDataReceiveError=10,    //数据接收失败
    ECodeLowBattery=11,                     //电量不足
    ECodeCodeVersionInvalid=12,             //代码版本不符合，拒绝升级固件文件
    ECodeUpgradeFileHeaderVerifyError=13,   //固件文件头信息校验失败，拒绝升级固件文件
    ECodeFlashSaveError=14,                 //设备保存数据出错,flash保存失败
    ECodeScanTimeout=15,                    //扫描超时，找不到目标设备
    ECodeConnectionFailed=17,               //连接失败，3次重连连接不上，则返回连接失败
    ECodeConnectionTimeout=21,              //连接错误，若120秒内，出现连接无响应、或发现服务无响应
    ECodeBluetoothUnavailable=23,           // 蓝牙关闭
    ECodeAbnormalDisconnect=24,             //异常断开
    ECodeWriteCharacterFailed=25,           //写特征错误
    ECodeUserCancel=26,                     //用户主动取消

    ECodeRandomCodeVerifyFailure=28,        //随机码验证错误
    ECodeWriteRandomCodeFailure=29,         //写随机码失败
    ECodeWritePairedConfirmFailure=30,      //写配对确认失败
    ECodeWriteDeviceIdFailure=31,           //写设备ID失败
    ECodeNoScanResults=32,                  //没有扫描结果
    
    ECodeFileUpdating=40,                   //文件更新中，拒绝任何设置指令下发
    
    ECodeFileNotFound=41,                   //没有对应的资源文件
    ECodeFileSystemBusy=42,                 //系统繁忙/文件任务传输中
    ECodeFileParameterError=43,             //文件参数错误
    ECodeFileVerifyError=44,                //文件校验失败
    ECodeFileException=45,                  //文件读写错误
    ECodeFileCancel=46,                     //设备端取消发送文件
    ECodeFileExisted=47,                    //资源文件已存在

};


#pragma mark - BTFilterMatchWay

/**
 * 广播名称的匹配方式
 */
typedef NS_ENUM(NSUInteger,BTFilterMatchWay)
{
    BTFilterMatchPrefix=1,               //前缀匹配，区分大小写
    BTFilterMatchPrefixIgnoreCase=2,     //前缀匹配，不区分大小写
    BTFilterMatchSuffix=3,               //后缀匹配，区分大小写
    BTFilterMatchSuffixIgnoreCase=4,     //后缀匹配，不区分大小写
    BTFilterMatchEquals=5,               //直接比较，区分大小写
    BTFilterMatchEqualsIgnoreCase=6,     //直接比较，不区分大小写
};


#endif /* AHDevicePluginProfiles_h */
