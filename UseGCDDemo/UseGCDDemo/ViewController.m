//
//  ViewController.m
//  UseGCDDemo
//
//  Created by cuzZLYues on 2017/7/6.
//  Copyright © 2017年 cuzZLYues. All rights reserved.
//

#import "ViewController.h"
#import "MBProgressHUD.h"
@interface ViewController ()
/**    */
@property (weak, nonatomic) IBOutlet UITextView *content;
@property (nonatomic,strong) UIButton *myBtn;
@end

static NSOperationQueue * queue;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
/*
 
************* 设置一个按钮 *******
 
 */
    _myBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _myBtn.frame = CGRectMake(100, 50, 200, 100);
    [_myBtn setTitle:@"开始下载" forState:UIControlStateNormal];
    
    _myBtn.titleLabel.font = [UIFont systemFontOfSize:24];
    
    [_myBtn addTarget:self action:@selector(someClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_myBtn];

}


//单击按钮后调用
-(void)someClick:(id)sender{

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    /*
     
     我们用NSInvocationOperation建了一个后台线程，并放到NSOperationQueue中。后台线程执行download方法。
     
     */
//    queue = [[NSOperationQueue alloc]init];
//    NSInvocationOperation * op = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(download) object:nil];
//    
//    [queue addOperation:op];
    
    [self useGCD];


}
/*
 
    这个方法处理下载网页的逻辑，下载完成后用performSelectorOnMainThread执行download_completed方法
 
 */
//-(void)download{
//
//    NSURL * url = [NSURL URLWithString:@"http://www.youdao.com"];
//    NSError * error;
//    //这里用的是NSString，如果是复杂的应用就可能不能这么简单了
//    NSString * data = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
//    if (data!=nil) {
//        [self performSelectorOnMainThread:@selector(download_completed:) withObject:data waitUntilDone:NO];
//    }else{
//        NSLog(@"error when download:%@",error);
//        
//    }
//
//}
//
//-(void)download_completed:(NSString *)data{
//    NSLog(@"call back");
//    //这个方法进行一个clear up 工作，停止菊花转动，并且把下载的内容显示在textView上面。
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
//    self.content.text = data;
//}

-(void)useGCD{

dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
   
    NSURL * url = [NSURL URLWithString:@"http://www.youdao.com"];
    NSError * error;
    //这里用的是NSString，如果是复杂的应用就可能不能这么简单了
    NSString * data = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    if (data!= nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            self.content.text = data;
            
        });
    }else{
    NSLog(@"error when download:%@",error);
    }
    
});

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
