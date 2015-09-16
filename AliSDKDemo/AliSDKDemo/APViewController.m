//
//  APViewController.m
//  AliSDKDemo
//
//  Created by 方彬 on 11/29/13.
//  Copyright (c) 2013 Alipay.com. All rights reserved.
//

#import "APViewController.h"
#import "Order.h"
#import "DataSigner.h"
#import "DataVerifier.h"
#import <AlipaySDK/AlipaySDK.h>
#import "rsa.h"
#import "HttpTool.h"
#import "JSONKit.h"

#import "APAuthV2Info.h"


#import "DataVerifier.h"

@implementation Product


@end

@interface APViewController ()

@end

@implementation APViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
/***********************************************************
   泰爱理财2期项目 RSA验证签名过程和方法:
   1、流程：服务端返回JSON对象，我们需要将返回的对象做字符串拼串， 顺序是：resultCode+resultMessage+result
这样拼接出来的字符串是待验签的字符串。我们需要将待验签的字符串结合chkValue和pubkey最终得出服务端端返回的数据是否被修改过。
 ***********************************************************/
    
    NSString *pubkey = @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC7XK8+o6awxC2tvcXa3dQ/7WnRGagrhqYqWZPnNxOSR/+c6BGuYaxhYhnfnmHXtHHphP3vY7Ew4/Eb+kf7XwOQBmxKxYleb/OWUZDXfs/j+w066YsA3MsV/UoS+prQcFnUXAHTKCwI9KtXN/rAh4VuSUBuZk1Bpq0QQn2e+3rrwQIDAQAB";//公钥 （导入头文件）
    
    //验签
   id<DataVerifier> signer = CreateRSADataVerifier(pubkey);
    
//    //签名
//    id<DataSigner>  singber = CreateRSADataSigner(@"私钥字符串");
//    [singber signString:@"需要签名的字符串"];
   
    /*丁竟成 登陆接口**/
    NSString *loan_url = [NSString stringWithFormat:@"%@/mobile/login.json",@"http://36.33.24.175:8076"];
    NSDictionary *dict = @{@"username":@"wpsadmin009",@"password":@"123456"};
    
    /*登陆请求*/
    [HttpTool postWithPath:loan_url params:dict success:^(id JSON) {
        NSDictionary *dict = JSON;
        NSString *resultCode =dict[@"resultCode"];//取出resultCode
        NSString *resultMessage =dict[@"resultMessage"];//取出resultMessage
        
        //如果服务端返回的result对象是字符串
        if ([dict[@"result"] isKindOfClass:[NSString class]]) {
//todo  用字符串承接对象并且处理
            NSString *result =  dict[@"result"];//取出result
            
            //.....
            
        }else{
            NSDictionary *result =  dict[@"result"];//取出result
            
            //利用JSONKit框架处理字典对象变成序列化输出的JSON对象
            NSString *result11 =  [result JSONStringWithOptions:JKSerializeOptionPretty error:nil];
            NSString *str = [NSString stringWithFormat:@"%@%@%@",resultCode,resultMessage,result11];//拼接字符串
            str  = [self toNowString:str];
    
            NSString  *chkValue = dict[@"chkValue"];//验签的Base64加密串
            chkValue  = [self toNowString:chkValue];
            
            
            BOOL status =  [signer verifyString:str withSign:chkValue];//str待验证签名的字符串   chkValue：服务端返回的签名值
            if (status) {
                NSLog(@"状态正常");
            }else{
                NSLog(@"状态异常！");
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"请求失败~~~~~");
    }];
}

- (NSString *)toNowString:(NSString *)str1{
    str1 = [str1 stringByReplacingOccurrencesOfString:@" " withString:@""];//去掉空格
    str1 = [str1 stringByReplacingOccurrencesOfString:@"\n" withString:@""];//去掉换行
    str1 = [str1 stringByReplacingOccurrencesOfString:@"\r" withString:@""];//去掉空格
    str1 = [str1 stringByReplacingOccurrencesOfString:@"\\//" withString:@"\\"];//可能会改变  需要替换特殊字符
    str1 =  [str1 stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//做utf-8编码
    
    return str1;
}


















//**********************************************************************
#pragma mark - 以下是支付宝订单信息我们不做关注
- (NSString *)generateTradeNO
{
	static int kNumber = 15;
	
	NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	NSMutableString *resultStr = [[NSMutableString alloc] init];
	srand(time(0));
	for (int i = 0; i < kNumber; i++)
	{
		unsigned index = rand() % [sourceStr length];
		NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
		[resultStr appendString:oneStr];
	}
	return resultStr;
}



#pragma mark -
#pragma mark   ==============产生订单信息==============

- (void)generateData{
	NSArray *subjects = @[@"1",
                          @"2",@"3",@"4",
                          @"5",@"6",@"7",
                          @"8",@"9",@"10"];
	NSArray *body = @[@"我是测试数据",
                      @"我是测试数据",
                      @"我是测试数据",
                      @"我是测试数据",
                      @"我是测试数据",
                      @"我是测试数据",
                      @"我是测试数据",
                      @"我是测试数据",
                      @"我是测试数据",
                      @"我是测试数据"];
	
	if (nil == self.productList) {
		self.productList = [[NSMutableArray alloc] init];
	}
	else {
		[self.productList removeAllObjects];
	}
    
	for (int i = 0; i < [subjects count]; ++i) {
		Product *product = [[Product alloc] init];
		product.subject = [subjects objectAtIndex:i];
		product.body = [body objectAtIndex:i];
        
		product.price = 0.01f+pow(10,i-2);
		[self.productList addObject:product];
	}
}


#pragma mark -
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 55.0f;
}

#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.productList count];
}




//
//用TableView呈现测试数据,外部商户不需要考虑
//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
													reuseIdentifier:@"Cell"];
    
	Product *product = [self.productList objectAtIndex:indexPath.row];

    cell.textLabel.text = product.body;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"一口价：%.2f",product.price];
	
	return cell;
}


#pragma mark -
#pragma mark   ==============点击订单模拟支付行为==============
//
//选中商品调用支付宝极简支付
//
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

	/*
	 *点击获取prodcut实例并初始化订单信息
	 */
	Product *product = [self.productList objectAtIndex:indexPath.row];
	
	/*
	 *商户的唯一的parnter和seller。
	 *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
	 */
    
/*============================================================================*/
/*=======================需要填写商户app申请的===================================*/
/*============================================================================*/
	NSString *partner = @"";
    NSString *seller = @"";
    NSString *privateKey = @"";
/*============================================================================*/
/*============================================================================*/
/*============================================================================*/
	
	//partner和seller获取失败,提示
	if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
														message:@"缺少partner或者seller或者私钥。"
													   delegate:self
											  cancelButtonTitle:@"确定"
											  otherButtonTitles:nil];
		[alert show];
		return;
	}
	
	/*
	 *生成订单信息及签名
	 */
	//将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
	order.partner = partner;
	order.seller = seller;
	order.tradeNO = [self generateTradeNO]; //订单ID（由商家自行制定）
	order.productName = product.subject; //商品标题
	order.productDescription = product.body; //商品描述
	order.amount = [NSString stringWithFormat:@"%.2f",product.price]; //商品价格
	order.notifyURL =  @"http://www.xxx.com"; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
	
	//应用注册scheme,在AlixPayDemo-Info.plist定义URL types
	NSString *appScheme = @"alisdkdemo";
	
	//将商品信息拼接成字符串
	NSString *orderSpec = [order description];
	NSLog(@"orderSpec = %@",orderSpec);
	
	//获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
	id<DataSigner> signer = CreateRSADataSigner(privateKey);
	NSString *signedString = [signer signString:orderSpec];
	
	//将签名成功字符串格式化为订单字符串,请严格按照该格式
	NSString *orderString = nil;
	if (signedString != nil) {
		orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
        }];
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}
@end
