#import "PXPrintExpression.h"
#import "PXExecutionResult.h"
#import "PXExecutionContext.h"
#import "PXHole.h"
#import "PXExpression+PXExpressionHelpers.h"
#import "PXContinuation.h"

enum {
  PXPrintEvalValueState = 0,
  PXPrintCommitState = 1
};

@implementation PXPrintExpression {
  PXHole *_valueHole;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _valueHole = [PXHole holeWithExpressionType:PXValueType parentExpression:self];
  }

  return self;
}

- (PXExecutionResult *)executeInContext:(PXExecutionContext *)context inState:(int)state {
  switch (state) {
    case PXPrintEvalValueState: {
      [context.dbg logWithFormat:@"PXPrintExpression(PXPrintEvalValueState) [id=%d; ctx=%d]", self.id, context.id];

      // Evaluate the value
      PXContinuation *valueContinuation = [PXContinuation continuationWithExpression:self.valueHole.expression context:context state:0];
      return [PXExecutionResult resultWithContinuation:[self continueAfter:valueContinuation inState:PXPrintCommitState]];
    }
    case PXPrintCommitState: {
      PXValue *value = [context lookupVariableNamed:self.valueHole.expression.returnValueIdentifier];
      if (value == nil) {
        return [PXExecutionResult failWithReason:PXInternalExecutionFailure expression:self];
      }
      NSString *toOutput = [value stringValue];

      if (self.newline) {
        [context.globalContext println:toOutput];
      } else {
        [context.globalContext print:toOutput];
      }

      return [PXExecutionResult success];
    }
  };
  return [PXExecutionResult failWithReason:PXUnknownExpressionStateFailure expression:self];
}

- (PXExpressionType)type {
  return PXVoidType;
}

- (PXHole *)valueHole {
  return _valueHole;
}


@end