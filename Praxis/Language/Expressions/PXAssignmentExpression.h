@import Foundation;

#import "PXExpression.h"

@class PXHole;

@interface PXAssignmentExpression : PXExpression

- (PXHole *)valueExpressionHole;

@property(nonatomic, strong) NSString *identifier;

@end