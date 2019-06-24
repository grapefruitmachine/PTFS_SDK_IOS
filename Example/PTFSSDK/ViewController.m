//
//  ViewController.m
//  PTFSSDKDemo
//
//  Created by 孙启明 on 2019/6/15.
//  Copyright © 2019年 zzb. All rights reserved.
//

#import "ViewController.h"
#import <PTFSSDK/PTFSSDK.h>
#import "PlayViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *speedLabel;


@property (weak, nonatomic) IBOutlet UIProgressView *uploadProgress;
@property (weak, nonatomic) IBOutlet UIProgressView *uploadProgress2;
@property (weak, nonatomic) IBOutlet UILabel *uploadInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *uploadInfoLabel2;


@property (weak, nonatomic) IBOutlet UIProgressView *downloadProgress;
@property (weak, nonatomic) IBOutlet UIProgressView *downloadProgress2;
@property (weak, nonatomic) IBOutlet UILabel *downloadInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *downloadInfoLabel2;

@property (weak, nonatomic) IBOutlet UILabel *repoSizeLabel;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSDK];
}


- (void)setupSDK
{
    [[PTFSSDK sharedInstance] initializePTFSRepoWithCompletion:^(PTFSResponse *response) {
        if (response.code != 0) {
            NSLog(@"%@",response.info);
        }
    }];
    
    [[PTFSSDK sharedInstance] initializePTFSBootStrap:@"/ip4/47.99.193.140/tcp/4001/ipfs/CiPNvR4z9aaBxzAW2aTWGK1Xn23iTSC2MHyFbQUMFLv4Cb" completion:^(PTFSResponse *response) {
        if (response.code == 0) {
            NSLog(@"%@",response.info);
        }
        
    }];
    
    [self updatebandWidth];
    
}

#pragma mark - IBAction

- (IBAction)start:(id)sender {
    [[PTFSSDK sharedInstance] startDaemonWithCompletion:^(PTFSResponse *response) {
        if (response.code == 0) {
            NSLog(@"%@",response.info);
        }
        
        BOOL status = [PTFSSDK.sharedInstance isDaemonOk];
        
        if (status) {
            NSLog(@"isDaemonOk");
        }
    }];
}
- (IBAction)stop:(id)sender {
    [[PTFSSDK sharedInstance] stopDaemonWithCompletion:^(PTFSResponse *response) {
        if (response.code == 0) {
            NSLog(@"%@",response.info);
        }
    }];
}
- (IBAction)restart:(id)sender {
    [[PTFSSDK sharedInstance] restartDaemonWithCompletion:^(PTFSResponse *response) {
        if (response.code == 0) {
            NSLog(@"%@",response.info);
        }
    }];
}


- (IBAction)upload:(UIButton *)sender {
    if (sender.isSelected) {
        [[PTFSSDK sharedInstance] cancelUploadWithTaskId:sender.tag];
        sender.selected = !sender.isSelected;
        return;
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"bbb.zip" ofType:nil];
    [[PTFSSDK sharedInstance] uploadFileWithPath:path fileSize:0 isDir:NO progress:^(NSUInteger completedSize, NSUInteger totalSize, NSInteger taskID) {
        CGFloat progress = (double)completedSize/totalSize;
        NSLog(@"completedSize %ld totalSize %ld taskID %d progress %f",(long)completedSize, (long)totalSize,(int)taskID,progress);
        
        self.uploadProgress.progress = progress;
        self.uploadInfoLabel.text = [NSString stringWithFormat:@"%@/%@",[self formatFizeSize:completedSize],[self formatFizeSize:totalSize]];
        if (progress >= 1) {
            sender.selected = !sender.isSelected;
        }
    } completion:^(PTFSResponse *response) {
        if (response.code == 0) {
            NSLog(@"上传出错 %@",response.info);
            return;
        }
        sender.selected = !sender.isSelected;
        sender.tag = response.code;
        NSLog(@"上传开始 任务id %ld",(long)response.code);
    }];
}
- (IBAction)upload2:(UIButton *)sender {
    if (sender.isSelected) {
        [[PTFSSDK sharedInstance] cancelUploadWithTaskId:sender.tag];
        sender.selected = !sender.isSelected;
        return;
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ccc.zip" ofType:nil];
    [[PTFSSDK sharedInstance] uploadFileWithPath:path fileSize:0 isDir:NO progress:^(NSUInteger completedSize, NSUInteger totalSize, NSInteger taskID) {
        CGFloat progress = (double)completedSize/totalSize;
        NSLog(@"completedSize %ld totalSize %ld taskID %d progress %f",(long)completedSize, (long)totalSize,(int)taskID,progress);
        
        self.uploadProgress2.progress = progress;
        self.uploadInfoLabel2.text = [NSString stringWithFormat:@"%@/%@",[self formatFizeSize:completedSize],[self formatFizeSize:totalSize]];
        if (progress >= 1) {
            sender.selected = !sender.isSelected;
        }
        
    } completion:^(PTFSResponse *response) {
        if (response.code == 0) {
            NSLog(@"上传出错 %@",response.info);
            return;
        }
        sender.selected = !sender.isSelected;
        sender.tag = response.code;
        NSLog(@"上传开始 任务id %ld",(long)response.code);
    }];
}

- (IBAction)download:(UIButton *)sender {
    if (sender.isSelected) {
        [[PTFSSDK sharedInstance] cancelDownloadingWithFileHash:@"CiUVN7A2Qywxz7SyQuisoxSxZYXozpH1vHHnSXkYnEQ81p" completion:^(PTFSResponse *response) {
            if (response.code == 1) {
                [[PTFSSDK sharedInstance] clearDownloadInfoWithTaskId:sender.tag];
            }
        }];;
        sender.selected = !sender.isSelected;
        return;
    }
    
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    [[PTFSSDK sharedInstance] downloadFileWithFileHash:@"CiUVN7A2Qywxz7SyQuisoxSxZYXozpH1vHHnSXkYnEQ81p" savePath:documentPath progress:^(NSUInteger completedSize, NSUInteger totalSize, NSInteger taskID) {
        CGFloat progress = (double)completedSize/totalSize;
        NSLog(@"completedSize %ld totalSize %ld taskID %d progress %f",(long)completedSize, (long)totalSize,(int)taskID,progress);
        
        self.downloadProgress.progress = progress;
        NSString *size1 = [self formatFizeSize:completedSize];
        NSString *size2 = [self formatFizeSize:totalSize];
        self.downloadInfoLabel.text = [NSString stringWithFormat:@"%@/%@",size1,size2];
        if (progress >= 1) {
            sender.selected = !sender.isSelected;
        }
    } completion:^(PTFSResponse *response) {
        if (response.code == 0) {
            NSLog(@"创建文件下载任务失败 %@",response.info);
            return;
        }
        sender.selected = !sender.isSelected;
        sender.tag = response.code;
        NSLog(@"下载开始 任务id %d",response.info.intValue);
    }];
}

- (IBAction)download2:(UIButton *)sender {
    if (sender.isSelected) {
        [[PTFSSDK sharedInstance] cancelDownloadingWithFileHash:@"CiaLqDcgBAJzuFtSxg5tGZc6No1DuHE5PiKk87QRUWw5h7" completion:^(PTFSResponse *response) {
            if (response.code == 1) {
                [[PTFSSDK sharedInstance] clearDownloadInfoWithTaskId:sender.tag];
            }
        }];;
        sender.selected = !sender.isSelected;
        return;
    }
    
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    [[PTFSSDK sharedInstance] downloadFileWithFileHash:@"CiaLqDcgBAJzuFtSxg5tGZc6No1DuHE5PiKk87QRUWw5h7" savePath:documentPath progress:^(NSUInteger completedSize, NSUInteger totalSize, NSInteger taskID) {
        CGFloat progress = (double)completedSize/totalSize;
        NSLog(@"completedSize %ld totalSize %ld taskID %d progress %f",(long)completedSize, (long)totalSize,(int)taskID,progress);
        
        self.downloadProgress2.progress = progress;
        NSString *size1 = [self formatFizeSize:completedSize];
        NSString *size2 = [self formatFizeSize:totalSize];
        self.downloadInfoLabel2.text = [NSString stringWithFormat:@"%@/%@",size1,size2];
        if (progress >= 1) {
            sender.selected = !sender.isSelected;
        }
    } completion:^(PTFSResponse *response) {
        if (response.code == 0) {
            NSLog(@"创建文件下载任务失败 %@",response.info);
            return;
        }
        sender.selected = !sender.isSelected;
        sender.tag = response.code;
        NSLog(@"下载开始 任务id %d",response.info.intValue);
    }];
}

- (IBAction)repoSize:(id)sender {
    [[PTFSSDK sharedInstance] repoSizeWithCompletion:^(PTFSResponse *response) {
        self.repoSizeLabel.text = [self formatFizeSize:response.code];
    }];
}

- (IBAction)clearRepoCache:(id)sender {
    [[PTFSSDK sharedInstance] clearCacheWithCompletion:^(PTFSResponse *response) {
        
    }];
    
    [self repoSize:nil];
}

- (IBAction)playLive:(id)sender {
    NSLog(@"播放直播视频");
    
    NSString * url = @"http://localhost:6003/ipfs/QmR8ykUYCtt4Kbm3TNMBARpNAseWf4C5CkUPLhsJ1z3sFb";
    
    PlayViewController * playVc = [[PlayViewController alloc] init];
    
    playVc.url = url;
    
    [self.navigationController pushViewController:playVc animated:YES];
}

#pragma mark - tools

//字节转文本
- (NSString *)formatFizeSize:(NSUInteger)fizeSize
{
    if (fizeSize < 1024) {
        return [NSString stringWithFormat:@"%dB",(int)fizeSize];
    }
    else if (fizeSize < 1024*1024)
    {
        return [NSString stringWithFormat:@"%.2fKB",fizeSize/1024.0];
    }
    else if (fizeSize < 1024*1024*1024)
    {
        return [NSString stringWithFormat:@"%.2fMB",fizeSize/(1024.0*1024.0)];
    }
    else
    {
        return [NSString stringWithFormat:@"%.2fGB",fizeSize/(1024.0*1024.0*1024.0)];
    }
}

- (void)updatebandWidth
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (@available(iOS 10.0, *)) {
            [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
                if (![[PTFSSDK sharedInstance] isDaemonOk]) {
                    return;
                }
                [[PTFSSDK sharedInstance] bandWidthWithCompletion:^(PTFSResponse *response) {
                    self.speedLabel.text = [NSString stringWithFormat:@"当前下行带宽:%@/S",[self formatFizeSize:response.code]];
                }];
            }];
        } else {
            // Fallback on earlier versions
        }
    });
}

@end
