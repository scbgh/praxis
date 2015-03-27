@import Foundation;
@import UIKit;

@interface PXBlockButton : UIButton

@property (nonatomic, copy) void (^block)();
- (instancetype)initWithBlock:(void (^)())block;
+ (instancetype)buttonWithBlock:(void (^)())block;


@end