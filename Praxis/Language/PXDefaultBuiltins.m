#import "PXValue.h"

@class PXBuiltin;

#define _DEFAULT_BUILTINS_IMPL_

#include "PXDefaultBuiltins+Decl.h"
#import "PXBuiltin.h"
#import "PXExecutionContext.h"
#import "PXFunction.h"
#import "PXArgument.h"
#import "PXCallExpression.h"
#import "PXExpression+PXExpressionHelpers.h"
#import "PXIdentifierExpression.h"

#undef _DEFAULT_BUILTINS_IMPL_

static PXValue *bad_args() {
  @throw([NSException exceptionWithName:@"BadArgs" reason:@"The argument types did not match the expected types." userInfo:nil]);
}

#define NUMERIC_BINOP(name, op) \
  static PXValue * name (PXValue *arg1, PXValue *arg2) { \
    /* Coerce to float if one is a float */ \
    if ((arg1.type & PXNumericType && arg2.type & PXNumericType) && (arg1.type == PXFloatType || arg2.type == PXFloatType)) { \
      double x = arg1.doubleValue; \
      double y = arg2.doubleValue; \
      return [PXValue valueWithDouble:op]; \
    } else if (arg1.type == PXIntegerType && arg2.type == PXIntegerType) { \
      int x = arg1.intValue; \
      int y = arg2.intValue; \
      return [PXValue valueWithInt:op]; \
    } \
    return bad_args(); \
  }

NUMERIC_BINOP(_builtin_add_impl, x + y);

NUMERIC_BINOP(_builtin_sub_impl, x - y);

NUMERIC_BINOP(_builtin_mul_impl, x * y);

NUMERIC_BINOP(_builtin_div_impl, x / y);

#undef NUMERIC_BINOP

#define COMPARISON_BINOP(name, numop, strop) \
  static PXValue * name (PXValue *arg1, PXValue *arg2) { \
    if (arg1.type == PXFloatType || arg2.type == PXFloatType) { \
      double x = arg1.doubleValue; \
      double y = arg2.doubleValue; \
      return [PXValue valueWithBool:numop]; \
    } else if (arg1.type == PXIntegerType && arg2.type == PXIntegerType) { \
      int x = arg1.intValue; \
      int y = arg2.intValue; \
      return [PXValue valueWithBool:numop]; \
    } else if (arg1.type == PXStringType && arg2.type == PXStringType) { \
      NSString *x = arg1.stringValue; \
      NSString *y = arg2.stringValue; \
      return [PXValue valueWithBool:strop]; \
    } \
    return bad_args(); \
  }

COMPARISON_BINOP(_builtin_eq_impl, x == y, [x isEqualToString:y]);

COMPARISON_BINOP(_builtin_lt_impl, x < y, ([x isEqualToString:y] || [x compare:y] == NSOrderedAscending));

COMPARISON_BINOP(_builtin_lte_impl, x <= y, ([x compare:y] == NSOrderedAscending));

COMPARISON_BINOP(_builtin_gt_impl, x > y, ([x compare:y] == NSOrderedDescending));

COMPARISON_BINOP(_builtin_gte_impl, x >= y, ([x isEqualToString:y] || [x compare:y] == NSOrderedDescending));

void PXInitBuiltins() {
  builtin_add = [PXBuiltin builtinWithType:PXNumericType binaryFunction:_builtin_add_impl];
  builtin_sub = [PXBuiltin builtinWithType:PXNumericType binaryFunction:_builtin_sub_impl];
  builtin_mul = [PXBuiltin builtinWithType:PXNumericType binaryFunction:_builtin_mul_impl];
  builtin_div = [PXBuiltin builtinWithType:PXNumericType binaryFunction:_builtin_div_impl];
  builtin_eq = [PXBuiltin builtinWithType:PXBooleanType binaryFunction:_builtin_eq_impl];
  builtin_lt = [PXBuiltin builtinWithType:PXBooleanType binaryFunction:_builtin_lt_impl];
  builtin_lte = [PXBuiltin builtinWithType:PXBooleanType binaryFunction:_builtin_lte_impl];
  builtin_gt = [PXBuiltin builtinWithType:PXBooleanType binaryFunction:_builtin_gt_impl];
  builtin_gte = [PXBuiltin builtinWithType:PXBooleanType binaryFunction:_builtin_gte_impl];
}

static PXFunction *PXCreateBinaryBuiltinFunction(PXBuiltin *builtin, PXExpressionType argType, PXExpressionType returnType) {
  NSArray *arguments = @[[PXArgument argumentWithName:@"x" type:argType], [PXArgument argumentWithName:@"y" type:argType]];
  PXIdentifierExpression *x = [PXIdentifierExpression expressionWithType:argType];
  PXIdentifierExpression *y = [PXIdentifierExpression expressionWithType:argType];
  x.identifier = @"x";
  y.identifier = @"y";
  PXCallExpression *expr = [PXCallExpression callWithBuiltin:builtin arguments:@[x, y] returnType:returnType];
  return [PXFunction functionWithArguments:arguments body:expr];
}

void PXInitContextWithBuiltins(PXExecutionContext *context) {
  [context assignVariableNamed:@"_add" withValue:[PXValue valueWithFunction:PXCreateBinaryBuiltinFunction(builtin_add, PXNumericType, PXNumericType)]];
  [context assignVariableNamed:@"_sub" withValue:[PXValue valueWithFunction:PXCreateBinaryBuiltinFunction(builtin_sub, PXNumericType, PXNumericType)]];
  [context assignVariableNamed:@"_mul" withValue:[PXValue valueWithFunction:PXCreateBinaryBuiltinFunction(builtin_mul, PXNumericType, PXNumericType)]];
  [context assignVariableNamed:@"_div" withValue:[PXValue valueWithFunction:PXCreateBinaryBuiltinFunction(builtin_div, PXNumericType, PXNumericType)]];
  [context assignVariableNamed:@"_eq" withValue:[PXValue valueWithFunction:PXCreateBinaryBuiltinFunction(builtin_eq, PXNumericType, PXBooleanType)]];
  [context assignVariableNamed:@"_lt" withValue:[PXValue valueWithFunction:PXCreateBinaryBuiltinFunction(builtin_lt, PXNumericType, PXBooleanType)]];
  [context assignVariableNamed:@"_lte" withValue:[PXValue valueWithFunction:PXCreateBinaryBuiltinFunction(builtin_lte, PXNumericType, PXBooleanType)]];
  [context assignVariableNamed:@"_gt" withValue:[PXValue valueWithFunction:PXCreateBinaryBuiltinFunction(builtin_gt, PXNumericType, PXBooleanType)]];
  [context assignVariableNamed:@"_gte" withValue:[PXValue valueWithFunction:PXCreateBinaryBuiltinFunction(builtin_gte, PXNumericType, PXBooleanType)]];
}
