@import Foundation;

#import "PXExpression.h"

@class PXHole;

@interface PXConditionalExpression : PXExpression

- (PXHole *)conditionExpressionHole;
- (PXHole *)trueExpressionHole;
- (PXHole *)falseExpressionHole;

@end