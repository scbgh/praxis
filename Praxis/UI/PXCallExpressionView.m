#import "PXCallExpressionView.h"
#import "PXHoleElement.h"
#import "PXCallExpression.h"
#import "PXCodeLayoutFactory.h"
#import "PXDefaultBuiltins+Decl.h"
#import "PXBuiltin.h"
#import "PXSymbolElement.h"
#import "PXHole.h"

@implementation PXCallExpressionView {
  NSArray *_holeViews;
}

- (void)invalidateViews {
  [super invalidateViews];

  PXCallExpression *expression = (PXCallExpression *) self.expression;
  PXCodeLayoutFactory *factory = [PXCodeLayoutFactory factoryWithEditor:self.editor];

  if (expression.builtin && expression.builtin.arity == 2) {
    // A bit hackish to display builtin function calls as operators
    NSString *op;
    if (expression.builtin == builtin_add) {
      op = @"+";
    } else if (expression.builtin == builtin_sub) {
      op = @"-";
    } else if (expression.builtin == builtin_mul) {
      op = @"*";
    } else if (expression.builtin == builtin_div) {
      op = @"/";
    } else if (expression.builtin == builtin_eq) {
      op = @"==";
    } else if (expression.builtin == builtin_lt) {
      op = @"<";
    } else if (expression.builtin == builtin_lte) {
      op = @"<=";
    } else if (expression.builtin == builtin_gt) {
      op = @">";
    } else if (expression.builtin == builtin_gte) {
      op = @">=";
    };

    [factory addLineWithElements:@[
        [PXHoleElement elementWithHole:[expression argumentHoleAtIndex:0] key:@"Arg1"],
        [PXSymbolElement elementWithSymbol:op],
        [PXHoleElement elementWithHole:[expression argumentHoleAtIndex:1] key:@"Arg2"]]];
    [factory createLayoutInView:self];

    _holeViews = [factory.views allValues];
  }
}

- (void)refresh {
  [_holeViews makeObjectsPerformSelector:@selector(refresh)];
}


@end

@implementation PXCallExpression (PXExpressionView)

- (PXCallExpressionView *)createView {
  PXCallExpressionView *view = [PXCallExpressionView viewWithExpression:self];
  return view;
}

@end