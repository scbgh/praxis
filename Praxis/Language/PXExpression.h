@import Foundation;
@class PXExecutionContext;
@class PXExecutionResult;
@class PXHole;

#import "PXExpressionType.h"
#import "PXDebugContext.h"

@interface PXExpression : NSObject

- (PXExecutionResult *)executeInContext:(PXExecutionContext *)context inState:(int)state;
- (PXExecutionResult *)executeFullyInContext:(PXExecutionContext *)context;
- (PXExpressionType)type;

@property (readonly, nonatomic) int id;
@property (nonatomic, strong) PXHole *hole;

@end
