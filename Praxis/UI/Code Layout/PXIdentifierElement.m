#import "PXIdentifierElement.h"

@implementation PXIdentifierElement {

}

- (instancetype)initWithIdentifier:(NSString *)identifier type:(PXExpressionType)type key:(NSString *)key {
  self = [super init];
  if (self) {
    _identifier = identifier;
    _type = type;
    _key = key;
  }

  return self;
}

+ (instancetype)elementWithIdentifier:(NSString *)identifier type:(PXExpressionType)type key:(NSString *)key {
  return [[self alloc] initWithIdentifier:identifier type:type key:key];
}

@end