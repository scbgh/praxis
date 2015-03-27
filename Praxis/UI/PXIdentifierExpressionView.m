#import "PXIdentifierExpressionView.h"
#import "UIColor+PXColor.h"
#import "PXCodeEditor.h"
#import "PXLabel.h"

@implementation PXIdentifierExpressionView {
  PXLabel *_identifierLabel;
}

- (void)invalidateViews {
  [super invalidateViews];

  PXIdentifierExpression *expression = (PXIdentifierExpression *)self.expression;

  _identifierLabel = [PXLabel new];
  _identifierLabel.translatesAutoresizingMaskIntoConstraints = NO;
  _identifierLabel.text = expression.identifier;
  _identifierLabel.textColor = [UIColor colorWithExpressionType:expression.type];
  _identifierLabel.userInteractionEnabled = YES;
  _identifierLabel.associatedView = self;
  [self addSubview:_identifierLabel];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_identifierLabel]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_identifierLabel)]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_identifierLabel]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_identifierLabel)]];
}

@end

@implementation PXIdentifierExpression (PXExpressionView)

- (PXIdentifierExpressionView *)createView {
  PXIdentifierExpressionView *view = [PXIdentifierExpressionView viewWithExpression:self];
  return view;
}

@end