#import "PXTaskFactory.h"
#import "PXHole.h"
#import "PXCodeEditor.h"
#import "PXTask.h"

@implementation PXTaskFactory {

}

- (PXTask *)createTaskWithClass:(Class)cls name:(NSString *)name setup:(PXTaskAction)action {
  PXTask *task = (PXTask *)[[cls alloc] init];
  task.name = name;
  task.editor = self.editor;
  task.hole = self.hole;
  if (action) {
    action(task);
  }
  return task;
}

@end