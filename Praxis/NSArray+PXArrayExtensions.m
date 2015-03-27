@import UIKit;
#import "NSArray+PXArrayExtensions.h"

@implementation NSArray (PXArrayExtensions)

- (NSArray *)reversedArray {
  NSMutableArray *array = [NSMutableArray arrayWithCapacity:[self count]];
  NSEnumerator *enumerator = [self reverseObjectEnumerator];
  for (id element in enumerator) {
    [array addObject:element];
  }
  return array;
}

- (NSString *)layoutConstraintString:(int)padding outMapping:(NSDictionary **)outMapping {
  NSMutableDictionary *mapping = [NSMutableDictionary dictionary];
  NSMutableString *string = [NSMutableString string];
  int i = 0;
  for (UIView *view in self) {
    NSString *key = [NSString stringWithFormat:@"v%d", i];
    mapping[key] = view;
    [string appendFormat:@"[%@]", key];
    i++;
    if (i < self.count) {
      [string appendFormat:@"-%d-", padding];
    }
  }
  *outMapping = mapping;
  return string;
}

@end