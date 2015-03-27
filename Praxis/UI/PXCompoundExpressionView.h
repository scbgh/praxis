@import Foundation;

#import "PXExpressionView.h"
#import "PXCompoundExpression.h"

@class PXCodeEditor;

@interface PXCompoundExpressionView : PXExpressionView
@end

@interface PXCompoundExpression (PXExpressionView)
- (PXCompoundExpressionView *)createView;
@end