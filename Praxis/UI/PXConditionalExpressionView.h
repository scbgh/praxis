@import Foundation;

#import "PXExpressionView.h"
#import "PXConditionalExpression.h"

@interface PXConditionalExpressionView : PXExpressionView
@end

@interface PXConditionalExpression (PXExpressionView)
- (PXConditionalExpressionView *)createView;
@end