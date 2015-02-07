#import "PXBuiltin.h"
#import "PXValue.h"

@implementation PXBuiltin

- (instancetype)initWithType:(PXExpressionType)type arity:(int)arity function:(void **)function {
  self = [super init];
  if (self) {
    self.type = type;
    self.arity = arity;
    self.function = function;
  }

  return self;
}

+ (instancetype)builtinWithType:(PXExpressionType)type arity:(int)arity function:(void **)function {
  return [[self alloc] initWithType:type arity:arity function:function];
}

- (PXValue *)callWithArguments:(NSArray *)arguments {
  switch (self.arity) {
    case 0:
      return ((PXNullaryBuiltin) self.function)();
    case 1: {
      PXValue *arg1 = (PXValue *) arguments[0];
      return ((PXUnaryBuiltin) self.function)(arg1);
    }
    case 2: {
      PXValue *arg1 = (PXValue *) arguments[0];
      PXValue *arg2 = (PXValue *) arguments[1];
      return ((PXBinaryBuiltin) self.function)(arg1, arg2);
    }
    case 3: {
      PXValue *arg1 = (PXValue *) arguments[0];
      PXValue *arg2 = (PXValue *) arguments[1];
      PXValue *arg3 = (PXValue *) arguments[2];
      return ((PXTernaryBuiltin) self.function)(arg1, arg2, arg3);
    }
    default:
      return nil;
  }
}

+ (instancetype)builtinWithType:(PXExpressionType)type nullaryFunction:(PXNullaryBuiltin)function {
  return [[self alloc] initWithType:type arity:0 function:(void *) function];
}

+ (instancetype)builtinWithType:(PXExpressionType)type unaryFunction:(PXUnaryBuiltin)function {
  return [[self alloc] initWithType:type arity:1 function:(void *) function];
}

+ (instancetype)builtinWithType:(PXExpressionType)type binaryFunction:(PXBinaryBuiltin)function {
  return [[self alloc] initWithType:type arity:2 function:(void *) function];
}

+ (instancetype)builtinWithType:(PXExpressionType)type ternaryFunction:(PXTernaryBuiltin)function {
  return [[self alloc] initWithType:type arity:3 function:(void *) function];
}

@end