#import "PXTaskGroup.h"

@implementation PXTaskGroup

- (instancetype)initWithTitle:(NSString *)title {
  self = [super init];
  if (self) {
    self.title = title;
  }

  return self;
}

+ (instancetype)groupWithTitle:(NSString *)title {
  return [[self alloc] initWithTitle:title];
}

- (UIView *)createView {
  return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
}

@end