/*
     封装了一些全局常用的函数功能在里面
 */
#import <Foundation/Foundation.h>

@interface ATCommonFunction : NSObject


/**
 *  得到用户上传头像的保存路径
 *  @return 返回用户头像保存的地址
 */
+ (NSString *)ATGetselfPhotoPath;


/**
 *  获取设备上的所有的NSUserDefaults的设置
 */
+ (void)ATGetNsUserDefaultSetting;

/**
 *  获取用户是否登陆
 */
+ (BOOL)ATgetUserIsLogin;

/**
 *  判断用户是否已经实名认证
 */
+ (BOOL)ATgetUserIsVerify;

/**
 *  获取登陆的用户名
 */
+(NSString *)ATgetUserName;

/**
 *  获取登陆用户的邮箱
 */
+(NSString *)ATgetUserEmail;

/**
 *  返回一张圆形的按钮图片
 */
+(UIImageView *)ATgetRoundImgae:(UIImageView *)image iconWidth:(CGFloat)kIconWidth;

/**
 *  十六进制转颜色
 */
+ (UIColor *) colorWithHexString: (NSString *) stringToConvert;

/**
 *  给一个字符串返回一个富文本   小数点前面大
 */
+(NSMutableAttributedString *)ATgetAttributeWithString:(NSString *)string;

//自动计算所有的人数以万为单位
+(NSString *)AtGetValue:(int)count;

#pragma -mark   数据验证类
/** 验证邮箱是否合法*/
+(BOOL)isValidateEmail:(NSString *)email;

/** 手机号匹配*/
+(BOOL)isPhoneNumber:(NSString *)phoneNumber;

/** 英文匹配*/
+(BOOL)isEnglish:(NSString *)English;

/** 阿拉伯数字匹配*/
+(BOOL)isNumber:(NSString *)Number;

/** 身份证匹配*/
+(BOOL)isID:(NSString *)ID;

/** 中文匹配*/
+(BOOL)isChinese:(NSString *)Chinese;

/** 以字母开头的数字和字母组合或纯数字和字母*/
+(BOOL)isNumberAndEnglish:(NSString *)NumberAndEnglish;

/** 只能是数字和字母组合*/
+(BOOL)userPasswordVarify:(NSString *)userPassword;

/** QQ号匹配*/
+(BOOL)isQQ:(NSString *)qq;

/** 国内邮政编码匹配*/
+(BOOL)isPostCode:(NSString *)PostCode;

@end
