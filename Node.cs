using System;
using System.IO;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using GPLexTutorial;

namespace GPLexTutorial.AST
{
    public abstract class Node
    {
        void Indent(int n)
        {
            for (int i = 0; i < n; i++)
                Console.Write("    ");
        }

        public void DumpValue(int indent = 0)
        {
            Indent(indent);
            Console.WriteLine("{0}", GetType().ToString());

            Indent(indent);
            Console.WriteLine("{");

            foreach (var field in GetType().GetFields(System.Reflection.BindingFlags.NonPublic |
                                                      System.Reflection.BindingFlags.Instance))
            {
                object value = field.GetValue(this);
                Indent(indent + 1);

                // Is this value something we can iterate through?
                // We test that it is a generic type, this way we don't treat strings as IEnumerables.
                if (value is System.Collections.IEnumerable && value.GetType().IsGenericType)
                {
                    Console.WriteLine("{0}:", field.Name);
                    Indent(indent + 1);
                    Console.WriteLine("{");

                    foreach (object item in (System.Collections.IEnumerable)value)
                    {
                        if (item is Node)
                        {
                            ((Node)item).DumpValue(indent + 2);
                        }
                        else
                        {
                            Indent(indent + 2);
                            Console.WriteLine("{0}", item);
                        }
                    }

                    Indent(indent + 1);
                    Console.WriteLine("}");
                }
                else if (value is Node)
                {
                    Console.WriteLine("{0}:", field.Name);
                    ((Node)value).DumpValue(indent + 2);
                }
                else
                {
                    Console.WriteLine("{0}: {1}", field.Name, value);
                }
            }

            Indent(indent);
            Console.WriteLine("}");
        }

        public virtual void ResolveNames(LexicalScope scope) { }
        public virtual void CheckType() { }
        public virtual void CodeGen(StreamWriter stream) { }
        public virtual void CodeStoreGen(StreamWriter stream) { }
    };
    

}
