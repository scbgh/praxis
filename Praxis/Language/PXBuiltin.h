@import Foundation;

#import "PXExpressionType.h"

@class PXValue;

// We support builtins with up to three arguments
typedef PXValue *(*PXNullaryBuiltin)();
typedef PXValue *(*PXUnaryBuiltin)(PXValue *);
typedef PXValue *(*PXBinaryBuiltin)(PXValue *, PXValue *);
typedef PXValue *(*PXTernaryBuiltin)(PXValue *, PXValue *, PXValue *);

@interface PXBuiltin : NSObject

- (instancetype)initWithType:(PXExpressionType)type arity:(int)arity function:(void **)function;
- (PXValue *)callWithArguments:(NSArray *)arguments;

+ (instancetype)builtinWithType:(PXExpressionType)type nullaryFunction:(PXNullaryBuiltin)function;
+ (instancetype)builtinWithType:(PXExpressionType)type unaryFunction:(PXUnaryBuiltin)function;
+ (instancetype)builtinWithType:(PXExpressionType)type binaryFunction:(PXBinaryBuiltin)function;
+ (instancetype)builtinWithType:(PXExpressionType)type ternaryFunction:(PXTernaryBuiltin)function;

@property(nonatomic) void **function;
@property(nonatomic) int arity;
@property(nonatomic) PXExpressionType type;

@end