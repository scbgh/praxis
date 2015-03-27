#import "PXCompoundExpressionView.h"
#import "UIColor+PXColor.h"
#import "PXHoleView.h"
#import "PXVisuals.h"
#import "PXCodeEditor.h"
#import "PXCodeLayoutFactory.h"
#import "PXKeywordElement.h"
#import "PXIndentElement.h"
#import "PXHoleElement.h"
#import "PXButtonElement.h"

@implementation PXCompoundExpressionView {
  CALayer *_borderLayer;
  NSArray *_holeViews;
}

- (instancetype)initWithExpression:(PXExpression *)expression {
  self = [super initWithExpression:expression];
  if (self) {
    _borderLayer = [CALayer layer];
    _borderLayer.backgroundColor = [UIColor blackColor].CGColor;
    [self.layer addSublayer:_borderLayer];
  }

  return self;
}

- (void)invalidateViews {
  [super invalidateViews];

  PXCompoundExpression *expression = (PXCompoundExpression *) self.expression;
  PXCodeLayoutFactory *factory = [PXCodeLayoutFactory factoryWithEditor:self.editor];

  [factory addLineWithElements:@[[PXKeywordElement elementWithKeyword:@"begin" key:@"Begin"]]];
  for (NSUInteger i = 0; i < expression.numberOfSubexpressions; i++) {
    PXHole *hole = [expression expressionHoleAtIndex:i];
    PXButtonElement *deleteButton = [PXButtonElement elementWithText:@"-" action:^{
      [expression deleteExpressionAtIndex:i];
      [self invalidateViews];
    }];
    deleteButton.color = [UIColor colorWithRed:.7f green:0.f blue:0.f alpha:1.f];
    [factory addLineWithElements:@[[PXIndentElement elementWithIndent:kEditorIndent], deleteButton,
        [PXHoleElement elementWithHole:hole key:[NSString stringWithFormat:@"Hole%d", i]]]];
  }
  PXButtonElement *addButton = [PXButtonElement elementWithText:@"+" action:^{
    expression.numberOfSubexpressions++;
    [self invalidateViews];
  }];
  addButton.color = [UIColor colorWithRed:.0f green:.5f blue:.0f alpha:1.f];
  [factory addLineWithElements:@[[PXIndentElement elementWithIndent:kEditorIndent], addButton]];
  [factory addLineWithElements:@[[PXKeywordElement elementWithKeyword:@"end" key:@"End"]]];
  [factory createLayoutInView:self];

  NSMutableArray *holeViews = [NSMutableArray array];
  for (UIView *view in [factory.views allValues]) {
    if ([view isKindOfClass:[PXHoleView class]]) {
      [holeViews addObject:view];
    }
  }
  _holeViews = holeViews;

  [self setNeedsLayout];
  [self layoutIfNeeded];
};

- (void)refresh {
  [_holeViews makeObjectsPerformSelector:@selector(refresh)];
}

- (void)layoutSubviews {
  [super layoutSubviews];
  _borderLayer.frame = CGRectMake(-8.f, 0.f, 1.f, self.frame.size.height);
}


@end

@implementation PXCompoundExpression (PXExpressionView)

- (PXCompoundExpressionView *)createView {
  PXCompoundExpressionView *view = [PXCompoundExpressionView viewWithExpression:self];
  return view;
}


@end