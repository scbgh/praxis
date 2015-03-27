#import "PXButtonElement.h"

@implementation PXButtonElement {

}

- (instancetype)initWithText:(NSString *)text action:(PXInsertAction)action {
  self = [super init];
  if (self) {
    self.color = [UIColor blackColor];
    self.text = text;
    self.action = action;
  }

  return self;
}

+ (instancetype)elementWithText:(NSString *)text action:(PXInsertAction)action {
  return [[self alloc] initWithText:text action:action];
}

@end