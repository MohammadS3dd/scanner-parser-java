%{
    #include <string.h>
    #include "y.tab.h"
    #define printyyt(x) printf(x, yytext)
    int line = 1;
%}

letter                      [a-zA-Z]
digit                       [0-9]
anychar                     {letter}|{digit}|"_"
space                       [ \t\n]+
paragraphComments           "/*"(.|\n)*"*/"
lineComments                "//".*\n
primitive                   "void"|"boolean"|"byte"|"short"|"int"|"long"|"float"|"double"|"char"
accessModifiers             "public"|"protected"|"private"
nonAccessModifiers          "static"|"final"|"abstract"|"volatile"
title                       [A-Z]{anychar}*
id                          {letter}({anychar})*
signedint                   {digit}+
double                      {digit}+"."{digit}*|"."{digit}+
charstring                  "\'"."\'"
notcharstring               "\'".(.+)"\'"
string                      "\"".+"\""
boolops                     "&&"|"||"
ops                         "+"|"-"|"*"|"/"
unops                       "++"|"--"
relops                      "<"|">"|"=="|"<="|">="

%%
{paragraphComments} {/* skip */}
{lineComments}      {/* skip */}
{string}            {printyyt("(STRING:%s)"); return _STRING;}
{charstring}        {printyyt("(CHAR:%s)"); return _CHAR;}
{notcharstring}     {printyyt("(NOTCHAR:%s)"); return _NCHAR;}
{space}             {printyyt("%s");}
"eof"               {printf("EOF"); return _EOF_;}
";"                 {printf(";"); return _SEMICOLON;}
":"                 {printf(":"); return _COLON;}
","                 {printf(","); return _COMMA;}
"["                 {printf("["); return _LBRACKET;}
"]"                 {printf("]"); return _RBRACKET;}
"{"                 {printf("{"); return _LBRACE;}
"}"                 {printf("}"); return _RBRACE;}
"("                 {printf("("); return _LPAREN;}
")"                 {printf(")"); return _RPAREN;}
"*"                 {printf("*"); return _STAR;}
"="                 {printf("="); return _IS;}
"."                 {printf("DOT"); return _DOT;}
"import"            {printf("IMPORT"); return _IMPORT;}
"class"             {printf("CLASS"); return _CLASS;}
"extends"           {printf("EXTENDS"); return _EXTENDS;}
"if"                {printf("IF"); return _IF;}
"else"              {printf("ELSE"); return _ELSE;}
"while"             {printf("WHILE"); return _WHILE;}
"break"             {printf("BREAK"); return _BREAK;}
"return"            {printf("RETURN"); return _RETURN;}
"for"               {printf("FOR"); return _FOR;}
"switch"            {printf("SWITCH"); return _SWITCH;}
"case"              {printf("CASE"); return _CASE;}
"default"           {printf("DEFAULT"); return _DEFAULT;}
"try" 				{printf("TRY"); return _TRY;}
"catch" 			{printf("CATCH"); return _CATCH;}
"finally" 			{printf("FINALLY"); return _FINALLY;}
{boolops}           {printyyt("(BOOLOP:%s)"); return _BOOLOP;}
{relops}            {printyyt("(RELOP:%s)"); return _RELOP;}
{ops}               {printyyt("(OP:%s)"); return _OP;}
{unops}             {printyyt("(UNOP:%s)"); return _UNOP;}
{primitive}         {printf("TYPE"); return _TYPE;}
{accessModifiers}   {printyyt("(ACCMOD:%s)"); return _ACC_MOD;}
{nonAccessModifiers} {printyyt("(NONACCMOD:%s)"); return _NON_ACC_MOD;}
{title}             {printyyt("(TITLE:%s)"); return _TITLE;}
{id}                {printyyt("(ID:%s)"); return _ID;}
{signedint}         {printyyt("(NUM:%s)"); return _NUM;}
{double}            {printyyt("(DOUBLE:%s)"); return _DOUBLE;}
.                   {printyyt("%s");}
%%

// "\'"                {printf("SINGLEQUOTE"); return _SINGLEQUOTE;}
// "\""                {printf("DOUBLEQUOTE"); return _DOUBLEQUOTE;}
int yywrap() {
    return 1;
}
