#import "PXAssignmentExpression.h"
#import "PXHole.h"
#import "PXExecutionResult.h"
#import "PXExecutionContext.h"
#import "PXFailureInfo.h"
#import "PXContinuation.h"
#import "PXExpression+PXExpressionHelpers.h"

enum {
  PXAssignmentEvaluateState = 0,
  PXAssignmentAssignState
};

@implementation PXAssignmentExpression {
  PXHole *_valueExpressionHole;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _valueExpressionHole = [PXHole holeWithExpressionType:PXValueType parentExpression:self];
  }
  return self;
}

- (PXExecutionResult *)executeInContext:(PXExecutionContext *)context inState:(int)state {
  // state 0 = evaluate rhs
  // state 1 = assign rhs value to return value
  switch (state) {
    case PXAssignmentEvaluateState: {
      [context.dbg logWithFormat:@"PXAssignmentExpression(PXAssignmentEvaluateState) [id=%d; ctx=%d]", self.id, context.id];

      PXContinuation *evalContinuation = [PXContinuation continuationWithExpression:self.valueExpressionHole.expression context:context state:0];
      return [PXExecutionResult resultWithContinuation:[self continueAfter:evalContinuation inState:PXAssignmentAssignState]];
    }
    case PXAssignmentAssignState: {
      [context.dbg logWithFormat:@"PXAssignmentExpression(PXAssignmentAssignState) [id=%d; ctx=%d]", self.id, context.id];

      PXValue *value = [context lookupVariableNamed:self.valueExpressionHole.expression.returnValueIdentifier];
      if (self.identifier == nil) {
        return [PXExecutionResult failWithReason:PXUnspecifiedIdentifierFailure expression:self];
      }
      [context assignVariableNamed:self.identifier withValue:value];
      return [PXExecutionResult success];
    }
  }

  // Unknown state
  return [PXExecutionResult failWithReason:PXUnknownExpressionStateFailure expression:self];
}

- (PXHole *)valueExpressionHole {
  return _valueExpressionHole;
}

- (PXExpressionType)type {
  return PXVoidType;
}


@end