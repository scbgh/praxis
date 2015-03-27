#import "PXConditionalExpressionView.h"
#import "PXHoleView.h"
#import "UIColor+PXColor.h"
#import "PXVisuals.h"
#import "PXCodeLayoutFactory.h"
#import "PXKeywordElement.h"
#import "PXIndentElement.h"
#import "PXHoleElement.h"

@implementation PXConditionalExpressionView {
  UILabel *_ifLabel;
  UILabel *_elseLabel;
  PXHoleView *_conditionHoleView;
  PXHoleView *_trueHoleView;
  PXHoleView *_falseHoleView;
}

- (void)invalidateViews {
  [super invalidateViews];

  PXConditionalExpression *expression = (PXConditionalExpression *) self.expression;
  PXCodeLayoutFactory *factory = [PXCodeLayoutFactory factoryWithEditor:self.editor];

  [factory addLineWithElements:@[[PXKeywordElement elementWithKeyword:@"if" key:@"If"],
      [PXHoleElement elementWithHole:expression.conditionExpressionHole key:@"Condition"]]];
  [factory addLineWithElements:@[[PXIndentElement elementWithIndent:kEditorIndent],
      [PXHoleElement elementWithHole:expression.trueExpressionHole key:@"TrueBody"]]];
  [factory addLineWithElements:@[[PXKeywordElement elementWithKeyword:@"else" key:@"Else"]]];
  [factory addLineWithElements:@[[PXIndentElement elementWithIndent:kEditorIndent],
      [PXHoleElement elementWithHole:expression.falseExpressionHole key:@"FalseBody"]]];
  [factory createLayoutInView:self];

  _ifLabel = factory.views[@"If"];
  _elseLabel = factory.views[@"Else"];
  _conditionHoleView = factory.views[@"Condition"];
  _trueHoleView = factory.views[@"TrueBody"];
  _falseHoleView = factory.views[@"FalseBody"];
}

- (void)refresh {
  [_conditionHoleView refresh];
  [_trueHoleView refresh];
  [_falseHoleView refresh];
}

@end

@implementation PXConditionalExpression (PXExpressionView)

- (PXConditionalExpressionView *)createView {
  PXConditionalExpressionView *view = [PXConditionalExpressionView viewWithExpression:self];
  return view;
}

@end