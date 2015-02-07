@import Foundation;

#import "PXExpression.h"

@class PXContinuation;
@class PXExecutionContext;
@class PXConstantExpression;
@class PXValue;
@class PXAssignmentExpression;
@class PXConditionalExpression;
@class PXIdentifierExpression;
@class PXBuiltin;
@class PXCallExpression;
@class PXCompoundExpression;
@class PXWhileExpression;

@interface PXExpression (PXExpressionHelpers)

- (NSString *)returnValueIdentifier;

- (PXContinuation *)continueAfter:(PXContinuation *)continuation inState:(int)state;
- (PXContinuation *)continueAfter:(PXContinuation *)continuation withContext:(PXExecutionContext *)context inState:(int)state;

+ (PXConstantExpression *)constantWithValue:(PXValue *)value;
+ (PXAssignmentExpression *)assignmentWithIdentifierName:(NSString *)identifier expression:(PXExpression *)expression;
+ (PXConditionalExpression *)conditionalWithCondition:(PXExpression *)conditionExpression trueExpression:(PXExpression *)trueExpression falseExpression:(PXExpression *)falseExpression;
+ (PXCompoundExpression *)compoundWithExpressions:(NSArray *)subexpressions;
+ (PXIdentifierExpression *)identifierWithName:(NSString *)identifier;
+ (PXCallExpression *)callWithIdentifier:(NSString *)identifier arguments:(NSArray *)array returnType:(PXExpressionType)returnType;
+ (PXCallExpression *)callWithBuiltin:(PXBuiltin *)builtin arguments:(NSArray *)array returnType:(PXExpressionType)returnType;
+ (PXWhileExpression *)whileLoopWithCondition:(PXExpression *)conditionExpression body:(PXExpression *)bodyExpression;

+ (PXExpression *)expressionWithString:(NSString *)string error:(NSError **)error;

@end