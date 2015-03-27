#import "PXHoleElement.h"
#import "PXHole.h"

@implementation PXHoleElement

- (instancetype)initWithHole:(PXExpression *)hole key:(NSString *)key {
  self = [super init];
  if (self) {
    _hole = hole;
    _key = key;
  }

  return self;
}

+ (instancetype)elementWithHole:(PXHole *)hole key:(NSString *)key {
  return [[self alloc] initWithHole:hole key:key];
}

@end