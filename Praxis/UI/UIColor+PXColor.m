#import "UIColor+PXColor.h"

@implementation UIColor (PXColor)

+ (UIColor *)integerColor {
    return [UIColor colorWithRed:0.f green:.6f blue:.2f alpha:1.f];
}

+ (UIColor *)floatColor {
  return [UIColor integerColor];
}

+ (UIColor *)stringColor {
  return [UIColor colorWithRed:.5f green:.2f blue:0.f alpha:1.f];
}

+ (UIColor *)boolColor {
  return [UIColor colorWithRed:1.f green:0.f blue:1.f alpha:1.f];
}

+ (UIColor *)keywordColor {
  return [UIColor colorWithRed:0.f green:0.f blue:1.f alpha:1.f];
}

+ (UIColor *)functionColor {
  return [UIColor colorWithRed:.5f green:.7f blue:.2f alpha:1.f];
}

+ (UIColor *)selectionColor {
  return [UIColor colorWithRed:.7f green:.3f blue:.1f alpha:.2f];
}

+ (UIColor *)colorWithExpressionType:(PXExpressionType)type {
  switch (type) {
    case PXFloatType:
      return [UIColor floatColor];
    case PXIntegerType:
      return [UIColor integerColor];
    case PXBooleanType:
      return [UIColor boolColor];
    case PXStringType:
      return [UIColor stringColor];
    case PXFunctionType:
      return [UIColor functionColor];
    default:
      return [UIColor blackColor];
  }
}

@end