//
// Created by Dana Buehre on 6/17/17.
// Copyright (c) 2017 CreatureCoding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIColor (ColorFromHex)

//returns a UIColor from the passed hex value eg [UIColor colorWithHex:0x6BB9F0FF] using the last 2 digits as the alpha;
+ (UIColor *)colorFromHex:(int)hex;

//returns a UIColor from the passed hex value eg [UIColor colorWithHex:0x6BB9F0 WithAlpha:1];
+ (UIColor *)colorFromHex:(int)hex WithAlpha:(CGFloat)alpha;

//returns a UIColor with alpha control from the passed hex string eg [UIColor colorFromHexString:@"#6BB9F0:0.500000"];
+ (UIColor *)colorFromHexString:(NSString *)hexString;

//returns a UIColor from the passed hex string with alpha control eg [UIColor colorFromHexString:@"#6BB9F0 alpha:0.5f"];
+ (UIColor *)colorFromHexString:(NSString *)hexString alpha:(CGFloat)alpha;
@end
