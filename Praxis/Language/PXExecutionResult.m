#import "PXExecutionResult.h"
#import "PXFailureInfo.h"
#import "PXContinuation.h"

@interface PXExecutionResult ()
- (instancetype)initWithFailureInfo:(PXFailureInfo *)failureInfo;
- (instancetype)initWithContinuation:(PXContinuation *)continuation;
@end

@implementation PXExecutionResult {
  PXContinuation *_continuation;
  PXFailureInfo *_failureInfo;
}

@synthesize continuation = _continuation;
@synthesize failureInfo = _failureInfo;

+ (instancetype)resultWithContinuation:(PXContinuation *)continuation {
  PXExecutionResult *result = [[PXExecutionResult alloc] initWithContinuation:continuation];
  return result;
}

+ (instancetype)resultWithFailureInfo:(PXFailureInfo *)failureInfo {
  PXExecutionResult *result = [[PXExecutionResult alloc] initWithFailureInfo:failureInfo];
  return result;
}

- (instancetype)initWithFailureInfo:(PXFailureInfo *)failureInfo {
  self = [super init];
  if (self) {
    _failureInfo = failureInfo;
  }

  return self;
}

- (instancetype)initWithContinuation:(PXContinuation *)continuation {
  self = [super init];
  if (self) {
    _continuation = continuation;
  }

  return self;
}

- (BOOL)isSuccess {
  return self.isCompleted && self.failureInfo == nil;
}

- (BOOL)isFailure {
  return self.isCompleted && self.failureInfo != nil;
}

- (BOOL)isCompleted {
  return self.continuation == nil;
}

+ (instancetype)failWithReason:(PXFailureType)reason
                    expression:(PXExpression *)expression {
  return [PXExecutionResult resultWithFailureInfo:[PXFailureInfo infoWithExpression:expression type:reason]];
}

+ (instancetype)success {
  return [PXExecutionResult resultWithContinuation:nil];
}

@end