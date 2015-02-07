#import "PXConstantExpressionView.h"
#import "PXConstantExpression.h"
#import "PXValue.h"
#import "UIColor+PXColor.h"

@implementation PXConstantExpressionView

- (void)invalidateViews {
  [super invalidateViews];

  PXConstantExpression *expression = (PXConstantExpression *)self.expression;

  UILabel *constantLabel = [UILabel new];
  constantLabel.translatesAutoresizingMaskIntoConstraints = NO;
  constantLabel.textColor = [UIColor colorWithExpressionType:expression.type];
  switch (expression.type) {
    case PXFloatType:
      constantLabel.text = [NSString stringWithFormat:@"%.2f", [expression.value doubleValue]];
      break;
    case PXIntegerType:
      constantLabel.text = [NSString stringWithFormat:@"%d", [expression.value intValue]];
      break;
    case PXBooleanType:
      constantLabel.text = [expression.value boolValue] ? @"true" : @"false";
      break;
    case PXStringType:
      constantLabel.Text = [NSString stringWithFormat:@"%@", [expression.value stringValue]];
      break;
    case PXVoidType:
      constantLabel.Text = @"()";
      break;
    case PXFunctionType:
      constantLabel.Text = @"[function]";
      break;
  }
  [self addSubview:constantLabel];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[constantLabel]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(constantLabel)]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[constantLabel]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(constantLabel)]];
}

@end


@implementation PXConstantExpression (PXExpressionView)

- (PXConstantExpressionView *)createView {
  return [PXConstantExpressionView viewWithExpression:self];
}

@end