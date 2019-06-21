//
//  PTFSSDK.h
//  PTFSSDK
//
//  Created by 孙启明 on 2019/6/15.
//  Copyright © 2019年 zzb. All rights reserved.
//

#import <Foundation/Foundation.h>

//PTFSSDK接口返回值对象

@interface PTFSResponse : NSObject

@property (assign, nonatomic)   NSInteger code;
@property (copy, nonatomic)     NSString *info;

@end


typedef void(^PTFSResponseBlock)(PTFSResponse *response);

typedef void(^PTFSProgressBlock)(NSUInteger completedSize, NSUInteger totalSize, NSInteger taskID);


@interface PTFSSDK : NSObject

/**
 初始化并返回一个 PTFSSDK 的单例

 @return 返回的单例
 */
+ (instancetype)sharedInstance;

/**
 初始化仓库  默认初始化在Document/zzb/PTFS下

 @param completionBlock 初始化结果block
 - 成功（初始化成功）        {"code":0,"info":"节点id"}
 - 失败（无法获取仓库路径）     {"code":1,"info":"错误信息"}
 - 失败（节点已经启动）        {"code":2,"info":"错误信息"}
 - 失败（节点已经初始化）    {"code":3,"info":"错误信息"}
 - 失败（其它）              {"code":4,"info":"错误信息"}
 */
- (void)initializePTFSRepoWithCompletion:(nullable PTFSResponseBlock)completionBlock;

/**
 初始化引导节点地址

 @param address 引导节点地址，以";"分隔  - 引导节点举列："/ip4/47.99.193.140/tcp/4001/ipfs/QmdUYPAyFpMmeVRYNLQsoSuGmoN1bbAfNa8RhqYZkZ39Xk"
  @param completionBlock 初始化结果block
 - 成功，返回{"code":0,"info":""}；
 - 失败，返回{"code":1,"info":"错误信息"}
 */
- (void)initializePTFSBootStrap:(nonnull NSString *)address
                     completion:(nullable PTFSResponseBlock)completionBlock;

/**
 启动守护进程

 @param completionBlock
 - 成功，返回{"code":1,"info":""}；
 - 失败，返回{"code":0,"info":"错误信息"}
 */
- (void)startDaemonWithCompletion:(nullable PTFSResponseBlock)completionBlock;

/**
 判断daemon进程是否已经启动

 @return 已启动返回true，否则返回false
 */
- (BOOL)isDaemonOk;

/**
 停止守护进程

 @param completionBlock
 - 成功，返回{"code":1,"info":""}；
 - 失败，返回{"code":0,"info":"错误信息"}
 */
- (void)stopDaemonWithCompletion:(nullable PTFSResponseBlock)completionBlock;

/**
 重启守护进程

 @param completionBlock
 - 成功，返回{"code":1,"info":""}；
 - 失败，返回{"code":0,"info":"错误信息"}
 */
- (void)restartDaemonWithCompletion:(nullable PTFSResponseBlock)completionBlock;

/**
  获取指定路径（文件/文件夹）的大小

 @param filePath 文件/文件夹路径
 @param isDir 若filePath是文件夹的路径传入true,否则传入false
 @param completionBlock
 - 成功，返回{"code":文件/文件夹大小,"info":""}；
 - 失败，返回{"code":0,"info":"错误信息"}
 */
- (void)pathFileSizeWithPath:(nonnull NSString *)filePath
                       isDir:(BOOL)isDir
                  completion:(nullable PTFSResponseBlock)completionBlock;

/**
 上传文件

 @param sFilePath 文件存放路径
 @param filesize 上传文件/文件夹大小
 @param isDir 若sFilePath是文件夹的路径传入true,否则传入false
 @param uploadProgressBlock 上传进度block
 @param completionBlock
 - 成功（上传任务开始），返回{"code":taskID,"info":"fileHash"}；
 - 失败（添加上传任务失败），返回{"code":0,"info":"错误信息"}
 */
- (void)uploadFileWithPath:(nonnull NSString *)sFilePath
                  fileSize:(NSUInteger)filesize
                     isDir:(BOOL)isDir
                  progress:(PTFSProgressBlock)uploadProgressBlock
                completion:(nullable PTFSResponseBlock)completionBlock;

/**
 取消文件上传

 @param taskID 上传任务ID
 */
- (void)cancelUploadWithTaskId:(NSInteger)taskID;

/**
 获取文件已上传的大小

 @param taskID 上传任务ID
@param completionBlock {"code":上传字节大小,"info":"错误信息"},错误信息用于表示文件上传任务开始后产生的错误
 */
- (void)uploadedFileSizeWithTaskId:(NSInteger)taskID
                        completion:(nullable PTFSResponseBlock)completionBlock;

/**
 清理文件的上传记录信息（文件上传完成或取消上传后需调用该接口）

 @param taskID 上传任务ID
 */
- (void)clearUploadInfoWithTaskId:(NSInteger)taskID;

/**
 下载文件

 @param fileHash 下载的文件hash
 @param sFilePath 文件存放路径
 @param downloadProgressBlock 下载进度block
 @param completionBlock
 - 成功（下载任务开始），返回{"code":文件大小（字节）,"info":"taskID"}；
 - 失败（添加下载任务失败），返回{"code":0,"info":"错误信息"}
 */
- (void)downloadFileWithFileHash:(nonnull NSString *)fileHash
                        savePath:(nonnull NSString *)sFilePath
                        progress:(PTFSProgressBlock)downloadProgressBlock
                      completion:(nullable PTFSResponseBlock)completionBlock;


/**
 根据文件hash获取文件已下载的大小

 @param taskID 下载任务ID
 @return 文件已下载的总字节大小
 */
- (NSUInteger)downloadedFileSizeWithTaskId:(NSInteger)taskID;


/**
 取消下载文件

 @param fileHash 下载的文件hash
 @param completionBlock
 - 成功，返回{"code":1,"info":"stop download success"}；
 - 失败，返回{"code":0,"info":"错误信息"}
 */
- (void)cancelDownloadingWithFileHash:(NSString *)fileHash
                           completion:(nullable PTFSResponseBlock)completionBlock;


/**
 清理文件的下载记录信息（文件下载完成或取消下载后需调用该接口）

 @param taskID 下载任务ID
 */
- (void)clearDownloadInfoWithTaskId:(NSInteger)taskID;


/**
 获取仓库大小

 @param completionBlock
 - 成功，返回{"code":仓库大小（字节）,"info":""}；
 - 失败，返回{"code":0,"info":"错误信息"}
 */
- (void)repoSizeWithCompletion:(nullable PTFSResponseBlock)completionBlock;


/**
 清理仓库缓存释放空间

 @param completionBlock
 - 成功，返回{"code":1,"info":""}；
 - 失败，返回{"code":0,"info":"错误信息"}
 */
- (void)clearCacheWithCompletion:(nullable PTFSResponseBlock)completionBlock;


/**
 获取当前下行带宽

 @param completionBlock
 - 成功，返回{"code":下行带宽（字节/秒）,"info":""}；
 - 失败，返回{"code":0,"info":"错误信息"}
 */
- (void)bandWidthWithCompletion:(nullable PTFSResponseBlock)completionBlock;

@end
