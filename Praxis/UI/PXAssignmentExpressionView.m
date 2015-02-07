#import "PXAssignmentExpressionView.h"
#import "PXHoleView.h"
#import "UIColor+PXColor.h"
#import "PXHole.h"
#import "PXVisuals.h"

@implementation PXAssignmentExpressionView

- (void)invalidateViews {
  [super invalidateViews];

  PXAssignmentExpression *expression = (PXAssignmentExpression *)self.expression;

  UILabel *identifierLabel = [UILabel new];
  UILabel *eqLabel = [UILabel new];
  PXHoleView *valueHole = [PXHoleView viewWithHole:expression.valueExpressionHole];

  identifierLabel.text = expression.identifier;
  identifierLabel.backgroundColor = [UIColor identifierColor];
  if (valueHole.hole.expression != nil) {
    identifierLabel.textColor = [UIColor colorWithExpressionType:valueHole.hole.expression.type];
  } else {
    identifierLabel.textColor = [UIColor blackColor];
  }
  eqLabel.text = @"=";

  identifierLabel.translatesAutoresizingMaskIntoConstraints = NO;
  eqLabel.translatesAutoresizingMaskIntoConstraints = NO;
  valueHole.translatesAutoresizingMaskIntoConstraints = NO;

  [self addSubview:identifierLabel];
  [self addSubview:eqLabel];
  [self addSubview:valueHole];

  NSString *horizontalConstraint = [NSString stringWithFormat:@"H:|[identifierLabel]-%d-[eqLabel]-%d-[valueHole]|", kEditorTokenSpacing, kEditorTokenSpacing];

  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[identifierLabel]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(identifierLabel)]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[eqLabel]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(eqLabel)]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[valueHole]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(valueHole)]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:horizontalConstraint options:0 metrics:nil views:NSDictionaryOfVariableBindings(identifierLabel, eqLabel, valueHole)]];
}

@end

@implementation PXAssignmentExpression (PXExpressionView)

- (PXAssignmentExpressionView *)createView {
  return [PXAssignmentExpressionView viewWithExpression:self];
}

@end