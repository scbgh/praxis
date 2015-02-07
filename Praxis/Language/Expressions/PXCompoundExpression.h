@import Foundation;

#import "PXExpression.h"

@class PXHole;

@interface PXCompoundExpression : PXExpression

- (instancetype)initWithType:(PXExpressionType)type;
+ (instancetype)expressionWithType:(PXExpressionType)type;

- (PXHole *)expressionHoleAtIndex:(NSUInteger)index;

@property(nonatomic) NSUInteger numberOfSubexpressions;

@end