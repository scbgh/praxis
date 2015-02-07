#import "PXWhileExpressionView.h"
#import "UIColor+PXColor.h"
#import "PXHoleView.h"
#import "PXVisuals.h"

@implementation PXWhileExpressionView

- (void)invalidateViews {
  [super invalidateViews];

  PXWhileExpression *expression = (PXWhileExpression *) self.expression;
  PXHoleView *conditionHole = [PXHoleView viewWithHole:expression.conditionExpressionHole];
  PXHoleView *bodyHole = [PXHoleView viewWithHole:expression.bodyExpressionHole];

  UIView *conditionContainer = [UIView new];
  UIView *bodyContainer = [UIView new];

  UILabel *whileLabel = [UILabel new];
  whileLabel.translatesAutoresizingMaskIntoConstraints = NO;
  whileLabel.text = @"while";
  whileLabel.textColor = [UIColor keywordColor];
  conditionHole.translatesAutoresizingMaskIntoConstraints = NO;
  bodyHole.translatesAutoresizingMaskIntoConstraints = NO;
  conditionContainer.translatesAutoresizingMaskIntoConstraints = NO;
  bodyContainer.translatesAutoresizingMaskIntoConstraints = NO;

  [conditionContainer addSubview:whileLabel];
  [conditionContainer addSubview:conditionHole];
  [bodyContainer addSubview:bodyHole];

  [self addSubview:conditionContainer];
  [self addSubview:bodyContainer];

  [conditionContainer addConstraints:
      [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[whileLabel]-space-[conditionHole]|"
                                              options:0
                                              metrics:@{@"space" : @(kEditorTokenSpacing)}
                                                views:NSDictionaryOfVariableBindings(whileLabel, conditionHole)]];
  [conditionContainer addConstraints:
      [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[whileLabel]|"
                                              options:0
                                              metrics:nil
                                                views:NSDictionaryOfVariableBindings(whileLabel)]];
  [conditionContainer addConstraints:
      [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[conditionHole]|"
                                              options:0
                                              metrics:nil
                                                views:NSDictionaryOfVariableBindings(conditionHole)]];
  [bodyContainer addConstraints:
      [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-indent-[bodyHole]|"
                                              options:0
                                              metrics:@{@"indent" : @(kEditorIndent)}
                                                views:NSDictionaryOfVariableBindings(bodyHole)]];
  [bodyContainer addConstraints:
      [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[bodyHole]|"
                                              options:0
                                              metrics:nil
                                                views:NSDictionaryOfVariableBindings(bodyHole)]];
  [self addConstraints:
      [NSLayoutConstraint constraintsWithVisualFormat:@"H:[self(>=conditionContainer,>=bodyContainer,==0@low)]"
                                              options:0
                                              metrics:@{@"low" : @(UILayoutPriorityDefaultLow)}
                                                views:NSDictionaryOfVariableBindings(conditionContainer, bodyContainer, self)]];
  [self addConstraints:
      [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[conditionContainer]"
                                              options:0
                                              metrics:nil
                                                views:NSDictionaryOfVariableBindings(conditionContainer)]];
  [self addConstraints:
      [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[bodyContainer]"
                                              options:0
                                              metrics:nil
                                                views:NSDictionaryOfVariableBindings(bodyContainer)]];
  [self addConstraints:
      [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[conditionContainer]-space-[bodyContainer]|"
                                              options:0
                                              metrics:@{@"space" : @(kEditorLineSpacing)}
                                                views:NSDictionaryOfVariableBindings(conditionContainer, bodyContainer)]];
};

@end

@implementation PXWhileExpression (PXExpressionView)

- (PXWhileExpressionView *)createView {
  return [PXWhileExpressionView viewWithExpression:self];
}

@end