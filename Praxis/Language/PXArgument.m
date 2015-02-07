#import "PXArgument.h"

@implementation PXArgument {

}

- (NSString *)description {
  NSMutableString *description = [NSMutableString stringWithFormat:@"%@[", NSStringFromClass([self class])];
  [description appendFormat:@"name=%@", self.name];
  [description appendFormat:@", type=%i", self.type];
  [description appendString:@"]"];
  return description;
}

- (instancetype)initWithName:(NSString *)name type:(PXExpressionType)type {
  self = [super init];
  if (self) {
    self.name = name;
    self.type = type;
  }

  return self;
}

+ (instancetype)argumentWithName:(NSString *)name type:(PXExpressionType)type {
  return [[self alloc] initWithName:name type:type];
}

@end