#import "PXIdentifierExpression.h"
#import "PXExecutionResult.h"
#import "PXExecutionContext.h"
#import "PXExpression+PXExpressionHelpers.h"

@implementation PXIdentifierExpression {
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
  [context.dbg logWithFormat:@"PXIdentifierExpression [id=%d; var=%@; ctx=%d]", self.id, self.identifier, context.id];
  if (state != 0) {
    return [PXExecutionResult failWithReason:PXUnknownExpressionStateFailure expression:self];
  }
  if (self.identifier == nil) {
    return [PXExecutionResult failWithReason:PXUnspecifiedIdentifierFailure expression:self];
  }
  PXValue *value = [context lookupVariableNamed:self.identifier];
  if (value == nil) {
    return [PXExecutionResult failWithReason:PXUnboundIdentifierFailure expression:self];
  }
  if (!(value.type & _type)) {
    return [PXExecutionResult failWithReason:PXTypeMismatchFailure expression:self];
  }
  [context assignVariableNamed:self.returnValueIdentifier withValue:value];
  return [PXExecutionResult success];
}


@end