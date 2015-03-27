@import Foundation;

#import "PXExpressionType.h"

@class PXExpression;

@interface PXHole : NSObject

- (instancetype)initWithExpressionType:(PXExpressionType)expressionType parentExpression:(PXExpression *)parentExpression;
+ (instancetype)holeWithExpressionType:(PXExpressionType)expressionType parentExpression:(PXExpression *)parentExpression;

@property (nonatomic) PXExpressionType expressionType;
@property (nonatomic, retain) PXExpression *expression;
@property (nonatomic, retain) PXExpression *parent;

@end
