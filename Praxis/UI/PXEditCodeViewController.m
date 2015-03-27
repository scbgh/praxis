#import "PXEditCodeViewController.h"
#import "PXTaskPane.h"
#import "PXCodeEditor.h"
#import "PXTestTaskGroup.h"
#import "PXConstantExpression.h"
#import "PXExpression+PXExpressionHelpers.h"
#import "PXValue.h"
#import "PXIdentifierExpression.h"
#import "PXHoleView.h"
#import "PXHole.h"

@interface PXEditCodeViewController ()

@end

@implementation PXEditCodeViewController {
  UIToolbar *_toolbar;
  PXTaskPane *_taskPane;
  PXCodeEditor *_codeEditor;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.title = @"Edit Source Code";

  // Toolbar
  _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
  _toolbar.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addSubview:_toolbar];

  // Editor
  _codeEditor = [[PXCodeEditor alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
  _codeEditor.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addSubview:_codeEditor];


  // Task pane
  _taskPane = [[PXTaskPane alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
  _taskPane.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addSubview:_taskPane];

  // Constraints
  id topGuide = self.topLayoutGuide;
  id bottomGuide = self.bottomLayoutGuide;
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_toolbar]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_toolbar)]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_taskPane]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_taskPane)]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_codeEditor]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_codeEditor)]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topGuide][_toolbar(44)][_codeEditor][_taskPane][bottomGuide]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_toolbar, _taskPane, _codeEditor, topGuide, bottomGuide)]];

  NSError *error;
  //PXExpression *expr = [PXExpression expressionWithString:@"{ x := int(0); while (true) { y := 7 ; z := \"Hello world\" } }" error:&error];
  PXExpression *expr = [PXExpression expressionWithString:@"" error:&error];
  _codeEditor.rootHoleView.hole.expression = expr;

  _taskPane.taskGroups = @[_codeEditor.insertTaskGroup, _codeEditor.identifierTaskGroup];
}

- (void)selectedHoleViewChanged {
  [_taskPane refresh];
};

@end
