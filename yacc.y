%{
    #include <stdio.h>
    #include <string.h>
    #define print(x) //printf(" ");printf(x);printf("\n");
    int error_count = 0, tab = 0;
    int tabdown() {
        tab++; return tab;
    }
    int tabup() {
        tab--; return tab;
    }
%}

%token _SEMICOLON _COMMA _DOT _STAR _LBRACKET _RBRACKET _LBRACE _RBRACE _LPAREN _RPAREN _ENDOFFILE
%token _IMPORT _TYPE _CLASS _EXTENDS _TITLE _ID _BOOLOP _RELOP _OP _UNOP _ACC_MOD _NON_ACC_MOD
%token _IS _SIGN _NUM _DOUBLE _CHAR _NCHAR _STRING _RETURN _BREAK _CONTINUE _IF _ELSE _WHILE _FOR _SWITCH _CASE _DEFAULT _COLON _TRY _CATCH _FINALLY
%%
start   : declarations _ENDOFFILE ;




declarations    : declarations modifiers methodDeclaration
                | declarations modifiers dataDeclaration
                |
;
dataDeclaration     : type names _SEMICOLON ;
methodDeclaration   : type name _LPAREN methodParameters _RPAREN _LBRACE methodDefinition _RBRACE ;
methodParameters    : methodParameters _COMMA type name | type name | ;
methodDefinition    : statements ;
statements          : statements statement | statement | ;
statement           : if_else | whileloop | forloop | breakstatement | returnstatement | assignment | idlestatement  


idlestatement       : value _SEMICOLON ;
returnstatement     : _RETURN value _SEMICOLON | _RETURN _SEMICOLON ;
breakstatement      : _BREAK _SEMICOLON ;
breakstatement      : _CONTINUE _SEMICOLON ;
assignment          : derived _IS initialized _SEMICOLON ;

if_else              : if_statement ;
if_statement         : _IF _LPAREN conditions _RPAREN body elseif_statement ;
elseif_statement     : elseif_statement _ELSE _IF _LPAREN conditions _RPAREN body | _ELSE _IF _LPAREN conditions _RPAREN body | elsestatement ;
elsestatement       : _ELSE body | ;

whileloop           : _WHILE _LPAREN conditions _RPAREN body ;

forloop             : _FOR _LPAREN stat1 _SEMICOLON stat2 _SEMICOLON stat3 _RPAREN body;
stat1               : assignment | idlestatement | data_forloop |;
stat2               : assignment | idlestatement | conditions | ;
stat3               : derived _IS initialized | value | ;
data_forloop        : modifiers type names ;

conditions          : conditions _BOOLOP condition | _LPAREN conditions _RPAREN | condition | ;
condition           : _LPAREN conditions _RPAREN | _LPAREN condition _RPAREN | relation _RELOP relation | relation ;
relation            : relation _OP value | value ;

body                : _LBRACE body _RBRACE | statement | _LBRACE statements _RBRACE | _LBRACE _RBRACE ;

type        : type _LBRACKET _RBRACKET | _TYPE | _TITLE ;
names       : names _COMMA name _IS value | names _COMMA name | name _IS value | name ;
name        : name _LBRACKET _NUM _RBRACKET | _ID | _TITLE | _ID _DOT _ID ;
modifiers   : _ACC_MOD | _NON_ACC_MOD | _ACC_MOD _NON_ACC_MOD | ;

value       : derived | initialized ;
derived     : derived _UNOP | derived _DOT _ID _LPAREN anything _RPAREN | derived _DOT _ID | _ID | derived _DOT _TITLE | _TITLE | derived _LBRACKET _RBRACKET | derived _LBRACKET _NUM _RBRACKET ;
initialized : _NUM | _DOUBLE | _OP _NUM | _OP _DOUBLE | _STRING | _CHAR | _NCHAR {yyerror("not a valid character");};
anything    : anything value | anything _OP | ;
%%

int yyerror(char *s) {
    printf("\nERROR: %s", s);
    error_count++;
    return 0;
}

int main(int argc, char** argv) {
    yyparse();
    return 0;
}
