@import Foundation;
@import UIKit;

@interface PXTaskGroup : NSObject

- (instancetype)initWithTitle:(NSString *)title;
+ (instancetype)groupWithTitle:(NSString *)title;

- (UIView *)createView;

@property (nonatomic, strong) NSString *title;

@end