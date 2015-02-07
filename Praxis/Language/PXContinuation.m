#import "PXContinuation.h"
#import "PXExpression.h"
#import "PXExecutionContext.h"
#import "PXExecutionResult.h"

@implementation PXContinuation

- (PXExecutionResult *)continueExecution {
  self.context.currentContinuation = self;

  PXExecutionResult *result = [self.expression executeInContext:self.context inState:self.state];
  if (result.isFailure) {
    // If the execution failed, simply return the failure as-is.
    return result;
  } else if (result.isCompleted) {
    // Execution is complete (successful), so if we are at the top of the call stack we are done. Otherwise we
    // continue execution up the call stack.
    if (self.parentContinuation == nil) {
      return [PXExecutionResult success];
    } else {
      // Continue up the call stack.
      return [PXExecutionResult resultWithContinuation:self.parentContinuation];
    }
  } else {
    // Execution is incomplete, so we call the continuation for the expression but with the call stack of this
    // continuation
    PXContinuation *newContinuation = [result.continuation continuationWithParentContinuation:self.parentContinuation];
    return [PXExecutionResult resultWithContinuation:newContinuation];
  }
}

- (PXExecutionResult *)waitForExecution {
  PXExecutionResult *result;
  PXContinuation *continuation = self;
  do {
    result = [continuation continueExecution];
    continuation = result.continuation;
  } while (result && !result.isCompleted);
  return result;
}

- (PXContinuation *)continuationWithParentContinuation:(PXContinuation *)outerContinuation {
  PXContinuation *newContinuation = [self copy];
  if (newContinuation.parentContinuation == nil) {
    newContinuation.parentContinuation = outerContinuation;
  } else {
    newContinuation.parentContinuation = [newContinuation.parentContinuation continuationWithParentContinuation:outerContinuation];
  }
  return newContinuation;
}

- (int)callDepth {
  if (self.parentContinuation != nil) {
    return 1 + self.parentContinuation.callDepth;
  }
  return 0;
}

- (instancetype)initWithExpression:(PXExpression *)expression context:(PXExecutionContext *)context state:(int)state {
  self = [super init];
  if (self) {
    _expression = expression;
    _context = context;
    _state = state;
  }

  return self;
}

+ (instancetype)continuationWithExpression:(PXExpression *)expression context:(PXExecutionContext *)context state:(int)state {
  return [[self alloc] initWithExpression:expression context:context state:state];
}

- (id)copyWithZone:(NSZone *)zone {
  PXContinuation *copy = (PXContinuation *) [[[self class] allocWithZone:zone] init];

  if (copy != nil) {
    copy.parentContinuation = [self.parentContinuation copy];
    copy.expression = self.expression;
    copy.context = self.context;
    copy.state = self.state;
  }

  return copy;
}

+ (PXContinuation *)continuationWithExpression:(PXExpression *)expression inContext:(PXExecutionContext *)context continuationState:(int)state {
  PXContinuation *continuation = [PXContinuation new];
  continuation.expression = expression;
  continuation.context = context;
  continuation.state = state;
  return continuation;
}


@end