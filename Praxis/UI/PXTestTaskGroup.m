#import "PXTestTaskGroup.h"

@implementation PXTestTaskGroup {

}

- (UIView *)createView {
  UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 45)];
  UIView *a = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 45)];
  UIView *b = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 45)];

  a.translatesAutoresizingMaskIntoConstraints = NO;
  b.translatesAutoresizingMaskIntoConstraints = NO;
  a.backgroundColor = [UIColor redColor];
  b.backgroundColor = [UIColor blueColor];
  [view addSubview:a];
  [view addSubview:b];

  [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[a(20)][b(40)]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(a, b)]];
  [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[a]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(a)]];
  [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[b]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(b)]];

  return view;
}


@end