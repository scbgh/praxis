#import "PXCallExpression.h"
#import "PXHole.h"
#import "PXExecutionResult.h"
#import "PXExecutionContext.h"
#import "PXExpression+PXExpressionHelpers.h"
#import "PXContinuation.h"
#import "PXFunction.h"
#import "PXArgument.h"
#import "PXBuiltin.h"

@implementation PXCallExpression {
  PXExpressionType _type;
  NSMutableArray *_holes;
  NSUInteger _numberOfArguments;
}

@synthesize numberOfArguments = _numberOfArguments;

- (instancetype)initWithType:(PXExpressionType)type {
  self = [super init];
  if (self) {
    _type = type;
    _holes = [NSMutableArray array];
    self.numberOfArguments = 0;
  }

  return self;
}

- (PXHole *)argumentHoleAtIndex:(NSUInteger)index {
  return _holes[index];
}

+ (instancetype)expressionWithType:(PXExpressionType)type {
  return [[self alloc] initWithType:type];
}

- (PXExecutionResult *)executeInContext:(PXExecutionContext *)context
                                inState:(int)state {
  // If we are invoking a function, fetch it from the context
  PXValue *functionValue;
  PXFunction *function;

  if (self.builtin == nil) {
    functionValue = [context lookupVariableNamed:self.identifier];
    if (functionValue == nil) {
      return [PXExecutionResult failWithReason:PXUnboundIdentifierFailure expression:self];
    }
    if (functionValue.type != PXFunctionType) {
      return [PXExecutionResult failWithReason:PXTypeMismatchFailure expression:self];
    }
    function = [functionValue functionValue];
  }

  // state 0 .. n - 1  = evaluate argument i of n
  // state n           = evaluate the function body
  // state n + 1       = copy function return value to outer return value
  if (state < self.numberOfArguments) {
    [context.dbg logWithFormat:@"PXCallExpression(eval.arg: %d) [id=%d; ctx=%d]", state, self.id, context.id];

    PXHole *hole = [self argumentHoleAtIndex:(NSUInteger) state];
    PXExpression *expression = hole.expression;
    PXContinuation *continuation = [PXContinuation continuationWithExpression:expression context:context state:0];
    return [PXExecutionResult resultWithContinuation:[self continueAfter:continuation inState:state + 1]];
  } else if (state == self.numberOfArguments) {
    // If we have all the return values from the arguments, then we can invoke the function.
    NSMutableArray *arguments = [NSMutableArray array];
    for (NSUInteger i = 0; i < self.numberOfArguments; i++) {
      PXHole *hole = [self argumentHoleAtIndex:i];
      PXValue *value = [context lookupVariableNamed:hole.expression.returnValueIdentifier];
      if (value == nil) {
        // Shouldn't happen
        return [PXExecutionResult failWithReason:PXInternalExecutionFailure
                                      expression:self];
      }
      [arguments addObject:value];
    }
    if (self.builtin == nil) {
      [context.dbg logWithFormat:@"PXCallExpression(invoke func) [id=%d; ctx=%d]", self.id, context.id];
      return [self invokeFunction:function arguments:arguments context:context returnState:state + 1];
    } else {
      [context.dbg logWithFormat:@"PXCallExpression(invoke builtin) [id=%d; ctx=%d]", self.id, context.id];

      // Executing a builtin so just execute it and copy the return value directly
      PXValue *value = [self.builtin callWithArguments:arguments];
      [context assignVariableNamed:self.returnValueIdentifier withValue:value];
      return [PXExecutionResult success];
    }
  } else if (state == self.numberOfArguments + 1 && self.builtin == nil) {
    [context.dbg logWithFormat:@"PXAssignmentExpression(copy return value) [id=%d; ctx=%d]", self.id, context.id];

    // Copy the return value of the function into the outer context
    PXValue *returnValue = [context lookupVariableNamed:function.bodyExpression.returnValueIdentifier];
    if (returnValue != nil) {
      // Check the return type matches the call's expected return type
      if (!(returnValue.type & self.type)) {
        return [PXExecutionResult failWithReason:PXTypeMismatchFailure expression:self];
      }

      PXExecutionContext *outerContext = context.parentContext;
      [outerContext assignVariableNamed:self.returnValueIdentifier withValue:returnValue];
    }
    return [PXExecutionResult success];
  }
  return [PXExecutionResult failWithReason:PXUnknownExpressionStateFailure expression:self];
}

- (PXExecutionResult *)invokeFunction:(PXFunction *)function arguments:(NSMutableArray *)arguments context:(PXExecutionContext *)context returnState:(int)returnState {
  // Open a new top level context for this function call
  PXExecutionContext *newContext = [context.globalContext createChildContext];

  // Put all the arguments into the context
  for (NSUInteger i = 0; i < self.numberOfArguments; i++) {
    PXArgument *argument = function.arguments[i];
    PXValue *value = arguments[i];

    // Check the argument type matches the value type
    if (!(value.type & argument.type)) {
      return [PXExecutionResult failWithReason:PXTypeMismatchFailure expression:self];
    }
    [newContext assignVariableNamed:argument.name withValue:value];
  }

  PXContinuation *continuation = [PXContinuation continuationWithExpression:function.bodyExpression context:newContext state:0];
  return [PXExecutionResult resultWithContinuation:[self continueAfter:continuation inState:returnState]];
}

- (void)setNumberOfArguments:(NSUInteger)numberOfArguments {
  if (numberOfArguments < _numberOfArguments) {
    NSMutableArray *newHoles = [NSMutableArray array];
    [newHoles addObjectsFromArray:[_holes subarrayWithRange:NSMakeRange(0, numberOfArguments)]];
    _holes = newHoles;
  } else {
    for (int i = _holes.count; i < numberOfArguments; i++) {
      [_holes addObject:[PXHole holeWithExpressionType:PXAnyType]];
    }
  }
  _numberOfArguments = numberOfArguments;
}

- (PXExpressionType)type {
  return _type;
}


@end