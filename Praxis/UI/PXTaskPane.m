#import "PXTaskPane.h"
#import "PXTaskGroup.h"
#import "PXTaskGroupView.h"

@interface PXTaskPane ()
- (void)initialize;
- (void)recreateSubviews;
@end

@implementation PXTaskPane {
  NSArray *_taskGroups;
  UIScrollView *_scrollView;
  UIView *_contentView;
}

@synthesize taskGroups = _taskGroups;

- (void)initialize {
  self.backgroundColor = [UIColor colorWithWhite:247.f/255.f alpha:1.f];

  _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.f, 0.f, 15.f, 15.f)];
  _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
  [self addSubview:_scrollView];

  _contentView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 20.f, 20.f)];
  _contentView.translatesAutoresizingMaskIntoConstraints = NO;
  [_scrollView addSubview:_contentView];

  [self addConstraint:[NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeLeading relatedBy:0 toItem:self attribute:NSLayoutAttributeLeading multiplier:1.f constant:0.f]];
  [self addConstraint:[NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeTrailing relatedBy:0 toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.f constant:0.f]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_contentView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_contentView)]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_contentView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_contentView)]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_scrollView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_scrollView)]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_scrollView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_scrollView)]];
}

- (void)recreateSubviews {
  NSMutableDictionary *bindings = [NSMutableDictionary dictionary];
  NSMutableString *constraintString = [NSMutableString stringWithString:@"V:|"];
  int i = 0;

  [_contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
  [_contentView removeConstraints:_contentView.constraints];
  for (PXTaskGroup *taskGroup in _taskGroups) {
    PXTaskGroupView *taskGroupView = [[PXTaskGroupView alloc] initWithTaskGroup:taskGroup];
    taskGroupView.translatesAutoresizingMaskIntoConstraints = NO;
    [_contentView addSubview:taskGroupView];
    NSString *viewName = [NSString stringWithFormat:@"view%d", i];
    [constraintString appendFormat:@"[%@]", viewName];
    NSString *horizontalConstraint = [NSString stringWithFormat:@"H:|[%@]|", viewName];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:horizontalConstraint options:0 metrics:nil views:@{viewName : taskGroupView}]];
    bindings[viewName] = taskGroupView;
    i++;
  };
  [constraintString appendString:@"|"];
  [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:constraintString options:0 metrics:nil views:bindings]];
  [_contentView setNeedsUpdateConstraints];
}

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self initialize];
  }
  return self;
}

- (void)setTaskGroups:(NSArray *)taskGroups {
  _taskGroups = taskGroups;
  [self recreateSubviews];
}


@end