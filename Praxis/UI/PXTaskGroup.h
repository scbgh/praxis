@import Foundation;
@import UIKit;@class PXTaskGroup;
@class PXCodeEditor;

@protocol PXTaskGroupDelegate
- (void) taskGroupRefreshed: (PXTaskGroup *)taskGroup;
@end

@interface PXTaskGroup : NSObject

- (instancetype)initWithTitle:(NSString *)title;
+ (instancetype)groupWithTitle:(NSString *)title;

- (UIView *)view;
- (void)refresh;

@property (nonatomic) BOOL hidden;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) PXCodeEditor *editor;
@property (nonatomic, weak) id <PXTaskGroupDelegate> delegate;

@end