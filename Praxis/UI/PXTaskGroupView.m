#import "PXTaskGroupView.h"
#import "PXTaskGroup.h"

@interface PXTaskGroupView ()
- (void)recreateSubviews;
@end

@implementation PXTaskGroupView {
  PXTaskGroup *_taskGroup;
}

- (instancetype)initWithTaskGroup:(PXTaskGroup *)taskGroup {
  self = [super init];
  if (self) {
    _taskGroup = taskGroup;
    _taskGroup.delegate = self;
  }
  [self recreateSubviews];
  return self;
}

+ (instancetype)viewWithTaskGroup:(PXTaskGroup *)taskGroup {
  return [[self alloc] initWithTaskGroup:taskGroup];
}

- (void)taskGroupRefreshed:(PXTaskGroup *)taskGroup {
  [self recreateSubviews];
}

- (void)recreateSubviews {
  if (_taskGroup == nil) {
    return;
  }

  [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
  [self removeConstraints:self.constraints];

  UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, 10.f, 10.f)];
  titleLabel.font = [UIFont boldSystemFontOfSize:14.f];
  titleLabel.text = _taskGroup.title;
  titleLabel.translatesAutoresizingMaskIntoConstraints = NO;

  UIView *taskGroupSubview = [_taskGroup view];
  taskGroupSubview.translatesAutoresizingMaskIntoConstraints = NO;

  [self addSubview:titleLabel];
  [self addSubview:taskGroupSubview];

  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[titleLabel]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(titleLabel)]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[taskGroupSubview]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(taskGroupSubview)]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[titleLabel]-[taskGroupSubview]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(titleLabel, taskGroupSubview)]];

  [self setNeedsUpdateConstraints];
}

- (void)didMoveToSuperview {
  [super didMoveToSuperview];
  [_taskGroup refresh];
  [self recreateSubviews];
}


@end