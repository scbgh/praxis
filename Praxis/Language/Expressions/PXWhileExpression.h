@import Foundation;

#import "PXExpression.h"

@class PXHole;

@interface PXWhileExpression : PXExpression

- (PXHole *)conditionExpressionHole;
- (PXHole *)bodyExpressionHole;

@end