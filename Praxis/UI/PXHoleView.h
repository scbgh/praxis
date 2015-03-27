@import Foundation;
@import UIKit;

@class PXHole;
@class PXCodeEditor;

@interface PXHoleView : UIView

- (instancetype)initWithHole:(PXHole *)hole editor:(PXCodeEditor *)editor;
+ (instancetype)viewWithHole:(PXHole *)hole editor:(PXCodeEditor *)editor;

- (void)refresh;
- (void)invalidateViews;

@property (nonatomic, weak) PXCodeEditor *editor;
@property (nonatomic, strong) PXHole *hole;

@end