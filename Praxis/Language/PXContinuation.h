@import Foundation;

#import "PXDebugContext.h"

@class PXExpression;
@class PXExecutionContext;
@class PXExecutionResult;

@interface PXContinuation : NSObject <NSCopying>

- (instancetype)initWithExpression:(PXExpression *)expression context:(PXExecutionContext *)context state:(int)state;
+ (instancetype)continuationWithExpression:(PXExpression *)expression context:(PXExecutionContext *)context state:(int)state;

- (PXExecutionResult *)continueExecution;
- (PXExecutionResult *)waitForExecution;
- (PXContinuation *)continuationWithParentContinuation:(PXContinuation *)outerContinuation;

@property (readonly, nonatomic) int callDepth;
@property (nonatomic, strong) PXContinuation *parentContinuation;
@property (nonatomic, strong) PXExpression *expression;
@property (nonatomic, strong) PXExecutionContext *context;
@property (nonatomic) int state;

@end