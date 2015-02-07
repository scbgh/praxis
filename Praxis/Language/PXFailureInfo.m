#import "PXFailureInfo.h"
#import "PXExpression.h"

@implementation PXFailureInfo

- (instancetype)initWithExpression:(PXExpression *)failedExpression type:(PXFailureType)failureType {
  self = [super init];
  if (self) {
    self.failedExpression = failedExpression;
    self.failureType = failureType;
  }

  return self;
}

+ (instancetype)infoWithExpression:(PXExpression *)failedExpression type:(PXFailureType)failureType {
  return [[self alloc] initWithExpression:failedExpression type:failureType];
}

@end