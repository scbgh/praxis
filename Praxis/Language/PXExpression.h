@import Foundation;
@class PXExecutionContext;
@class PXExecutionResult;

#import "PXExpressionType.h"
#import "PXDebugContext.h"

@interface PXExpression : NSObject

- (PXExecutionResult *)executeInContext:(PXExecutionContext *)context inState:(int)state;
- (PXExecutionResult *)executeFullyInContext:(PXExecutionContext *)context;
- (PXExpressionType)type;

@property (readonly, nonatomic) int id;

@end
