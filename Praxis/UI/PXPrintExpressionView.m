#import "PXPrintExpressionView.h"
#import "PXHoleView.h"
#import "PXPrintExpression.h"
#import "PXCodeLayoutFactory.h"
#import "PXKeywordElement.h"
#import "PXHoleElement.h"

@implementation PXPrintExpressionView {
  PXHoleView *_valueHole;
}

- (void)refresh {
  [_valueHole refresh];
}

- (void)invalidateViews {
  [super invalidateViews];

  PXPrintExpression *expression = (PXPrintExpression *) self.expression;
  PXCodeLayoutFactory *factory = [PXCodeLayoutFactory factoryWithEditor:self.editor];
  NSString *keyword = expression.newline ? @"println" : @"print";

  [factory addLineWithElements:@[
      [PXKeywordElement elementWithKeyword:keyword key:@"Print"],
      [PXHoleElement elementWithHole:[expression valueHole] key:@"Value"]]];
  [factory createLayoutInView:self];

  _valueHole = factory.views[@"Value"];
}

@end

@implementation PXPrintExpression (PXExpressionView)

- (PXPrintExpressionView *)createView {
  PXPrintExpressionView *view = [PXPrintExpressionView viewWithExpression:self];
  return view;
}

@end