@import Foundation;

#import "PXExpressionView.h"
#import "PXWhileExpression.h"

@class PXCodeEditor;

@interface PXWhileExpressionView : PXExpressionView

@end

@interface PXWhileExpression (PXExpressionView)
- (PXWhileExpressionView *)createView;
@end