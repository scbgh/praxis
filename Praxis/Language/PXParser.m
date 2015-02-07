#import "PXParser.h"
#import <PEGKit/PEGKit.h>


@interface PXParser ()

@property (nonatomic, retain) NSMutableDictionary *expr_memo;
@property (nonatomic, retain) NSMutableDictionary *compoundExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *constantExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *identifierExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *assignmentExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *conditionalExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *elsePart_memo;
@property (nonatomic, retain) NSMutableDictionary *callExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *whileExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *function_memo;
@property (nonatomic, retain) NSMutableDictionary *arg_memo;
@property (nonatomic, retain) NSMutableDictionary *liststart_memo;
@property (nonatomic, retain) NSMutableDictionary *intLiteral_memo;
@property (nonatomic, retain) NSMutableDictionary *floatLiteral_memo;
@property (nonatomic, retain) NSMutableDictionary *stringLiteral_memo;
@property (nonatomic, retain) NSMutableDictionary *boolLiteral_memo;
@property (nonatomic, retain) NSMutableDictionary *unitLiteral_memo;
@property (nonatomic, retain) NSMutableDictionary *valueTypeName_memo;
@property (nonatomic, retain) NSMutableDictionary *typeName_memo;
@property (nonatomic, retain) NSMutableDictionary *intType_memo;
@property (nonatomic, retain) NSMutableDictionary *floatType_memo;
@property (nonatomic, retain) NSMutableDictionary *boolType_memo;
@property (nonatomic, retain) NSMutableDictionary *stringType_memo;
@property (nonatomic, retain) NSMutableDictionary *unitType_memo;
@property (nonatomic, retain) NSMutableDictionary *functionType_memo;
@property (nonatomic, retain) NSMutableDictionary *numericType_memo;
@property (nonatomic, retain) NSMutableDictionary *scalarType_memo;
@property (nonatomic, retain) NSMutableDictionary *valueType_memo;
@property (nonatomic, retain) NSMutableDictionary *anyType_memo;
@property (nonatomic, retain) NSMutableDictionary *identifier_memo;
@end

@implementation PXParser { }

- (instancetype)initWithDelegate:(id)d {
    self = [super initWithDelegate:d];
    if (self) {
        
        self.startRuleName = @"expr";
        self.tokenKindTab[@","] = @(PXPARSER_TOKEN_KIND_COMMA);
        self.tokenKindTab[@"true"] = @(PXPARSER_TOKEN_KIND_TRUE);
        self.tokenKindTab[@";"] = @(PXPARSER_TOKEN_KIND_SEMI_COLON);
        self.tokenKindTab[@"any"] = @(PXPARSER_TOKEN_KIND_ANYTYPE);
        self.tokenKindTab[@"while"] = @(PXPARSER_TOKEN_KIND_WHILE);
        self.tokenKindTab[@"void"] = @(PXPARSER_TOKEN_KIND_UNITTYPE);
        self.tokenKindTab[@"scalar"] = @(PXPARSER_TOKEN_KIND_SCALARTYPE);
        self.tokenKindTab[@"bool"] = @(PXPARSER_TOKEN_KIND_BOOLTYPE);
        self.tokenKindTab[@"fun"] = @(PXPARSER_TOKEN_KIND_FUN);
        self.tokenKindTab[@"["] = @(PXPARSER_TOKEN_KIND_OPEN_BRACKET);
        self.tokenKindTab[@"int"] = @(PXPARSER_TOKEN_KIND_INT);
        self.tokenKindTab[@"false"] = @(PXPARSER_TOKEN_KIND_FALSE);
        self.tokenKindTab[@"number"] = @(PXPARSER_TOKEN_KIND_NUMERICTYPE);
        self.tokenKindTab[@"]"] = @(PXPARSER_TOKEN_KIND_CLOSE_BRACKET);
        self.tokenKindTab[@"float"] = @(PXPARSER_TOKEN_KIND_FLOATTYPE);
        self.tokenKindTab[@"("] = @(PXPARSER_TOKEN_KIND_OPEN_PAREN);
        self.tokenKindTab[@":="] = @(PXPARSER_TOKEN_KIND_ASSIGN);
        self.tokenKindTab[@"else"] = @(PXPARSER_TOKEN_KIND_ELSE);
        self.tokenKindTab[@"unit"] = @(PXPARSER_TOKEN_KIND_UNITLITERAL);
        self.tokenKindTab[@"if"] = @(PXPARSER_TOKEN_KIND_IF);
        self.tokenKindTab[@"{"] = @(PXPARSER_TOKEN_KIND_OPEN_CURLY);
        self.tokenKindTab[@")"] = @(PXPARSER_TOKEN_KIND_CLOSE_PAREN);
        self.tokenKindTab[@"value"] = @(PXPARSER_TOKEN_KIND_VALUETYPE);
        self.tokenKindTab[@"string"] = @(PXPARSER_TOKEN_KIND_STRINGTYPE);
        self.tokenKindTab[@"}"] = @(PXPARSER_TOKEN_KIND_CLOSE_CURLY);

        self.tokenKindNameTab[PXPARSER_TOKEN_KIND_COMMA] = @",";
        self.tokenKindNameTab[PXPARSER_TOKEN_KIND_TRUE] = @"true";
        self.tokenKindNameTab[PXPARSER_TOKEN_KIND_SEMI_COLON] = @";";
        self.tokenKindNameTab[PXPARSER_TOKEN_KIND_ANYTYPE] = @"any";
        self.tokenKindNameTab[PXPARSER_TOKEN_KIND_WHILE] = @"while";
        self.tokenKindNameTab[PXPARSER_TOKEN_KIND_UNITTYPE] = @"void";
        self.tokenKindNameTab[PXPARSER_TOKEN_KIND_SCALARTYPE] = @"scalar";
        self.tokenKindNameTab[PXPARSER_TOKEN_KIND_BOOLTYPE] = @"bool";
        self.tokenKindNameTab[PXPARSER_TOKEN_KIND_FUN] = @"fun";
        self.tokenKindNameTab[PXPARSER_TOKEN_KIND_OPEN_BRACKET] = @"[";
        self.tokenKindNameTab[PXPARSER_TOKEN_KIND_INT] = @"int";
        self.tokenKindNameTab[PXPARSER_TOKEN_KIND_FALSE] = @"false";
        self.tokenKindNameTab[PXPARSER_TOKEN_KIND_NUMERICTYPE] = @"number";
        self.tokenKindNameTab[PXPARSER_TOKEN_KIND_CLOSE_BRACKET] = @"]";
        self.tokenKindNameTab[PXPARSER_TOKEN_KIND_FLOATTYPE] = @"float";
        self.tokenKindNameTab[PXPARSER_TOKEN_KIND_OPEN_PAREN] = @"(";
        self.tokenKindNameTab[PXPARSER_TOKEN_KIND_ASSIGN] = @":=";
        self.tokenKindNameTab[PXPARSER_TOKEN_KIND_ELSE] = @"else";
        self.tokenKindNameTab[PXPARSER_TOKEN_KIND_UNITLITERAL] = @"unit";
        self.tokenKindNameTab[PXPARSER_TOKEN_KIND_IF] = @"if";
        self.tokenKindNameTab[PXPARSER_TOKEN_KIND_OPEN_CURLY] = @"{";
        self.tokenKindNameTab[PXPARSER_TOKEN_KIND_CLOSE_PAREN] = @")";
        self.tokenKindNameTab[PXPARSER_TOKEN_KIND_VALUETYPE] = @"value";
        self.tokenKindNameTab[PXPARSER_TOKEN_KIND_STRINGTYPE] = @"string";
        self.tokenKindNameTab[PXPARSER_TOKEN_KIND_CLOSE_CURLY] = @"}";

        self.expr_memo = [NSMutableDictionary dictionary];
        self.compoundExpr_memo = [NSMutableDictionary dictionary];
        self.constantExpr_memo = [NSMutableDictionary dictionary];
        self.identifierExpr_memo = [NSMutableDictionary dictionary];
        self.assignmentExpr_memo = [NSMutableDictionary dictionary];
        self.conditionalExpr_memo = [NSMutableDictionary dictionary];
        self.elsePart_memo = [NSMutableDictionary dictionary];
        self.callExpr_memo = [NSMutableDictionary dictionary];
        self.whileExpr_memo = [NSMutableDictionary dictionary];
        self.function_memo = [NSMutableDictionary dictionary];
        self.arg_memo = [NSMutableDictionary dictionary];
        self.liststart_memo = [NSMutableDictionary dictionary];
        self.intLiteral_memo = [NSMutableDictionary dictionary];
        self.floatLiteral_memo = [NSMutableDictionary dictionary];
        self.stringLiteral_memo = [NSMutableDictionary dictionary];
        self.boolLiteral_memo = [NSMutableDictionary dictionary];
        self.unitLiteral_memo = [NSMutableDictionary dictionary];
        self.valueTypeName_memo = [NSMutableDictionary dictionary];
        self.typeName_memo = [NSMutableDictionary dictionary];
        self.intType_memo = [NSMutableDictionary dictionary];
        self.floatType_memo = [NSMutableDictionary dictionary];
        self.boolType_memo = [NSMutableDictionary dictionary];
        self.stringType_memo = [NSMutableDictionary dictionary];
        self.unitType_memo = [NSMutableDictionary dictionary];
        self.functionType_memo = [NSMutableDictionary dictionary];
        self.numericType_memo = [NSMutableDictionary dictionary];
        self.scalarType_memo = [NSMutableDictionary dictionary];
        self.valueType_memo = [NSMutableDictionary dictionary];
        self.anyType_memo = [NSMutableDictionary dictionary];
        self.identifier_memo = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)clearMemo {
    [_expr_memo removeAllObjects];
    [_compoundExpr_memo removeAllObjects];
    [_constantExpr_memo removeAllObjects];
    [_identifierExpr_memo removeAllObjects];
    [_assignmentExpr_memo removeAllObjects];
    [_conditionalExpr_memo removeAllObjects];
    [_elsePart_memo removeAllObjects];
    [_callExpr_memo removeAllObjects];
    [_whileExpr_memo removeAllObjects];
    [_function_memo removeAllObjects];
    [_arg_memo removeAllObjects];
    [_liststart_memo removeAllObjects];
    [_intLiteral_memo removeAllObjects];
    [_floatLiteral_memo removeAllObjects];
    [_stringLiteral_memo removeAllObjects];
    [_boolLiteral_memo removeAllObjects];
    [_unitLiteral_memo removeAllObjects];
    [_valueTypeName_memo removeAllObjects];
    [_typeName_memo removeAllObjects];
    [_intType_memo removeAllObjects];
    [_floatType_memo removeAllObjects];
    [_boolType_memo removeAllObjects];
    [_stringType_memo removeAllObjects];
    [_unitType_memo removeAllObjects];
    [_functionType_memo removeAllObjects];
    [_numericType_memo removeAllObjects];
    [_scalarType_memo removeAllObjects];
    [_valueType_memo removeAllObjects];
    [_anyType_memo removeAllObjects];
    [_identifier_memo removeAllObjects];
}

- (void)start {
    [self execute:^{
    
    [self.tokenizer.symbolState add:@":="];
    [self.tokenizer setTokenizerState:self.tokenizer.wordState from:'_' to:'_'];

    }];

    [self expr_]; 
    [self matchEOF:YES]; 

}

- (void)__expr {
    
    if ([self speculate:^{ [self conditionalExpr_]; }]) {
        [self conditionalExpr_]; 
    } else if ([self speculate:^{ [self callExpr_]; }]) {
        [self callExpr_]; 
    } else if ([self speculate:^{ [self compoundExpr_]; }]) {
        [self compoundExpr_]; 
    } else if ([self speculate:^{ [self constantExpr_]; }]) {
        [self constantExpr_]; 
    } else if ([self speculate:^{ [self assignmentExpr_]; }]) {
        [self assignmentExpr_]; 
    } else if ([self speculate:^{ [self identifierExpr_]; }]) {
        [self identifierExpr_]; 
    } else if ([self speculate:^{ [self whileExpr_]; }]) {
        [self whileExpr_]; 
    } else if ([self speculate:^{ [self function_]; }]) {
        [self function_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'expr'."];
    }

}

- (void)expr_ {
    [self parseRule:@selector(__expr) withMemo:_expr_memo];
}

- (void)__compoundExpr {
    
    [self match:PXPARSER_TOKEN_KIND_OPEN_CURLY discard:YES]; 
    [self liststart_]; 
    [self expr_]; 
    while ([self speculate:^{ [self match:PXPARSER_TOKEN_KIND_SEMI_COLON discard:YES]; [self expr_]; }]) {
        [self match:PXPARSER_TOKEN_KIND_SEMI_COLON discard:YES]; 
        [self expr_]; 
    }
    [self match:PXPARSER_TOKEN_KIND_CLOSE_CURLY discard:YES]; 
    [self execute:^{
    
    NSArray *exprs = [[self.assembly objectsAbove:@"$liststart"] reversedArray];
    POP();
    PUSH([PXExpression compoundWithExpressions:exprs]);

    }];

}

- (void)compoundExpr_ {
    [self parseRule:@selector(__compoundExpr) withMemo:_compoundExpr_memo];
}

- (void)__constantExpr {
    
    if ([self predicts:PXPARSER_TOKEN_KIND_INT, 0]) {
        [self intLiteral_]; 
    } else if ([self predicts:TOKEN_KIND_BUILTIN_NUMBER, 0]) {
        [self floatLiteral_]; 
    } else if ([self predicts:TOKEN_KIND_BUILTIN_QUOTEDSTRING, 0]) {
        [self stringLiteral_]; 
    } else if ([self predicts:PXPARSER_TOKEN_KIND_FALSE, PXPARSER_TOKEN_KIND_TRUE, 0]) {
        [self boolLiteral_]; 
    } else if ([self predicts:PXPARSER_TOKEN_KIND_UNITLITERAL, 0]) {
        [self unitLiteral_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'constantExpr'."];
    }

}

- (void)constantExpr_ {
    [self parseRule:@selector(__constantExpr) withMemo:_constantExpr_memo];
}

- (void)__identifierExpr {
    
    [self identifier_]; 
    [self execute:^{
    
    PUSH([PXExpression identifierWithName:POP_STR()]);

    }];

}

- (void)identifierExpr_ {
    [self parseRule:@selector(__identifierExpr) withMemo:_identifierExpr_memo];
}

- (void)__assignmentExpr {
    
    [self testAndThrow:(id)^{ return [LS(2) isEqual:@":="]; }]; 
    [self identifier_]; 
    [self match:PXPARSER_TOKEN_KIND_ASSIGN discard:YES]; 
    [self expr_]; 
    [self execute:^{
    
    PXExpression *expr = POP();
    PUSH([PXExpression assignmentWithIdentifierName:POP_STR() expression:expr]);

    }];

}

- (void)assignmentExpr_ {
    [self parseRule:@selector(__assignmentExpr) withMemo:_assignmentExpr_memo];
}

- (void)__conditionalExpr {
    
    [self match:PXPARSER_TOKEN_KIND_IF discard:YES]; 
    [self match:PXPARSER_TOKEN_KIND_OPEN_PAREN discard:YES]; 
    [self expr_]; 
    [self match:PXPARSER_TOKEN_KIND_CLOSE_PAREN discard:YES]; 
    [self expr_]; 
    [self elsePart_]; 
    [self execute:^{
    
    id last = POP();
    PXExpression *falseExpr;
    PXExpression *trueExpr;
    if ([last isEqual:@"$haselse"]) {
        falseExpr = POP();
        trueExpr = POP();
    } else {
        trueExpr = last;
    }

    PXExpression *conditionExpr = POP();
    PUSH([PXExpression conditionalWithCondition:conditionExpr trueExpression:trueExpr falseExpression:falseExpr]);

    }];

}

- (void)conditionalExpr_ {
    [self parseRule:@selector(__conditionalExpr) withMemo:_conditionalExpr_memo];
}

- (void)__elsePart {
    
    [self match:PXPARSER_TOKEN_KIND_ELSE discard:YES]; 
    [self expr_]; 
    [self execute:^{
    
    PUSH(@"$haselse");

    }];

}

- (void)elsePart_ {
    [self parseRule:@selector(__elsePart) withMemo:_elsePart_memo];
}

- (void)__callExpr {
    
    [self testAndThrow:(id)^{ return [LS(2) isEqual:@"("]; }]; 
    [self identifier_]; 
    [self match:PXPARSER_TOKEN_KIND_OPEN_PAREN discard:YES]; 
    [self liststart_]; 
    if ([self speculate:^{ [self expr_]; while ([self speculate:^{ [self match:PXPARSER_TOKEN_KIND_COMMA discard:YES]; [self expr_]; }]) {[self match:PXPARSER_TOKEN_KIND_COMMA discard:YES]; [self expr_]; }}]) {
        [self expr_]; 
        while ([self speculate:^{ [self match:PXPARSER_TOKEN_KIND_COMMA discard:YES]; [self expr_]; }]) {
            [self match:PXPARSER_TOKEN_KIND_COMMA discard:YES]; 
            [self expr_]; 
        }
    }
    [self match:PXPARSER_TOKEN_KIND_CLOSE_PAREN discard:YES]; 
    [self match:PXPARSER_TOKEN_KIND_OPEN_BRACKET discard:YES]; 
    [self valueTypeName_]; 
    [self match:PXPARSER_TOKEN_KIND_CLOSE_BRACKET discard:YES]; 
    [self execute:^{
    
    PXExpressionType type = POP_INT();
    NSArray *args = [[self.assembly objectsAbove:@"$liststart"] reversedArray];
    POP();
    NSString *ident = POP_STR();
    PUSH([PXExpression callWithIdentifier:ident arguments:args returnType:type]);

    }];

}

- (void)callExpr_ {
    [self parseRule:@selector(__callExpr) withMemo:_callExpr_memo];
}

- (void)__whileExpr {
    
    [self match:PXPARSER_TOKEN_KIND_WHILE discard:YES]; 
    [self match:PXPARSER_TOKEN_KIND_OPEN_PAREN discard:YES]; 
    [self expr_]; 
    [self match:PXPARSER_TOKEN_KIND_CLOSE_PAREN discard:YES]; 
    [self expr_]; 
    [self execute:^{
    
    PXExpression *bodyExpr = POP();
    PXExpression *conditionExpr = POP();
    PUSH([PXExpression whileLoopWithCondition:conditionExpr body:bodyExpr]);

    }];

}

- (void)whileExpr_ {
    [self parseRule:@selector(__whileExpr) withMemo:_whileExpr_memo];
}

- (void)__function {
    
    [self match:PXPARSER_TOKEN_KIND_FUN discard:YES]; 
    [self match:PXPARSER_TOKEN_KIND_OPEN_PAREN discard:YES]; 
    [self liststart_]; 
    if ([self speculate:^{ [self arg_]; while ([self speculate:^{ [self match:PXPARSER_TOKEN_KIND_COMMA discard:YES]; [self arg_]; }]) {[self match:PXPARSER_TOKEN_KIND_COMMA discard:YES]; [self arg_]; }}]) {
        [self arg_]; 
        while ([self speculate:^{ [self match:PXPARSER_TOKEN_KIND_COMMA discard:YES]; [self arg_]; }]) {
            [self match:PXPARSER_TOKEN_KIND_COMMA discard:YES]; 
            [self arg_]; 
        }
    }
    [self match:PXPARSER_TOKEN_KIND_CLOSE_PAREN discard:YES]; 
    [self match:PXPARSER_TOKEN_KIND_OPEN_BRACKET discard:YES]; 
    [self expr_]; 
    [self match:PXPARSER_TOKEN_KIND_CLOSE_BRACKET discard:YES]; 
    [self execute:^{
    
    PXExpression *expr = POP();
    NSArray *args = [[self.assembly objectsAbove:@"$liststart"] reversedArray];
    PXFunction *function = [PXFunction functionWithArguments:args body:expr];
    POP();
    PUSH([PXExpression constantWithValue:[PXValue valueWithFunction:function]]);

    }];

}

- (void)function_ {
    [self parseRule:@selector(__function) withMemo:_function_memo];
}

- (void)__arg {
    
    [self identifier_]; 
    [self valueTypeName_]; 
    [self execute:^{
    
    PXExpressionType type = POP_INT();
    PUSH([PXArgument argumentWithName:POP_STR() type:type]);

    }];

}

- (void)arg_ {
    [self parseRule:@selector(__arg) withMemo:_arg_memo];
}

- (void)__liststart {
    
    [self matchEmpty:NO]; 
    [self execute:^{
    
    PUSH(@"$liststart");

    }];

}

- (void)liststart_ {
    [self parseRule:@selector(__liststart) withMemo:_liststart_memo];
}

- (void)__intLiteral {
    
    [self match:PXPARSER_TOKEN_KIND_INT discard:YES]; 
    [self match:PXPARSER_TOKEN_KIND_OPEN_PAREN discard:YES]; 
    [self matchNumber:NO]; 
    [self execute:^{
     PUSH_INT(POP_DOUBLE()); 
    }];
    [self match:PXPARSER_TOKEN_KIND_CLOSE_PAREN discard:YES]; 
    [self execute:^{
    
    PUSH([PXExpression constantWithValue:[PXValue valueWithInt:POP_INT()]]);

    }];

}

- (void)intLiteral_ {
    [self parseRule:@selector(__intLiteral) withMemo:_intLiteral_memo];
}

- (void)__floatLiteral {
    
    [self matchNumber:NO]; 
    [self execute:^{
    
    PUSH([PXExpression constantWithValue:[PXValue valueWithDouble:POP_DOUBLE()]]);

    }];

}

- (void)floatLiteral_ {
    [self parseRule:@selector(__floatLiteral) withMemo:_floatLiteral_memo];
}

- (void)__stringLiteral {
    
    [self matchQuotedString:NO]; 
    [self execute:^{
    
    PUSH([PXExpression constantWithValue:[PXValue valueWithString:POP_STR()]]);

    }];

}

- (void)stringLiteral_ {
    [self parseRule:@selector(__stringLiteral) withMemo:_stringLiteral_memo];
}

- (void)__boolLiteral {
    
    if ([self predicts:PXPARSER_TOKEN_KIND_TRUE, 0]) {
        [self match:PXPARSER_TOKEN_KIND_TRUE discard:NO]; 
    } else if ([self predicts:PXPARSER_TOKEN_KIND_FALSE, 0]) {
        [self match:PXPARSER_TOKEN_KIND_FALSE discard:NO]; 
    } else {
        [self raise:@"No viable alternative found in rule 'boolLiteral'."];
    }
    [self execute:^{
    
    PUSH([PXExpression constantWithValue:[PXValue valueWithBool:[POP_STR() isEqualToString:@"true"]]]);

    }];

}

- (void)boolLiteral_ {
    [self parseRule:@selector(__boolLiteral) withMemo:_boolLiteral_memo];
}

- (void)__unitLiteral {
    
    [self match:PXPARSER_TOKEN_KIND_UNITLITERAL discard:NO]; 
    [self execute:^{
    
    PUSH([PXExpression constantWithValue:[PXValue unitValue]]);

    }];

}

- (void)unitLiteral_ {
    [self parseRule:@selector(__unitLiteral) withMemo:_unitLiteral_memo];
}

- (void)__valueTypeName {
    
    if ([self predicts:PXPARSER_TOKEN_KIND_INT, 0]) {
        [self intType_]; 
    } else if ([self predicts:PXPARSER_TOKEN_KIND_FLOATTYPE, 0]) {
        [self floatType_]; 
    } else if ([self predicts:PXPARSER_TOKEN_KIND_BOOLTYPE, 0]) {
        [self boolType_]; 
    } else if ([self predicts:PXPARSER_TOKEN_KIND_STRINGTYPE, 0]) {
        [self stringType_]; 
    } else if ([self predicts:PXPARSER_TOKEN_KIND_NUMERICTYPE, 0]) {
        [self numericType_]; 
    } else if ([self predicts:PXPARSER_TOKEN_KIND_FUN, 0]) {
        [self functionType_]; 
    } else if ([self predicts:PXPARSER_TOKEN_KIND_SCALARTYPE, 0]) {
        [self scalarType_]; 
    } else if ([self predicts:PXPARSER_TOKEN_KIND_VALUETYPE, 0]) {
        [self valueType_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'valueTypeName'."];
    }

}

- (void)valueTypeName_ {
    [self parseRule:@selector(__valueTypeName) withMemo:_valueTypeName_memo];
}

- (void)__typeName {
    
    if ([self predicts:PXPARSER_TOKEN_KIND_BOOLTYPE, PXPARSER_TOKEN_KIND_FLOATTYPE, PXPARSER_TOKEN_KIND_FUN, PXPARSER_TOKEN_KIND_INT, PXPARSER_TOKEN_KIND_NUMERICTYPE, PXPARSER_TOKEN_KIND_SCALARTYPE, PXPARSER_TOKEN_KIND_STRINGTYPE, PXPARSER_TOKEN_KIND_VALUETYPE, 0]) {
        [self valueTypeName_]; 
    } else if ([self predicts:PXPARSER_TOKEN_KIND_ANYTYPE, 0]) {
        [self anyType_]; 
    } else if ([self predicts:PXPARSER_TOKEN_KIND_UNITTYPE, 0]) {
        [self unitType_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'typeName'."];
    }

}

- (void)typeName_ {
    [self parseRule:@selector(__typeName) withMemo:_typeName_memo];
}

- (void)__intType {
    
    [self match:PXPARSER_TOKEN_KIND_INT discard:YES]; 
    [self execute:^{
    
    PUSH_INT(PXIntegerType);

    }];

}

- (void)intType_ {
    [self parseRule:@selector(__intType) withMemo:_intType_memo];
}

- (void)__floatType {
    
    [self match:PXPARSER_TOKEN_KIND_FLOATTYPE discard:YES]; 
    [self execute:^{
    
    PUSH_INT(PXFloatType);

    }];

}

- (void)floatType_ {
    [self parseRule:@selector(__floatType) withMemo:_floatType_memo];
}

- (void)__boolType {
    
    [self match:PXPARSER_TOKEN_KIND_BOOLTYPE discard:YES]; 
    [self execute:^{
    
    PUSH_INT(PXBooleanType);

    }];

}

- (void)boolType_ {
    [self parseRule:@selector(__boolType) withMemo:_boolType_memo];
}

- (void)__stringType {
    
    [self match:PXPARSER_TOKEN_KIND_STRINGTYPE discard:YES]; 
    [self execute:^{
    
    PUSH_INT(PXStringType);

    }];

}

- (void)stringType_ {
    [self parseRule:@selector(__stringType) withMemo:_stringType_memo];
}

- (void)__unitType {
    
    [self match:PXPARSER_TOKEN_KIND_UNITTYPE discard:YES]; 
    [self execute:^{
    
    PUSH_INT(PXVoidType);

    }];

}

- (void)unitType_ {
    [self parseRule:@selector(__unitType) withMemo:_unitType_memo];
}

- (void)__functionType {
    
    [self match:PXPARSER_TOKEN_KIND_FUN discard:YES]; 
    [self execute:^{
    
    PUSH_INT(PXFunctionType);

    }];

}

- (void)functionType_ {
    [self parseRule:@selector(__functionType) withMemo:_functionType_memo];
}

- (void)__numericType {
    
    [self match:PXPARSER_TOKEN_KIND_NUMERICTYPE discard:YES]; 
    [self execute:^{
    
    PUSH_INT(PXNumericType);

    }];

}

- (void)numericType_ {
    [self parseRule:@selector(__numericType) withMemo:_numericType_memo];
}

- (void)__scalarType {
    
    [self match:PXPARSER_TOKEN_KIND_SCALARTYPE discard:YES]; 
    [self execute:^{
    
    PUSH_INT(PXScalarType);

    }];

}

- (void)scalarType_ {
    [self parseRule:@selector(__scalarType) withMemo:_scalarType_memo];
}

- (void)__valueType {
    
    [self match:PXPARSER_TOKEN_KIND_VALUETYPE discard:YES]; 
    [self execute:^{
    
    PUSH_INT(PXValueType);

    }];

}

- (void)valueType_ {
    [self parseRule:@selector(__valueType) withMemo:_valueType_memo];
}

- (void)__anyType {
    
    [self match:PXPARSER_TOKEN_KIND_ANYTYPE discard:YES]; 
    [self execute:^{
    
    PUSH_INT(PXAnyType);

    }];

}

- (void)anyType_ {
    [self parseRule:@selector(__anyType) withMemo:_anyType_memo];
}

- (void)__identifier {
    
    [self matchWord:NO]; 

}

- (void)identifier_ {
    [self parseRule:@selector(__identifier) withMemo:_identifier_memo];
}

@end