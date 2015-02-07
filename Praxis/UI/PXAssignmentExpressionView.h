@import Foundation;

#import "PXExpressionView.h"
#import "PXAssignmentExpression.h"

@interface PXAssignmentExpressionView : PXExpressionView

@end

@interface PXAssignmentExpression (PXExpressionView)
- (PXAssignmentExpressionView *)createView;
@end