@import Foundation;

#import "PXExpressionView.h"
#import "PXConstantExpression.h"

@interface PXConstantExpressionView : PXExpressionView

@end

@interface PXConstantExpression (PXExpressionView)
- (PXConstantExpressionView *)createView;
@end
