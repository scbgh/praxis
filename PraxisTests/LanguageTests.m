#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "PXExpression.h"
#import "PXAssignmentExpression.h"
#import "PXExecutionContext.h"
#import "PXConstantExpression.h"
#import "PXExecutionResult.h"
#import "PXExpression+PXExpressionHelpers.h"
#import "PXIdentifierExpression.h"
#import "PXConditionalExpression.h"
#import "PXDefaultBuiltins.h"
#import "PXCallExpression.h"
#import "PXFunction.h"
#import "PXArgument.h"
#import "PXBuiltin.h"
#import "PXFailureInfo.h"

@interface LanguageTests : XCTestCase

@end

@implementation LanguageTests {
  PXExecutionContext *context;
}

- (void)setUp {
  [super setUp];
  context = [PXExecutionContext new];

  PXInitBuiltins();
  PXInitContextWithBuiltins(context);

  PXCallExpression *expr = [PXExpression callWithBuiltin:builtin_add
                                               arguments:@[[PXExpression identifierWithName:@"x"], [PXExpression identifierWithName:@"y"]]
                                              returnType:PXNumericType];
  PXFunction *function = [PXFunction functionWithArguments:@[[PXArgument argumentWithName:@"x" type:PXNumericType], [PXArgument argumentWithName:@"y" type:PXNumericType]]
                                                      body:expr];
  PXValue *functionValue = [PXValue valueWithFunction:function];
  [context assignVariableNamed:@"add" withValue:functionValue];
}

- (void)tearDown {
  [super tearDown];
}

- (PXValue *)executeAndTest:(NSString *)code {
  NSError *error;
  PXExpression *expr = [PXExpression expressionWithString:code error:&error];
  PXExecutionResult *result = [expr executeFullyInContext:context];
  XCTAssertEqual(nil, result.failureInfo.failureType);
  PXValue *val = [context lookupVariableNamed:expr.returnValueIdentifier];
  return val;
}

- (void)testConstantExpression {
  PXValue *value = [self executeAndTest:@"622"];
  XCTAssertEqual(622, value.intValue);
}

- (void)testSimpleAssignmentExpression {
  [self executeAndTest:@"var := int(111)"];
  PXValue *val = [context lookupVariableNamed:@"var"];
  XCTAssertEqual(111, val.intValue);
}

- (void)testIdentifierExpression {
  [context assignVariableNamed:@"var" withValue:[PXValue valueWithInt:112]];
  PXValue *value = [self executeAndTest:@"var"];
  XCTAssertEqual(112, value.intValue);
}

- (void)testConditionalExpression {
  PXValue *value = [self executeAndTest:@"if (true) var := 6 else var := 2"];
  PXValue *val = [context lookupVariableNamed:@"var"];
  value = [self executeAndTest:@"if (false) var := 5 else var := 10"];
  val = [context lookupVariableNamed:@"var"];
  XCTAssertEqual(10, val.intValue);
}

- (void)testPrintExpression {
  
}

#define TEST_NUMERIC_BINOP_BUILTIN(op, x_, y_, compare) \
  do { \
    PXValue *r; \
    { \
      int x = (int)(x_); \
      int y = (int)(y_); \
      r = [op callWithArguments:@[[PXValue valueWithInt:x], [PXValue valueWithInt:y]]]; \
      XCTAssertEqual(PXIntegerType, r.type); \
      XCTAssertEqual(compare, r.intValue); \
    } \
    { \
      double x = (double)(x_); \
      double y = (double)(y_); \
      r = [op callWithArguments:@[[PXValue valueWithDouble:x], [PXValue valueWithDouble:y]]]; \
      XCTAssertEqualWithAccuracy(compare, r.doubleValue, 0.000001); \
      XCTAssertEqual(PXFloatType, r.type); \
    } \
  } while (0)

- (void)testBuiltins {
  TEST_NUMERIC_BINOP_BUILTIN(builtin_add, 422.288, 126.565, x + y);
  TEST_NUMERIC_BINOP_BUILTIN(builtin_sub, 123.456, 6264.526, x - y);
  TEST_NUMERIC_BINOP_BUILTIN(builtin_mul, 34.624, 6384.5, x * y);
  TEST_NUMERIC_BINOP_BUILTIN(builtin_div, 3499.72, 34.1, x / y);
}

- (void)testCallBuiltin {
  NSError *error;
  PXValue *value = [self executeAndTest:@"_add(5, 6)[number]"];
  XCTAssertEqual(11, value.intValue);
}

- (void)testCallFunction {
  PXValue *value = [self executeAndTest:@"add(3.4, 1.1)[number]"];
  XCTAssertEqual(4.5, value.doubleValue);
}

- (void)testCompoundExpression {
  PXValue *value = [self executeAndTest:@"{ x := 4 ; y := 5 ; z := add(x, y)[number] ; z }"];
  XCTAssertEqual(9, value.intValue);
}

- (void)testWhileExpression {
  //PXValue *value = [self executeAndTest:@"begin x := 0; y := 0; while _lt(x, 10) bool do begin x := _add(x, 1) number; y := _add(y, 2) number; end; y end"];
  PXValue *value = [self executeAndTest:@"{ x := 0 ; while (_lt(x, 5)[bool]) x := _add(x, 1)[number] ; x }"];
  XCTAssertEqual(5, value.intValue);
}

@end
