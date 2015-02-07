#import "PXExpressionView.h"
#import "PXExpression.h"

@implementation PXExpressionView {
  PXExpression *_expression;
}

@synthesize expression = _expression;

- (instancetype)initWithExpression:(PXExpression *)expression {
  self = [super init];
  if (self) {
    _expression = expression;
  }

  return self;
}

+ (instancetype)viewWithExpression:(PXExpression *)expression {
  return [[self alloc] initWithExpression:expression];
}

- (void)invalidateViews {
  [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

- (void)didMoveToSuperview {
  [self invalidateViews];
}


@end