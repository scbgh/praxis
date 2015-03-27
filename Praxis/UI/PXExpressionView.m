#import <objc/runtime.h>
#import "PXExpressionView.h"
#import "PXExpression.h"
#import "PXExpression+PXExpressionView.h"
#import "PXCodeEditor.h"
#import "UIView+PXGestureExtensions.h"
#import "PXHoleView.h"
#import "PXHole.h"
#import "PXLabel.h"

@implementation PXExpressionView

- (instancetype)initWithExpression:(PXExpression *)expression {
  self = [super init];
  if (self) {
    _expression = expression;
    _expression.expressionView = self;
  }
  return self;
}

+ (instancetype)viewWithExpression:(PXExpression *)expression {
  return [[self alloc] initWithExpression:expression];
}

- (void)refresh {
}

- (void)invalidateViews {
  [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

- (void)didMoveToSuperview {
  if (self.superview) {
    [self refresh];
  }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
  UIView *view = [super hitTest:point withEvent:event];
  if ([view isKindOfClass:[PXLabel class]]) {
    return ((PXLabel *)view).associatedView;
  }
  return view;
}

- (BOOL)isSelected {
  return self.editor.selectedHoleView.hole.expression == self.expression;
}


@end