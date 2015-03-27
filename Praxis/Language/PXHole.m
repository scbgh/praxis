#import "PXHole.h"
#import "PXExpression.h"
#import "PXHoleView.h"

@implementation PXHole

- (instancetype)initWithExpressionType:(PXExpressionType)expressionType parentExpression:(PXExpression *)parentExpression {
  self = [super init];
  if (self) {
    self.expressionType = expressionType;
    self.parent = parentExpression;
  }

  return self;
}

+ (instancetype)holeWithExpressionType:(PXExpressionType)expressionType parentExpression:(PXExpression *)parentExpression {
  return [[PXHole alloc] initWithExpressionType:expressionType parentExpression:parentExpression];
}

- (void)setExpression:(PXExpression *)expression {
  _expression = expression;
  expression.hole = self;
}

@end