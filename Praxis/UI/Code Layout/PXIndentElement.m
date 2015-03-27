#import "PXIndentElement.h"

@implementation PXIndentElement

- (instancetype)initWithIndent:(CGFloat)indent {
  self = [super init];
  if (self) {
    _indent = indent;
  }

  return self;
}

+ (instancetype)elementWithIndent:(CGFloat)indent {
  return [[self alloc] initWithIndent:indent];
}


@end