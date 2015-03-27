#import <objc/runtime.h>
#import "PXExpression+PXExpressionView.h"

@implementation PXExpression (PXExpressionView)

- (PXExpressionView *)expressionView {
  return objc_getAssociatedObject(self, @selector(expressionView));
}

- (void)setExpressionView:(PXExpressionView *)expressionView {
  objc_setAssociatedObject(self, @selector(expressionView), expressionView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end