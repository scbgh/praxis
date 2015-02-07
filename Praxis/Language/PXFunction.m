#import "PXFunction.h"
#import "PXExpression.h"
#import "PXContinuation.h"
#import "PXExecutionContext.h"
#import "PXExecutionResult.h"

@implementation PXFunction

- (instancetype)initWithArguments:(NSArray *)arguments body:(PXExpression *)bodyExpression {
  self = [super init];
  if (self) {
    self.arguments = arguments;
    self.bodyExpression = bodyExpression;
  }
  return self;
}

+ (instancetype)functionWithArguments:(NSArray *)arguments body:(PXExpression *)bodyExpression {
  return [[self alloc] initWithArguments:arguments body:bodyExpression];
}

- (NSString *)description {
  NSMutableString *description = [NSMutableString stringWithFormat:@"%@[", NSStringFromClass([self class])];
  [description appendFormat:@"arguments=%@", self.arguments];
  [description appendString:@"]"];
  return description;
}


@end