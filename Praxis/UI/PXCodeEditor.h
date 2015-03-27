@import Foundation;
@import UIKit;

@class PXExpression;
@class PXTaskProvider;
@class PXTaskGroup;
@class PXHoleView;

@protocol PXCodeEditorDelegate

- (void)selectedHoleViewChanged;

@end

@interface PXCodeEditor : UIView

- (void)refresh;
- (void)invalidateViews;
- (PXTaskGroup *)insertTaskGroup;
- (PXTaskGroup *)identifierTaskGroup;
- (void)updateOverlays;

@property (nonatomic, readonly, strong) PXHoleView *rootHoleView;
@property (nonatomic, strong) PXHoleView *selectedHoleView;
@property (nonatomic, strong) PXHoleView *highlightedHoleView;
@property (nonatomic, weak) id <PXCodeEditorDelegate> delegate;

@end