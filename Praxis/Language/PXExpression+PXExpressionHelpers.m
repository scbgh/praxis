#import "PKAssembly.h"
#import "PXParser.h"
#import "PXExpression.h"
#import "PXExpression+PXExpressionHelpers.h"
#import "PXContinuation.h"
#import "PXExecutionContext.h"
#import "PXConstantExpression.h"
#import "PXValue.h"
#import "PXAssignmentExpression.h"
#import "PXConditionalExpression.h"
#import "PXIdentifierExpression.h"
#import "PXHole.h"
#import "PXBuiltin.h"
#import "PXCallExpression.h"
#import "PXCompoundExpression.h"
#import "PXWhileExpression.h"

@implementation PXExpression (PXExpressionHelpers)

- (NSString *)returnValueIdentifier {
  return [NSString stringWithFormat:@"$rv:%d", self.id];
}

- (PXContinuation *)continueAfter:(PXContinuation *)continuation inState:(int)state {
  PXContinuation *newContinuation = [PXContinuation continuationWithExpression:self context:continuation.context state:state];
  return [continuation continuationWithParentContinuation:newContinuation];
}

- (PXContinuation *)continueAfter:(PXContinuation *)continuation withContext:(PXExecutionContext *)context inState:(int)state {
  PXContinuation *newContinuation = [self continueAfter:continuation inState:state];
  newContinuation.context = context;
  return newContinuation;
}

+ (PXConstantExpression *)constantWithValue:(PXValue *)value {
  PXConstantExpression *expr = [PXConstantExpression expressionWithType:value.type];
  expr.value = value;
  return expr;
}

+ (PXAssignmentExpression *)assignmentWithIdentifierName:(NSString *)identifier expression:(PXExpression *)expression {
  PXAssignmentExpression *expr = [PXAssignmentExpression new];
  expr.identifier = identifier;
  expr.valueExpressionHole.expression = expression;
  return expr;
}

+ (PXConditionalExpression *)conditionalWithCondition:(PXExpression *)conditionExpression trueExpression:(PXExpression *)trueExpression falseExpression:(PXExpression *)falseExpression {
  PXConditionalExpression *expr = [PXConditionalExpression new];
  expr.conditionExpressionHole.expression = conditionExpression;
  expr.trueExpressionHole.expression = trueExpression;
  expr.falseExpressionHole.expression = falseExpression;
  return expr;
}

+ (PXCompoundExpression *)compoundWithExpressions:(NSArray *)subexpressions {
  PXCompoundExpression *expr = [PXCompoundExpression expressionWithType:PXAnyType];
  expr.numberOfSubexpressions = subexpressions.count;
  for (NSUInteger i = 0; i < expr.numberOfSubexpressions; i++) {
    PXHole *hole = [expr expressionHoleAtIndex:i];
    hole.expression = (PXExpression *)subexpressions[i];
  }
  return expr;
}

+ (PXIdentifierExpression *)identifierWithName:(NSString *)identifier {
  PXIdentifierExpression *expr = [PXIdentifierExpression expressionWithType:PXAnyType];
  expr.identifier = identifier;
  return expr;
}

+ (PXCallExpression *)callWithIdentifier:(NSString *)identifier arguments:(NSArray *)array returnType:(PXExpressionType)type {
  PXCallExpression *expr = [PXCallExpression expressionWithType:type];
  expr.identifier = identifier;
  expr.numberOfArguments = array.count;
  for (NSUInteger i = 0; i < expr.numberOfArguments; i++) {
    PXHole *hole = [expr argumentHoleAtIndex:i];
    hole.expression = (PXExpression *) array[i];
  }
  return expr;
}

+ (PXCallExpression *)callWithBuiltin:(PXBuiltin *)builtin arguments:(NSArray *)array returnType:(PXExpressionType)type {
  PXCallExpression *expr = [PXCallExpression expressionWithType:type];
  expr.builtin = builtin;
  expr.numberOfArguments = (NSUInteger)builtin.arity;
  if (array != nil) {
    for (NSUInteger i = 0; i < expr.numberOfArguments; i++) {
      PXHole *hole = [expr argumentHoleAtIndex:i];
      hole.expression = (PXExpression *) array[i];
    }
  }
  return expr;
}

+ (PXWhileExpression *)whileLoopWithCondition:(PXExpression *)conditionExpression body:(PXExpression *)bodyExpression {
  PXWhileExpression *expr = [PXWhileExpression new];
  expr.conditionExpressionHole.expression = conditionExpression;
  expr.bodyExpressionHole.expression = bodyExpression;
  return expr;
}

+ (PXExpression *)expressionWithString:(NSString *)string error:(NSError **)error {
  PXParser *parser = [PXParser new];

  PKAssembly *assembly = [parser parseString:string error:error];
  if (assembly == nil) {
    return nil;
  }
  return [assembly pop];
}

@end