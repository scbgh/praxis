#import "PXScopeAnalyzer.h"
#import "PXExpression.h"
#import "PXHole.h"
#import "PXCompoundExpression.h"
#import "PXAssignmentExpression.h"

@implementation PXScopeAnalyzer

- (NSDictionary *)identifiersInScope:(PXHole *)hole {
  NSMutableDictionary *identifiers = [NSMutableDictionary dictionary];
  PXExpression *scope = hole.parent;
  PXExpression *lastScope = hole.expression;

  while (scope) {
    if ([scope isKindOfClass:[PXCompoundExpression class]]) {
      PXCompoundExpression *compound = (PXCompoundExpression *) scope;
      for (NSUInteger i = 0; i < compound.numberOfSubexpressions && (!lastScope || [compound expressionHoleAtIndex:i].expression != lastScope); i++) {
        PXExpression *subexpression = [compound expressionHoleAtIndex:i].expression;
        if ([subexpression isKindOfClass:[PXAssignmentExpression class]]) {
          PXAssignmentExpression *assignment = (PXAssignmentExpression *) subexpression;
          NSString *identifier = assignment.identifier;
          PXExpressionType type = assignment.valueExpressionHole.expression.type;
          identifiers[identifier] = @(type);
        }
      }
    }
    lastScope = scope;
    scope = scope.hole.parent;
  }
  return identifiers;
}

@end