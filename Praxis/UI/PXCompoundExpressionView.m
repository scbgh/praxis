#import "PXCompoundExpressionView.h"
#import "UIColor+PXColor.h"
#import "PXHoleView.h"
#import "PXVisuals.h"

@implementation PXCompoundExpressionView

- (void)invalidateViews {
  [super invalidateViews];

  PXCompoundExpression *expression = (PXCompoundExpression *) self.expression;

  UILabel *beginLabel = [UILabel new];
  UILabel *endLabel = [UILabel new];
  UIView *compoundContainer = [UIView new];

  beginLabel.text = @"begin";
  beginLabel.textColor = [UIColor keywordColor];
  endLabel.text = @"end";
  endLabel.textColor = [UIColor keywordColor];

  beginLabel.translatesAutoresizingMaskIntoConstraints = NO;
  endLabel.translatesAutoresizingMaskIntoConstraints = NO;
  compoundContainer.translatesAutoresizingMaskIntoConstraints = NO;

  [self addSubview:beginLabel];
  [self addSubview:endLabel];
  [self addSubview:compoundContainer];

  // This mess sets up the constraints for the compound view. It makes the container of the subexpressions the minimum
  // possible width to fit all subexpressions.

  NSMutableArray *componentArray = [NSMutableArray array];
  NSMutableDictionary *componentMap = [NSMutableDictionary dictionary];
  for (int i = 0; i < expression.numberOfSubexpressions; i++) {
    PXHoleView *holeView = [PXHoleView viewWithHole:[expression expressionHoleAtIndex:i]];
    holeView.translatesAutoresizingMaskIntoConstraints = NO;
    [compoundContainer addSubview:holeView];
    NSString *id = [NSString stringWithFormat:@"v%d", i];
    [compoundContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-space-[view]"
                                                                              options:0
                                                                              metrics:@{@"space" : @(kEditorIndent)}
                                                                                views:@{@"view" : holeView}]];
    componentMap[id] = holeView;
    [componentArray addObject:id];
  };
  NSMutableArray *constraintParts = [NSMutableArray array];
  for (NSString *id in componentArray) {
    [constraintParts addObject:[NSString stringWithFormat:@"[%@]", id]];
  }
  NSString *verticalCompoundConstraint = [NSString stringWithFormat:@"V:|%@|", [constraintParts componentsJoinedByString:@"-space-"]];
  constraintParts = [NSMutableArray arrayWithArray:@[@"==0@low"]];
  for (NSString *id in componentArray) {
    [constraintParts addObject:[NSString stringWithFormat:@">=%@", id]];
  }
  NSString *horizontalCompoundConstraint = [NSString stringWithFormat:@"H:[self(%@)]", [constraintParts componentsJoinedByString:@","]];
  componentMap[@"self"] = self;

  [self addConstraints:
      [NSLayoutConstraint constraintsWithVisualFormat:horizontalCompoundConstraint
                                              options:0
                                              metrics:@{@"low" : @(UILayoutPriorityDefaultLow)}
                                                views:componentMap]];
  [compoundContainer addConstraints:
      [NSLayoutConstraint constraintsWithVisualFormat:verticalCompoundConstraint
                                              options:0
                                              metrics:@{@"space" : @(kEditorLineSpacing)}
                                                views:componentMap]];
  [self addConstraints:
      [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[beginLabel]"
                                              options:0
                                              metrics:nil
                                                views:NSDictionaryOfVariableBindings(beginLabel)]];
  [self addConstraints:
      [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[endLabel]"
                                              options:0
                                              metrics:nil
                                                views:NSDictionaryOfVariableBindings(endLabel)]];
  [self addConstraints:
      [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[compoundContainer]"
                                              options:0
                                              metrics:@{@"space" : @(kEditorIndent)}
                                                views:NSDictionaryOfVariableBindings(compoundContainer)]];
  [self addConstraints:
      [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[beginLabel]-space-[compoundContainer]-space-[endLabel]|"
                                              options:0
                                              metrics:@{@"space" : @(kEditorLineSpacing)}
                                                views:NSDictionaryOfVariableBindings(beginLabel, compoundContainer, endLabel)]];
};

@end

@implementation PXCompoundExpression (PXExpressionView)

- (PXCompoundExpressionView *)createView {
  return [PXCompoundExpressionView viewWithExpression:self];
}


@end