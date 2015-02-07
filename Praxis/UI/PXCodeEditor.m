#import "PXCodeEditor.h"
#import "PXExpression.h"
#import "PXTaskProvider.h"
#import "PXExpressionView.h"
#import "PXVisuals.h"

@implementation PXCodeEditor {
  PXExpression *_expression;
}

- (void)setExpression:(PXExpression *)expression {
  _expression = expression;
  [self invalidateViews];
}

- (void)invalidateViews {
  [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
  if (self.expression == nil) {
    return;
  }

  if ([self.expression respondsToSelector:@selector(createView)]) {
    PXExpressionView *expressionView = (PXExpressionView *)[self.expression performSelector:@selector(createView)];
    expressionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:expressionView];

    NSString *horizontalConstraint = [NSString stringWithFormat:@"H:|-%d-[expressionView]", kEditorPadding];
    NSString *verticalConstraint = [NSString stringWithFormat:@"V:|-%d-[expressionView]", kEditorPadding];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:horizontalConstraint options:0 metrics:nil views:NSDictionaryOfVariableBindings(expressionView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:verticalConstraint options:0 metrics:nil views:NSDictionaryOfVariableBindings(expressionView)]];
  }

}

@end