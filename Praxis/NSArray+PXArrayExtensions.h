@import Foundation;

@interface NSArray (PXArrayExtensions)

- (NSArray *)reversedArray;
- (NSString *)layoutConstraintString:(int)padding outMapping:(NSDictionary **)outMapping;

@end