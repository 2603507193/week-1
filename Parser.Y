%namespace GPLexTutorial
%using GPLexTutorial.AST

%union
{
    public int num;
    public string name;
    public bool boolValue;
    public int Integer_Literal;
    public float FloatingPoint_Literal;

	public CompilationUnit ordinaryCompilationUnit;
	public JavaType javaType;
	public List<Modifier> modifiers;
	public Packagedeclaration packagedeclarationopt;
	public List<ImportDeclaration> importDeclarations;
	public List<TypeDeclaration> typeDeclarations;
	public TypeDeclaration typeDeclaration;
	public List<Declaration> declarations;
    public Declaration declaration;
	public Modifier modifier;
	public List<Parameter> parameters;
    public Parameter parameter;

	public List<Statement> statements;
    public Statement statement;
	public AssignmentExpression assignmentExpression;
	public LiteralExpression literalExpression;
	public NamedExpression namedExpression;
	public ArrayType arrayType;
	public char assignmentOperator;
}



%token <name> IDENT STRING
%token <boolValue> BOOLEANLITERAL
%token <Integer_Literal> Integer_Literal	
%token <FloatingPoint_Literal> Floating_Point_Literal
%token ABSTRACT ASSERT BOOLEAN BREAK BYTE CASE CATCH CHAR CLASS CONST CONTINUE DEFAULT DO DOUBLE ELSE ENUM EXTENDS FINAL FINALLY FLOAT FOR IF GOTO IMPLEMENTS IMPORT INSTANCEOF INT INTERFACE LONG NATIVE NEW PACKAGE PRIVATE PROTECTED PUBLIC RETURN SHORT STATIC STRICTFP SUPER SWITCH SYNCHRONIZED THIS THROW THROWS TRANSIENT TRY VOID VOLATILE WHILE NULL 
%token PR EQUALTO GTE LTE NET LA LO INC DEC LSO RSO URSO AAA SAA MAA DAA MoAA LSAA RSAA BAAA BIOAA BEOAA URSOAA AO LTO GTO EO TO QO CO BAO BDO BMO  BD UA UO EXP BM
%token OP CP OB CB AOB ACB ET VS PO AOF Separator_VariableArguments Separator_DoubleColon
%left '='
%nonassoc '<'
%left '+'

%type <typeDeclaration> NormalClassDeclaration
%type <modifiers> ClassModifiers
%type <name> TypeIdentifier
%type <ordinaryCompilationUnit> CompilationUnit
%type <ordinaryCompilationUnit> OrdinaryCompilationUnit
%type <packagedeclarationopt> PackageDeclarationOpt
%type <importDeclarations> ImportDeclarations
%type <typeDeclarations> TypeDeclarations
%type <typeDeclaration> TypeDeclaration
%type <javaType> IntegralType
%type <modifier> ClassModifier
%type <modifiers> MethodModifiers
%type <modifier> MethodModifier

%type <declarations> ClassBodyDeclarations
%type <declarations> ClassBody
%type <declaration> ClassBodyDeclaration
%type <javaType> Result 
%type <parameters> Parameters
%type <parameter> Parameter
%type <declaration> MethodDeclaration
%type <statements> BlockStatements
%type <statement> BlockStatement
%type <statements> Block

%type <statement> LocalVariableDeclaration
%type <statement> ExpressionStatement
%type <literalExpression> LiteralExpression
%type <namedExpression> NamedExpression
%type <arrayType> ArrayType
%type <javaType> InnerType
%type <modifiers> VariableModifiers
/*%type <modifier> VariableModifier*/
%type <assignmentExpression> AssignmentExpression
%type <assignmentOperator> AssignmentOperator
%type <name> VarName
%type <name> Name
%type <Integer_Literal> IntegerLiteral

%%


CompilationUnit 
	: OrdinaryCompilationUnit { CompilationUnit.root = $1; }
	  /* ToDo */
	;

OrdinaryCompilationUnit
	: PackageDeclarationOpt ImportDeclarations TypeDeclarations		 { $$ = new CompilationUnit($1, $2, $3);}
	;

PackageDeclarationOpt
	: /* empty */													 { $$ = new AST.Packagedeclaration();}
	  /* ToDo */
	;

ImportDeclarations
	: /* empty */												     { $$ = new List<AST.ImportDeclaration>();}
	  /* ToDo */
	;

TypeDeclarations
	: /* empty */													 { $$ = new List<AST.TypeDeclaration>();}
	| TypeDeclaration TypeDeclarations								 { $$ = new List<AST.TypeDeclaration>(); $$.Add($1);$$.AddRange($2);}
	;

TypeDeclaration
	: NormalClassDeclaration 
	  /* ToDo */
	;

NormalClassDeclaration
	: ClassModifiers CLASS TypeIdentifier TypeParametersOpt SuperclassOpt SuperInterfacesOpt ClassBody  { $$ = new AST.ClassDeclaration($1, $3, $7); }
	;

ClassModifiers
	: /* empty */													{ $$ = new List<AST.Modifier>(); }
	| ClassModifier ClassModifiers									{ $$ = new List<AST.Modifier>(); $$.Add($1); $$.AddRange($2); }
	;

ClassModifier
	: PUBLIC														{$$ = Modifier.Public;}
	  /* ToDo */
	;

TypeParametersOpt
	: /* empty */
	  /* ToDo */
	;

SuperclassOpt
	: /* empty */
	  /* ToDo */
	;

SuperInterfacesOpt
	: /* empty */
	  /* ToDo */
	;

TypeIdentifier
	: IDENT															 { $$ = $1; }
	;

ClassBody
    : '{' ClassBodyDeclarations '}' { $$ = $2; }  
	;

ClassBodyDeclarations
	: /* empty */													 { $$ = new List<AST.Declaration>();}
	| ClassBodyDeclaration ClassBodyDeclarations					 { $$ = new List<AST.Declaration>(); $$.Add($1);$$.AddRange($2);} 
	;


ClassBodyDeclaration
	: MethodDeclaration
	  /* ToDo */
	;

MethodDeclaration
	: MethodModifiers  Result IDENT '(' Parameters ')' Block  { $$ = new MethodDeclaration($1, $2, $3, $5, $7);}
	;

MethodModifiers
	: /* empty */													 { $$ = new List<AST.Modifier>(); }
	| MethodModifier MethodModifiers								 { $$ = new List<AST.Modifier>(); $$.Add($1); $$.AddRange($2); }
	;

MethodModifier
	: PUBLIC														 {$$ = Modifier.Public;}
	| STATIC														 {$$ = Modifier.Static;}
	  /* ToDo*/
	;

Result
	: VOID 															 {$$ = JavaType.Void;}
	  /* ToDo */
	;


Parameters
	: /* empty */ 												     { $$ = new List<AST.Parameter>(); }
	| Parameter Parameters											 { $$ = new List<AST.Parameter>(); $$.Add($1); $$.AddRange($2); }
	;

Parameter
	:VariableModifiers ArrayType IDENT								 { $$ = new Parameter($1, $2, $3); }
	;

VariableModifiers
	: /* empty */													  { $$ = new List<AST.Modifier>(); }
	/*| VariableModifier VariableModifiers							  { $$ = new List<AST.Modifier>(); $$.Add($1); $$.AddRange($2); }*/
	;



ArrayType
	: InnerType '[' ']'														 { $$ =  new ArrayType($1); }
	;

InnerType
	: IDENT															 { $$ = new NamedType($1); }
	;

Block
	: '{' '}'														 { $$ = new List<AST.Statement>(); }
	| '{' BlockStatements '}'										 { $$ = $2; }
	;

BlockStatements
	: /* empty */													 { $$ = new List<AST.Statement>(); }
	| BlockStatement BlockStatements								 { $$ = new List<AST.Statement>(); $$.Add($1); $$.AddRange($2); }
	;

BlockStatement
	: LocalVariableDeclarationStatement
	| ExpressionStatement
	  /* Todo */
	;
LocalVariableDeclarationStatement
	: LocalVariableDeclaration ';'											
	;


LocalVariableDeclaration
	: IntegralType VarName											{ $$ = new  LocalVariableDeclarationStatement(new List<Modifier>(), $1, $2); }
	;

IntegralType
	: INT															{ $$ = JavaType.Int; }
	/* To Do */
	;

VarName
	: IDENT															{ $$ = $1; }
	;

ExpressionStatement
	: AssignmentExpression ';'													{ $$ = new ExpressionStatement($1);}
	/* To Do */
	;

AssignmentExpression
	: NamedExpression AssignmentOperator LiteralExpression		    { $$ = new AssignmentExpression($1, $2, $3); }
	;

NamedExpression
	: Name															{ $$ = new NamedExpression($1); } 
	;

Name
    : IDENT														    { $$ = $1; }
	;

AssignmentOperator
	: '=' { $$ = '='; }
	;

LiteralExpression
	: IntegerLiteral												{ $$ = new LiteralExpression($1); }
	;
	
IntegerLiteral
	: Integer_Literal												{ $$ = $1; }
	;


%%
public Parser(Scanner scanner) : base(scanner)
{
}