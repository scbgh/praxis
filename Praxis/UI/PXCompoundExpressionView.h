@import Foundation;

#import "PXExpressionView.h"
#import "PXCompoundExpression.h"

@interface PXCompoundExpressionView : PXExpressionView

@end

@interface PXCompoundExpression (PXExpressionView)
- (PXCompoundExpressionView *)createView;
@end