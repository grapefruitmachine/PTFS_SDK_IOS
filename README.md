## PTFSSDK 文档
---
### 版本说明
- 1.0.0（当前版本）:
  - 提供节点相关功能（初始化、启动、停止、重启、判断状态）
  - 提供文件上传、下载进度获取功能
  - 提供获取仓库大小、清理缓存功能
  - 提供查询带宽功能

---

### 使用说明

PTFSSDK只支持arm64及以上真机上运行，SDK不支持bitcode，设置bitcode为NO，选中target-Build Settings-搜索bitcode-把YES改成NO。

#### CocoaPods 安装
### Podfile
```
platform :ios, '8.0'
pod 'PTFSSDK'
```
在需要使用 PTFSSDK 库文件接口的地方直接 import 即可：
```objective-c
#import "PTFSSDK.h"
```

### 接口说明
SDK第一次初始化时，必须先通过调用initializePTFSRepoWithCompletion和initializePTFSBootStrap传入节点参数初始化SDK，以后可以不再调用这两个方法。
其他功能必须在调用startDaemonWithCompletion启动守护进程成功后才回生效。\
大部分接口返回是通过completionBlock方式回调:
```objective-c
typedef void(^PTFSResponseBlock)(PTFSResponse *response);
```
PTFSResponse对象:
```objective-c
@interface PTFSResponse : NSObject

@property (assign, nonatomic)   NSInteger code;
@property (copy, nonatomic)     NSString *info;

@end
```
上传和下载进度可以自己单独调用相应的获取进度接口获取，也可以通过ProgressBlock回调获取:
```objective-c
typedef void(^PTFSProgressBlock)(NSUInteger completedSize, NSUInteger totalSize, NSInteger taskID);
```

/**
 初始化并返回一个 PTFSSDK 的单例

 @return 返回的单例
 */
 ```objective-c
+ (instancetype)sharedInstance;
 ```
---
/**
 初始化仓库  默认初始化在Document/zzb/PTFS下

 @param completionBlock 初始化结果block
 - 成功（初始化成功）        {"code":0,"info":"节点id"}
 - 失败（无法获取仓库路径）     {"code":1,"info":"错误信息"}
 - 失败（节点已经启动）        {"code":2,"info":"错误信息"}
 - 失败（节点已经初始化）    {"code":3,"info":"错误信息"}
 - 失败（其它）              {"code":4,"info":"错误信息"}
 */
 ```objective-c
- (void)initializePTFSRepoWithCompletion:(nullable PTFSResponseBlock)completionBlock;
 ```
---
/**
 初始化引导节点地址

 @param address 引导节点地址，以";"分隔  - 引导节点举列："/ip4/47.99.193.140/tcp/4001/ipfs/QmdUYPAyFpMmeVRYNLQsoSuGmoN1bbAfNa8RhqYZkZ39Xk"\
 @param completionBlock 初始化结果block
 - 成功，返回{"code":0,"info":""}；
 - 失败，返回{"code":1,"info":"错误信息"}
 */
  ```objective-c
- (void)initializePTFSBootStrap:(nonnull NSString *)address
                     completion:(nullable PTFSResponseBlock)completionBlock;
 ```
---
/**
 启动守护进程

 @param completionBlock
 - 成功，返回{"code":1,"info":""}；
 - 失败，返回{"code":0,"info":"错误信息"}
 */
  ```objective-c
- (void)startDaemonWithCompletion:(nullable PTFSResponseBlock)completionBlock;
 ```
---
/**
 判断daemon进程是否已经启动

 @return 已启动返回true，否则返回false
 */
```objective-c
- (BOOL)isDaemonOk;
 ```
---
/**
 停止守护进程

 @param completionBlock
 - 成功，返回{"code":1,"info":""}；
 - 失败，返回{"code":0,"info":"错误信息"}
 */
 ```objective-c
- (void)stopDaemonWithCompletion:(nullable PTFSResponseBlock)completionBlock;
 ```
---
/**
 重启守护进程

 @param completionBlock
 - 成功，返回{"code":1,"info":""}；
 - 失败，返回{"code":0,"info":"错误信息"}
 */
 ```objective-c
- (void)restartDaemonWithCompletion:(nullable PTFSResponseBlock)completionBlock;
 ```
---
/**
  获取指定路径（文件/文件夹）的大小

 @param filePath 文件/文件夹路径\
 @param isDir 若filePath是文件夹的路径传入true,否则传入false\
 @param completionBlock
 - 成功，返回{"code":文件/文件夹大小,"info":""}；
 - 失败，返回{"code":0,"info":"错误信息"}
 */
 ```objective-c
- (void)pathFileSizeWithPath:(nonnull NSString *)filePath
                       isDir:(BOOL)isDir
                  completion:(nullable PTFSResponseBlock)completionBlock;
 ```
---
/**
 上传文件

 @param sFilePath 文件存放路径\
 @param filesize 上传文件/文件夹大小\
 @param isDir 若sFilePath是文件夹的路径传入true,否则传入false\
 @param uploadProgressBlock 上传进度block\
 @param completionBlock
 - 成功（上传任务开始），返回{"code":taskID,"info":"fileHash"}；
 - 失败（添加上传任务失败），返回{"code":0,"info":"错误信息"}
 */
 ```objective-c
- (void)uploadFileWithPath:(nonnull NSString *)sFilePath
                  fileSize:(NSUInteger)filesize
                     isDir:(BOOL)isDir
                  progress:(PTFSProgressBlock)uploadProgressBlock
                completion:(nullable PTFSResponseBlock)completionBlock;
```
---
/**
 取消文件上传

 @param taskID 上传任务ID
 */
 ```objective-c
- (void)cancelUploadWithTaskId:(NSInteger)taskID;
 ```
---
/**
 获取文件已上传的大小

 @param taskID 上传任务ID\
@param completionBlock {"code":上传字节大小,"info":"错误信息"},错误信息用于表示文件上传任务开始后产生的错误
 */
 ```objective-c
- (void)uploadedFileSizeWithTaskId:(NSInteger)taskID
                        completion:(nullable PTFSResponseBlock)completionBlock;
 ```
---
/**
 清理文件的上传记录信息（文件上传完成或取消上传后需调用该接口）

 @param taskID 上传任务ID
 */
```objective-c
- (void)clearUploadInfoWithTaskId:(NSInteger)taskID;
```
---
/**
 下载文件

 @param fileHash 下载的文件hash\
 @param sFilePath 文件存放路径\
 @param downloadProgressBlock 下载进度block\
 @param completionBlock
 - 成功（下载任务开始），返回{"code":文件大小（字节）,"info":"taskID"}；
 - 失败（添加下载任务失败），返回{"code":0,"info":"错误信息"}
 */
```objective-c
- (void)downloadFileWithFileHash:(nonnull NSString *)fileHash
                        savePath:(nonnull NSString *)sFilePath
                        progress:(PTFSProgressBlock)downloadProgressBlock
                      completion:(nullable PTFSResponseBlock)completionBlock;
```
---
/**
 根据文件hash获取文件已下载的大小

 @param taskID 下载任务ID
 @return 文件已下载的总字节大小
 */
```objective-c
- (NSUInteger)downloadedFileSizeWithTaskId:(NSInteger)taskID;
```
---
/**
 取消下载文件

 @param fileHash 下载的文件hash
 @param completionBlock
 - 成功，返回{"code":1,"info":"stop download success"}；
 - 失败，返回{"code":0,"info":"错误信息"}
 */
```objective-c
- (void)cancelDownloadingWithFileHash:(NSString *)fileHash
                           completion:(nullable PTFSResponseBlock)completionBlock;
```
---
/**
 清理文件的下载记录信息（文件下载完成或取消下载后需调用该接口）

 @param taskID 下载任务ID
 */
```objective-c
- (void)clearDownloadInfoWithTaskId:(NSInteger)taskID;
```
---
/**
 获取仓库大小

 @param completionBlock
 - 成功，返回{"code":仓库大小（字节）,"info":""}；
 - 失败，返回{"code":0,"info":"错误信息"}
 */
```objective-c
- (void)repoSizeWithCompletion:(nullable PTFSResponseBlock)completionBlock;
```
---
/**
 清理仓库缓存释放空间

 @param completionBlock
 - 成功，返回{"code":1,"info":""}；
 - 失败，返回{"code":0,"info":"错误信息"}
 */
```objective-c
- (void)clearCacheWithCompletion:(nullable PTFSResponseBlock)completionBlock;
```
---
/**
 获取当前下行带宽

 @param completionBlock
 - 成功，返回{"code":下行带宽（字节/秒）,"info":""}；
 - 失败，返回{"code":0,"info":"错误信息"}
 */
```objective-c
- (void)bandWidthWithCompletion:(nullable PTFSResponseBlock)completionBlock;
```
