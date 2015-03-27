#import "PXConstantExpressionView.h"
#import "PXConstantExpression.h"
#import "PXValue.h"
#import "UIColor+PXColor.h"
#import "PXCodeEditor.h"
#import "PXConditionalExpression.h"

@implementation PXConstantExpressionView {
  UILabel *_constantLabel;
}

- (void)invalidateViews {
  [super invalidateViews];

  _constantLabel = [UILabel new];
  _constantLabel.translatesAutoresizingMaskIntoConstraints = NO;
  [self addSubview:_constantLabel];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_constantLabel]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_constantLabel)]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_constantLabel]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_constantLabel)]];

  [self refresh];
}

- (void)refresh {
  PXConstantExpression *expression = (PXConstantExpression *)self.expression;
  _constantLabel.textColor = [UIColor colorWithExpressionType:expression.type];

  switch (expression.type) {
    case PXFloatType:
      _constantLabel.text = [NSString stringWithFormat:@"%.2f", [expression.value doubleValue]];
      break;
    case PXIntegerType:
      _constantLabel.text = [NSString stringWithFormat:@"%d", [expression.value intValue]];
      break;
    case PXBooleanType:
      _constantLabel.text = [expression.value boolValue] ? @"true" : @"false";
      break;
    case PXStringType:
      _constantLabel.Text = [NSString stringWithFormat:@"\"%@\"", [expression.value stringValue]];
      break;
    case PXVoidType:
      _constantLabel.Text = @"()";
      break;
    case PXFunctionType:
      _constantLabel.Text = @"[function]";
      break;
  }
}


@end


@implementation PXConstantExpression (PXExpressionView)

- (PXConstantExpressionView *)createView {
  PXConstantExpressionView *view = [PXConstantExpressionView viewWithExpression:self];
  return view;
}

@end