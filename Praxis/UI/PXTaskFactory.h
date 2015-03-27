@import Foundation;

#import "PXTask.h"

@class PXExpression;
@class PXCodeEditor;

@interface PXTaskFactory : NSObject

typedef void (^PXTaskAction)(id task);

- (PXTask *)createTaskWithClass:(Class)cls name:(NSString *)string setup:(PXTaskAction)action;

@property (nonatomic, strong) PXHole *hole;
@property (nonatomic, strong) PXCodeEditor *editor;

@end