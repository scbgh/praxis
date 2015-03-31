@import Foundation;

#import "PXExpressionView.h"
#import "PXPrintExpression.h"

@interface PXPrintExpressionView : PXExpressionView
@end


@interface PXPrintExpression (PXExpressionView)
- (PXPrintExpressionView *)createView;
@end