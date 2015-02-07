@import Foundation;

#import "PXExpressionView.h"
#import "PXWhileExpression.h"

@interface PXWhileExpressionView : PXExpressionView

@end

@interface PXWhileExpression (PXExpressionView)
- (PXWhileExpressionView *)createView;
@end