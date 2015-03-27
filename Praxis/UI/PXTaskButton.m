#import "PXTaskButton.h"
#import "PXTask.h"

@implementation PXTaskButton {

}

- (instancetype)initWithTask:(PXTask *)task {
  self = [super init];
  if (self) {
    _task = task;
  }
  return self;
}

+ (instancetype)buttonWithTask:(PXTask *)task {
  return [[self alloc] initWithTask:task];
}

@end