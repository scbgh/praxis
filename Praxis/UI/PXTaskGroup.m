#import "PXTaskGroup.h"
#import "PXCodeEditor.h"

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

- (UIView *)view {
  return nil;
}

- (void)refresh {
  [self.delegate taskGroupRefreshed:self];
}

@end