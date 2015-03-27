@import Foundation;
@class PXCodeEditor;
@class PXHole;

@interface PXTask : NSObject

- (void)execute;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) PXHole *hole;
@property (nonatomic, strong) PXCodeEditor *editor;

@end