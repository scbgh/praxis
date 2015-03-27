#import "PXSymbolElement.h"

@implementation PXSymbolElement {

}

- (instancetype)initWithSymbol:(NSString *)symbol {
  self = [super init];
  if (self) {
    self.symbol = symbol;
  }

  return self;
}

+ (instancetype)elementWithSymbol:(NSString *)symbol {
  return [[self alloc] initWithSymbol:symbol];
}

@end