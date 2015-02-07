@import Foundation;

#import "PXFailureType.h"

@class PXExpression;
@class PXValue;
@class PXFailureInfo;
@class PXExecutionContext;
@class PXContinuation;

@interface PXExecutionResult : NSObject

+ (instancetype)resultWithFailureInfo:(PXFailureInfo *)failureInfo;
+ (instancetype)resultWithContinuation:(PXContinuation *)continuation;
+ (instancetype)failWithReason:(PXFailureType)reason expression:(PXExpression *)expression;
+ (instancetype)success;

- (BOOL)isSuccess;
- (BOOL)isFailure;
- (BOOL)isCompleted;

@property (readonly, nonatomic, strong) PXContinuation *continuation;
@property (readonly, nonatomic, strong) PXFailureInfo *failureInfo;

@end