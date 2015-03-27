#import "PXIdentifierTaskGroup.h"
#import "PXHole.h"
#import "PXIdentifierTask.h"
#import "PXTaskButton.h"
#import "UIColor+PXColor.h"
#import "PXVisuals.h"
#import "NSArray+PXArrayExtensions.h"
#import "PXTaskFactory.h"
#import "PXScopeAnalyzer.h"
#import "PXExpression+PXExpressionView.h"

@implementation PXIdentifierTaskGroup {
  NSMutableArray *_buttons;
  UIView *_view;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _buttons = [NSMutableArray array];
  }
  return self;
}

- (UIView *)view {
  if (_view == nil) {
    _view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 45, 50)];
  }
  return _view;
}

- (void)setHole:(PXExpression *)hole {
  _hole = hole;
  [self refresh];
}

- (void)recreateButtons {
  [_buttons makeObjectsPerformSelector:@selector(removeFromSuperview)];
  _buttons = [NSMutableArray array];

  for (PXIdentifierTask *task in self.tasks) {
    PXTaskButton *taskButton = [[PXTaskButton alloc] init];
    [taskButton setTitle:task.name forState:UIControlStateNormal];
    [taskButton setTitleColor:[UIColor colorWithExpressionType:task.type] forState:UIControlStateNormal];
    taskButton.task = task;
    taskButton.translatesAutoresizingMaskIntoConstraints = NO;
    [taskButton addTarget:self action:@selector(taskButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_buttons addObject:taskButton];
    [self.view addSubview:taskButton];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[taskButton]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(taskButton)]];
  }
  if ([self.tasks count]) {
    NSDictionary *mapping;
    NSString *layoutString = [NSString stringWithFormat:@"H:|%@", [_buttons layoutConstraintString:kTaskPadding outMapping:&mapping]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:layoutString options:0 metrics:nil views:mapping]];
  }
  [self.view setNeedsUpdateConstraints];
}

- (void)taskButtonClicked:(PXTaskButton *)taskButton {
  [taskButton.task execute];
}

- (NSArray *)tasks {
  if (_hole == nil) {
    return @[];
  }
  NSMutableArray *array = [NSMutableArray array];
  PXTaskFactory *taskFactory = [[PXTaskFactory alloc] init];
  taskFactory.editor = self.editor;
  taskFactory.hole = self.hole;

  PXScopeAnalyzer *analyzer = [[PXScopeAnalyzer alloc] init];
  NSDictionary *identifiers = [analyzer identifiersInScope:self.hole];
  NSArray *allKeys = [[identifiers allKeys] sortedArrayUsingComparator:^(NSString *a, NSString *b) {
    return [a compare:b];
  }];
  for (NSString *identifier in allKeys) {
    PXExpressionType type = ((NSNumber *) identifiers[identifier]).intValue;
    if (self.hole.expressionType & type) {
      [array addObject:[taskFactory createTaskWithClass:[PXIdentifierTask class] name:identifier setup:^(PXIdentifierTask *t) {
        t.identifier = identifier;
        t.type = ((NSNumber *) identifiers[identifier]).intValue;
      }]];
    }
  }
  return array;
}

- (void)refresh {
  [super refresh];
  [self recreateButtons];
}

- (BOOL)hidden {
  return super.hidden || self.tasks.count == 0;
}


@end