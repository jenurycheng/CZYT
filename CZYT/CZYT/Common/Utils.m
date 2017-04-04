//
//  Utils.m
//  CZYT
//
//  Created by jerry cheng on 2017/3/27.
//  Copyright © 2017年 chester. All rights reserved.
//

#import "Utils.h"
#include "pinyin.h"

@implementation Utils

+ (NSString *)toPinYin:(NSString *)source
{
    NSMutableString *str = [NSMutableString stringWithString:source];
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    NSString *pinYin = [str capitalizedString];
    return [pinYin substringToIndex:1];
}

+ (NSString *)toPinYins:(NSString *)source
{
    NSString *pinyin = @"";
    for (int i = 0; i < [source length]; i++)  {
        pinyin = [pinyin stringByAppendingFormat:@"%c", pinyinFirstLetter([source characterAtIndex:i])];
    }
    return pinyin;
}

@end
