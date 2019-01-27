using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GPLexTutorial.AST
{
    public interface Declare
    {
        JavaType GetType();
        string GetName();
        int GetNumber();
    }
}
