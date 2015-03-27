@import Foundation;

#import "PXIdentifierExpression.h"
#import "PXExpressionView.h"

@class PXCodeEditor;

@interface PXIdentifierExpressionView : PXExpressionView

@end

@interface PXIdentifierExpression (PXExpressionView)
- (PXIdentifierExpressionView *)createView;
@end
