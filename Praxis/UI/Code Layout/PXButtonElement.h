@import Foundation;
@import UIKit;

@interface PXButtonElement : NSObject

typedef void (^PXInsertAction)();

- (instancetype)initWithText:(NSString *)text action:(PXInsertAction)action;
+ (instancetype)elementWithText:(NSString *)text action:(PXInsertAction)action;

@property (nonatomic, copy) UIColor *color;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, copy) PXInsertAction action;

@end