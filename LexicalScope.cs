using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GPLexTutorial.AST
{
    public class LexicalScope
    {
        private Dictionary<string, Declare> symbol_table;
        private LexicalScope parent;

        public LexicalScope(LexicalScope parent)
        {
            this.parent = parent;
            symbol_table = new Dictionary<string, Declare>();
        }

        public void Add(string symbol, Declare decl)
        {
            if (symbol_table.ContainsKey(symbol))
                throw new Exception("Name is already used");
            else
                symbol_table[symbol] = decl;
        }

        public Declare ResoveNameHere(string symbol)
        {
            if (symbol_table.ContainsKey(symbol))
                return symbol_table[symbol];
            else
                return null;
        }

        public Declare ResolveName(string symbol)
        {
            Declare decl = ResoveNameHere(symbol);
            if (decl != null)
                return decl;
            else if (parent != null)
                return parent.ResolveName(symbol);
            else
                return null;
        }
    }
}
