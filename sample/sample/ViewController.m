//
//  ViewController.m
//  sample
//
//  Created by kouliang on 15/2/14.
//  Copyright (c) 2015年 kouliang. All rights reserved.
//
#import "ViewController.h"

@interface ViewController ()<UIWebViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIWebView *webView=(UIWebView *)self.view;
    webView.delegate=self;
    
    NSString *path=[[NSBundle mainBundle]pathForResource:@"study.html" ofType:nil];
    NSString *html=[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    [webView loadHTMLString:html baseURL:nil];
}


#pragma mark - webView代理方法

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    //图片资源的路径
    NSString *path=[[NSBundle mainBundle]pathForResource:@"422128.png" ofType:nil];
    NSString *pictPath=[NSString stringWithFormat:@"file://%@",path];
    
    
    //获得网页中的img标签，并设置其资源路径
    [webView stringByEvaluatingJavaScriptFromString:@"img=document.getElementsByTagName('img')[0];"];
    NSString *jsStr=[NSString stringWithFormat:@"img.src='%@';",pictPath];
    [webView stringByEvaluatingJavaScriptFromString:jsStr];
    
    
    //设置网页中图片的点击事件
    /*
     通用url的设计 kl:<#methodName#>&<#param#>
     协议固定： kl:
     参数param可以为空，最多有一个
     */
    NSString *onclick=@"img.onclick=function(){"
    "window.location.href = 'kl:test:&helloOC,thisIsFromJavaScript';"
    "};";
    [webView stringByEvaluatingJavaScriptFromString:onclick];
}


-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    //获取请求路径
    NSString *urlStr=request.URL.absoluteString;
    //判断协议头
    NSRange range=[urlStr rangeOfString:@"kl:"];
    if (range.location!=NSNotFound) {
        NSUInteger loc=range.location+range.length;
        //获得方法和参数
        NSString *path=[urlStr substringFromIndex:loc];
        NSArray *methodNameAndParam=[path componentsSeparatedByString:@"&"];
        //方法名
        NSString *methodName=[methodNameAndParam firstObject];
        //参数名
        NSString *param=nil;
        if (methodNameAndParam.count>1) {
            param=[methodNameAndParam lastObject];
        }
        //调用方法
        if ([self respondsToSelector:NSSelectorFromString(methodName)]) {
            [self performSelector:NSSelectorFromString(methodName) withObject:param];
        }
        return NO;
    }
    return YES;
}


-(void)test:(NSString *)str{
    NSLog(@"%s---%@",__func__,str);
}
@end

