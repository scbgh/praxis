@import Foundation;

#import "PXExpressionType.h"

@class PXExpression;
@class PXHole;


@interface PXHole : NSObject

- (instancetype)initWithExpressionType:(PXExpressionType)expressionType;
+ (instancetype)holeWithExpressionType:(PXExpressionType)expressionType;

@property(nonatomic) PXExpressionType expressionType;
@property(nonatomic, retain) PXExpression *expression;

@end
