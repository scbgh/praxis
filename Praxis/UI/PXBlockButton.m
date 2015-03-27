#import "PXBlockButton.h"

@implementation PXBlockButton

- (instancetype)init {
  self = [super init];
  if (self) {
    [self addTarget:self action:@selector(touched:) forControlEvents:UIControlEventTouchUpInside];
  }

  return self;
}

- (instancetype)initWithBlock:(void (^)())block {
  self = [self init];
  if (self) {
    self.block = block;
  }

  return self;
}

+ (instancetype)buttonWithBlock:(void (^)())block {
  return [[self alloc] initWithBlock:block];
}

- (void)touched:(id)button {
  if (self.block) {
    self.block();
  }
}


@end