#import "PXHole.h"
#import "PXExpression.h"

@implementation PXHole

- (instancetype)initWithExpressionType:(PXExpressionType)expressionType {
  self = [super init];
  if (self) {
    self.expressionType = expressionType;
  }

  return self;
}

+ (instancetype)holeWithExpressionType:(PXExpressionType)expressionType {
  return [[PXHole alloc] initWithExpressionType:expressionType];
}

@end