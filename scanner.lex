%namespace GPLexTutorial

%{
int lines = 0;
%}

OctalDigit								[0-7]
HexDigit								[0-9a-fA-F]
BinaryDigit								0|1
IntegerTypeSuffix						1|L
NonZeroDigit							[1-9]
Underscores								\_+

//DecimalIntegerLiteral 
Digit									0|{NonZeroDigit}
DigitOrUnderscore						{Digit}|{Underscores}
DigitsAndUnderscores					{DigitOrUnderscore}{DigitOrUnderscore}*
Digits									{Digit}|{Digit}{DigitsAndUnderscores}?{Digit}
DecimalNumeral							0|{NonZeroDigit}{Digits}?|{NonZeroDigit}{Underscores}{Digits}
DecimalIntegerLiteral					{DecimalNumeral}{IntegerTypeSuffix}?

// HexIntegerLiteral 
HexDigitOrUnderscore					{HexDigit}|\_
HexDigitsAndUnderscores					{HexDigitOrUnderscore}{HexDigitOrUnderscore}*
HexDigits								{HexDigit}|{HexDigit}{HexDigitsAndUnderscores}?{HexDigit}
HexNumeral								0x{HexDigits}|0X{HexDigits}
HexIntegerLiteral						{HexNumeral}{IntegerTypeSuffix}?

//ctalIntegerLiteral 
OctalDigitOrUnderscore					{OctalDigit}|\_
OctalDigitsAndUnderscores				{OctalDigitOrUnderscore}+
OctalDigits								{OctalDigit}|{OctalDigit}{OctalDigitsAndUnderscores}?{OctalDigit}
OctalNumeral							0{OctalDigits}|0{Underscores}{OctalDigits}
OctalIntegerLiteral						{OctalNumeral}{IntegerTypeSuffix}?

// BinaryIntegerLiteral
BinaryDigitOrUnderscore					{BinaryDigit}|\_
BinaryDigitsAndUnderscores				{BinaryDigitOrUnderscore}+
BinaryDigits							{BinaryDigit}|{BinaryDigit}{BinaryDigitsAndUnderscores}?{BinaryDigit}
BinaryNumeral							0b{BinaryDigits}|0B{BinaryDigits}
BinaryIntegerLiteral					{BinaryNumeral}{IntegerTypeSuffix}?

/* floating-point literal */
BinaryExponentIndicator [Pp]
FloatTypeSuffix         [fFdD] 
Sign                    \+|\-
ExponentIndicator       [eE]

//Floating-point
SignedInteger       {Sign}{Digits}
BinaryExponent      {BinaryExponentIndicator}{SignedInteger}
HexSignificand      ({HexNumeral}\.?)|(0x[HexDigits]?\.{HexDigits})|(0X[HexDigits]?\.{HexDigits}) 
HexadecimalFloatingPointLiteral      {HexSignificand}{BinaryExponent}{FloatTypeSuffix}
ExponentPart        {ExponentIndicator}{SignedInteger}
DecimalFloatingPointLiteral     {Digits}\.{Digits}?{ExponentPart}?{FloatTypeSuffix}|\.{Digits}{ExponentPart}?{FloatTypeSuffix}|{Digits}{ExponentPart}{FloatTypeSuffix}?|{Digits}{ExponentPart}?{FloatTypeSuffix} 
FloatingPointLiteral          {DecimalFloatingPointLiteral}|{HexadecimalFloatingPointLiteral}

digit [0-9]
letter [a-zA-Z]
underscore [_]
dollar [$]
Character [a-zA-Z]
NullLiteral [\0]
LineTerminator [\r\n]
WhiteSpace [ \t\f]|{LineTerminator}
RawInputCharacter [\u0020-\u00ff]
UnicodeMarker [u]+
UnicodeEscape [\\]{UnicodeMarker}{HexDigit}{HexDigit}{HexDigit}{HexDigit}
UnicodeInputCharacter {UnicodeEscape}|{RawInputCharacter}
ZeroToThree [0-3]
OctalEscape [\\]({OctalDigit}|{OctalDigit}{OctalDigit}|{ZeroToThree}{OctalDigit}{OctalDigit})
EscapeSequence ([\\][btnfr\"\'\\])|{OctalEscape}
InputCharacter {UnicodeInputCharacter}
SingleCharacter {InputCharacter}
CharacterLiteral [\']({SingleCharacter}|{EscapeSequence})[\']
StringCharacter ({InputCharacter}|{EscapeSequence})
StringLiteral [\"]{StringCharacter}*[\"]
%%



// keywords
abstract { return (int)Tokens.ABSTRACT; }
assert { return (int)Tokens.ASSERT; }
boolean	{ return (int)Tokens.BOOLEAN; }
break { return (int)Tokens.BREAK; }
byte { return (int)Tokens.BYTE; }
case { return (int)Tokens.CASE; }
catch { return (int)Tokens.CATCH; }
char { return (int)Tokens.CHAR; }
class { return (int)Tokens.CLASS; }
const { return (int)Tokens.CONST; }
continue { return (int)Tokens.CONTINUE; }
default { return (int)Tokens.DEFAULT; }
do { return (int)Tokens.DO; }
double { return (int)Tokens.DOUBLE; }
else { return (int)Tokens.ELSE; }
enum { return (int)Tokens.ENUM; }
extends { return (int)Tokens.EXTENDS; }
final { return (int)Tokens.FINAL; }
finally { return (int)Tokens.FINALLY; }
float { return (int)Tokens.FLOAT; }
for { return (int)Tokens.FOR; }
if { return (int)Tokens.IF; }
goto { return (int)Tokens.GOTO; }
implements { return (int)Tokens.IMPLEMENTS; }
import { return (int)Tokens.IMPORT; }
instanceof { return (int)Tokens.INSTANCEOF; }
int { return (int)Tokens.INT; }
interface { return (int)Tokens.INTERFACE; }
long { return (int)Tokens.LONG; }
native { return (int)Tokens.NATIVE; }
new { return (int)Tokens.NEW; }
package { return (int)Tokens.PACKAGE; }
private { return (int)Tokens.PRIVATE; }
protected { return (int)Tokens.PROTECTED; }
public { return (int)Tokens.PUBLIC; }
return { return (int)Tokens.RETURN; }
short { return (int)Tokens.SHORT; }
static { return (int)Tokens.STATIC; }
strictfp { return (int)Tokens.STRICTFP; }
super { return (int)Tokens.SUPER; }
switch { return (int)Tokens.SWITCH; }
synchronized { return (int)Tokens.SYNCHRONIZED; }
this { return (int)Tokens.THIS; }
throw { return (int)Tokens.THROW; }
throws { return (int)Tokens.THROWS; }
transient { return (int)Tokens.TRANSIENT; }
try { return (int)Tokens.TRY; }
void { return (int)Tokens.VOID; }
volatile { return (int)Tokens.VOLATILE; }
while { return (int)Tokens.WHILE; }
null { return (int)Tokens.NULL; }

// boolean
true						 { yylval.boolValue = true; return (int)Tokens.BOOLEANLITERAL; }
false						 { yylval.boolValue = false; return (int)Tokens.BOOLEANLITERAL; }

({letter}|(({underscore}|{dollar})({letter}|{digit})))(({letter}|{digit})*|{underscore}+)* { yylval.name = yytext; return (int)Tokens.IDENT; }


// character
{CharacterLiteral} { yylval.name = yytext; return (int)Tokens.CHAR; }
{StringLiteral} { yylval.name = yytext; return (int)Tokens.STRING; }

//Interger Literal
{DecimalIntegerLiteral}	                {yylval.Integer_Literal=Convert.ToInt32(yytext, 10); return (int)Tokens.Integer_Literal;}
{HexIntegerLiteral}                     {yylval.Integer_Literal=Convert.ToInt32(yytext, 16); return (int)Tokens.Integer_Literal;}
{OctalIntegerLiteral}                   {yylval.Integer_Literal=Convert.ToInt32(yytext, 8); return (int)Tokens.Integer_Literal;}
{BinaryIntegerLiteral}                  {yylval.Integer_Literal=Convert.ToInt32(yytext, 2); return (int)Tokens.Integer_Literal;}

//floating-point literal
{FloatingPointLiteral}                  {yylval.FloatingPoint_Literal=float.Parse(yytext); return (int)Tokens.Floating_Point_Literal;}                


// Operators (38 cases)
"<<" { return (int)Tokens.LSO; }
">>" { return (int)Tokens.RSO; }
"+=" { return (int)Tokens.AAA; }
"-=" { return (int)Tokens.SAA; }
">>>" { return (int)Tokens.URSO; }
"*=" { return (int)Tokens.MAA; }
"/=" { return (int)Tokens.DAA; }
"&=" { return (int)Tokens.BAAA; }
"|=" { return (int)Tokens.BIOAA; }
"^=" { return (int)Tokens.BEOAA; }
"%=" { return (int)Tokens.MoAA; }
"<<=" { return (int)Tokens.LSAA; }
">>=" { return (int)Tokens.RSAA; }
">>>=" { return (int)Tokens.URSOAA; }
"->" { return (int)Tokens.PR; }
"==" { return (int)Tokens.EQUALTO; }
">=" { return (int)Tokens.GTE; }
"<=" { return (int)Tokens.LTE; }
"!=" { return (int)Tokens.NET; }
"&&" { return (int)Tokens.LA; }
"||" { return (int)Tokens.LO; }
"++" { return (int)Tokens.INC; }
"--" { return (int)Tokens.DEC; }
"=" { return '='; }
"<" { return '<'; }
">" { return '>'; }
"!" { return '!'; }
"~" { return '~'; }
"?" { return '?'; }
":" { return ':'; }
"+" { return '+'; }
"-" { return '-'; }
"*" { return '*'; }
"/" { return '/'; }
"&" { return '&'; }
"|" { return '|'; }
"^" { return '^'; }
"%" { return '%'; }


//Separators (12 cases)
"(" 							{return '(';}
")" 							{return ')';}
"{" 							{return '{';}
"}" 							{return '}';}
"[" 							{return '[';}
"]" 							{return ']';}
";" 							{return ';';}
"," 							{return ',';}
"." 							{return '.';}
"..." 							{return (int)Tokens.Separator_VariableArguments;}
"@" 							{return  '@';}
"::" 							{return (int)Tokens.Separator_DoubleColon;}
                        
//white Space
[\n]    {lines++;}
[\t\r ]   /*ignore other whitespace */

//Comment
"//".*	/* skip comments*/
[/][*][^*]*[*]+([^*/][^*]*[*]+)*[/]	/*skip comments*/
[/][*]	{
			throw new Exception(
				String.Format("Unterminated multiline comment"));
				}


.                                {
									throw new Exception(
										String.Format(
											"unexpected character '{0}'", yytext));
								  }
%%

public override void yyerror( string format, params object[] args )
{
    System.Console.Error.WriteLine("Error: line {0}, {1}", lines,
        String.Format(format, args));
}
