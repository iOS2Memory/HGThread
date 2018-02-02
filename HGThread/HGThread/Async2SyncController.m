//
//  Async2SyncController.m
//  HGThread
//
//  Created by  ZhuHong on 2018/2/2.
//  Copyright © 2018年 CoderHG. All rights reserved.
//

#import "Async2SyncController.h"

@interface Async2SyncController ()

@end

@implementation Async2SyncController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        // GCD
        NSLog(@"  ------  start");
        
        NSInteger temp = [self gcd_group];
        NSLog(@"%zd", temp);
        
        NSLog(@"  ------  end");
    } else {
        // 信号量
        NSLog(@"  ------  start");
        NSInteger temp = [self semaphore];
        NSLog(@"%zd", temp);
        NSLog(@"  ------  end");
        
        
    }
}

// 异步 -> 同步
- (NSInteger)gcd_group {
    
    __block NSInteger count = 50;
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        // 做点其它事情
        sleep(4);
        
        NSLog(@"睡醒了");
        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            count = 45;
//            dispatch_group_leave(group);
//        });
        
        count = 45;
        dispatch_group_leave(group);
    });
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
    NSLog(@"等待结束");
    
    return count;
}

- (NSInteger)semaphore {
    __block NSInteger result = 10;
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        sleep(4);
        result = 89;
        dispatch_semaphore_signal(sema);
    });
    // 这里本来同步方法会立即返回，但信号量=0使得线程阻塞
    // 当异步方法回调之后，发送信号，信号量变为1，这里的阻塞将被解除，从而返回正确的结果
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    NSLog(@"methodSync 结束 result:%ld", (long)result);
    return result;
}

@end
