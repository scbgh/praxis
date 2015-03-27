#import <objc/runtime.h>
#import "PXHole+PXHoleView.h"

@implementation PXHole (PXHoleView)

- (PXHoleView *)holeView {
  return objc_getAssociatedObject(self, @selector(holeView));
}

- (void)setHoleView:(PXHoleView *)holeView {
  objc_setAssociatedObject(self, @selector(holeView), holeView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end