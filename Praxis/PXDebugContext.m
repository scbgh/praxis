#import "PXDebugContext.h"
#import "Common.h"
#import "PXExecutionContext.h"
#import "PXContinuation.h"

@implementation PXDebugContext

- (instancetype)initWithContext:(PXExecutionContext *)context {
  self = [super init];
  if (self) {
    _context = context;
  }

  return self;
}

+ (instancetype)debugContextWithContext:(PXExecutionContext *)context {
  return [[self alloc] initWithContext:context];
}

- (void)log:(NSString *)message {
  [self logWithFormat:message];
}

- (void)logWithFormat:(NSString *)format, ... {
  va_list args;
  va_start(args, format);
  NSString *str = [[NSString alloc] initWithFormat:format arguments:args];
  va_end(args);
  int indentation = 0;
  if (self.context.currentContinuation != nil) {
    indentation = self.context.currentContinuation.callDepth;
  }
  NSString *indent = [@"" stringByPaddingToLength:(NSUInteger)indentation
                                       withString:@" "
                                  startingAtIndex:0];
  NSString *message = [NSString stringWithFormat:@"%@%@", indent, str];
  DebugLog(@"%@", message);
};

@end