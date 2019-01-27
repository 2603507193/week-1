using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using GPLexTutorial;
using System.IO;

namespace GPLexTutorial.AST
{
    public class CompilationUnit : Node
    {
        public static CompilationUnit root;

        private Packagedeclaration packagedeclaration;
        private List<ImportDeclaration> importDeclarations;
        private List<TypeDeclaration> typeDeclarations;

        public CompilationUnit(Packagedeclaration packagedeclaration, List<ImportDeclaration> importDeclarations, List<TypeDeclaration> typeDeclarations)
        {
            this.packagedeclaration = packagedeclaration;
            this.importDeclarations = importDeclarations;
            this.typeDeclarations = typeDeclarations;
        }
        public override void ResolveNames(LexicalScope scope)
        {
            if (typeDeclarations != null)
            {
                foreach(var type in typeDeclarations)
                    type.ResolveNames(scope);
            }

        }

        public override void CheckType()
        {
            if (typeDeclarations != null)
            {
                foreach (var type in typeDeclarations)
                    type.CheckType();
            }
        }

        public override void CodeGen(StreamWriter stream)
        {
            stream.WriteLine(".assembly HelloWorld");
            stream.WriteLine("{");

            foreach (var child in typeDeclarations)
            {
                child.CodeGen(stream);
            }

            stream.WriteLine("}");
        }

    }
    
    public class Packagedeclaration: Declaration
    {
    }

    public class ImportDeclaration: Declaration
    {
    }

    public class Declaration:Node
    {
    }

    public class TypeDeclaration :  Declaration
    {
    }

    public class ClassDeclaration : TypeDeclaration, Declare
    {
        private List<Modifier> modifiers;
        private string classname;
        private List<Declaration> declarations;

        public ClassDeclaration(List<Modifier> modifiers, string classname, List<Declaration> declarations)
        {
            this.modifiers = modifiers;
            this.classname = classname;
            this.declarations = declarations;
        }

        public string GetName()
        {
            return classname;
        }

        public int GetNumber()
        {
            throw new NotImplementedException();
        }

        JavaType Declare.GetType()
        {
            throw new NotImplementedException();
        }

        public override void ResolveNames(LexicalScope scope)
        {
            if (classname != null)
            {
                scope.Add(classname, this);
            }

            foreach (var decl in declarations)
                decl.ResolveNames(scope);
        }

        public override void CheckType()
        {
            if (declarations != null)
            {
                foreach (var type in declarations)
                    type.CheckType();
            }
        }
        public override void CodeGen(StreamWriter stream)
        {
            stream.Write(".class ");
            foreach (var child in modifiers)
            {
                if (child == Modifier.Public) stream.Write("public ");
                if (child == Modifier.Static) stream.Write("static ");
            }
            stream.WriteLine("{0}", classname);
            stream.WriteLine("{");
            foreach (var child in declarations)
            {
                child.CodeGen(stream);
            }
            stream.WriteLine("}");
        }
   

    }
    public enum Modifier
    {
        Public, Static
    }

    public class MethodDeclaration :  Declaration, Declare
    {

        private List<Modifier> modifiers;
        private JavaType type;
        private string methodname;
        private List<Parameter> parameters;
        private List<Statement> statements;
        public MethodDeclaration(List<Modifier> modifiers, JavaType type, string methodname, List<Parameter> parameters, List<Statement> statements)
        {
            this.modifiers = modifiers;
            this.type = type;
            this.methodname = methodname;
            this.parameters = parameters;
            this.statements = statements;
        }
        public string GetName()
        {
            return methodname;
        }

        public int GetNumber()
        {
            throw new NotImplementedException();
        }

        JavaType Declare.GetType()
        {
            throw new NotImplementedException();
        }
        public override void ResolveNames(LexicalScope scope)
        {
            LocalVariableDeclarationStatement.LastLocal = 0;
            if (methodname != null)
            {
                scope.Add(methodname, this);
            }
            if (parameters != null)
            {
                foreach (var parameter in parameters)
                    parameter.ResolveNames(scope);
            }
            if (statements != null)
            {
                foreach (var statement in statements)
                    statement.ResolveNames(scope);
            }
            

        }
        public override void CheckType()
        {
            if (parameters != null)
            {
                foreach (var parameter in parameters)
                    parameter.CheckType();
            }
            if (statements != null)
            {
                foreach (var statement in statements)
                    statement.CheckType();
            }
        }

        public override void CodeGen(StreamWriter stream)
        {
            stream.Write(".method ");
            foreach (var child in modifiers)
            {
                if (child == Modifier.Public) stream.Write("public ");
                if (child == Modifier.Static) stream.Write("static ");
            }
            stream.Write("{0} {1}", type.GetTypeName(), methodname);
            foreach (var child in parameters)
                child.CodeGen(stream);
            stream.WriteLine();
            stream.WriteLine("{");
            stream.WriteLine(".entrypoint");
            foreach (var child in statements)
                child.CodeGen(stream);
            stream.WriteLine("}");

        }

    }

    public class JavaType
    {
        public static JavaType Void = new NamedType("void");
        public static JavaType Int = new NamedType("int32");

        protected string name;
        public string GetTypeName() { return name; }

        public bool Compatible(JavaType other)
        {
            return Equal(other);
        }

        public bool Equal(JavaType other)
        {
            return name.Equals(other.GetTypeName());
        }
        
        public virtual void CodeGen(StreamWriter stream)
        {

        }

    }

    public class NamedType : JavaType
    {
        public NamedType(string name)
        {
            this.name = name;
        }

        public override void CodeGen(StreamWriter stream)
        {
            stream.Write("{0}", name);
        }
    }

    public class ArrayType : JavaType
    {
        private JavaType innerType;
        public ArrayType(JavaType innerType)
            {
                this.innerType = innerType;
                this.name = innerType.GetTypeName() + "[]";
        }
       public override void CodeGen(StreamWriter stream)
        {
            innerType.CodeGen(stream);
            stream.Write("[");
         
            stream.Write("]");
        }
}

 

    public class PrimitiveType : JavaType
    {

    }
    
    public class Parameter: Node, Declare
    {
        private List<Modifier> modifiers;
        private JavaType arraytype;
        private string IDENT;
        public Parameter(List<Modifier> modifiers, JavaType arraytype, string IDENT)
        {
            this.modifiers = modifiers;
            this.arraytype = arraytype;
            this.IDENT = IDENT;
        }

        public string GetName()
        {
            return IDENT;
        }

        public int GetNumber()
        {
            throw new NotImplementedException();
        }

        JavaType Declare.GetType()
        {
            throw new NotImplementedException();
        }

        public override void ResolveNames(LexicalScope scope)
        {
                scope.Add(IDENT, this);

        }
        public override void CheckType()
        {
        }
        public override void CodeGen(StreamWriter stream)
        {
            stream.Write("(");
            arraytype.CodeGen(stream);
            stream.Write(")");
        }

    }

    public abstract class Expression : Node 
    {
        public JavaType type;
    }

    public class ExpressionStatement : Statement
    {
        private Expression exp;

        public ExpressionStatement(Expression exp)
        {
            this.exp = exp;
        }

        public override void ResolveNames(LexicalScope scope)
        {
            exp.ResolveNames(scope);
        }

        public override void CheckType()
        {
                exp.CheckType();
        }

        public override void CodeGen(StreamWriter stream)
        {
            exp.CodeGen(stream);
            stream.BaseStream.Seek(0, SeekOrigin.End);
            stream.WriteLine("pop");
        }
    }

    public class AssignmentExpression : Expression
    {
        private Expression lhs;
        private char assignmentOperator;
        private Expression rhs;

        public AssignmentExpression(Expression lhs, char assignmentOperator, Expression rhs)
        {
            this.lhs = lhs;
            this.assignmentOperator = assignmentOperator;
            this.rhs = rhs;
        }

        public override void ResolveNames(LexicalScope scope)
        {
            lhs.ResolveNames(scope);
            rhs.ResolveNames(scope);
        }
        public override void CheckType()
        {
            lhs.CheckType();
            rhs.CheckType();

            if (rhs.type != null && lhs.type != null)
            {
                if (!lhs.type.GetTypeName().Equals(rhs.type.GetTypeName()))
                {
                    Console.WriteLine("Type error in assignment \n");
                }

            }
        }

        public override void CodeGen(StreamWriter stream)
        {
            rhs.CodeGen(stream);
            lhs.CodeStoreGen(stream);
            lhs.CodeGen(stream);
        }
    }

    public class NamedExpression : Expression
    {
        private string assName;
        Declare decl;

        public NamedExpression(string assName)
        {
            this.assName = assName;
        }

        public override void ResolveNames(LexicalScope scope)
        {
            if (scope != null)
            {
                decl = scope.ResolveName(assName);
            }
            if (decl == null)
            {
                Console.WriteLine("Undeclared Identifier");
                throw new Exception("Resolve Name Error");
            }
        }

        public void TypeCheck()
            {
                type = decl.GetType();
            }

        public override void CodeGen(StreamWriter stream)
            {
                stream.BaseStream.Seek(0, SeekOrigin.End);
                stream.WriteLine("ldloc.{0}", decl.GetNumber());
            }
        public override void CodeStoreGen(StreamWriter stream)
            {
                stream.BaseStream.Seek(0, SeekOrigin.End);
                stream.WriteLine("dup");
                stream.WriteLine("stloc.{0}", decl.GetNumber());
            }
    }

    public class LiteralExpression : Expression
    {
        private int expValue;

        public LiteralExpression(int expValue)
        {
            this.expValue = expValue;
        }
        public override void ResolveNames(LexicalScope scope)
        {
        }

        void TypeCheck()
        {
            type = JavaType.Int;
        }

        public override void CodeGen(StreamWriter stream)
        {
            stream.BaseStream.Seek(0, SeekOrigin.End);
            stream.WriteLine("ldc.i4.{0}", expValue);
        }
    }

    public class PlusExpression : Expression
    {
        private Expression lhs;
        private char additionOperator;
        private Expression rhs;

        public PlusExpression(Expression lhs, char additionOperator, Expression rhs)
        {
            this.lhs = lhs;
            this.additionOperator = additionOperator;
            this.rhs = rhs;
        }

        public override void ResolveNames(LexicalScope scope)
        {
            lhs.ResolveNames(scope);
            rhs.ResolveNames(scope);
        }
        public override void CheckType()
        {
            lhs.CheckType();
            rhs.CheckType();

            if (rhs.type != null && lhs.type != null)
            {
                if (!lhs.Equals(rhs.type.GetTypeName()))
                {
                    Console.WriteLine("Invalid arguments for addition expression \n");
                    throw new Exception("Addition Expression Type Error");
                }

            }
        }

        public override void CodeGen(StreamWriter stream)
        {
            stream.BaseStream.Seek(0, SeekOrigin.End);
            stream.WriteLine("add");
        }


    }
    public abstract class Statement : Node 
    {
    }

    public class LocalVariableDeclarationStatement : Statement, Declare
    {
        public static int LastLocal = 0;

        private List<Modifier> modifiers;
        private JavaType type;
        private string varName;
        private int num;

        public LocalVariableDeclarationStatement(List<Modifier> modifiers, JavaType type, string varName)
        {
            this.modifiers = modifiers;
            this.type = type;
            this.varName = varName;
        }

        public string GetName()
        {
            return varName;
        }

        public int GetNumber()
        {
            return num;
        }
        JavaType Declare.GetType()
        {
            throw new NotImplementedException();
        }

        public override void ResolveNames(LexicalScope scope)
        {
            this.num = LastLocal++;           // Find a way to declare extern int variable
            scope.Add(varName, this);
        }

        public void TypeCheck()
        {
            type.GetType();
        }

        public override void CodeGen(StreamWriter stream)
        {
            stream.BaseStream.Seek(0, SeekOrigin.End);
            stream.WriteLine(".locals init ([{0}] {1} {2})", num, type.GetTypeName(), varName);
        }

    }

}



