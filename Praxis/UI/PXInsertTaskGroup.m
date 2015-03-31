#import "PXInsertTaskGroup.h"
#import "PXHole.h"
#import "PXInsertTask.h"
#import "PXConditionalExpression.h"
#import "PXAssignmentExpression.h"
#import "PXHoleView.h"
#import "PXHoleView.h"
#import "PXWhileExpression.h"
#import "PXTaskButton.h"
#import "NSArray+PXArrayExtensions.h"
#import "PXVisuals.h"
#import "PXCodeEditor.h"
#import "PXConstantExpression.h"
#import "PXValue.h"
#import "PXExpression+PXExpressionHelpers.h"
#import "PXTaskFactory.h"
#import "PXCompoundExpression.h"
#import "PXInsertAssignmentTask.h"
#import "PXInsertStringTask.h"
#import "PXInsertIntegerTask.h"
#import "PXCallExpression.h"
#import "PXDefaultBuiltins+Decl.h"
#import "PXPrintExpression.h"

@interface PXInsertTaskGroup ()

- (NSArray *)tasks;
- (void)recreateButtons;
- (void)taskButtonClicked:(PXTaskButton *)taskButton;
@end

@implementation PXInsertTaskGroup {
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

- (void)setHole:(PXHole *)hole {
  _hole = hole;
  [self refresh];
}

- (void)recreateButtons {
  [_buttons makeObjectsPerformSelector:@selector(removeFromSuperview)];
  _buttons = [NSMutableArray array];

  for (PXTask *task in self.tasks) {
    PXTaskButton *taskButton = [[PXTaskButton alloc] init];
    [taskButton setTitle:task.name forState:UIControlStateNormal];
    [taskButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
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
  PXInsertTask *task = (PXInsertTask *) taskButton.task;
  [task execute];
}

- (NSArray *)tasks {
  if (_hole == nil) {
    return @[];
  }
  NSMutableArray *array = [NSMutableArray array];
  PXTaskFactory *taskFactory = [[PXTaskFactory alloc] init];
  taskFactory.editor = self.editor;
  taskFactory.hole = self.hole;

  // Statements
  if (_hole.expressionType & PXVoidType) {
    [array addObject:[taskFactory createTaskWithClass:[PXInsertTask class] name:@"if" setup:^(PXInsertTask *task) {
      task.generator = ^{
        return [[PXConditionalExpression alloc] init];
      };
    }]];
    [array addObject:[taskFactory createTaskWithClass:[PXInsertTask class] name:@"while" setup:^(PXInsertTask *task) {
      task.generator = ^{
        return [[PXWhileExpression alloc] init];
      };
    }]];
    [array addObject:[taskFactory createTaskWithClass:[PXInsertTask class] name:@"{ ... }" setup:^(PXInsertTask *task) {
      task.generator = ^{
        return [[PXCompoundExpression alloc] init];
      };
    }]];
    [array addObject:[taskFactory createTaskWithClass:[PXInsertTask class] name:@"print" setup:^(PXInsertTask *task) {
      task.generator = ^{
        PXPrintExpression *expression = [[PXPrintExpression alloc] init];
        expression.newline = NO;
        return expression;
      };
    }]];
    [array addObject:[taskFactory createTaskWithClass:[PXInsertTask class] name:@"println" setup:^(PXInsertTask *task) {
      task.generator = ^{
        PXPrintExpression *expression = [[PXPrintExpression alloc] init];
        expression.newline = YES;
        return expression;
      };
    }]];
    [array addObject:[taskFactory createTaskWithClass:[PXInsertAssignmentTask class] name:@":=" setup:nil]];
  }

  // Boolean expressions
  if (_hole.expressionType & PXBooleanType) {
    [array addObject:[taskFactory createTaskWithClass:[PXInsertTask class] name:@"true" setup:^(PXInsertTask *task) {
      task.generator = ^{
        return [PXExpression constantWithValue:[PXValue valueWithBool:YES]];
      };
    }]];
    [array addObject:[taskFactory createTaskWithClass:[PXInsertTask class] name:@"false" setup:^(PXInsertTask *task) {
      task.generator = ^{
        return [PXExpression constantWithValue:[PXValue valueWithBool:NO]];
      };
    }]];
    [array addObject:[taskFactory createTaskWithClass:[PXInsertTask class] name:@"<" setup:^(PXInsertTask *task) {
      task.generator = ^{
        return [PXExpression callWithBuiltin:builtin_lt arguments:nil returnType:PXBooleanType];
      };
    }]];
    [array addObject:[taskFactory createTaskWithClass:[PXInsertTask class] name:@"<=" setup:^(PXInsertTask *task) {
      task.generator = ^{
        return [PXExpression callWithBuiltin:builtin_lte arguments:nil returnType:PXBooleanType];
      };
    }]];
    [array addObject:[taskFactory createTaskWithClass:[PXInsertTask class] name:@"==" setup:^(PXInsertTask *task) {
      task.generator = ^{
        return [PXExpression callWithBuiltin:builtin_eq arguments:nil returnType:PXBooleanType];
      };
    }]];
    [array addObject:[taskFactory createTaskWithClass:[PXInsertTask class] name:@">=" setup:^(PXInsertTask *task) {
      task.generator = ^{
        return [PXExpression callWithBuiltin:builtin_gte arguments:nil returnType:PXBooleanType];
      };
    }]];
    [array addObject:[taskFactory createTaskWithClass:[PXInsertTask class] name:@">" setup:^(PXInsertTask *task) {
      task.generator = ^{
        return [PXExpression callWithBuiltin:builtin_gt arguments:nil returnType:PXBooleanType];
      };
    }]];
  }

  // String expressions
  if (_hole.expressionType & PXStringType) {
    [array addObject:[taskFactory createTaskWithClass:[PXInsertStringTask class] name:@"\"...\"" setup:nil]];
  }

  // Integer expressions
  if (_hole.expressionType & PXIntegerType) {
    [array addObject:[taskFactory createTaskWithClass:[PXInsertIntegerTask class] name:@"123" setup:nil]];
    [array addObject:[taskFactory createTaskWithClass:[PXInsertTask class] name:@"+" setup:^(PXInsertTask *task) {
      task.generator = ^{
        return [PXExpression callWithBuiltin:builtin_add arguments:nil returnType:PXIntegerType];
      };
    }]];
    [array addObject:[taskFactory createTaskWithClass:[PXInsertTask class] name:@"-" setup:^(PXInsertTask *task) {
      task.generator = ^{
        return [PXExpression callWithBuiltin:builtin_sub arguments:nil returnType:PXIntegerType];
      };
    }]];
    [array addObject:[taskFactory createTaskWithClass:[PXInsertTask class] name:@"*" setup:^(PXInsertTask *task) {
      task.generator = ^{
        return [PXExpression callWithBuiltin:builtin_mul arguments:nil returnType:PXIntegerType];
      };
    }]];
    [array addObject:[taskFactory createTaskWithClass:[PXInsertTask class] name:@"/" setup:^(PXInsertTask *task) {
      task.generator = ^{
        return [PXExpression callWithBuiltin:builtin_div arguments:nil returnType:PXIntegerType];
      };
    }]];
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