#import "UIView+PXGestureExtensions.h"

@implementation UIView (PXGestureExtensions)


- (BOOL)superviewHierarchyContainsGestureRecognizer:(UIGestureRecognizer *)recognizer {
  if ([self.gestureRecognizers indexOfObject:recognizer] != NSNotFound) {
    return YES;
  }
  if (self.superview != nil) {
    return [self.superview superviewHierarchyContainsGestureRecognizer:recognizer];
  }
  return NO;
}

@end