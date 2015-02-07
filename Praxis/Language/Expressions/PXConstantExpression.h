@import Foundation;

#import "PXExpression.h"

@class PXValue;

@interface PXConstantExpression : PXExpression

- (instancetype)initWithType:(PXExpressionType)type;
+ (instancetype)expressionWithType:(PXExpressionType)type;

@property(nonatomic, strong) PXValue *value;

@end