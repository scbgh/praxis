#import "PXCompoundExpression.h"
#import "PXHole.h"
#import "PXExecutionResult.h"
#import "PXExecutionContext.h"
#import "PXContinuation.h"
#import "PXExpression+PXExpressionHelpers.h"

@implementation PXCompoundExpression {
  NSMutableArray *_holes;
  NSUInteger _numberOfSubexpressions;
  PXExpressionType _type;
}

@synthesize numberOfSubexpressions = _numberOfSubexpressions;

- (instancetype)init {
  self = [super init];
  if (self) {
    self.numberOfSubexpressions = 1;
  }
  return [self commonInit];
}

- (instancetype)initWithType:(PXExpressionType)type {
  self = [super init];
  if (self) {
    _type = type;
  }

  return [self commonInit];
}

- (PXCompoundExpression *)commonInit {
  _holes = [NSMutableArray array];
  return self;
}

+ (instancetype)expressionWithType:(PXExpressionType)type {
  return [[self alloc] initWithType:type];
}

- (PXExpressionType)type {
  return _type;
}

- (PXExecutionResult *)executeInContext:(PXExecutionContext *)context inState:(int)state {
  PXExecutionContext *nextContext = context;

  // state 0           = open a new context and execute the first subexpression
  // state 1 .. n - 1  = execute subexpression i of n
  // state n           = copy the return value to the parent context
  if (state < self.numberOfSubexpressions) {
    [context.dbg logWithFormat:@"PXCompoundExpression(subexpr %d) [id=%d; ctx=%d]", state + 1, self.id, context.id];

    PXHole *hole = _holes[state];
    PXExpression *expression = hole.expression;

    if (state == 0) {
      nextContext = [context createChildContext];
    }
    PXContinuation *continuation = [PXContinuation continuationWithExpression:expression context:nextContext state:0];
    return [PXExecutionResult resultWithContinuation:[self continueAfter:continuation inState:state + 1]];
  } else if (state == self.numberOfSubexpressions) {
    [context.dbg logWithFormat:@"PXCompoundExpression(copy return value) [id=%d; ctx=%d]", self.id, context.id];
    PXValue *value = [context lookupVariableNamed:((PXHole *) _holes.lastObject).expression.returnValueIdentifier];
    if (value != nil) {
      PXExecutionContext *parentContext = context.parentContext;
      [parentContext assignVariableNamed:self.returnValueIdentifier withValue:value];
    }
    return [PXExecutionResult success];
  }
  return [PXExecutionResult failWithReason:PXUnknownExpressionStateFailure expression:self];
}

- (void)setNumberOfSubexpressions:(NSUInteger)numberOfSubexpressions {
  if (numberOfSubexpressions < _numberOfSubexpressions) {
    NSMutableArray *newHoles = [NSMutableArray array];
    [newHoles addObjectsFromArray:[_holes subarrayWithRange:NSMakeRange(0, numberOfSubexpressions)]];
    _holes = newHoles;
  } else {
    for (int i = _holes.count; i < numberOfSubexpressions; i++) {
      [_holes addObject:[PXHole holeWithExpressionType:PXAnyType]];
    }
  }
  _numberOfSubexpressions = numberOfSubexpressions;
}

- (PXHole *)expressionHoleAtIndex:(NSUInteger)index {
  return _holes[index];
}

@end