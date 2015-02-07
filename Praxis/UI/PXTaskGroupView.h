@import Foundation;
@import UIKit;

@class PXTaskGroup;

@interface PXTaskGroupView : UIView

- (instancetype)initWithTaskGroup:(PXTaskGroup *)taskGroup;
+ (instancetype)viewWithTaskGroup:(PXTaskGroup *)taskGroup;


@end