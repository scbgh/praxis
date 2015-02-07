@import Foundation;

#import "PXExpression.h"

@class PXHole;
@class PXBuiltin;

@interface PXCallExpression : PXExpression

- (instancetype)initWithType:(PXExpressionType)type;
+ (instancetype)expressionWithType:(PXExpressionType)type;

- (PXHole *)argumentHoleAtIndex:(NSUInteger)index;

@property(nonatomic, strong) NSString *identifier;
@property(nonatomic, strong) PXBuiltin *builtin;
@property(nonatomic) NSUInteger numberOfArguments;

@end