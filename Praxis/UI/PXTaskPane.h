@import Foundation;
@import UIKit;

@interface PXTaskPane : UIView

@property (nonatomic, strong) NSArray *taskGroups;

- (void)refresh;
@end