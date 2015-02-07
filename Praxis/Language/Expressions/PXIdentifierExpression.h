@import Foundation;

#import "PXExpression.h"

@interface PXIdentifierExpression : PXExpression

- (instancetype)initWithType:(PXExpressionType)type;
+ (instancetype)expressionWithType:(PXExpressionType)type;

@property(nonatomic, strong) NSString *identifier;

@end