#import "PXConditionalExpression.h"
#import "PXHole.h"
#import "PXExecutionResult.h"
#import "PXExecutionContext.h"
#import "PXContinuation.h"
#import "PXExpression+PXExpressionHelpers.h"
#import "PXAssignmentExpression.h"
#import "PXConstantExpression.h"
#import "PXIdentifierExpression.h"

enum {
  PXConditionalEvaluateState = 0,
  PXConditionalExecuteState,
  PXConditionalReturnTrueState,
  PXConditionalReturnFalseState
};

@implementation PXConditionalExpression {
  PXHole *_conditionExpressionHole;
  PXHole *_trueExpressionHole;
  PXHole *_falseExpressionHole;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _conditionExpressionHole = [PXHole holeWithExpressionType:PXBooleanType parentExpression:self];
    _trueExpressionHole = [PXHole holeWithExpressionType:PXVoidType parentExpression:self];
    _falseExpressionHole = [PXHole holeWithExpressionType:PXVoidType parentExpression:self];
  }
  return self;
}

- (PXHole *)conditionExpressionHole {
  return _conditionExpressionHole;
}

- (PXHole *)trueExpressionHole {
  return _trueExpressionHole;
}

- (PXHole *)falseExpressionHole {
  return _falseExpressionHole;
}

- (PXExecutionResult *)executeInContext:(PXExecutionContext *)context inState:(int)state {
  switch (state) {
    case PXConditionalEvaluateState: {
      [context.dbg logWithFormat:@"PXConditionalExpression(PXConditionalEvaluateState) [id=%d; ctx=%d]", self.id, context.id];

      // Evaluate the condition
      PXContinuation *conditionContinuation = [PXContinuation continuationWithExpression:self.conditionExpressionHole.expression context:context state:0];
      return [PXExecutionResult resultWithContinuation:[self continueAfter:conditionContinuation inState:PXConditionalExecuteState]];
    }
    case PXConditionalExecuteState: {
      [context.dbg logWithFormat:@"PXConditionalExpression(PXConditionalExecuteState) [id=%d; ctx=%d]", self.id, context.id];

      // Check the condition
      PXValue *result = [context lookupVariableNamed:self.conditionExpressionHole.expression.returnValueIdentifier];
      if (result == nil) {
        return [PXExecutionResult failWithReason:PXInternalExecutionFailure expression:self];
      }
      if (result.type != PXBooleanType) {
        return [PXExecutionResult failWithReason:PXTypeMismatchFailure expression:self];
      }
      PXExpression *next = nil;
      next = result.boolValue
          ? self.trueExpressionHole.expression
          : self.falseExpressionHole.expression;
      if (next == nil) {
        [context assignVariableNamed:self.returnValueIdentifier withValue:[PXValue unitValue]];
        return [PXExecutionResult success];
      } else {
        PXContinuation *continuation = [PXContinuation continuationWithExpression:next context:context state:0];
        int nextState = result.boolValue ? PXConditionalReturnTrueState : PXConditionalReturnFalseState;
        return [PXExecutionResult resultWithContinuation:[self continueAfter:continuation inState:nextState]];
      }
    }
    case PXConditionalReturnTrueState:
    case PXConditionalReturnFalseState: {
      [context.dbg logWithFormat:@"PXConditionalExpression(PXConditionalReturnState) [%d] [id=%d; ctx=%d]", state == PXConditionalReturnTrueState, self.id, context.id];
      PXExpression *expression = state == PXConditionalReturnTrueState ? self.trueExpressionHole.expression : self.falseExpressionHole.expression;
      PXValue *returnValue = [context lookupVariableNamed:expression.returnValueIdentifier];
      if (returnValue != nil) {
        [context assignVariableNamed:self.returnValueIdentifier withValue:returnValue];
      }
      return [PXExecutionResult success];
    }
  };
  return [PXExecutionResult failWithReason:PXUnknownExpressionStateFailure expression:self];
}

- (PXExpressionType)type {
  return PXVoidType;
}


@end