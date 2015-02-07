#import "PXConstantExpression.h"
#import "PXValue.h"
#import "PXExecutionResult.h"
#import "PXExecutionContext.h"
#import "PXExpression+PXExpressionHelpers.h"
#import "PXConstantExpressionView.h"

@implementation PXConstantExpression {
  PXExpressionType _type;
}

- (instancetype)initWithType:(PXExpressionType)type {
  self = [super init];
  if (self) {
    _type = type;
  }

  return self;
}

+ (instancetype)expressionWithType:(PXExpressionType)type {
  return [[self alloc] initWithType:type];
}

- (PXExpressionType)type {
  return _type;
}

- (PXExecutionResult *)executeInContext:(PXExecutionContext *)context inState:(int)state {
  [context.dbg logWithFormat:@"PXConstantExpression [id=%d; ctx=%d]", self.id, context.id];
  if (state != 0) {
    return [PXExecutionResult failWithReason:PXUnknownExpressionStateFailure expression:self];
  }

  if (self.value == nil) {
    return [PXExecutionResult failWithReason:PXUnspecifiedValueFailure expression:self];
  } else if (!(self.value.type & _type)) {
    return [PXExecutionResult failWithReason:PXTypeMismatchFailure expression:self];
  }
  [context assignVariableNamed:[self returnValueIdentifier] withValue:self.value];
  return [PXExecutionResult success];
}

@end
