
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