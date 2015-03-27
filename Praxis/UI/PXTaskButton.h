@import Foundation;
@import UIKit;
@class PXTask;

@interface PXTaskButton : UIButton

@property (nonatomic, strong) PXTask *task;
- (instancetype)initWithTask:(PXTask *)task;
+ (instancetype)buttonWithTask:(PXTask *)task;


@end