#import "PXWhileExpression.h"
#import "PXHole.h"
#import "PXExecutionResult.h"
#import "PXExecutionContext.h"
#import "PXContinuation.h"
#import "PXExpression+PXExpressionHelpers.h"

enum {
  PXWhileConditionState = 0,
  PXWhileBodyState
};


@implementation PXWhileExpression {
  PXHole *_conditionExpressionHole;
  PXHole *_bodyExpressionHole;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _conditionExpressionHole = [PXHole holeWithExpressionType:PXBooleanType];
    _bodyExpressionHole = [PXHole holeWithExpressionType:PXAnyType];
  }
  return self;
}

- (PXExpressionType)type {
  return PXVoidType;
}

- (PXExecutionResult *)executeInContext:(PXExecutionContext *)context inState:(int)state {
  // state 0           = evaluate the condition
  // state 1           = evaluate the body if necessary
  if (state == PXWhileConditionState) {
    [context.dbg logWithFormat:@"PXWhileExpression(PXWhileConditionState) [id=%d; ctx=%d]", self.id, context.id];
    PXContinuation *continuation = [PXContinuation continuationWithExpression:_conditionExpressionHole.expression context:context state:0];
    return [PXExecutionResult resultWithContinuation:[self continueAfter:continuation inState:PXWhileBodyState]];
  } else if (state == PXWhileBodyState) {
    [context.dbg logWithFormat:@"PXWhileExpression(PXWhileBodyState) [id=%d; ctx=%d]", self.id, context.id];
    PXValue *value = [context lookupVariableNamed:_conditionExpressionHole.expression.returnValueIdentifier];
    if (value == nil) {
      return [PXExecutionResult failWithReason:PXInternalExecutionFailure expression:self];
    }
    if (value.type != PXBooleanType) {
      return [PXExecutionResult failWithReason:PXTypeMismatchFailure expression:self];
    }

    // If the condition is true, evaluate the body, otherwise just leave the loop
    if ([value boolValue]) {
      if (_bodyExpressionHole.expression == nil) {
        return [PXExecutionResult failWithReason:PXInternalExecutionFailure expression:self];
      }
      PXContinuation *continuation = [PXContinuation continuationWithExpression:_bodyExpressionHole.expression context:context state:0];
      return [PXExecutionResult resultWithContinuation:[self continueAfter:continuation withContext:context inState:PXWhileConditionState]];
    }

    return [PXExecutionResult success];
  }

  return [PXExecutionResult failWithReason:PXUnknownExpressionStateFailure expression:self];
}

- (PXHole *)bodyExpressionHole {
  return _bodyExpressionHole;
}

- (PXHole *)conditionExpressionHole {
  return _conditionExpressionHole;
}

@end