
#import "ATCommonFunction.h"

@implementation ATCommonFunction

+ (NSString *)ATGetselfPhotoPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"selfPhoto.png"];
}

+ (void)ATGetNsUserDefaultSetting
{
    NSDictionary* defaults = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
//    ATLog(@"Defaults-->: %@", defaults);
}

+ (BOOL)ATgetUserIsLogin
{
   NSString *islogin =  [[NSUserDefaults standardUserDefaults] objectForKey:@"isLogin"];
    if ([islogin isEqualToString:@"YES"]) {
        return YES;
    }else{
        return NO;
    }
}

+ (BOOL)ATgetUserIsVerify
{
    NSString *isVerify =  [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userIsVarify"]];
    if ([isVerify isEqualToString:@"1"]) {
        return YES;
    }else{
        return NO;
    }
}

+ (NSString *)ATgetUserName
{
   return [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
}

+ (NSString *)ATgetUserEmail
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"userEmail"];
}

+ (UIImageView *)ATgetRoundImgae:(UIImageView *)image iconWidth:(CGFloat)kIconWidth
{
    image.layer.cornerRadius= kIconWidth/2;
    image.layer.masksToBounds= YES;
    return image;
}


+ (UIColor *) colorWithHexString: (NSString *) stringToConvert

{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString]; //去掉前后空格换行符
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor redColor];
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor redColor];
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];  //扫描16进制到int
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

+(NSMutableAttributedString *)ATgetAttributeWithString:(NSString *)string
{
    
    //每三位一个逗号
//    NSNumberFormatter *formater = [[NSNumberFormatter alloc] init];
//    formater.numberStyle = NSNumberFormatterDecimalStyle;
//    NSString *string = [formater stringFromNumber:[NSNumber numberWithFloat:1234567]];
//    NSString *s =  [NSString stringWithFormat:@"￥%@",string];
    
    NSInteger strLocation =  [string rangeOfString:@"."].location;
    NSMutableAttributedString *attribute;
    //外部进来的数据先判断是否有小数点
    if (strLocation!=NSNotFound){
        //如果是有小数点的
        attribute = [[NSMutableAttributedString alloc] initWithString:string];
        [attribute addAttribute:
         NSFontAttributeName
         value:[UIFont fontWithName:nil size:16]
         range:NSMakeRange(0,strLocation)];
    }else {
        attribute = [[NSMutableAttributedString alloc] initWithString:string];
        [attribute addAttribute:
         NSFontAttributeName
                          value:[UIFont fontWithName:nil size:16]
                          range:NSMakeRange(0,string.length)];
    }
    return attribute;
}

+(NSString *)AtGetValue:(int)count{
    
    NSString *moneyNumber;
    if (count >= 10000) { // [10000, 无限大)
        moneyNumber  = [NSString stringWithFormat:@"%.1f万",count / 10000.0];
        // 用空串替换掉所有的.0
        moneyNumber = [moneyNumber stringByReplacingOccurrencesOfString:@".0" withString:@""];
    } else if (count > 0) { // (0, 10000)
        moneyNumber = [NSString stringWithFormat:@"%d %@", count, moneyNumber];
    } else {
        moneyNumber = [NSString stringWithFormat:@"%d",count];
    }
    return moneyNumber;
}

+(BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+(BOOL)isEmail:(NSString *)EmailPar
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.((com)|(cn)|(net))";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:EmailPar];
}

+(BOOL)isPhoneNumber:(NSString *)phoneNumber
{
    if ([phoneNumber length] == 0) {
        return NO;
    }
    NSString *PhoneNumberRegex = @"^((13[0-9])|(17)[0-9]|(147)|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneNumberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PhoneNumberRegex];
    return [phoneNumberTest evaluateWithObject:phoneNumber];
}

+(BOOL)isEnglish:(NSString *)English
{
    NSString *englishRegex = @"^[A-Za-z]+$";
    NSPredicate *EnglishTest =  [NSPredicate predicateWithFormat:@"SELF MATCHES %@",englishRegex];
    return [EnglishTest evaluateWithObject:English];
    
}

+(BOOL)isNumber:(NSString *)Number
{
    NSString *NumberRegex = @"^[0-9]+$";
    NSPredicate *NumberTest =  [NSPredicate predicateWithFormat:@"SELF MATCHES %@",NumberRegex];
    return [NumberTest evaluateWithObject:Number];
}


+(BOOL)isID:(NSString *)ID
{
    
    if (!((ID.length==18)||(ID.length==15))) {
        
        return NO;
    }
    if (ID) {
        
        //验证前14或者17位是否为纯数字
        NSRange range=NSMakeRange(0,ID.length-1);
        NSString *subString=[ID substringWithRange:range];
        if (![self isNumber:subString]) {
            return NO;
        }
        
        for (int i=0; i<ID.length; i++) {
            if (i==ID.length-1) {
                NSRange range=NSMakeRange(i,1);
                NSString *subString=[ID substringWithRange:range];
                //#warning 验证身份证最后一位
                if (![@"X0123456789" containsString:subString]) {
                    return NO;
                }
            }
            
        }
    }
    return YES;
}

+(BOOL)isChinese:(NSString *)Chinese
{
    if (Chinese) {
        for (int i=0; i<Chinese.length; i++) {
            NSRange range=NSMakeRange(i,1);
            NSString *subString=[Chinese substringWithRange:range];
            const char *cString=[subString UTF8String];
            if (strlen(cString)!=3)
            {
                return NO;
            }
        }
    }
    return YES;
}

+(BOOL)isNumberAndEnglish:(NSString *)NumberAndEnglish
{
    NSString *NumberAndEnglishRegex = @"^[a-zA-Z][a-zA-Z0-9]*";
    NSPredicate *NumberAndEnglishTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",NumberAndEnglishRegex];
    return [NumberAndEnglishTest evaluateWithObject:NumberAndEnglish];
}

+(BOOL)userPasswordVarify:(NSString *)userPassword
{
    NSString *userPasswordRegex = @"[a-zA-Z0-9]*";
    NSPredicate *userPasswordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userPasswordRegex];
    return [userPasswordTest evaluateWithObject:userPassword];
}

+(BOOL)isQQ:(NSString *)qq
{
    if (qq.length>11) {
        return NO;
    }
    NSString *qqRegex = @"[1-9][0-9]{4,}";
    NSPredicate *qqTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",qqRegex];
    return [qqTest evaluateWithObject:qq];
}

+(BOOL)isPostCode:(NSString *)PostCode
{
    if (PostCode.length>6) {
        return NO;
    }
    
    //验证前6位是否为纯数字
    NSRange range=NSMakeRange(0,PostCode.length);
    NSString *subString=[PostCode substringWithRange:range];
    
    if (![self isNumber:subString]) {
        return NO;
    }
    for (int i = 0; i<PostCode.length; i++) {
        if (i == 0) {
            NSRange range=NSMakeRange(i,1);
            NSString *subString=[PostCode substringWithRange:range];
            if ([@"0" containsString:subString]) {
                return NO;
            }
        }
        
    }
    return YES;
}

@end
