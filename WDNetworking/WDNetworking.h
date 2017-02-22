//
//  WDNetworking.h
//  WDNetworkingDemo
//
//  Created by huylens on 17/1/9.
//  Copyright © 2017年 WDD. All rights reserved.
//
#import <UIKit/UIKit.h>

#import "NSObject+convertParamToString.h"
#import "NSString+WDCategory.h"
#import "NSString+Check.h"
#import "NSString+Encrypt.h"
#import "NSDictionary+Resolve.h"

typedef enum
{
    StatusUnknown           = -1,   //未知网络
    StatusNotReachable      = 0,    //没有网络
    StatusReachableViaWWAN  = 1,    //手机自带网络
    StatusReachableViaWiFi  = 2     //wifi
    
}NetworkStatus;

@interface WDNetworking : NSObject

/**
 *  单例
 *
 *  @return WDNetworking对象
 */
+ (WDNetworking *)sharedWDNetworking;

/**
 *  Task数组
 *  方便管理请求任务。执行取消，暂停，继续等任务.
 *  - (void)cancel，取消任务
 *  - (void)suspend，暂停任务
 *  - (void)resume，继续任务
 @return task数组
 */
+ (NSMutableArray *)getTasks;


/**
 *  get请求方法,block回调
 *
 *  @param url     请求连接，根路径
 *  @param params  参数
 *  @param success 请求成功返回数据
 *  @param failure    请求失败
 *  @param showHUD 是否显示HUD
 */
-(NSURLSessionTask *)getWithUrl:(NSString *)url
                         params:(id)params
                        success:(void (^)(NSURLSessionDataTask * task, id responseObject))success
                          wrong:(void (^)(NSURLSessionDataTask * task, id responseObject))wrong
                        failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure
                        showHUD:(BOOL)showHUD;

/**
 *  post请求方法,block回调
 *
 *  @param url     请求连接，根路径
 *  @param params  参数
 *  @param success 请求成功返回数据
 *  @param failure    请求失败
 *  @param showHUD 是否显示HUD
 */
-(NSURLSessionTask *)postWithUrl:(NSString *)url
                          params:(id)params
                         success:(void (^)(NSURLSessionDataTask * task, id responseObject))success
                           wrong:(void (^)(NSURLSessionDataTask * task, id responseObject))wrong
                         failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure
                         showHUD:(BOOL)showHUD;

/**
 *  上传图片方法
 *
 *  @param image      上传的图片
 *  @param url        请求连接，根路径
 *  @param filename   图片的名称(如果不传则以当时间命名)
 *  @param name       上传图片时填写的图片对应的参数
 *  @param params     参数
 *  @param progress   上传进度
 *  @param success    请求成功返回数据
 *  @param failure       请求失败
 *  @param showHUD    是否显示HUD
 */
-(NSURLSessionTask *)uploadWithImage:(UIImage *)image
                                 url:(NSString *)url
                            filename:(NSString *)filename
                                name:(NSString *)name
                              params:(NSDictionary *)params
                            progress:(void (^)(int64_t completedUnitCount, int64_t  totalUnitCount))progress
                             success:(void (^)(NSURLSessionDataTask * task, id responseObject))success
                             failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure
                             showHUD:(BOOL)showHUD;

/** 
 *  下载文件方法
 *
 *  @param url           下载地址
 *  @param saveToPath    文件保存的路径,如果不传则保存到Documents目录下，以文件本来的名字命名
 *  @param progress 下载进度回调
 *  @param success       下载完成
 *  @param failure          失败
 *  @param showHUD       是否显示HUD
 *  @return 返回请求任务对象，便于操作
 */
-(NSURLSessionTask *)downloadWithUrl:(NSString *)url
                          saveToPath:(NSString *)saveToPath
                            progress:(void (^)(int64_t completedUnitCount, int64_t totalUnitCount))progress
                             success:(void (^)(NSString * filePath))success
                             failure:(void (^)(NSError * error))failure
                             showHUD:(BOOL)showHUD;



#pragma mark - 工具方法
/**
 获取网络状态

 @param NetworkStatusBlock 获取后的回调
 */
+(void)getNetworkState: (void(^)(NetworkStatus)) NetworkStatusBlock;

//取得get方法URL拼接参数后的URL
-(NSString*)getFinalUrlWithBaseUrl:(NSString*)urlStr parmDic:(NSDictionary*)dic;




@end
