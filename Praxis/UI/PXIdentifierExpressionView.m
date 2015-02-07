#import "PXIdentifierExpressionView.h"
#import "UIColor+PXColor.h"

@implementation PXIdentifierExpressionView

- (void)invalidateViews {
  [super invalidateViews];

  PXIdentifierExpression *expression = (PXIdentifierExpression *)self.expression;

  UILabel *identifierLabel = [UILabel new];
  identifierLabel.translatesAutoresizingMaskIntoConstraints = NO;
  identifierLabel.text = expression.identifier;
  identifierLabel.backgroundColor = [UIColor identifierColor];
  identifierLabel.textColor = [UIColor colorWithExpressionType:expression.type];
  [self addSubview:identifierLabel];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[identifierLabel]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(identifierLabel)]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[identifierLabel]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(identifierLabel)]];
}

@end

@implementation PXIdentifierExpression (PXExpressionView)

- (PXIdentifierExpressionView *)createView {
  return [PXIdentifierExpressionView viewWithExpression:self];
}

@end