@import Foundation;
@import UIKit;

#import "PXExpressionType.h"

@interface UIColor (PXColor)

+ (UIColor *)integerColor;
+ (UIColor *)floatColor;
+ (UIColor *)stringColor;
+ (UIColor *)boolColor;
+ (UIColor *)identifierColor;
+ (UIColor *)keywordColor;
+ (UIColor *)functionColor;
+ (UIColor *)colorWithExpressionType:(PXExpressionType)type;


@end