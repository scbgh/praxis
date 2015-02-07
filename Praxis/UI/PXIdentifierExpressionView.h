@import Foundation;

#import "PXIdentifierExpression.h"
#import "PXExpressionView.h"

@interface PXIdentifierExpressionView : PXExpressionView

@end

@interface PXIdentifierExpression (PXExpressionView)
- (PXIdentifierExpressionView *)createView;
@end
