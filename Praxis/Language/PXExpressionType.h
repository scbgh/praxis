
enum {
  PXIntegerType = 1,
  PXBooleanType = 2,
  PXFloatType = 4,
  PXStringType = 8,
  PXVoidType = 16,
  PXFunctionType = 32
};
typedef int PXExpressionType;

static const int PXNumericType = PXIntegerType | PXFloatType;
static const int PXScalarType = PXNumericType | PXBooleanType | PXStringType;
static const int PXValueType = PXNumericType | PXScalarType | PXFunctionType;
static const int PXAnyType = PXValueType | PXVoidType;

static inline NSString *PXExpressionTypeString(PXExpressionType type) {
  switch (type) {
    case PXIntegerType:
      return @"integer";
    case PXBooleanType:
      return @"boolean";
    case PXFloatType:
      return @"float";
    case PXStringType:
      return @"string";
    case PXVoidType:
      return @"void";
    case PXFunctionType:
      return @"function";
    case PXNumericType:
      return @"number";
    case PXScalarType:
      return @"scalar";
    case PXValueType:
      return @"value";
    case PXAnyType:
      return @"any";
  }
  return @"unknown";
}
