//
//  ZXEDUViewController.m
//  CampusMap
//
//  Created by Tarena on 16/4/19.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import "ZXEDUViewController.h"

@interface ZXEDUViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forwardItem;
- (IBAction)back:(UIBarButtonItem *)sender;
- (IBAction)forward:(UIBarButtonItem *)sender;
- (IBAction)refresh:(UIBarButtonItem *)sender;

@end

@implementation ZXEDUViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.delegate = self;
    //网页的内容缩小到适应真个设备的屏幕
    self.webView.scalesPageToFit = YES;
    //检测网页中的各种字符串，比如 电话。网址。自动识别，在用户长按时，弹出相应的菜单，做操作
    self.webView.dataDetectorTypes = UIDataDetectorTypeAll;
    //http://www.haue.edu.cn 校园网
    NSURL *url = [NSURL URLWithString:@"http://www.haue.edu.cn"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}
- (IBAction)dissmissVC:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    self.backItem.enabled  = webView.canGoBack;
    self.forwardItem.enabled = webView.canGoForward;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.backItem.enabled  = webView.canGoBack;
    self.forwardItem.enabled = webView.canGoForward;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    // 加载错误时执行
}


- (IBAction)back:(UIBarButtonItem *)sender {
    [self.webView goBack];
}

- (IBAction)forward:(UIBarButtonItem *)sender {
    [self.webView goForward];
}

- (IBAction)refresh:(UIBarButtonItem *)sender {
    [self.webView reload];
}
@end
