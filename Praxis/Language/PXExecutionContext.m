#import "PXExecutionContext.h"
#import "PXContinuation.h"

static int ctr = 2000;

@interface PXExecutionContext ()
- (instancetype)initWithParentContext:(PXExecutionContext *)parentContext;
@end

@implementation PXExecutionContext {
  int _id;
  NSMutableString *_output;
  NSMutableDictionary *_environment;
  PXContinuation *_currentContinuation;
}

- (instancetype)commonInit {
  _environment = [NSMutableDictionary dictionary];
  _output = [NSMutableString string];
  self.dbg = [PXDebugContext debugContextWithContext:self];
  self.globalContext = self;
  return self;
}

- (instancetype)initWithParentContext:(PXExecutionContext *)parentContext {
  self = [super init];
  if (self) {
    [self commonInit];
    self.dbg = parentContext.dbg;
    self.globalContext = parentContext.globalContext;
    self.parentContext = parentContext;
  }
  return self;
}

- (instancetype)init {
  self = [super init];
  return [self commonInit];
}

- (PXValue *)lookupVariableNamed:(NSString *)name {
  if (name == nil) {
    return nil;
  }
  PXValue *value = _environment[name];
  if (value == nil) {
    if (self.parentContext != nil) {
      return [self.parentContext lookupVariableNamed:name];
    }
  }
  return value;
}

- (void)assignVariableNamed:(NSString *)name withValue:(PXValue *)value {
  if (self.parentContext != nil && [self.parentContext lookupVariableNamed:name] != nil) {
    [self.parentContext assignVariableNamed:name withValue:value];
  } else {
    [self.dbg logWithFormat:@"┠ assignVariableNamed [ctx=%d, name=%@, value=%@]", self.id, name, value];
    _environment[name] = value;
  }
}

- (PXExecutionContext *)createChildContext {
  PXExecutionContext *child = [[PXExecutionContext alloc] initWithParentContext:self];
  [self.dbg logWithFormat:@"┠ createChildContext [ctx=%d, child=%d]", self.id, child.id];
  return child;
}

- (int)id {
  if (_id == 0) {
    _id = ctr++;
  }
  return _id;
}

- (PXContinuation *)currentContinuation {
  if (self.parentContext) {
    return self.parentContext.currentContinuation;
  }
  return _currentContinuation;
}

- (void)setCurrentContinuation:(PXContinuation *)currentContinuation {
  if (self.parentContext) {
    self.parentContext.currentContinuation = currentContinuation;
  }
  _currentContinuation = currentContinuation;
}

- (void)print:(NSString *)value {
  [_output appendString:value];
}

- (void)println:(NSString *)value {
  [_output appendFormat:@"%@\n", value];
}


@end
