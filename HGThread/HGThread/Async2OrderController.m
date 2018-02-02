//
//  Async2OrderController.m
//  HGThread
//
//  Created by  ZhuHong on 2018/2/2.
//  Copyright © 2018年 CoderHG. All rights reserved.
//

#import "Async2OrderController.h"

@interface Async2OrderController ()

@end

@implementation Async2OrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        // GCD
        NSLog(@"  ------  start");
        
        [self gcd_group];
        
        NSLog(@"  ------  end");
    } else {
        // 信号量
        NSLog(@"  ------  start");
        [self semaphore];
        NSLog(@"  ------  end");
    }
}

- (void)gcd_group {
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        // 做点其它事情
        sleep(4);
        
        NSLog(@"结束 1 任务了");
        dispatch_group_leave(group);
    });
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        // 做点其它事情
        sleep(4);
        
        NSLog(@"结束 2 任务了");
        dispatch_group_leave(group);
    });
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        // 做点其它事情
        sleep(4);
        
        NSLog(@"结束 3 任务了");
        dispatch_group_leave(group);
    });
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
    
    
    NSLog(@"等待结束");
}

- (void)semaphore {
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        sleep(4);
        NSLog(@"结束 1 任务了");
        
        dispatch_semaphore_signal(sema);
    });
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        sleep(4);
        NSLog(@"结束 1 任务了");
        
        dispatch_semaphore_signal(sema);
    });
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        sleep(4);
        NSLog(@"结束 2 任务了");
        
        dispatch_semaphore_signal(sema);
    });
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        sleep(4);
        NSLog(@"结束 3 任务了");
        
        dispatch_semaphore_signal(sema);
    });
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        sleep(4);
        NSLog(@"结束 4 任务了");
        
        dispatch_semaphore_signal(sema);
    });
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}

@end
