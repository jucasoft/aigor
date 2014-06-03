package com.dehats.fgl.analysis {

/**
 *
 * @author davidderaedt
 *
 * C# file parser
 *
 */

public class CSParser implements ICodeParser {

    public function parseCode(csCode:String):Array {

        // Remove strings
        csCode = csCode.replace(/"[^"]*"/g, ""); // double quotes
        csCode = csCode.replace(/'[^']*'/g, ""); // simple quote

        // Remove comments
        csCode = csCode.replace(/\/\/\s*.*\n/g, ""); // comments
        csCode = csCode.replace(/\/\*.*\*\//g, "");
        /* one line */
        csCode = csCode.replace(/\/\*.*?\*\//sg, "");
        /* multiline */


        //Get namespace Name
        var packageName:String = "";
        var packagesDecls:Array = csCode.match(/namespace\s+.*/);
        if (packagesDecls.length > 0) {
            var rawP:String = packagesDecls[0];
            packageName = rawP.substring(10, rawP.length);
        }


        // Get Classes
        var classDefList:Array = csCode.match(/public\s+class\s+\w+/gi);

        if (classDefList.length == 0) return [];

        //---

        var tab:Array = [];

        for (var i:int = 0; i < classDefList.length; i++) {
            var thisClassName:String = classDefList[i];

            var endOfSearch:int;

            if (i < classDefList.length - 1) {
                var nextClassName:String = classDefList[i + 1];
                endOfSearch = csCode.indexOf(nextClassName);
            }
            else {
                endOfSearch = csCode.lastIndexOf("}");
            }

            var classBody:String = csCode.substring(csCode.indexOf(thisClassName), endOfSearch);
            tab.push(classBody);
        }


        var classList:Array = [];

        for (var j:int = 0; j < tab.length; j++) {
            var c:PseudoClass = analyzeClass(tab[j], packageName);
            classList.push(c);
        }

        return classList;
    }


    private function analyzeClass(classCode:String, pPackageName:String):PseudoClass {

        var csClassFile:PseudoClass = new PseudoClass();

        csClassFile.className = classCode.match(/\w+/g)[2];
        csClassFile.packageName = pPackageName;

        // Get class block code

        var classCode:String = classCode.substring(classCode.indexOf("{") + 1, classCode.lastIndexOf("}"));

        // List public methods
        var rawMethodTable:Array = classCode.match(/public\s+\w+\s+\w+(.+)\)/g);
        // typed Array return type methods
        var rawMethodTable2:Array = classCode.match(/public\s+\w+\s*\[\s*]\s+\w+(.+)\)/g);
        rawMethodTable = rawMethodTable.concat(rawMethodTable2);

        for (var a:int = 0; a < rawMethodTable.length; a++) {
            var s:String = rawMethodTable[a];

            var meth:PseudoClassMethod = new PseudoClassMethod();
            var returnType:String;
            if (s.indexOf("[") != -1) returnType = "List";
            else returnType = s.match(/\w+/g)[1];

            meth.returnType = getASEquivType(returnType);

            //if(meth.returnType.indexOf("<") !=-1) meth.returnType = meth.returnType.substr(0, meth.returnType.indexOf("<"));

            var methodName:String = s.match(/\w+\s*\(/)[0];
            meth.name = methodName.match(/\w+/)[0];

            var paramsString:String = s.match(/\(.*\)/)[0];
            paramsString = paramsString.replace(/[\$\(\)]/g, "");

            if (paramsString != "") {
                var argsName:Array = paramsString.split(",");
                for (var b:int = 0; b < argsName.length; b++) {
                    var argTab:Array = argsName[b].match(/\w+/g);
                    var argName:String = argTab[1];
                    var argType:String = getASEquivType(argTab[0]);

                    meth.arguments.push(new PseudoVariable(argName, argType));
                }
            }

            if (meth.name != csClassFile.className) csClassFile.methods.push(meth);

        }

        // look for properties

        // ...in variables
        var rawVarTable:Array = classCode.match(/public\s+\w+\s+\w+\s*;/g);
        var rawVarTable2:Array = classCode.match(/public\s+\w+\s+\w+\s*=/g);
        rawVarTable = rawVarTable.concat(rawVarTable2);

        for (var j:int = 0; j < rawVarTable.length; j++) {
            var rawVar:String = rawVarTable[j];
            var tb:Array = rawVar.match(/\w+/g);

            var vName:String = tb[2];
            var type:String = getASEquivType(tb[1]);
            var v:PseudoVariable = new PseudoVariable(vName, type)
            csClassFile.properties.push(v);

        }


        // ... in getter/setters
        var rawGSList:Array = classCode.match(/public\s+\w+\s+\w+\s*\{\s*get\s*{/g);

        for (var i:int = 0; i < rawGSList.length; i++) {
            var rawGS:String = rawGSList[i];
            var propName:String = rawGS.match(/\w+/g)[2];
            var csType:String = rawGS.match(/\w+/g)[1];
            var _type:String = getASEquivType(csType);
            var _v:PseudoVariable = new PseudoVariable(propName, _type)
            csClassFile.properties.push(_v);

        }

        return csClassFile;

    }


    private function getASEquivType(pCSType:String):String {

        if (pCSType == "byte") return "int";
        if (pCSType == "short") return "int";
        if (pCSType == "long") return "int";
        if (pCSType == "float") return "Number";
        if (pCSType == "double") return "Number";
        if (pCSType == "string") return "String";
        if (pCSType == "List") return "Array";

        return pCSType;
    }

}
}