#import "PXExpression.h"
#import "PXExecutionContext.h"
#import "PXExecutionResult.h"
#import "PXFailureInfo.h"
#import "PXContinuation.h"
#import "PXHole.h"

static int ctr = 1000;

@implementation PXExpression {
  int _id;
}

- (PXExecutionResult *)executeInContext:(PXExecutionContext *)context
                                inState:(int)state {
  PXFailureInfo *info = [PXFailureInfo infoWithExpression:self type:PXExpressionTypeUnimplementedFailure];
  return [PXExecutionResult resultWithFailureInfo:info];
}

- (PXExecutionResult *)executeFullyInContext:(PXExecutionContext *)context {
  PXExecutionResult *result = [self executeInContext:context inState:0];
  if (result.isCompleted) {
    return result;
  } else {
    return [result.continuation waitForExecution];
  }
}

- (PXExpressionType)type {
  return PXVoidType;
}

- (int)id {
  if (_id == 0) {
    _id = ctr++;
  }
  return _id;
}

@end