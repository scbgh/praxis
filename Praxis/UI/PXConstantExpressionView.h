@import Foundation;

#import "PXExpressionView.h"
#import "PXConstantExpression.h"

@class PXCodeEditor;

@interface PXConstantExpressionView : PXExpressionView
@end

@interface PXConstantExpression (PXExpressionView)
- (PXConstantExpressionView *)createView;
@end
