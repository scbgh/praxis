@import Foundation;
@import UIKit;
@class UIGestureRecognizer;

@interface UIView (PXGestureExtensions)
  - (BOOL)superviewHierarchyContainsGestureRecognizer:(UIGestureRecognizer *)recognizer;
@end