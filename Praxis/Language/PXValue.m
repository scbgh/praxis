#import "PXValue.h"
#import "PXFunction.h"

@implementation PXValue {
  NSString *_stringValue;
  NSNumber *_numberValue;
  PXFunction *_functionValue;
}

- (instancetype)initWithStringValue:(NSString *)stringValue {
  self = [super init];
  if (self) {
    _stringValue = stringValue;
    _type = PXStringType;
  }

  return self;
}

- (instancetype)initWithNumberValue:(NSNumber *)numberValue ofType:(PXExpressionType)type {
  self = [super init];
  if (self) {
    _numberValue = numberValue;
    _type = type;
  }

  return self;
}

- (instancetype)initWithFunction:(PXFunction *)functionValue {
  self = [super init];
  if (self) {
    _functionValue = functionValue;
    _type = PXFunctionType;
  }

  return self;
}

- (PXFunction *)functionValue {
  return _functionValue;
}

- (int)intValue {
  return [_numberValue intValue];
}

- (double)doubleValue {
  return [_numberValue doubleValue];
}

- (BOOL)boolValue {
  return [_numberValue boolValue];
}

- (NSNumber *)numberValue {
  return _numberValue;
}

- (NSString *)stringValue {
  return _stringValue;
}

- (id)copyWithZone:(NSZone *)zone {
  PXValue *copy = (PXValue *) [[[self class] allocWithZone:zone] init];

  if (copy != nil) {
    copy->_stringValue = [_stringValue copy];
    copy->_numberValue = [_numberValue copy];
    copy->_type = _type;
  }

  return copy;
}

+ (instancetype)valueWithFunction:(PXFunction *)functionValue {
  return [[self alloc] initWithFunction:functionValue];
}

+ (instancetype)valueWithNumber:(NSNumber *)numberValue ofType:(PXExpressionType)type {
  return [[self alloc] initWithNumberValue:numberValue ofType:type];
}

+ (instancetype)valueWithInt:(int)value {
  return [PXValue valueWithNumber:@(value) ofType:PXIntegerType];
}

+ (instancetype)valueWithDouble:(double)value {
  return [PXValue valueWithNumber:@(value) ofType:PXFloatType];
}

+ (instancetype)valueWithBool:(BOOL)value {
  return [PXValue valueWithNumber:@(value) ofType:PXBooleanType];
}

+ (instancetype)unitValue {
  return [PXValue valueWithNumber:@(0) ofType:PXFloatType];
}

+ (instancetype)valueWithString:(NSString *)stringValue {
  return [[self alloc] initWithStringValue:stringValue];
}

- (NSString *)description {
  NSMutableString *description = [NSMutableString stringWithFormat:@"%@[", NSStringFromClass([self class])];
  NSString *typeDescription;
  switch ((int) self.type) {
    case PXIntegerType:
      typeDescription = @"integer";
      break;
    case PXBooleanType:
      typeDescription = @"boolean";
      break;
    case PXFloatType:
      typeDescription = @"float";
      break;
    case PXStringType:
      typeDescription = @"string";
      break;
    case PXVoidType:
      typeDescription = @"void";
      break;
    case PXFunctionType:
      typeDescription = @"function";
      break;
    case PXNumericType:
      typeDescription = @"numeric";
      break;
    case PXValueType:
      typeDescription = @"value";
      break;
    case PXAnyType:
      typeDescription = @"any";
      break;
    case PXScalarType:
      typeDescription = @"scalar";
      break;
    default:
      typeDescription = @"unknown";
      break;
  }
  NSString *valueDescription;
  if (self.functionValue != nil) {
    valueDescription = [self.functionValue description];
  } else if (self.stringValue != nil) {
    valueDescription = _stringValue;
  } else {
    valueDescription = [NSString stringWithFormat:@"%@", _numberValue];
  }
  [description appendFormat:@"type=%@", typeDescription];
  [description appendFormat:@", value=%@", valueDescription];
  [description appendString:@"]"];
  return description;
}
@end