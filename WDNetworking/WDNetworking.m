//
//  WDNetworking.m
//  WDNetworkingDemo
//
//  Created by huylens on 17/1/9.
//  Copyright © 2017年 WDD. All rights reserved.
//

#import "WDNetworking.h"
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"


//根据自己项目需要替换
#import "SVProgressHUD.h"
static NSString *const BaseURLDomain = @"https://t-appportal.meitianhui.com/openapi/";




static NSMutableArray *tasks;
static WDNetworking * manager = nil;

@interface WDNetworking()

@property (nonatomic, strong)AFHTTPSessionManager *AFManager;

@property (nonatomic,assign)NetworkStatus networkStats;

@end

@implementation WDNetworking

#pragma mark - 请求者单例
+ (WDNetworking *)sharedWDNetworking
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[WDNetworking alloc] init];
    });
    return manager;
}

#pragma mark - 任务数组
+ (NSMutableArray *)getTasks
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tasks = [[NSMutableArray alloc] init];
    });
    return tasks;
}

- (instancetype)init{
    if (self == [super init])
    {
        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
        
        self.AFManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:BaseURLDomain]];
        //设置请求数据为json
        _AFManager.requestSerializer = [AFJSONRequestSerializer serializer];
        _AFManager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
        _AFManager.requestSerializer.timeoutInterval=15;
        
        //应该是加密相关
        //        [_AFManager.requestSerializer setValue:@"66a1fb8dd9b95fe1f190d1df1563f2ba" forHTTPHeaderField:@"apikey"];
        
        //设置返回数据为json
        _AFManager.responseSerializer = [AFJSONResponseSerializer serializer];
        _AFManager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",@"text/html",@"text/json",@"text/plain",@"text/javascript",@"text/xml",@"image/*"]];
    }
    return self;
}

#pragma mark - get
-(NSURLSessionTask *)getWithUrl:(NSString *)url
                         params:(id)params
                        success:(void (^)(NSURLSessionDataTask * task, id responseObject))success
                          wrong:(void (^)(NSURLSessionDataTask * task, id responseObject))wrong
                        failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure
                        showHUD:(BOOL)showHUD
{
    
    
    if (url==nil)
    {
        return nil;
    }
    
    if (showHUD==YES)
    {
        [SVProgressHUD show];
    }
    
    NSString *urlStr=[NSURL URLWithString:url]?url:[self strUTF8Encoding:url];
    
    NSURLSessionTask *sessionTask = [self.AFManager GET:urlStr parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        //隐藏指示器
        if (showHUD==YES)
        {
            [SVProgressHUD dismiss];
        }
        
        //删除任务
        [[WDNetworking getTasks] removeObject:sessionTask];
        
        
        //检测响应
        if ([responseObject resultOK])
        {//响应正常
            //成功回调
            !success?:success(task,responseObject);
        }
        else
        {//响应出错
            
            //判断出错信息
            if ([responseObject[@"error_code"] isEqualToString:@"invalid app_token"]){
                [SVProgressHUD showErrorWithStatus:@"网络连接有点问题，请稍后再试"];
            }
            
            //展示出错信息
            [SVProgressHUD showErrorWithStatus:responseObject[@"error_msg"]];
            
            //出错回调
            !wrong?:wrong(task,responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        
        //隐藏指示器
        if (showHUD==YES) {
            [SVProgressHUD dismiss];
        }
        
        //删除任务
        [[WDNetworking getTasks] removeObject:sessionTask];
        
        
        //失败输出失败url
        NSLog(@"失败URL->\n%@\n--参数->\n%@",task.originalRequest.URL.absoluteString,[(NSDictionary *)params getParamStr]);
        
        !failure?:failure(task,error);
        
    }];
    
    if (sessionTask)
    {
        [[WDNetworking getTasks] addObject:sessionTask];
    }
    
    return sessionTask;
}
#pragma mark - post
-(NSURLSessionTask *)postWithUrl:(NSString *)url
                          params:(id)params
                         success:(void (^)(NSURLSessionDataTask * task, id responseObject))success
                           wrong:(void (^)(NSURLSessionDataTask * task, id responseObject))wrong
                         failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure
                         showHUD:(BOOL)showHUD
{
    
    if (url==nil)
    {
        return nil;
    }
    
    if (showHUD==YES)
    {
        [SVProgressHUD show];
    }
    
    NSString *urlStr=[NSURL URLWithString:url]?url:[self strUTF8Encoding:url];
    
    NSURLSessionTask *sessionTask  = [self.AFManager POST:urlStr parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        //隐藏指示器
        if (showHUD==YES) {
            [SVProgressHUD dismiss];
        }
        
        //删除任务
        [[WDNetworking getTasks] removeObject:sessionTask];
        
        //检测响应
        if ([responseObject resultOK])
        {//响应正常
            //成功回调
            !success?:success(task,responseObject);
        }
        else
        {//响应出错
            
            //判断出错信息
            if ([responseObject[@"error_code"] isEqualToString:@"invalid app_token"]){
                [SVProgressHUD showErrorWithStatus:@"网络连接有点问题，请稍后再试"];
            }
            
            //展示出错信息以及相关的操作
            [SVProgressHUD showErrorWithStatus:responseObject[@"error_msg"]];
            
            //出错回调
            !wrong?:wrong(task,responseObject);
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        //隐藏指示器
        if (showHUD==YES) {
            [SVProgressHUD dismiss];
        }
        
        //删除任务
        [[WDNetworking getTasks] removeObject:sessionTask];
        
        //失败输出失败url
        NSLog(@"失败URL->\n%@\n--参数->\n%@",task.originalRequest.URL.absoluteString,[(NSDictionary *)params getParamStr]);
        
        !failure?:failure(task,error);
        
    }];
    
    if (sessionTask)
    {
        [[WDNetworking getTasks] addObject:sessionTask];
    }
    
    return sessionTask;
    
}
#pragma mark - 上传
-(NSURLSessionTask *)uploadWithImage:(UIImage *)image
                                 url:(NSString *)url
                            filename:(NSString *)filename
                                name:(NSString *)name
                              params:(NSDictionary *)params
                            progress:(void (^)(int64_t completedUnitCount, int64_t  totalUnitCount))progress
                             success:(void (^)(NSURLSessionDataTask * task, id responseObject))success
                             failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure
                             showHUD:(BOOL)showHUD
{
    
    if (url==nil) {
        return nil;
    }
    
    if (showHUD==YES) {
        [SVProgressHUD show];
    }
    
    //检查地址中是否有中文
    NSString *urlStr=[NSURL URLWithString:url]?url:[self strUTF8Encoding:url];
    
    
    NSURLSessionTask *sessionTask = [self.AFManager POST:urlStr parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //压缩图片
        NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
        
        NSString *imageFileName = filename;
        if (filename == nil || ![filename isKindOfClass:[NSString class]] || filename.length == 0)
        {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            imageFileName = [NSString stringWithFormat:@"%@.jpg", str];
        }
        
        // 上传图片，以文件流的格式
        [formData appendPartWithFileData:imageData name:name fileName:imageFileName mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"上传进度--%lld,总进度---%lld",uploadProgress.completedUnitCount,uploadProgress.totalUnitCount);
        if (progress)
        {
            progress(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"上传图片成功=%@",responseObject);
        
        if (showHUD==YES) {
            [SVProgressHUD dismiss];
        }
        
        [[WDNetworking getTasks] removeObject:sessionTask];
        
        if (success) {
            success(task,responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error=%@",error);
        
        if (showHUD==YES) {
            [SVProgressHUD dismiss];
        }
        
        [[WDNetworking getTasks] removeObject:sessionTask];
        
        if (failure) {
            failure(task,error);
        }
    }];
    
    
    if (sessionTask) {
        [[WDNetworking getTasks] addObject:sessionTask];
    }
    
    return sessionTask;
}


#pragma mark - 下载
-(NSURLSessionTask *)downloadWithUrl:(NSString *)url
                          saveToPath:(NSString *)saveToPath
                            progress:(void (^)(int64_t completedUnitCount, int64_t totalUnitCount))progress
                             success:(void (^)(NSString * filePath))success
                             failure:(void (^)(NSError * error))failure
                             showHUD:(BOOL)showHUD
{
    
    if (url==nil) {
        return nil;
    }
    
    if (showHUD==YES) {
        [SVProgressHUD show];
    }
    
    NSURLRequest *downloadRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    NSURLSessionTask *sessionTask = [self.AFManager downloadTaskWithRequest:downloadRequest progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"下载进度--%.1f",1.0 * downloadProgress.completedUnitCount/downloadProgress.totalUnitCount);
        //回到主线程刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            if (progress) {
                progress(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
            }
        });
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        if (!saveToPath) {
            
            NSURL *downloadURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
            NSLog(@"默认路径--%@",downloadURL);
            return [downloadURL URLByAppendingPathComponent:[response suggestedFilename]];
            
        }else{
            return [NSURL fileURLWithPath:saveToPath];
            
        }
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        NSLog(@"下载文件成功");
        if (showHUD==YES) {
            [SVProgressHUD dismiss];
        }
        
        [[WDNetworking getTasks] removeObject:sessionTask];
        
        if (error == nil) {
            if (success) {
                success([filePath path]);//返回完整路径
            }
            
        } else {
            if (failure) {
                failure(error);
            }
        }
        
    }];
    
    //开始启动任务
    [sessionTask resume];
    
    if (sessionTask) {
        [[WDNetworking getTasks] addObject:sessionTask];
    }
    
    return sessionTask;
}

#pragma mark - 获取网络状态
+(void)getNetworkState: (void(^)(NetworkStatus)) NetworkStatusBlock
{
    // 1.获得网络监控的管理者
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    // 2.设置网络状态改变后的处理
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变了, 就会调用这个block
        switch (status)
        {
            case AFNetworkReachabilityStatusUnknown: // 未知网络
            {
                NSLog(@"未知网络");
                
                [WDNetworking sharedWDNetworking].networkStats=StatusUnknown;
                
                NetworkStatusBlock(StatusUnknown);
            }
                break;
            case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
            {
                NSLog(@"没有网络");
                
                [WDNetworking sharedWDNetworking].networkStats=StatusNotReachable;
                NetworkStatusBlock(StatusNotReachable);

            }   break;
            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
            {
                NSLog(@"手机自带网络");
                
                [WDNetworking sharedWDNetworking].networkStats=StatusReachableViaWWAN;
                
                NetworkStatusBlock(StatusReachableViaWWAN);
                
            }   break;
            case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
            {
                NSLog(@"WIFI");

                [WDNetworking sharedWDNetworking].networkStats=StatusReachableViaWiFi;
                
                NetworkStatusBlock(StatusReachableViaWiFi);

            }   break;
        }
    }];
    
    [mgr startMonitoring];
}


#pragma mark - 如果有中文使用UTF-8编码
-(NSString *)strUTF8Encoding:(NSString *)str
{
    
    return [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

#pragma mark - 私有方法
#pragma mark - 取得get方法URL拼接参数后的地址
-(NSString*)getFinalUrlWithBaseUrl:(NSString*)urlStr parmDic:(NSDictionary*)dic
{
    if(!urlStr){
        return nil;
    }
    if (!dic) {
        return urlStr;
    }
    //1.参数排序
    NSArray* sortedKeys = [[dic allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }];
    
    //2.参数拼接
    NSMutableString* mStr = [NSMutableString string];
    for (NSString* key in sortedKeys) {
        [mStr appendFormat:@"&%@=%@",key,dic[key]];
    }
    [mStr replaceCharactersInRange:NSMakeRange(0,1) withString:@"?"];
    //3.地址和参数拼接
    NSString* finalUrl = [NSString stringWithFormat:@"%@%@",urlStr,mStr];
    //4.中文转义
    finalUrl = [self URLEncodedString:finalUrl];
    
    return finalUrl;
}
// 中文转义
- (NSString *)URLEncodedString:(NSString*)url
{
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)url,(CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",NULL,kCFStringEncodingUTF8));
    return encodedString;
}

#pragma mark - 二次封装-等待后台出接口










@end
