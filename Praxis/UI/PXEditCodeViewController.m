#import "PXEditCodeViewController.h"
#import "PXTaskPane.h"
#import "PXCodeEditor.h"
#import "PXTestTaskGroup.h"
#import "PXConstantExpression.h"
#import "PXExpression+PXExpressionHelpers.h"
#import "PXValue.h"
#import "PXIdentifierExpression.h"

@interface PXEditCodeViewController ()

@end

@implementation PXEditCodeViewController {
  UIToolbar *toolbar;
  PXTaskPane *taskPane;
  PXCodeEditor *codeEditor;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.title = @"Edit Source Code";

  // Toolbar
  toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
  toolbar.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addSubview:toolbar];

  // Editor
  codeEditor = [[PXCodeEditor alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
  codeEditor.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addSubview:codeEditor];


  // Task pane
  taskPane = [[PXTaskPane alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
  taskPane.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addSubview:taskPane];

  // Constraints
  id topGuide = self.topLayoutGuide;
  id bottomGuide = self.bottomLayoutGuide;
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[toolbar]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(toolbar)]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[taskPane]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(taskPane)]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[codeEditor]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(codeEditor)]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topGuide][toolbar(44)][codeEditor][taskPane(>=44,<=240)][bottomGuide]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(toolbar, taskPane, codeEditor, topGuide, bottomGuide)]];

  NSError *error;
  PXExpression *expr = [PXExpression expressionWithString:@"{ x := int(0); while (true) { y := 7 ; z := \"Hello world\" } }" error:&error];
  codeEditor.expression = expr;

  PXTestTaskGroup *group1 = [PXTestTaskGroup groupWithTitle:@"Group One"];
  PXTestTaskGroup *group2 = [PXTestTaskGroup groupWithTitle:@"Group Two"];
  PXTestTaskGroup *group3 = [PXTestTaskGroup groupWithTitle:@"Group Three"];
  taskPane.taskGroups = @[group1, group2, group3];
};

@end
