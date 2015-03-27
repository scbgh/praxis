#import "PXWhileExpressionView.h"
#import "UIColor+PXColor.h"
#import "PXHoleView.h"
#import "PXVisuals.h"
#import "PXCodeEditor.h"
#import "PXCodeLayoutFactory.h"
#import "PXIndentElement.h"
#import "PXHoleElement.h"
#import "PXKeywordElement.h"

@implementation PXWhileExpressionView {
  PXHoleView *_conditionHoleView;
  PXHoleView *_bodyHoleView;
}

- (void)invalidateViews {
  [super invalidateViews];

  PXWhileExpression *expression = (PXWhileExpression *) self.expression;
  PXCodeLayoutFactory *factory = [PXCodeLayoutFactory factoryWithEditor:self.editor];

  [factory addLineWithElements:@[[PXKeywordElement elementWithKeyword:@"while" key:@"While"], [PXHoleElement elementWithHole:expression.conditionExpressionHole key:@"Condition"]]];
  [factory addLineWithElements:@[[PXIndentElement elementWithIndent:kEditorIndent], [PXHoleElement elementWithHole:expression.bodyExpressionHole key:@"Body"]]];
  [factory createLayoutInView:self];

  _conditionHoleView = factory.views[@"Condition"];
  _bodyHoleView = factory.views[@"Body"];
};

- (void)refresh {
  [_conditionHoleView refresh];
  [_bodyHoleView refresh];
}


@end

@implementation PXWhileExpression (PXExpressionView)

- (PXWhileExpressionView *)createView {
  PXWhileExpressionView *view = [PXWhileExpressionView viewWithExpression:self];
  return view;
}

@end