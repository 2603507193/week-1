using System;
using System.IO;
using System.Collections.Generic;
using System.Linq;
using GPLexTutorial.AST;
namespace GPLexTutorial
{
    class Program
    {
        static void Main(string[] args)
        {
            Scanner scanner = new Scanner(new FileStream(args[0], FileMode.Open));
            /*for (int i =0; i < 100; i++)
            {
                int n = scanner.yylex();
                Console.WriteLine(n);
            }*/
            Parser parser = new Parser(scanner);
            if (!parser.Parse())
            {
                Console.WriteLine("Parsing failed");
                return;
            }

            CompilationUnit.root.DumpValue();

            LexicalScope scope = new LexicalScope(null);
            CompilationUnit.root.ResolveNames(scope);
            CompilationUnit.root.CheckType();

            string file = "Test1";
            StreamWriter stream = new StreamWriter(file + ".il");
            CompilationUnit.root.CodeGen(stream);
            stream.Close();
            Console.ReadKey();
            // open up a file (test.il)
            // call CodeGen

            //var root = new CompilationUnit(
            // null,
            // new List<ImportDeclaration>(),
            // new List<TypeDeclaration>{
            //    new ClassDeclaration(
            //        new List<Modifier> { Modifier.Public },
            //        "HelloWorld",
            //        new List<Declaration> {
            //            new MethodDeclaration(
            //                new List<Modifier> { Modifier.Public, Modifier.Static },
            //                JavaType.Void,
            //                "main",
            //                new List<Parameter>{
            //                    new Parameter(
            //                        new List<Modifier>(),
            //                        new ArrayType(new NamedType("String")),
            //                        "args")},
            //                new List<Statement> {
            //                    new LocalVariableDeclarationStatement(
            //                        new List<Modifier>(),
            //                        JavaType.Int,
            //                        "x"),
            //                new ExpressionStatement(
            //                    new AssignmentExpression(
            //                        new NamedExpression("x"),
            //                        '=',
            //                        new LiteralExpression(42) ))}) }) });
            //root.DumpValue();
        }
    }
}     