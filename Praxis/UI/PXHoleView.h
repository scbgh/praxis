@import Foundation;
@import UIKit;
@class PXHole;

@interface PXHoleView : UIView

- (instancetype)initWithHole:(PXHole *)hole;
+ (instancetype)viewWithHole:(PXHole *)hole;

- (void)invalidateViews;

@property (nonatomic, strong) PXHole *hole;

@end