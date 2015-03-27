#import "PXAssignmentExpressionView.h"
#import "PXHoleView.h"
#import "UIColor+PXColor.h"
#import "PXHole.h"
#import "PXVisuals.h"
#import "PXCodeEditor.h"
#import "PXCodeLayoutFactory.h"
#import "PXIdentifierElement.h"
#import "PXSymbolElement.h"
#import "PXHoleElement.h"
#import "PXLabel.h"

@implementation PXAssignmentExpressionView {
  PXLabel *_identifierLabel;
  PXHoleView *_valueHoleView;
}

- (void)invalidateViews {
  [super invalidateViews];

  PXAssignmentExpression *expression = (PXAssignmentExpression *) self.expression;
  PXCodeLayoutFactory *factory = [PXCodeLayoutFactory factoryWithEditor:self.editor];

  [factory addLineWithElements:@[
      [PXIdentifierElement elementWithIdentifier:expression.identifier type:expression.valueExpressionHole.expression.type key:@"Identifier"],
      [PXSymbolElement elementWithSymbol:@":="],
      [PXHoleElement elementWithHole:expression.valueExpressionHole key:@"Value"]
  ]];
  [factory createLayoutInView:self];

  _identifierLabel = factory.views[@"Identifier"];
  _valueHoleView = factory.views[@"Value"];
  [self setNeedsLayout];
  [self layoutIfNeeded];
}

- (void)refresh {
  PXAssignmentExpression *expression = (PXAssignmentExpression *) self.expression;
  _identifierLabel.textColor = [UIColor colorWithExpressionType:expression.valueExpressionHole.expression.type];
  _valueHoleView.refresh;
}


@end

@implementation PXAssignmentExpression (PXExpressionView)

- (PXAssignmentExpressionView *)createView {
  PXAssignmentExpressionView *view = [PXAssignmentExpressionView viewWithExpression:self];
  return view;
}

@end