@import Foundation;

#import "PXExpressionView.h"
#import "PXAssignmentExpression.h"

@class PXCodeEditor;

@interface PXAssignmentExpressionView : PXExpressionView

@end

@interface PXAssignmentExpression (PXExpressionView)
- (PXAssignmentExpressionView *)createView;
@end